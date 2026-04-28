+++
title = 'DAMON Release News Letter (v7.0-rc1..v7.1-rc1)'
date = 2026-04-28T08:10:25-08:00
draft = false
categories = ['release_news']
tags = ['release_news', '7.1-rc1', 'news']
+++

This is also
[posted](https://lore.kernel.org/20260428150817.125575-1-sj@kernel.org/) to the
mailing list.

---

Hello community,


This news letter covers DAMON features that landed on the mainline, and misc
events that were interesting to me that happened in v7.0-rc1..v7.1-rc1 time
period (2026-02-22..2026-04.26).

The news letter covering the previous release cycle (v6.19-rc1..v7.0-rc1) is
also available [1].

Changes Landed On v7.0
======================

All changes that were landed on v7.0-rc1 have successfully landed on v7.0.
Read the news letter for v7.0-rc1 [1] for the list of changes.

Changes Landed For v7.1
=======================

During the 7.1-rc1 merge window, 67 DAMON patches have landed via the MM pull
requests [2,3].  Introducing a few of changes that could introduce non-trivial
user impacts.

New Features
------------

In the merge window, below user-visible new features are added.

    commit 8719c59c4b928: Patch series "mm/damon: support multiple goal-based quota tuning algorithms".
    commit c63067e8b0849: Patch series "mm/damon: support addr_unit on default monitoring targets for modules".

The first series extends DAMOS quota auto-tuning to allow users select the
tuning algorithms.  Together with the extension, a new tuning algorithm, namely
temporal, is introduced.  The new algorithm is expected to be useful for
user-space control based deterministic DAMOS utilization.

The second series extends the support of 32 bit machines with physical address
extensions for all DAMON modules.

Internal Improvements
---------------------

Below two significant internal implementation improvements also landed.

    commit e7e1a26b8ddf0: Patch series "mm/damon/core: improve DAMOS quota efficiency for core layer filters".
    commit b1029f29eb1d5: Patch series "mm/damon: strictly respect min_nr_regions".

The first series makes the core layer DAMOS filters be more practical.  Due to
the impracticality, complex DAMOS use cases were recommended to use multiple
DAMON contexts as workaround.  With the series, the workarounds will hopefully
no longer be required.

The second series makes min_nr_regions parameters strictly respected.  This is
expected to be useful for more deterministic fixed granularity monitoring.

Statistics
==========

Putting simple statistics for the last release period.  Tools other than git
that are used here for getting the numbers are available [4,5] at GitHub.

Number of DAMON Commits
-----------------------

Nine DAMON hotfixes have landed on 7.0.

    $ git log v7.0-rc1..v7.0 --oneline --no-merges -- \
            mm/damon include/linux/damon.h Documentation/mm/damon/ \
            Documentation/admin-guide/mm/damon/ include/trace/events/damon.h \
            samples/damon/ tools/testing/selftests/damon | wc -l
    9

Sixty seven DAMON changes have landed on 7.1-rc1 during the merge window.

    $ git log v7.0..v7.1-rc1 --oneline --no-merges -- \
            mm/damon include/linux/damon.h Documentation/mm/damon/ \
            Documentation/admin-guide/mm/damon/ include/trace/events/damon.h \
            samples/damon/ tools/testing/selftests/damon | wc -l
    67

The numbers were 7 and 66 for v6.19-rc1..v6.19 and v6.19..v7.0-rc1.

Contributors
------------

In the time period, eight people made 73 grateful DAMON commits on the Linux
mainline.

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --linux_subsystems DAMON --since 2026-02-22 --until 2026-04-26
    1. SeongJae Park <sj@kernel.org>: 58 commits
    2. Josh Law <objecting@objecting.org>: 7 commits
    3. Liew Rui Yan <aethernet65535@gmail.com>: 2 commits
    4. Asier Gutierrez <gutierrez.asier@huawei-partners.com>: 2 commits
    5. Jackie Liu <liuyun01@kylinos.cn>: 1 commits
    6. Vineeth Pillai (Google) <vineeth@bitbyteword.org>: 1 commits
    7. qinyu <qin.yuA@h3c.com>: 1 commits
    8. Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>: 1 commits
    # 8 authors, 73 commits in total

The last line was "12 authors, 75 commits in total" for v6.19-rc1..v7.0-rc1 [1]
period.  The number of contributors has bit decreased, while the number of
commits has nearly not changed.

DAMON user-space tool (damo) also got a significant amount of changes.

    $ ./lazybox/version_control/authors.py ./damo --skip_merge_commits \
            --since 2026-02-22 --until 2026-04-26
    1. SeongJae Park <sj@kernel.org>: 123 commits
    # 1 authors, 123 commits in total

The last line was "2 authors, 337 commits in total" for v6.19-rc1..v7.0-rc1 [1]
period.  It means still a high number of changes are made for the user-space
tool, but the number has significantly reduced in this release cycle.  I think
that's mainly because I was busy for hkml-Sashiko integration, Sashiko-found
issues and LSF/MM/BPF preparation.

Mailing List Traffic
--------------------

DAMON mailing list was quite busy.

    $ hkml list damon --since v7.0-rc1 --until v7.1-rc1 --collapse \
            --stat_only --stdout
    # stat for total mails
    # 1098 mails, 152 threads, 147 new threads
    # 450 patches, 129 series

The traffic for the last release period was like below.

    $ hkml list damon --since v6.19-rc1 --until v7.0-rc1 --collapse \
            --stat_only --stdout
    # stat for total mails
    # 440 mails, 111 threads, 72 new threads
    # 223 patches, 43 series

While the number of landed commits for the last two release cycle were similar,
the traffic has significantly increased compared to the previous release cycle.
I suspect Sashiko might have made the impact.

Events
======

Listing a few events that happened in the last release cycle, and I think
noteworthy for DAMON community.

Sashiko
-------

In the middle of the last release cycle, Google-developed AI review system
Sashiko has announced [6].  It turned out to be useful for not only gating new
bugs but also for finding existing bugs.  As a result, more than 10 fixes for
DAMON are made.

    $ git log --author sj@kernel.org --grep "discovered" | grep "ashiko"
        The issue was discovered [1] by Sashiko.
        The issue was discovered [1] by Sashiko.
        The issue was discovered [1] by Sashiko.
        The issue was discovered by sashiko [1].
        The issue was discovered [1] by sashiko.
        The issue was discovered in [1] by sashiko.
        The issue was discovered [1,2] by sashiko.
        The issue was discovered in [1] by sashiko.
        The issue was discovered [1] by sashiko.
        The issue was discovered [1] by sashiko.
        This issue is discovered by sashiko [1].

Continued DAMON Development From Contributors
---------------------------------------------

Ravi Jonnalagadda from Micron continued their node_eligible_mem_bp DAMOS quota
goal development.  By the time of v7.1-rc1 release, Ravi posted v8 [7] of the
patch.  It looks good and almost ready to be landed to me.  This work also
inspired the multiple quota tuning algorithm series that landed for 7.1-rc1.

Asier Gutierrez from Huawei continued their work for making DAMOS more useful
for THP.  As a result, Asier made DAMOS_COLLAPSE patch [8] merged in the
damon/next tree.  Hopefully this will be landed on the mainline for 7.2-rc1.

Akinobu Mita continued their work for extending DAMON with perf events for
lightweight fine and fixed granularity monitoring.  By the time of v7.1-rc1
release, Akinobu posted RFC v3 [9] of the patch series.  It is currently
blocked for the general data attributes monitoring interface [10] that I'm
working on.  Hopefully the data attributes monitoring interface will soon be
stabilized and Akinobu's work will be unblocked.  This work also inspired the
strict min_nr_regions respect series that landed for 7.1-rc1.

Liew Rui Yan started contributing patches to DAMON.  It resulted in two
hotfixes being merged into the mainline, and a few more patches that queued
into damon/next aiming 7.2-rc1 merge.

DAMON at LSF/MM/BPF
-------------------

In addition to the two DAMON topics [11,12] for LSF/MM/BPF that were proposed
in the last release cycle, I proposed one more topic [13] in the last release
cycle.  Thankfully all three topics are accepted and scheduled [14] for an one
hour session.

References
----------

[1] 7.0-rc1 news:
    https://lore.kernel.org/all/20260228194805.97228-1-sj@kernel.org/ 
[2] MM PR for 7.1-rc1:
     https://lore.kernel.org/20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org/ 
[3] Second MM PR for 7.1-rc1:
     https://lore.kernel.org/20260418223823.b45ef6a83267fa886d182ed7@linux-foundation.org/ 
[4] authors.py: https://github.com/sjp38/lazybox/blob/master/version_control/authors.py 
[5] hkml: https://github.com/hackermail 
[6] Sashiko announcement:
    https://lore.kernel.org/all/7ia4o6kmpj5s.fsf@castle.c.googlers.com/ 
[7] node_eligible_mem_bp v8:
    https://lore.kernel.org/20260426003245.2687-1-ravis.opensrc@gmail.com 
[8] DAMOS_COLLAPSE:
    https://lore.kernel.org/20260409150128.1566835-1-gutierrez.asier@huawei-partners.com/ 
[9] perf events based DAMON extension:
    https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com/ 
[10] Data Attributes Monitoring:
     https://lore.kernel.org/20260426205222.93895-1-sj@kernel.org/ 
[11] LSF/MM/BPF topic for access-aware THP:
     https://lore.kernel.org/20260211022845.68865-1-sj@kernel.org/ 
[12] LSF/MM/BPF topic for allowing NUMA hinting faults to DAMON:
     https://lore.kernel.org/20260218054320.4570-1-sj@kernel.org/ 
[13] LSF/MM/BPF topic for DAMON updates:
     https://lore.kernel.org/20260307210250.204245-1-sj@kernel.org/ 
[14] LSF/MM/BPF schedule:
     https://docs.google.com/spreadsheets/d/1mGEdDrWskp7Ua91jGXzquQGinorcD58DAVXhOiRp2Gg/edit?gid=1852749899#gid=1852749899 
