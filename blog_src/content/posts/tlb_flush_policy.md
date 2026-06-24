+++
title = 'DAMON TLB Flush Policy'
date = 2026-06-09T00:00:00+08:00
draft = false
author = "Kunwu Chan, Wang Lian"
tags = ["damon", "tlb", "monitoring"]
categories = ["damon"]
+++

*Authors: Kunwu Chan &lt;kunwu.chan@gmail.com&gt;, Wang Lian &lt;lianux.mm@gmail.com&gt;*

## Overview

DAMON monitors data access by sampling PTE (Page Table Entry) Accessed bits.
It clears the Accessed bit but does **not** flush the TLB (Translation
Lookaside Buffer).  This is an intentional design choice.

Questions about this behavior come up repeatedly, both on the mailing list
and in private inquiries.  This document describes the reasoning, the
trade-offs, and recommendations for users and testers.

## Background

DAMON's access check works as follows:

1. Clear the PTE Accessed bit for a sampled page.
2. Wait for one `sampling interval`.
3. Check if the Accessed bit has been set again by the hardware.

If the bit was set again, the page was accessed during the sampling interval.

On architectures with hardware-managed TLB (e.g., x86, arm64), the TLB caches
virtual-to-physical address translations, not PTE Accessed bits.  After DAMON
clears the Accessed bit in the page table, a valid TLB entry still allows the
workload to access the page without a new page-table walk.  Without a
page-table walk — whose side effect is setting the Accessed bit — the hardware
does not set the Accessed bit again.  DAMON may therefore fail to detect real
accesses on its next check, reporting false negatives.

Flushing the TLB after clearing the Accessed bit forces subsequent accesses
to consult the updated page table and eliminates this problem.  Functions such as `ptep_clear_flush_young()` and
`pmdp_clear_flush_young()` provide this behavior.  However, TLB flushes come
at a performance cost.

## Why DAMON Does Not Flush TLB

DAMON intentionally avoids TLB flushes to keep monitoring overhead low.
The decision was made after measuring the performance impact of adding TLB
flushes to the sampling path.  The measurement showed the overhead is
significant enough to matter for production use [^1].

Production workloads typically have working sets that exceed the effective
TLB reach, causing natural TLB eviction through normal memory access patterns.
TLB entries that would otherwise avoid page-table walks are evicted by the
workload's own memory activity before the next
sampling interval.  The accuracy impact is therefore negligible in
production.

The following table summarizes the trade-off:

|                     | Without TLB Flush (current) | With TLB Flush            |
|---------------------|-----------------------------|---------------------------|
| Monitoring Overhead | Low                         | Higher (flush cost)       |
| Accuracy (prod)     | Good                        | Good                      |
| Accuracy (test)     | May degrade                 | Good                      |

## Impact on Testing and Small Workloads

The lack of TLB flush becomes problematic when the working set is small enough
to fit entirely within the TLB reach.  This is common in test environments
and synthetic benchmarks.  In such cases, existing TLB entries remain valid across sampling intervals,
allowing accesses to proceed without page-table walks.  DAMON may therefore
miss real accesses, making monitoring results incorrect.

For example, on a Kunpeng 920 (L2 unified TLB: 2048 entries; 2MB THP reach:
4GB), a 16MB THP workload occupies only 8 PMD entries — well within the L2
TLB capacity.  After DAMON clears the Accessed bit, all subsequent accesses
hit the TLB without triggering a page-table walk.  The Accessed bit is not set again, and DAMON reports zero accesses despite the
workload touching every page [^3].

A 512MB 4KB workload (131K PTEs) or a 16GB THP workload (8192 PMDs), in
contrast, far exceeds the L2 TLB capacity and triggers enough TLB eviction
for the hardware to set the Accessed bit normally.  DAMON monitoring results
are correct in these cases.

DAMON's WSS (Working Set Size) estimation may therefore report active
regions as inactive, producing up to 100% error, and DAMOS schemes may never
trigger correctly.

This issue was observed in DAMON selftests and was addressed by increasing the
test working set size to simulate production-like conditions, rather than
changing DAMON's TLB flush behavior [^2].  The selftest working set size was
increased up to 160 MiB for this reason.

## Recommendations

### For Users

If you observe unexpected `nr_accesses` values or inaccurate working
set size estimates, the cause is likely accesses being served by existing TLB entries without
triggering a page-table walk.  This happens when the working set fits
within the TLB reach, which is uncommon for production workloads but can
occur with small workloads.  See the For Testers section below for
how to verify this.

### For Testers and Developers

When writing DAMON tests, ensure the test workload's working set is large
enough to trigger natural TLB eviction on the target test machine.  The
exact size depends on the CPU's TLB configuration.  The DAMON selftest for WSS estimation uses working sets of up to 160 MiB,
after smaller working-set sizes were found unreliable on systems with large
TLB buffers [^2].

For out-of-tree tests, gradually increase the working set size until DAMON
reports stable and accurate results, then use that size as the baseline for
subsequent tests on the same hardware.

If DAMON reports unexpectedly low `nr_accesses` or no accesses despite an
actively running workload, the workload may fit within the effective TLB
reach — gradually increasing the working set size will confirm this.

The existing DAMON selftests follow this approach [^2].

## References

[^1]: [DAMON TLB flush overhead measurement](https://lore.kernel.org/20200403103059.12762-1-sjpark@amazon.com/)

[^2]: [DAMON selftest: increase working set size for reliable results](https://lore.kernel.org/20260117020731.226785-3-sj@kernel.org/)

[^3]: [DAMON mTHP split: THP hotspot overestimation on ARM64 test report](https://lore.kernel.org/all/20260618094838.32805-1-lianux.mm@gmail.com/)
