+++
title = 'DAMON Release Newsletter for v7.2-rc1'
date = 2026-06-28T14:23:22-07:00
draft = false
categories = ['release_news']
tags = ['release_news', '7.2-rc1', 'news']
+++

This is also
[posted](https://lore.kernel.org/20260628211904.94361-1-sj@kernel.org) to the
mailing list.

---

Hello community,


This newsletter covers DAMON features that landed on the mainline, queued for
the mainline, development statistics and misc events that were interesting to
me that happened in v7.1-rc1..v7.2-rc1 time period (2026-04-26..2026-06-28).

The newsletter covering the previous release cycle (v7.0-rc1..v7.1-rc1) is
also available [1].

TLDR
====

The last development cycle for DAMON was the busiest cycle of its mainline
history (~5 years, since 2021 September).  12 Authors landed 106 DAMON patches
for a number of changes including 7 new features on the mainline.  A roadmap
for extending DAMON to utilize AMD IBS, Intel PEBS like h/w features and do
per-CPUs/threads/reads/writes monitoring is made.

Changes Landed on 7.1
=====================

All changs that were landed on v7.1-rc1 have successfully landed on v7.1.  The
changes include selective DAMOS auto-tuning algorithms (commit 8719c59c4b928).
Read the newsletter for 7.1-rc1 [1] for more details of the changes.

Chanegs Landed for 7.2
======================

During the 7.2-rc1 merge window, 95 DAMON patches have landed via the MM pull
requests [2,3].  Introducing a few of changes that could introduce non-trivial
user impacts.

New Features
------------

In the merge window, below user-visible new features are added.

1. Commit 9138e27a3bc38: "mm/damon: add node_eligible_mem_bp goal metric"
2. Commit c7ec7d5f6b3d1 "mm/damon: introduce DAMOS failed region quota charge
   ratio"
3. Commit 3b9e3cc0405b4 "mm/damon: let DAMON be paused and resumed"
4. Commit 70d8797c15d64 "mm/damon/reclaim,lru_sort: monitor all system rams by
   default"
5. Commit 0453f857eb32c "mm/damon/reclaim: support monitoring intervals
   auto-tuning"
6. Commit 3a0bc9568c354 "mm/damon/stat: add kdamond_pid parameter".
7. Commit 45c49d9fd6089 "mm/damon: introduce data attributes monitoring".

Feature 1 is developed by Ravi at Micron, for their auto-tuned dynamic
DRAM/CXL memory interleaving for memory bandwidth optimization.

Features 2 and 3 make DAMOS be more deterministically controllable.

Features 4-6 improves DAMON modules for easier control and more reliable
operations.

Feature 7 introduces the data attributes monitoring, which enables light-weight
page level (e.g., cgroup-aware) access monitoring.  It will also be the
foundation of the ongoing collaboration project.

Deprecation
-----------

In the merge window, below change for deprecating one user-visible feature is
also merged.  It deprecates a directory in DAMON sysfs interface. Users can
replace it with its alternatives, 'core_filters/' and 'ops_filters/'
directories.  We will continue supporting the deprecated feature for a while,
but will eventually remove it.  Please update your usages, or request holding
the removal if it is really needed for you.

- Commit 7e6cc9f954aa3: "mm/damon/sysfs: document filters/ directory as
  deprecated"

Changes Cooking for >7.3
========================

A number of patches are queued and being developed for 7.3-rc1.  My personal
tree for those (damon/next) contains 231 downstream patches as of this writing.
Not all the patches are aiming to be merged into 7.3-rc1.  However, apparently
the next cycle will also not be a very idle cycle.

Statistics
==========

Putting simple statistics for the last release period.  Tools other than git
that are used here for getting the numbers are available [4,5] at GitHub.

In short, this cycle was the busiest cycle of DAMON development history.

Number of DAMON Commits
-----------------------

Eleven DAMON hotfixes have landed on 7.1.

    $ git log v7.1-rc1..v7.1 --oneline --no-merges -- \
            mm/damon include/linux/damon.h \
            Documentation/mm/damon/ Documentation/admin-guide/mm/damon/ \
	    Documentation/ABI/testing/sysfs-kernel-mm-damon \
            include/trace/events/damon.h samples/damon/
            tools/testing/selftests/damon | wc -l
    11

Ninty two DAMON changes have landed on 7.2-rc1 during the merge window.

    $ git log v7.1..v7.2-rc1 --oneline --no-merges -- \
            mm/damon include/linux/damon.h \
            Documentation/mm/damon/ Documentation/admin-guide/mm/damon/ \
	    Documentation/ABI/testing/sysfs-kernel-mm-damon \
            include/trace/events/damon.h samples/damon/ \
            tools/testing/selftests/damon | wc -l
    95

The numbers for the last seven release cycles are like below:

    7.1   fixes:  11  7.2   changes:  95
    7.0   fixes:  9   7.1   changes:  64
    6.19  fixes:  7   7.0   changes:  68
    6.18  fixes:  7   6.19  changes:  78
    6.17  fixes:  15  6.18  changes:  41
    6.16  fixes:  8   6.17  changes:  93
    6.15  fixes:  0   6.16  changes:  22

The 6.17 development cycle was the busiest DAMON development cycle in history
(~5 years since 5.15).  This cycle broke the record.

Contributors
------------

In this cycle, 12 people made 106 grateful DAMON commits on the Linux mainline.

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --linux_subsystems DAMON --since v7.1-rc1 --until v7.2-rc1
    1. SeongJae Park <sj@kernel.org>: 91 commits
    2. Liew Rui Yan <aethernet65535@gmail.com>: 4 commits
    3. Maksym Shcherba <maksym.shcherba@lnu.edu.ua>: 2 commits
    4. Zenghui Yu <zenghui.yu@linux.dev>: 1 commits
    5. Sakurai Shun <ssh1326@icloud.com>: 1 commits
    6. niecheng <niecheng1@uniontech.com>: 1 commits
    7. Kefeng Wang <wangkefeng.wang@huawei.com>: 1 commits
    8. Vineet Agarwal <agarwal.vineet2006@gmail.com>: 1 commits
    9. Jiayuan Chen <jiayuan.chen@shopee.com>: 1 commits
    10. Asier Gutierrez <gutierrez.asier@huawei-partners.com>: 1 commits
    11. Cheng-Han Wu <hank20010209@gmail.com>: 1 commits
    12. Ravi Jonnalagadda <ravis.opensrc@gmail.com>: 1 commits
    # 12 authors, 106 commits in total

The last lines for the last eight release cycles are like below:

    7.2-rc1:   #  12  authors,  106  commits  in  total
    7.1-rc1:   #  8   authors,  73   commits  in  total
    7.0-rc1:   #  12  authors,  75   commits  in  total
    6.19-rc1:  #  10  authors,  85   commits  in  total
    6.18-rc1:  #  11  authors,  56   commits  in  total
    6.17-rc1:  #  7   authors,  101  commits  in  total
    6.16-rc1:  #  5   authors,  22   commits  in  total
    6.15-rc1:  #  7   authors,  68   commits  in  total

DAMON user-space tool (damo) also got a significant amount of changes.

    $ ./lazybox/version_control/authors.py ./damo --skip_merge_commits \
            --since 2026-04-26 --until 2026-06-28
    1. SeongJae Park <sj@kernel.org>: 146 commits
    2. Sean Jackson <sjackson@crusoe.ai>: 2 commits
    3. Kunwu Chan <kunwu.chan@gmail.com>: 2 commits
    4. Zeyu Wang <wangzeyu2024@lzu.edu.cn>: 1 commits
    # 4 authors, 151 commits in total

The last line was "1 authors, 123 commits in total" for the last cycle [1].
Both the number of contributors and the number of commits have significantly
increased.

Mailing List Traffic
--------------------

DAMON mailing list was quite busy.

    $ hkml list damon --since v7.1-rc1 --until v7.2-rc1 \
            --collapse --stat_only --stdout
    # stat for total mails
    # 1480 mails, 163 threads, 141 new threads
    # 670 patches, 125 series
    [...]

The traffic for the last cycle period was like below.

    $ hkml list damon --since v7.0-rc1 --until v7.1-rc1 \
            --collapse --stat_only --stdout
    # stat for total mails
    # 1098 mails, 152 threads, 147 new threads
    # 450 patches, 129 series
    [...]

The traffic has also sigificantly increased.  Since the traffic is not only for
the 7.2-rc1 but also for 7.3-rc1, 7.3-rc1 might have even more DAMON changes.

Events
======

Ravi from Micron landed DAMOS_QUOTA_ELIGIBLE_MEM_BP patch [6] for auto-tuned
DRAM/CXL memory dynamic interleaving has finally reached the mainline.

A few DAMON topics were discussed in LSFMMBPF'26.  The topics included
- update of DAMON developments for CXL and memory tiering and plan for general
  NUMA management,
- a plan for extending DAMON to Data Attributes Monitoring and Operations
  eNgine that will cover per-cgroup light-weight access monitoring,
- a way for extending DAMON to enable per-CPUs/threads/reads/writes monitoring,
- ways to use DAMON for huge pages, and
- DAMON Enabled Compute Systems (DAMON-X).
Refer to LWN's great article [7] summarizing the discussions.

Akinobu continued [8] perf event based DAMON extension.  Ravi implemented [9]
h/w sampled access reports  that can utilize AMB IBS and Intel PEBS on it.  We
made a roadmap [10] for making it all upstreamed by LSFMMBPF'27.

Bijan from UW-Madison published a paper [11] for the dynamic memory
interleaving for tiered memory system at ISMM'26.  Apparently the work was a
collaboration between UW-Madison and Micron.

Asier from Huawei continued [12] work on DAMOS auto-tuning goal for THP.
Wang Lian shared [13] an RFC patch series and plans for adding mTHP collapse/split
management and ARM SPE feedback utilization to DAMON.

DAMON project blog got its first and grateful post contribution [14] from Kunwu
Chan, for its TLB policy.

The Chinese Kernel Community organized a meetup [15], with a session for DAMON.

Liew Rui Yan shared [16] their user-space program for auto-tuning of
DAMON-based reclamation, dama.

New Letter Subscription
=======================

This newsletter series is posted to DAMON mailing list [17] and archived on the
project blog [18], for each release.  If you want a reliable delivery of this
newsletter series to your inbox, subscribing to the mailing list [18] could be
an option.  If the mailing list traffic is too much, feel free to ask me (send
mail to sj@kernel.org) to [b]cc you for each newsletter posting.

References
==========

[1] 7.1-rc1 news: https://lore.kernel.org/20260428150817.125575-1-sj@kernel.org  
[2] First MM PR for 7.2-rc1:
    https://lore.kernel.org/20260618093027.803700be945480575260b0f3@linux-foundation.org/  
[3] Second MM PR for 7.2-rc1:
    https://lore.kernel.org/20260623085840.0819c7694831ca2055e6a733@linux-foundation.org/  
[4] authors.py: https://github.com/sjp38/lazybox/blob/master/version_control/authors.py  
[5] hkml: https://github.com/hackermail  
[6] DAMOS_QUOTA_ELIGIBLE_MEM_BP patch:
    https://lore.kernel.org/20260428030520.701-1-ravis.opensrc@gmail.com  
[7] LWN artile for LSFMMBPF'26 DAMON session: https://lwn.net/Articles/1071256/  
[8] perf event extension:
    https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com  
[9] H/W sampled access repors:
    https://lore.kernel.org/20260529165640.820-1-ravis.opensrc@gmail.com  
[10] DAMON extension roadmap:
     https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/  
[11] Dynamic interleaving paper: https://dl.acm.org/doi/10.1145/3814942.3816137  
[12] DAMOS_HUGEPAGE_MEM_BP:
     https://lore.kernel.org/20260616150316.580819-1-gutierrez.asier@huawei-partners.com  
[13] mTHP and ARM SPE:
     https://lore.kernel.org/20260618094838.32805-1-lianux.mm@gmail.com  
[14] DAMON tlb flush poste: https://damonitor.github.io/posts/tlb_flush_policy/  
[15] Chinese kernel meetup:
     https://www.linkedin.com/posts/wang-lian-03b180271_linuxkernel-opensource-kerneldevelopment-share-7475789130229223425-CCk9/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAuQ2s0BFPM2rGjEAKbwpwDB53YY6CCA9lY  
[16] dama: https://lore.kernel.org/20260628085155.20828-1-aethernet65535@gmail.com  
[17] DAMON mailing list: https://lore.kernel.org/damon  
[18] News letter on project blog: https://damonitor.github.io/tags/release_news/  
[18] Mailing list subscription guide:
     https://subspace.kernel.org/subscribing.html  


Thanks,
SJ

