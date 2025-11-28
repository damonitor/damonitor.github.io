+++
title = 'A rough plan for CPUs/write-only monitoring RFC v3 and future'
date = 2025-11-28T11:47:34-08:00
draft = false
tags = ["development plan", "CPUs/write-only monitoring", "Write-only",
"Cpus-only"]
categories = ["development plan"]
+++

Below is also sent as a
[mail](https://lore.kernel.org/20251128193947.80866-1-sj@kernel.org) to DAMON
mailing list and relevant people.

---

I'm working [1] on extending DAMON to monitor accesses that are made by
specific CPUs, and/or for writes.  The aimed usages include NUMA hit/miss
monitoring [2], Kernel Same page Merging scan target selection [3,4], cache
aware CPU scheduling, live migration target VM selection [5], and general
NUMA-aware pages migration [6].

I posted its first working version as RFC v2 [7] about four months ago.  After
the posting, it got interests and tests publicly [5] and privately.  RFC v2
was, however, a never upstreamable hack that was made for only showing if it
can be implemented.  For making it upstreamed, a significant amount of efforts
are expected [8].  And after the posting, I was unfortunately unable to spend
meaningful time on it due to other events and work.  I received more continued
interests in the work recently, and hence I'm trying to spend more time on it.

The Rough Plan
--------------

The rough plan of it that I shared on DAMON blog [8] was just saying "it needs
to be upstreamed and it will require a significant amount of effort".  So I'm
sharing yet another rough plan here.

This work require multiple changes including
1. extending DAMON for receiving access report from other subsystems
   (damon_report_access() [9]),
2. making other subsystem who can capture origin CPU/writeness of accesses
   (e.g., page fault handler [10]) report the information to DAMON,
3. extending DAMON for filtering the reports for origin CPU/writeness of
   accesses.

The first part in the current implementation has many rooms to improve in terms
of performance.  I don't think that's upstreaming blocker though, unless some
early testers find a problem of it.  So I think this is not a blocker for this
project, at least at the moment.

For the second part, I'm trying to modify the page fault handler, to use
information like NUMA balancing hint faults.  As Lorenzo pointed out on RFC v2,
it needs to have clean and non disruptive design.  Also this requires alignment
of multiple stakeholders, including MM core and NUMA balancing maintainers.  I
think this is the biggest challenge of this project.  Using other subsystems or
features such as instruction sampling can be another way to go.  But for
general availability of it on any architecture and virtual machine internal
cases, people I privately discussed preferred this fault based approach.  I
will try to make the alignment with the stakeholders, after the upcoming LPC [11].
Unless I make good progress on this part very quickly, I will propose an
LSFMMBPF'26 [12] session for this.  So hopefully we will make some alignment
among the stakeholders by LSFMM.  Hopefully we will get a more concrete
upstreaming plan and timeline, at least after the LSFMM'26.

The third part in current implementation is very ugly.  Especially its kernel
API and user ABI need to be redesigned from the beginning.  The interface is
better to be stabilized sooner, as changes of the interface will make the early
users/testers be confused and frustrated.  I started working on this, and
hopefully I will share RFC v3 of this project with the stabilized interface, by
upcoming LPC'25.

Summary and Message for User/Tester
-----------------------------------

To summarize the major expected timeline here,

1. By LPC'25 (2025-12-13), another version having stabilized DAMON interface
   will be shared.
2. By LSFMMBPF'26 (2026-05-06), an alignment on part 2 stakeholders will be
   made.
3. After the alignment, a more clear plan will be made.

If you are already using or testing RFC v2 of this project, please be aware the
kernel API and user ABI will significantly be changed on the version that I am willing to
share by LPC'25.  It means if you are directly using or testing the features
via the kernel API and/or user ABI, your usages or tests might need to be
updated.

The support of the features on DAMON user-sapce tool (damo) is also
experimental at the moment, and that will also be changed in more stable form
in future.  But, the experimental interface will support both before-LPC and
after-LPC DAMON for the short term.  Hence, if you are using or testing the
features via DAMON user-space tool's experimental interface, you will not need
to make any change in the short term.

Please feel free to raise any questions or comments on the plan and the
project.

References
----------

[1] https://damonitor.github.io/posts/write_only_cpus_only_monitoring/  
[2] https://lore.kernel.org/linux-mm/cover.1645024354.git.xhao@linux.alibaba.com/  
[3] https://lore.kernel.org/lkml/20220203131237.298090-1-pedrodemargomes@gmail.com/  
[4] https://lore.kernel.org/damon/20250129044041.25884-1-pedrodemargomes@gmail.com/  
[5] https://lore.kernel.org/all/aJAfTUh-49pYuhbg@3c06303d853a/  
[6] https://lpc.events/event/19/contributions/2066/  
[7] https://lore.kernel.org/all/20250727201813.53858-1-sj@kernel.org/  
[8] https://damonitor.github.io/posts/write_only_cpus_only_monitoring/#cautions-and-plan-to-drop-experimental-tag  
[9] https://lwn.net/Articles/1016525/  
[10] https://lore.kernel.org/all/20250727201813.53858-6-sj@kernel.org/  
[11] https://lpc.events/event/19/  
[12] https://events.linuxfoundation.org/lsfmmbpf/  
