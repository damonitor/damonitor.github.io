+++
title = 'DAMON Release News (v6.19-rc1..v7.0-rc1)'
date = 2026-02-28T11:53:00-08:00
draft = false
categories = ['release_news']
tags = ['release_news', '7.0-rc1', 'news']
+++

This is also
[posted](https://lore.kernel.org/all/20260228194805.97228-1-sj@kernel.org/) to
the mailing list.

---

Hello community,


I shared DAMON quarterly news [1, 2, 3, 4] in 2024.  I was further planning to
write that for 2025 Q1.  But I dropped the ball and never finished it.  I'm
starting a new series of DAMON news, that aims to cover each -rc1 release.

This news letter covers DAMON features that landed on the mainline, and misc
events that were interesting to me that happened in v6.19-rc1..v7.0-rc1 time
period (2025-12-14..2026-02-22).

TL; DR
======

Interesting DAMON development ideas including PMU-based extension, automated
THP application, and new DAMOS quota auto-tune metrics for CXL-based tiered
memory systems have been proposed.

Two DAMON topics for LSF/MM/BPF are proposed.

In the time period, 12 grateful contributors landed 75 commits on the linux
mainline.

Notable Events
==============

In the time period, many events happened.  Among those, I think below events
are worthy to be noted here.

Release
-------

Seven DAMON hotfixes have landed on 6.19.

    $ git log v6.19-rc1..v6.19 --oneline -- mm/damon include/linux/damon.h \
            Documentation/mm/damon/ Documentation/admin-guide/mm/damon/ \
    	include/trace/events/damon.h samples/damon/ \
    	tools/testing/selftests/damon | wc -l
    7

Sixty six DAMON changes have landed on 7.0-rc1 during the merge window.

    $ git log v6.19..v7.0-rc1 --oneline -- mm/damon include/linux/damon.h \
            Documentation/mm/damon/ Documentation/admin-guide/mm/damon/ \
    	include/trace/events/damon.h samples/damon/ \
    	tools/testing/selftests/damon | wc -l
    66

Read below 'Changes Landed On ...' sections for more details of the changes
including user-visible ones (mostly new features).

New and Ongoing Developments
----------------------------

Enze Li proposed [5] to make DAMON supports loadable modules.  Because of the
lack of the real use case, it is on hold for now.

Asier proposed [6] a new DAMON module that finds hot processes and applies THP
to hot pages of the processes.  We are aligned on the high level approach,
though details might need some changes.  Asier is further working on tests.

Akinobu Mita proposed [7] PMU-based access check.  It could allow sub-page
level access monitoring and more interesting expansions of DAMON, such as
per-CPUs/processes/reads/writes monitoring.  It may be restrictive for virtual
machines, though.  Akinobu is looking at rebasing it on my page faults-based
similar extension RFC code.

Ravi Jonnalagadda proposed [8] new DAMOS quota goal metrics for weights-based
pages promotion and demotion on CXL-based tiered memory systems.  After a few
revisioning, I think we are now quite aligned on the direction of the change.
Ravi continues working on it, with tests.

LSF/MM/BPF
----------

DAMON is picked [9] as one of Linux kernel machine learning library
demonstration use cases.  DAMON community promised any collaborations for that
on demand.

Two DAMON-related LSF/MM/BPF topics are suggested.  The first one [10] aims to
discuss possible DAMON usage for THP, on production level.  It will share past
DAMON-based THP improvement works and why it was inappropriate on product
environments.  Further, it will brainstorm better approaches.  Asier's work may
also be discussed.

The second one [11] aims to make alignment on required DAMON-external changes
for page faults based per-CPUs/threads/reads/writes DAMON monitoring extension.
The very initial extension attempt was started from nearly the very beginning
of DAMON, and I continued it from last summer.  Hopefully it will make more
progress or happily fail early.

Misc
----

DAMON user-space tool (damo) started supporting trace-cmd [12], making use of
it on Android much easier.  It also started supporting command line
auto-completion [13].

DAMON development yearly retrospects for 2024 [14] and 2025 [15] are also
finally posted.

Statistics
==========

In the time period, 12 people made 75 grateful DAMON commits on the Linux
mainline.  The script is availabe at my GitHub toolbox repo [16].

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --linux_subsystems DAMON --since 2025-12-14 --until 2026-02-22
    1. SeongJae Park <sj@kernel.org>: 54 commits
    2. Shu Anzai <shu17az@gmail.com>: 5 commits
    3. Enze Li <lienze@kylinos.cn>: 3 commits
    4. Shakeel Butt <shakeel.butt@linux.dev>: 3 commits
    5. Kees Cook <kees@kernel.org>: 2 commits
    6. Linus Torvalds <torvalds@linux-foundation.org>: 2 commits
    7. Li RongQing <lirongqing@baidu.com>: 1 commits
    8. Aaron Yang <yangqixiao@inspur.com>: 1 commits
    9. Kevin Lourenco <klourencodev@gmail.com>: 1 commits
    10. JaeJoon Jung <rgbi3307@gmail.com>: 1 commits
    11. Swaraj Gaikwad <swarajgaikwad1925@gmail.com>: 1 commits
    12. Akinobu Mita <akinobu.mita@gmail.com>: 1 commits
    # 12 authors, 75 commits in total

DAMON user-space tool also got grateful changes.

    $ ./lazybox/version_control/authors.py ./damo --skip_merge_commits \
            --since 2025-12-14 --until 2026-02-22
    1. SeongJae Park <sj@kernel.org>: 335 commits
    2. Andrew Paniakin <apanyaki@amazon.com>: 2 commits
    # 2 authors, 337 commits in total

According to 'hkml' [20], DAMON mailing list received 440 mails of 111 threads.
77 threads were newly initiated.  Among the mails, 223 mails were for patches.
It included 43 series.

    $ hkml list damon --alias tmp --since v6.19-rc1 --until v7.0-rc1 --collapse --stdout --stat_only
    # (cached output)
    # 440 mails, 111 threads, 72 new threads
    # 223 patches, 43 series
    # oldest: 2025-12-11 04:56:14-08:00
    # newest: 2026-02-22 13:01:01-08:00

Huge appreciation to all the great contributors!

Changes landed on v6.19
=======================

All DAMON changes that landed on v6.19-rc1 via MM pull requests [17, 18] are
successfully landed on v6.19.

User-visible Changes
--------------------

Among the changes, below two new features are notable.

    commit adf7d6cdd716e: Patch series "mm/damon: support pin-point targets removal".
    commit d3946c5f4c1c5: Patch series "mm/damon: allow DAMOS auto-tuned for per-memcg per-node memory usage."

The first feature allows more efficient and flexible use of DAMON and DAMOS for
dynamic list of virtual address spaces.  It was motivated by Bijan's dynamic
access-aware memory interleaving on CXL-based memory tiering work.

The second feature is for general per-memcg per-node memory utilization based
automatic access-aware system operations.  The motivation was per-cgroup
fairness on memory tiering use case.

User-invisible Changes
----------------------

Below non-feature changes that made for more reliable and complete DAMON tests
are also notable.  The kunit tests memory bugs fix is now on all relevant
stable kernels.

    commit b5ab490d85b77: Patch series "mm/damon/tests: fix memory bugs in kunit tests".
    commit e859a224fad65: Patch series "mm/damon: fixes for address alignment issues in DAMON_LRU_SORT and DAMON_RECLAIM".
    commit 37104286f9390: Patch series "mm/damon/tests: add more tests for online parameters commit".

Changes landed on v7.0-rc1
==========================

During the 7.0-rc1 merge window, 66 DAMON patches have landed via the MM pull
request [19].

User-visible Changes
--------------------

In the merge window, below user-visible new features are added.

    commit 4835e2871321f: Patch series "mm/damon: advance DAMOS-based LRU sorting".
    commit 4a6ceb7c9744c: Patch series "mm/damon: introduce {,max_}nr_snapshots and tracepoint for damos stats".

The first series advances DAMON_LRU_SORT module, which protects hot LRU pages,
to be easier to control.  Support of active:inactive list size based automation
and DAMON monitoring intervals automation are especially notable.

The second series allows more deterministic control and internal behavior
observabilities for DAMOS.  The development was motivated by Ravi's dynamic
page interleaving latency/capacity improvement-aimed CXL memory tiering
approach.

User-invisible Changes
----------------------

Also important changes for DAMON tests improvement, API/code code refactoring,
and documentation cleanup were landed, including below series.

    commit 94a62284ede02: Patch series "selftests/damon: improve leak detection and wss estimation reliability."
    commit 6c59085fc0942: Patch series "mm/damon/tests/core-kunit: extend existing test scenarios",
    commit 4262c53236977: Patch series "mm/damon: hide kdamond and kdamond_lock from API callers".
    commit 50962b16c0d63: Patch series "mm/damon: cleanup kdamond, damon_call(), damos filter and DAMON_MIN_REGION."
    commit 32d11b3208971: Patch series "Docs/mm/damon: update intro, modules, maintainer profile, and misc."

References
==========

[1] 2024 Q1 news: https://lore.kernel.org//20240402191224.92305-1-sj@kernel.org/  
[2] 2024 Q2 news: https://lore.kernel.org/20241001002449.515043-1-sj@kernel.org/  
[3] 2024 Q3 news: https://lore.kernel.org/20241001191425.588219-1-sj@kernel.org/  
[4] 2024 Q4 news: https://lore.kernel.org/20250102211811.48322-1-sj@kernel.org/  
[5] loadable module support: https://lore.kernel.org/20251215142057.588500-1-lienze@kylinos.cn  
[6] THP-ing hot processes: https://lore.kernel.org/20260202145650.1795854-1-gutierrez.asier@huawei-partners.com  
[7] perf event based access check: https://lore.kernel.org/20260123021014.26915-1-akinobu.mita@gmail.com  
[8] node_target_[in]eligible_mem_bp: https://lore.kernel.org/20260123045733.6954-1-ravis.opensrc@gmail.com  
[9] ML library: https://lore.kernel.org/all/c24a209d5a4af0c4cc08f30098998ce16c668b58.camel@ibm.com/  
[10] DAMON for THP, LSFMMBPF: https://lore.kernel.org/all/20260211022845.68865-1-sj@kernel.org/  
[11] DAMON for faults, LSFMMBPF: https://lore.kernel.org/all/20260218054320.4570-1-sj@kernel.org/  
[12] damo trace-cmd support: https://damonitor.github.io/posts/damo_support_trace_cmd/  
[13] damo cli auto-completion: https://github.com/damonitor/damo/blob/next/USAGE.md#command-line-auto-completion  
[14] DAMON yearly restrospects, 2024: https://lore.kernel.org/all/20260216210625.68098-1-sj@kernel.org/  
[15] DAMON yearly retrospects, 2025: https://lore.kernel.org/all/20260222210102.153347-1-sj@kernel.org/  
[16] https://github.com/sjp38/lazybox/blob/master/version_control/authors.py  
[17] 6.19-rc1 mm pr 1/2: https://lore.kernel.org/20251203212918.82f1c9d3947940aeae263878@linux-foundation.org/  
[18] 6.19-rc1 mm pr 2/2: https://lore.kernel.org/20251211131127.defed99e5b82e49af605108a@linux-foundation.org/  
[19] 7.0-rc1 mm pr: https://lore.kernel.org/20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org/  
[20] https://docs.kernel.org/process/email-clients.html#hackermail-tui  


Thanks,
SJ
