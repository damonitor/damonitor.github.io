+++
title = 'DAMON Release Newsletter for v7.3-rc1'
date = 2026-08-30T16:52:00-07:00
draft = false
categories = ['release_news']
tags = ['release_news', '7.3-rc1', 'news']
+++

This is also
[posted](https://lore.kernel.org/20260830235014.64406-1-sj@kernel.org/) to the
mailing list.

---

This newsletter covers DAMON features that landed on or queued for the
mainline, development statistics and misc events that were noteworthy in my
opinion, that were happened from v7.2-rc1 (2026-06-28) to v7.3-rc1 (2026-08-30)
time period.

The newsletter covering the previous release cycle (v7.1-rc1..v7.2-rc1) is
also available [1].

TL; DR
======

Just after breaking the record of DAMON history in the last cycle, this cycle
again broke the record.  It was the busiest cycle of DAMON history.  20 authors
made 161 commits and 2283 lines of changes for DAMON on the Linux mainline.  A
new data attributes monitoring feature, a few optimizations for DAMON users,
and quite a lot of refactoring are delivered.  New DAMON usages and development
projects are shared.  The first DAMON (nano) Conference is scheduled.


Changes Landed on 7.2
=====================

All 95 commits that were landed on v7.2-rc1 have successfully landed on v7.2.
In addition to those, 15 additional hotfixes have merged into 7.2.

Those from 7.2-rc1 include a few user-visible and impactful features.  To pick
only two among those, new DAMOS auto-tuning goal for tiered memory system
(node_eligible_mem_bp, commit 9138e27a3bc38) and data attributes monitoring
(commit 45c49d9fd6089) are introduced.  Read the previous newsletter [1] for
more details.


Chanegs Landed for 7.3
======================

During the 7.3-rc1 merge window, 146 DAMON patches have landed via the MM pull
requests [2,3].  Introducing a few of changes that could introduce non-trivial
impacts.

New Features
------------

In this merge window, the below user-visible feature is added.

1. Commit 37aae41c1056: Patch series "mm/damon: introduce data attributes only
   monitoring".

This feature makes DAMON useful for monitoring not only the data access
pattern, but also general data attributes.  This is an important feature for
extending DAMON for not only access monitoring but general data attributes
monitoring.  It is also the foundation part of ongoing project [4] for multiple
access check primitives support.   As a followup, we are working on extending
data attributes to include access events.  Once it is done, access monitoring
will be just a part of flexible attributes monitoring.

Optimizations
-------------

This merge window also introduces below DAMON internal behavior optimizations.

1. Commit 1a582e6e0174: Patch series "mm/damon/core: detect internal variation
   above max_nr_regions/2", v3.
2. Commit aa497a270f68: Patch series "mm/damon: provide pseudo moving sum
   probe_hits".
3. Commit 6c25083f7ae7: mm/damon/ops-common: use nr_accesses moving sum for
   quota score

The first optimization is contributed by Jiayuan from Shopee.  With it, DAMON
makes more efforts on the monitoring accuracy.  The second optimization makes
snapshot-based data attributes monitoring (update_schemes_tried_regions) just
works.  Without it, DAMON tracepoints were the only reliable way to get
attributes monitoring results.  The third optimization improves DAMOS quality
in setups that separately and differently have schemes apply interval and
monitoring aggregation interval.

Refactoring
-----------

This merge window also introduced many cleanups and refactoring.  Below three
changes among those may be noteworthy.

1. Commit b90408ef1163: Patch series "mm/damon: validate all parameters in the
   core".
2. Commit 5bf9c1f3a97e: Patch series "mm/damon: refactor
   damon_{start,stop,commit}() for simple error handling".
3. Commit e0ea9467dbef: Patch series "mm/damon/core: hide core-private struct
   fields".

These are mostly motivated from recently found classes of bugs.  Hopefully
these refactoring will reduce future bugs of same classes.

Changes Cooking for >7.3
========================

A number of patches are queued and being developed for future mainline landing.
My personal tree for those (damon/next) contains 214 downstream patches as of
this writing.  Not all the patches are ready to be merged.  Some will be
squashed or broken down.  Anyway, the number was 231 for the last release
cycle.  This cycle might be less busier than the last cycle, but still expected
to be non-idle.

Statistics
==========

Putting simple statistics for the last release period.  Tools other than git
that are used here for getting the numbers are available [4,5] at GitHub.

In short, this cycle was the busiest cycle of DAMON development history.

Number Hotfixes and Non-hotfixes
--------------------------------

15 DAMON hotfixes have landed on 7.2.

    git -C ./ log v7.2-rc1..v7.2 --oneline --no-merges -- \
            Documentation/ABI/testing/sysfs-kernel-mm-damon \
            Documentation/admin-guide/mm/damon/ Documentation/mm/damon/ \
            Documentation/vm/damon/ include/linux/damon.h \
            include/trace/events/damon.h mm/damon/ samples/damon/ \
            tools/testing/selftests/damon  | wc -l
    15

146 six DAMON changes have landed on 7.3-rc1 during the merge
window.

    git -C ./ log v7.2..linus/master --oneline --no-merges -- \
            Documentation/ABI/testing/sysfs-kernel-mm-damon \
            Documentation/admin-guide/mm/damon/ Documentation/mm/damon/ \
            Documentation/vm/damon/ include/linux/damon.h \
            include/trace/events/damon.h mm/damon/ samples/damon/ \
            tools/testing/selftests/damon  | wc -l
    146

The numbers for the last ten release cycles are like below:

    7.2   fixes:  15  7.3   changes: 146
    7.1   fixes:  11  7.2   changes:  95
    7.0   fixes:  9   7.1   changes:  64
    6.19  fixes:  7   7.0   changes:  68
    6.18  fixes:  7   6.19  changes:  78
    6.17  fixes:  15  6.18  changes:  41
    6.16  fixes:  8   6.17  changes:  93
    6.15  fixes:  0   6.16  changes:  22
    6.14  fixes:  6   6.15  changes:  62
    6.13  fixes:  4   6.14  changes:  57

The 6.17 development cycle was the busiest DAMON development cycle in history
(~6 years since 5.15) before the 7.2 cycle.  The 7.2 cycle broke the record.
And right after that, this cycle for 7.3 broke the record again.

Authors, Commits and Changed Lines
----------------------------------

In this cycle, 20 people made gratful 161 commits and 2283 lines of changes
for DAMON on the Linux mainline.

    $ # stat for number of commits
    $ ./lazybox/version_control/authors.py ./linux/ \
            --since v7.2-rc1 --until v7.3-rc1 \
            --skip_merge_commits --linux_subsystems DAMON
    1. SJ Park <sj@kernel.org>: 130 commits
    2. Song Hu <husong@kylinos.cn>: 6 commits
    3. Kunwu Chan <chentao@kylinos.cn>: 3 commits
    4. SeongJae Park <sj@kernel.org>: 3 commits
    5. Jiayuan Chen <jiayuan.chen@shopee.com>: 2 commits
    6. Ruslan Valiyev <linuxoid@gmail.com>: 2 commits
    7. Cheng Nie <niecheng1@uniontech.com>: 2 commits
    8. Xuewen Wang <wangxuewen@kylinos.cn>: 1 commits
    9. Jiahui Zhang <jiahuitry@outlook.com>: 1 commits
    10. Enze Li <lienze@kylinos.cn>: 1 commits
    11. liyouhong <liyouhong@kylinos.cn>: 1 commits
    12. Lorenzo Stoakes <ljs@kernel.org>: 1 commits
    13. wang wei <a929244872@163.com>: 1 commits
    14. Sailesh Nandanavanam <saileshnandanavanam@gmail.com>: 1 commits
    15. Asier Gutierrez <gutierrez.asier@huawei-partners.com>: 1 commits
    16. Doehyun Baek <doehyunbaek@gmail.com>: 1 commits
    17. Philippe Laferriere <plafer@proton.me>: 1 commits
    18. Akinobu Mita <akinobu.mita@gmail.com>: 1 commits
    19. Arnd Bergmann <arnd@arndb.de>: 1 commits
    20. Zenghui Yu <yuzenghui@huawei.com>: 1 commits
    # 20 authors, 161 commits in total

    $ # stat for number of lines
    $ ./lazybox/version_control/authors.py ./worktree.linux/ \
            --since v7.2-rc1 --until v7.3-rc1 --skip_merge_commits \
            --linux_subsystems DAMON --sortby lines
    1. SJ Park <sj@kernel.org>: 1810 lines
    2. Jiayuan Chen <jiayuan.chen@shopee.com>: 113 lines
    3. Song Hu <husong@kylinos.cn>: 95 lines
    4. Ruslan Valiyev <linuxoid@gmail.com>: 85 lines
    5. Kunwu Chan <chentao@kylinos.cn>: 34 lines
    6. Cheng Nie <niecheng1@uniontech.com>: 33 lines
    7. Sailesh Nandanavanam <saileshnandanavanam@gmail.com>: 28 lines
    8. SeongJae Park <sj@kernel.org>: 26 lines
    9. Doehyun Baek <doehyunbaek@gmail.com>: 20 lines
    10. liyouhong <liyouhong@kylinos.cn>: 9 lines
    11. Xuewen Wang <wangxuewen@kylinos.cn>: 6 lines
    12. Lorenzo Stoakes <ljs@kernel.org>: 5 lines
    13. Akinobu Mita <akinobu.mita@gmail.com>: 4 lines
    14. Zenghui Yu <yuzenghui@huawei.com>: 3 lines
    15. Jiahui Zhang <jiahuitry@outlook.com>: 2 lines
    16. Enze Li <lienze@kylinos.cn>: 2 lines
    17. wang wei <a929244872@163.com>: 2 lines
    18. Asier Gutierrez <gutierrez.asier@huawei-partners.com>: 2 lines
    19. Philippe Laferriere <plafer@proton.me>: 2 lines
    20. Arnd Bergmann <arnd@arndb.de>: 2 lines
    # 20 authors, 2283 lines in total

Snapshots of the number of authors, commits and changed lines for the last ten
cycles are below.  The snapshots for the entire DAMON history is also available
[7] at the DAMON project blog.

    <version>  <nr_authors>  <nr_commits>  <nr_lines>
    v7.3-rc1   21            162           2283
    v7.2-rc1   14            109           3311
    v7.1-rc1   9             77            1070
    v7.0-rc1   12            75            1279
    v6.19-rc1  10            85            1640
    v6.18-rc1  13            59            864
    v6.17-rc1  8             104           3785
    v6.16-rc1  5             22            564
    v6.15-rc1  7             68            1479
    v6.14-rc1  8             61            4008

In terms of number of contributors and number of commits, this was the busiest
cycle in DAMON's development history.

DAMON user-space tool (damo) also got a significant amount of changes.

    ./lazybox/version_control/authors.py ./damo \
            --since 2026-06-28T12:01:31-07:00 \
            --until 2026-08-30T13:34:40-07:00 \
            --skip_merge_commits
    1. SJ Park <sj@kernel.org>: 257 commits
    2. Michel Lind <salimma@fedoraproject.org>: 1 commits
    3. Enze Li <lienze@kylinos.cn>: 1 commits
    4. Daniel Lysyi <daniellysy566@gmail.com>: 1 commits
    5. oopiec <157018150+oopiec@users.noreply.github.com>: 1 commits
    # 5 authors, 261 commits in total

The last line was "4 authors, 151 commits in total" for the last cycle [1].

Mailing List Traffic
--------------------

DAMON mailing list was quite busy.

    $ hkml list damon --since v7.2-rc1 --until v7.3-rc1 --collapse \
            --stat_only --stdout --ignore_cache
    # stat for total mails
    # 2019 mails, 183 threads, 180 new threads
    # 871 patches, 148 series
    [...]

The traffic for the last ten cycles were like below.  The numbers for the
entire DAMON development history is also available [7] at DAMON project blog.

    <version>  <nr_mails>  <nr_threads>  <nr_new_threads>  <nr_patches>  <nr_series>
    v7.3-rc1   2019        183           180               871           148
    v7.2-rc1   1486        164           142               671           126
    v7.1-rc1   1098        152           147               450           129
    v7.0-rc1   426         111           58                223           43
    v6.19-rc1  414         48            43                222           38
    v6.18-rc1  563         82            62                211           53
    v6.17-rc1  499         78            72                256           64
    v6.16-rc1  147         40            31                63            22
    v6.15-rc1  263         56            41                176           34
    v6.14-rc1  260         55            34                154           23

So the traffic is continuously and exponentially increasing.  By every traffic
metric, the last cycle was the busiest cycle in DAMON's history.

Events
======

Lian Wang from ProcessMission continued working on mTHP monitoring
improvement.  As a part of it, they developed and shared patches [8] for
extending DAMOS to flexibly handle mTHP collapse and split.

Asier Gutierrez from Huawei continued working on DAMOS tuning goal for THP
(hugepage_mem_bp).  The latest version [9] of the series has passed my humble
review.  Hopefully it will be merged into 7.4-rc1.

Kunwu Chan and Lian Wang developed and shared [10] ARM SPE based DAMON backend.
As soon as the major milestones of ongoing projects for multiple DAMON access
check primitives support [4] is completed, this series will also hopefully be
merged.

Jason Angelov developed and shared [11] a user-space pager that finds cold
pages using DAMON and compresses those.

Krishna Iyer from Crusoe developed and shared patches [12] for monitoring
hugetlb pages on physical address space mode.  It also includes interesting
test results on Crusoe's VM host setups.

I'm also more that excited to share that we will have our first DAMON (nano)
Conference [13] at LPC this year.  There will be five small sessions covering
the evolution of DAMON for multiple access check primitives, memory tiering,
huge pages, and AI cloud.  Refer to the website [13] for more details.

Newsletter Subscription
=======================

This newsletter series is posted to DAMON mailing list [14] and archived on the
project blog [15], for each release.  If you want a reliable delivery of this
newsletter series to your inbox, subscribing to the mailing list [16] could be
an option.  If the mailing list traffic is too much, feel free to ask me (send
mail to sj@kernel.org) to [b]cc you for each newsletter posting.

References
==========

[1] 7.2-rc1 news: https://lore.kernel.org/20260628211904.94361-1-sj@kernel.org/  
[2] First MM PR for 7.3-rc1:  
    https://lore.kernel.org/178728181878.600189.588163658498005550.pr-tracker-bot@kernel.org  
[3] Second MM PR for 7.3-rc1:  
    https://lore.kernel.org/20260826152330.9cdd482b43726942d6c149cb@linux-foundation.org/  
[4] DAMON access primitives extension roadmap:  
    https://lore.kernel.org/20260525225208.1179-1-sj@kernel.org/  
[5] authors.py: https://github.com/sjp38/lazybox/blob/master/version_control/authors.py  
[6] hkml: https://github.com/hackermail  
[7] DAMON development stat history: https://damonitor.github.io/posts/dev_stat/  
[8] DAMOS mTHP collapse/split series:  
    https://lore.kernel.org/20260720030327.80153-1-lianux.mm@gmail.com  
[9] hugepage_mem_bp series:  
    https://lore.kernel.org/20260720120140.881468-1-gutierrez.asier@huawei-partners.com  
[10] ARM SPE-based DAMON backend:  
     https://lore.kernel.org/all/20260816142222.689624-1-kunwu.chan@linux.dev/  
[11] Cold Pages DAMON Pager:  
     https://github.com/jasonangelov/damon-compression-pager  
[12] paddr hugetlb monitoring series:  
     https://lore.kernel.org/20260830051407.50008-1-kiyer@crusoe.ai/  
[13] DAMON (nano) Conference: https://lpc.events/event/20/contributions/2453/  
[14] DAMON mailing list: https://lore.kernel.org/damon  
[15] News letter on project blog: https://damonitor.github.io/tags/release_news/  
[16] Mailing list subscription guide: https://subspace.kernel.org/subscribing.html  
