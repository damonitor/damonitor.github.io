---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "DAMON News List"
subtitle: ""
summary: ""
authors: []
tags: ["damon", "linux", "kernel", "mm", "projects", "news"]
categories: ["damon"]
date: 2023-05-06T11:27:07-07:00
lastmod: Wed, 09 Jul 2025 04:23:30 -0700
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

Below is a list of news around DAMON [project]({{< ref "damon.md" >}}).

This list is not exhaustive but just a DAMON maintainer's collection of news.
If you find a news that should be added to this list, please let us know at
sj@kernel.org and/or damon@lists.linux.dev.

---

2025
----

_2025-12-08_: Third RFC [patch
series](https://lore.kernel.org/damon/20251208062943.68824-1-sj@kernel.org/)
for per-CPU/threads/read/write monitoring is posted.

_2025-12-05_: DAMON changes for Linux 6.19-rc1 has merged as a part of MM
subsystem [pull
rquest](https://lore.kernel.org/20251203212918.82f1c9d3947940aeae263878@linux-foundation.org).
Major changes include but not limited to:
- Per-memcg per-node memory usage based DAMOS auto-tuning ([patch
  series](https://lore.kernel.org/20251017212706.183502-1-sj@kernel.org)). This
  allows cgroup-level NUMA memory management, such as hot pages promotion, cold
  pages demotion and reclaim. This was developed as a collaboration with my
  now-ex-colleagues at Meta.
- Address alignment fix for DAMON modules ([patch
  series](https://lore.kernel.org/20251020130125.2875164-1-yanquanmin1@huawei.com)).
  This was developed as a followup fix of ARM32 LAPE support, by Quanmin from
  Huawei.
- Pin-point targets removal ([patch
  series](https://lore.kernel.org/20251023012535.69625-1-sj@kernel.org)). This
  was developed as a
  [collaboration](https://github.com/damonitor/damo/issues/36), as a followup
  of his vaddr-based DAMOS-migration to multi-destination nodes.

_2025-11-13_: An idea for DAMON-based CXL memory management aiming both
  bandwidth and capacity efficiency, which motivated by recent works from
  Micron and SK Hynix, has
  [shared](https://lore.kernel.org/all/20251114014255.72884-1-sj@kernel.org/).

_2025-10-03_: DAMON changes including below two have been merged into Linux
6.18-rc1, via memory management subsystem [pull
request](https://lore.kernel.org/20251001190218.f33f695b869696c2df9e841d@linux-foundation.org).
- virtual address space page level monitoring
  [support](https://lkml.kernel.org/r/cover.1754135312.git.pyyjason@gmail.com),
  which was developed by Yueyang Pan (Meta).
- 32-bit ARM LAPE
  [support](https://lore.kernel.org/https://lkml.kernel.org/r/20250828171242.59810-1-sj@kernel.org),
  which was collaboratively developed by Meta and
  Huawei people (Quanmin Yan and Ze Zuo).

_2025-09-23_: DAMON has
[presented](https://kernel-recipes.org/en/2025/schedule/overcoming-observer-effects-in-memory-management-with-damon/)
at Kernel Recipes.

_2025-08-22_: A patch
[series](https://lkml.kernel.org/r/20250822093420.2103803-2-yanquanmin1@huawei.com)
for making DAMON supports ARM (32bit) with LPAE has just landed on mm-new tree.
It was made by a great and joyful collaboration between I and Huawei (Quanmin
Yan and Zuo Ze).

_2025-08-10_: DAMON user-space tool added a visualization script for [cold
memory tail](https://social.kernel.org/notice/Ax2IFjCCoj51eJgkNM)
visualization.

_2025-08-03_: A prototype of per-CPUs and write-only monitoing is implemented
and added to damon/next tree, and an experimental support of it is
[added](https://github.com/damonitor/damo/blob/next/USAGE.md#write-only-and-cpus-only-access-monitoring-experimental)
to DAMON user-space tool (damo).

_2025-07-08_: Bijan's DAMON patch
[series](https://lore.kernel.org/20250709005952.17776-1-bijan311@gmail.com) for
dynamic NUMA memory weighted interleaving that shows ~25% performance
improvements on a test is now merged into mm-new.

_2025-08-22_: A patch
[series](https://lkml.kernel.org/r/20250822093420.2103803-2-yanquanmin1@huawei.com)
for making DAMON supports ARM (32bit) with LPAE has just landed on mm-new tree.
It was made by a great and joyful collaboration between I and Huawei (Quanmin
Yan and Zuo Ze).

_2025-08-10_: DAMON user-space tool added a visualization script for [cold
memory tail](https://social.kernel.org/notice/Ax2IFjCCoj51eJgkNM)
visualization.

_2025-08-03_: A prototype of per-CPUs and write-only monitoing is implemented
and added to damon/next tree, and an experimental support of it is
[added](https://github.com/damonitor/damo/blob/next/USAGE.md#write-only-and-cpus-only-access-monitoring-experimental)
to DAMON user-space tool (damo).

_2025-07-08_: Bijan's DAMON patch
[series](https://lore.kernel.org/20250709005952.17776-1-bijan311@gmail.com) for
dynamic NUMA memory weighted interleaving that shows ~25% performance
improvements on a test is now merged into mm-new.

_2025-06-22_: An ISCA'25
[paper](https://dl.acm.org/doi/10.1145/3695053.3731001) for better memory
tiering is published. The paper uses DAMON and masim for showing access
patterns of artificial and realistic workloads.

_2025_06_20_: Bijan from Micron found DAMON-based post-allocation memory
interleaving
[achieves](https://lore.kernel.org/20250620180458.5041-1-bijan311@gmail.com)
approximately 25% speedup.

_2025-06-15_: DAMON user-space tool added access temperature-sorted heatmap
visualization feature.  Example output of the feature are as below.

![unsorted snpashot](/img/damo_temperature_sorted_heatmap/unsorted_snapshot.png)
![sorted snapshot](/img/damo_temperature_sorted_heatmap/sorted_snapshot.png)
![unsorted record](/img/damo_temperature_sorted_heatmap/unsorted_record.png)
![sorted record](/img/damo_temperature_sorted_heatmap/sorted_record.png)

_2025-06-14_:
Intel has published another excellent ArXiv
[paper](https://arxiv.org/pdf/2506.06067) for memory tiering. The research used
DAMON for a validation of the behavior of their approach (GPAC).

_2025-06-02_:
[Changes](https://lore.kernel.org/all/20250521042755.39653-1-sj@kernel.org/)
for enabling CONFIG_DAMON by default has been
[merged](https://lore.kernel.org/all/174891081008.961800.5493448222601669134.pr-tracker-bot@kernel.org/)
into the mainline, by the second MM subsystem pull request for Linux 6.16-rc1.
Later, the change has reverted by Linus Torvalds with his good
[explanation](https://lore.kernel.org/20250610173228.49109-1-sj@kernel.org) of
the reason.

_2025-05-31_: DAMON patches for [more self-driven memory
tiering](https://lore.kernel.org/all/20250420194030.75838-1-sj@kernel.org/)
have been
[merged](https://lore.kernel.org/all/174874604794.296823.9742582059292506586.pr-tracker-bot@kernel.org/)
into the mainline.

_2025-05-26_: DAMON patches for simple and practical access monitoring have
been [posted](https://lore.kernel.org/20250526210936.2744-1-sj@kernel.org)

_2025-05-23_: DAMON talk for Kernel Recipes 2025 has been
[updated](https://kernel-recipes.org/en/2025/schedule/overcoming-observer-effects-in-memory-management-with-damon/).

_2025-05-12_: RFC for build-enabling DAMON by default has been
[posted](https://lore.kernel.org/20250512182716.50245-1-sj@kernel.org).

_2025-04-30_: Researchers [found](https://arxiv.org/pdf/2504.18714)
automatically tuning parameters can improve memory tieirng performance by 2x,
using DAMON and SK hynix' DAMON-based memory tiering solution as a part of
their research.

_2025-04-24_: Some of OpenSuse kernels will
[apparently](https://social.kernel.org/notice/AtQ94OoroZhOGuGuAq) build-enable
DAMON in near future.

_2025-04-19_: DAMON user-space tool feature for let users program their access
pattern visualization in Python code, as a script or interactively on the
Python interpreter, is
[developed](https://github.com/damonitor/damo/blob/d0eb41035db1a870d482a14087afda0196c5980b/USAGE.md#damo-report-access-programming-visualization).

_2025-04-17_: Yet another DAMON-citation from a HCDS'25
[paper](https://www.pure.ed.ac.uk/ws/portalfiles/portal/497211278/XingandBarbalaceHDCS2025RethinkingApplications_AddressSpace.pdf)
is found. The paper discusses h/w-based CXL coherency management.

_2025-04-10_: LWN made an excellent
[summary](https://lwn.net/Articles/1016525/) of the two DAMON sessions that we
had at LSFMM+BPF 2025.

_2025-04-07_: DAMON talk for OSSummit North America 2025 has been accepted and
[scheduled](https://sched.co/1zfmE).

_2025-04-01_: An EuroSys'25
[paper](https://dl.acm.org/doi/10.1145/3689031.3717471) for proactive demotion
on tiered memory managment is published.  It also shares evaluations of a
DAMON-based tiering approach that is being used by HMSDK.

_2025-04-01_: MM
[pull request](https://lore.kernel.org/20250330165732.f4c1493615375623f67e38eb@linux-foundation.org/)
for Linux 6.15-rc1 including below major DAMON changes is merged.

- Monitoring intervals auto-tuning
- Extending DAMOS filter types for hugepage, LRU-[in]active page, and
  [un]mapped pages
- DAMOS allow filters behavior improvement
- Important cleanups and fixes of code and documents

_2025-03-20_: DAMON session on LSF/MM/BPF 2025 has been
[scheduled](https://docs.google.com/spreadsheets/d/1PgjzaPOnIHgRIfqgwDNiftY5Xr6aU3NLWtDs7zFoIvc/edit?gid=1852749899#gid=1852749899).

_2025-03-19_: RFC patch series for self-tuned DAMON-based memory tiering has
[posted](https://lore.kernel.org/20250320053937.57734-1-sj@kernel.org/) with an
evaluation result, and
[introduced](https://www.phoronix.com/news/DAMON-Self-Tuned-Memory-Tiering) by
Phoronix.

_2025-03-03_: DAMON monitoring intervals auto-tuning [patch
series](https://lore.kernel.org/all/20250303221726.484227-1-sj@kernel.org/) has
been posted, and queued in mm tree.

_2025-02-22_: An [academic
paper](https://uu.diva-portal.org/smash/get/diva2:1927657/FULLTEXT01.pdf)
showing DAMON-based memory tiering can be further improved using h/w-assisted
promotion has been published.

_2025-02-12_: DAMON monitoring intervals auto-tuning RFC [patch
series](https://lore.kernel.org/20250213014438.145611-1-sj@kernel.org) has been
posted.

_2025-02-08_: FOSDEM'25 DAMON talk record video has been
[available](https://fosdem.org/2025/schedule/event/fosdem-2025-4396-damon-kernel-subsystem-for-data-access-monitoring-and-access-aware-system-operations/).

_2025-01-26_: MM pull request for Linux 6.14-rc1 is
[merged](https://lore.kernel.org/173794918049.2962345.16153806964109303355.pr-tracker-bot@kernel.org)
with DAMON changes including below six patch series.

- mm/damon: add sample modules
  ([link](https://git.kernel.org/torvalds/c/19d7c3adfdd4))
- mm/damon: replace most damon_callback usages in sysfs with new core functions
  ([link](https://git.kernel.org/torvalds/c/e035320fd38e))
- mm/damon: enable page level properties based monitoring
  ([link](https://git.kernel.org/torvalds/c/626ffabe67c2))
- mm/damon: remove DAMON debugfs interface
  ([link](https://git.kernel.org/torvalds/c/2a91cb2d2b33))
- mm/damon: extend DAMOS filters for inclusion
  ([link](https://git.kernel.org/torvalds/c/e20f52e8e3b7))
- Docs/mm/damon: add tuning guide and misc updates
  ([link](https://git.kernel.org/torvalds/c/82047ae18446))

_2025-01-02_: Two LSF/MM/BPF topic proposals for DAMON have been
posted(
[1](https://lore.kernel.org/20250102222317.48760-1-sj@kernel.org),
[2](https://lore.kernel.org/20250101222039.74565-1-sj@kernel.org)).

_2025-01-02_: DAMON quaterly news letter for Q4 2024 has been
[posted](https://lore.kernel.org/20250102211811.48322-1-sj@kernel.org)

_2025-01-01_: An LSF/MM/BPF topic proposal for gathering DAMON requirements for
future MM has been
[posted](https://lore.kernel.org/20250101222039.74565-1-sj@kernel.org).

_2025-01-01_: DAMON debugfs interface removal patch series have been
[posted](20250101213527.74203-1-sj@kernel.org)

2024
----

_204-12-26_: RFC patch series for inclusive DAMOS filters has been
[posted](https://lore.kernel.org/20241227210819.63776-1-sj@kernel.org)

_2024-12-23_: `damo`
[v2.6.1](https://github.com/damonitor/damo/blob/v2.6.1/release_note#L4) is
released with page level properties based monitoring support.  Show a blog
[post](https://damonitor.github.io/posts/damon_sz_filter_passed/) for more
details.

_2024-12-18_: RFC patch series for page level properties based acces monitoing
has been
[posted](https://lore.kernel.org/20241219040327.61902-1-sj@kernel.org).

_2024-12-12_: A DAMON presentation
[proposal](https://pretalx.fosdem.org/fosdem-2025/talk/review/3UT9TYYRE3UXJMRRCRLMQLJKUHLRKVYE)
has accepted to [FOSDEM'25](https://fosdem.org/2025/).

_2024-12-10_: DAMON sample modules have
[posted](https://lore.kernel.org/20241210215030.85675-1-sj@kernel.org).

_2024-12-02_: DAMON monitoring parameters tuning guide example on a real server
workload has been
[shared](https://lore.kernel.org/20241202175459.2005526-1-sj@kernel.org).

_2024-12-02_: On Middlewar'24, a
[paper](https://dl.acm.org/doi/10.1145/3652892.3700755) describing DAMON as a
common cloud workload and evaluate their system for DAMON usage has presented.

_2024-11-25_: `damo` [v2.5.7](https://github.com/damonitor/damo/tree/v2.5.7) is
releasd with tempearture-based regions filtering and formatting features.  Show a
blog [post](https://damonitor.github.io/posts/damo_2_5_7_features/) showing the
details of the fetures and examples on a server workload.

_2024-11-18_: `damo` [v2.5.6](https://github.com/damonitor/damo/tree/v2.5.6) is
released with heatmap snapshot visualization
[format](https://github.com/damonitor/damo/blob/v2.5.6/release_note#L6) and
multiple kdamonds edit
[feature](https://github.com/damonitor/damo/blob/v2.5.6/USAGE.md#multiple-kdamonds).

_2024-11-08_: A guide to DAMON tuning and results interpretation for hot pages
has [posted](https://lore.kernel.org/20241108232536.73843-1-sj@kernel.org).

_2024-11-04_: `damo`
[v2.5.4](https://github.com/damonitor/damo/blob/v2.5.4/release_note#L4) is
released with recency/temperature histogram visualization
[features](https://github.com/damonitor/damo/blob/v2.5.4/USAGE.md#access-report-styles).

_2024-10-21_: Monthly PyPI downloads of DAMON user-space tool, DAMO, doubled
(8,000 -> 16,000) again after about ten dasys.
![damo_16000_monthly_downloads](/img/damo_16000_monthly_downloads.png)
![damo_rolling_monthly_downloads_2024-10-21](/img/damo_rolling_monthly_downloads_2024-10-21.png)

_2024-10-18_: DAMON projet site started hosting its own
[blog](https://github.com/damonitor/damonitor.github.io/commit/817d619090d8abb02e6a4020ff5d0b9664c6464c).

_2024-10-15_: DAMON debugfs interface removal RFC patch has
[posted](https://lore.kernel.org/20241015175412.60563-1-sj@kernel.org).

_2024-10-10_: Monthly PyPI downloads of DAMON user-space too, DAMO, doubled
again after ten days.
![damo_9000_monthly_downloads](/img/damo_download_9213.png)
![damo_rolling_monthly_downloads_2024-10-10](/img/damo_rolling_monthly_downloads_2024-10-10.png)

_2024-10-08_: Videos for
[DAMON recipes](https://youtu.be/xKJO4kLTHOI?feature=shared) at Open Source
Summit EU'2024 and
[DAMON long-term plans](https://youtu.be/mRU1ZeNB9WY?feature=shared) at Kernel
Memory Management Microconference'2024 are uploaded to YouTube.

_2024-10-01_: 2024-Q3 DAMON news letter including news for new features,
more users, repos reorganizations, and conference talks is
[posted](https://lore.kernel.org/20241001191425.588219-1-sj@kernel.org).

_2024-09-30_: DAMON User Space Tool, DAMO,
[surpasses](https://pypistats.org/packages/damo) 4,000 monthly PyPI downloads!
![damo_4000_monthly_downloads](/img/damo_download_4122.png)

_2024-09-20_: Livestreamed video for DAMON talk at kernel memory management
microconference 2024 is now
[available](https://www.youtube.com/live/CTWQ-d7pj5s?feature=shared&t=20182) at
Youtube.

_2024-09-19_: An academic paper preprint that optimizing THP using DAMON and
BPF, titled "eBPF-mm: Userspace-guided memory management in Linux with
eBPF" is [uploaded](https://arxiv.org/pdf/2409.11220) to ArXiv

_2024-09-16_: `CONFIG_DAMON` is
[enabled](https://salsa.debian.org/kernel-team/linux/-/merge_requests/1172) on
Debian kernel

_2024-08-14_: GitHub repos for non-kernel parts of DAMON project including
'damo', 'damon-tests' and 'damoos' will be
[moved](https://lore.kernel.org/20240813232158.83903-1-sj@kernel.org/) from
'[awslabs](https://github.com/awslabs)' to
'[damonitor](https://github.com/damonitor)', by 2024-09-05

_2024-07-29_: VLDB paper about Aurora Serverless V2, which reveals their usage
of DAMON on the product, is now
[available](https://www.amazon.science/publications/resource-management-in-aurora-serverless).

_2024-07-21_: Memory Management subsystem pull request for Linux v6.11-rc1 is
[posted](https://lore.kernel.org/20240721145415.fbeb01a853962ef91334f3d1@linux-foundation.org)
with DAMON changes for CXL memory
[tiering](https://lore.kernel.org/20240614030010.751-1-honggyu.kim@sk.com),
[documentation](https://lore.kernel.org/20240621163626.74815-1-sj@kernel.org)
of a mailing tool for newcomers, and minor fixups.

_2024-07-18_: DAMON topic for Linux Kernel Memory Management Microconference at
LPC'24 has [accepted](https://lpc.events/event/18/contributions/1768/).

_2024-07-11_: ATC'24 also published two DAMON-citing papers at the same time. The
first [one](https://www.usenix.org/conference/atc24/presentation/nair) proposes
a way to improve monitoring accuracy of DAMON, while the
second [one](https://www.usenix.org/conference/atc24/presentation/tabatabai)
mentions DAMON can be useful for extensible memory management.

_2024-07-11_: A couple of OSDI'24 papers
([1](https://www.usenix.org/conference/osdi24/presentation/xiang),
[2](https://www.usenix.org/conference/osdi24/presentation/zhong-yuhong)) for
memory tiering that references and exploring DAMON as a part of them are
available now.

_2024-07-01_: DAMON Quaterly Newsletter for 2024-Q2 has
[posted](https://lore.kernel.org/20240701212244.52288-1-sj@kernel.org).

_2024-06-21_: HacKerMaiL (hkml) has
[announced](https://lore.kernel.org/20240621170355.939F7C2BBFC@smtp.kernel.org)
as a mailing tool for DAMON community that the maintainer is committed to
support.

_2024-06-14_: DAMON talk for Kernel Summit 2024 is
[proposed](https://lore.kernel.org/20240614175504.87365-1-sj@kernel.org/).

_2024-06-14_: SK hynix' patch series "DAMON based tiered memory management for
CXL memory" has
[merged](https://lore.kernel.org/all/20240614185328.BA2C1C2BD10@smtp.kernel.org/)
into -mm tree.

_2024-06-12_: DAMON talk for OpenSource Summit Europe 2024 has been accepted
and [scheduled](https://sched.co/1ej2S).

_2024-05-18_: Memory management subsystem pull
[request](https://lore.kernel.org/20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org)
for Linux 6.10-rc1 has been posted.  This pull request includes DAMOS young
page filter, a DAMOS functionality kselftest, and misc cleanups/fixups for
code, documentation, and tests.

_2024-05-17_: LWN published an [article](https://lwn.net/Articles/973702/)
introducing DAMON session at LSFMM 2024.

_2024-05-02_: LSFMMBPF schedule is
[uploaded](https://docs.google.com/spreadsheets/d/176LXLys9Uh6A-Eal2flrzcbUSJMUXGkGwyihr9jAAaQ/edit?usp=sharing).
DAMON talk is scheduled for the Monday noon.

_2024-04-29_: The video of the DAMON presentation at OSSummit NA'24 is
[uploaded](https://youtu.be/vP5x5P47S1U?feature=shared).

_2024-04-28_: Yet another academic
[paper](https://dl.acm.org/doi/abs/10.1145/3620666.3651355) exploring DAMON for
serverless computing has published on ASPLOS 24.

_2024-04-17_: The third in-person DAMON meetup has
[held](https://sched.co/1cP4G) as a unconference session of Open Source Summint
North America 2024

_2024-04-03_: Oracle released a
[tool](https://blogs.oracle.com/linux/post/explore-linux-kernel-kconfigs) that
[helps](https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=DAMON&config=DAMON_RECLAIM&config=DAMON_LRU_SORT)
finding distros that enabled DAMON

_2024-04-01_: DAMO v2.2.8 is out. This version
[supports](https://github.com/damonitor/damo/blob/v2.2.8/USAGE.md#recording-memory-footprints)
recording memory footprint of monitoring target processes together with their
access pattern.  Users could know when how much memory is allocated and really
accessed. Such visualization is one of the future works, though.

_2024-03-13_: Memory management subsystem pull
[request](https://lore.kernel.org/all/20240313200532.34e4cff216acd3db8def4637@linux-foundation.org/)
for Linux 6.9-rc1 has been posted.  To quote Andrew’s summary for DAMON part:
- More DAMON work from SeongJae Park in the series
  - "mm/damon: make DAMON debugfs interface deprecation unignorable"
  - "selftests/damon: add more tests for core functionalities and corner cases"
  - "Docs/mm/damon: misc readability improvements"
  - "mm/damon: let DAMOS feeds and tame/auto-tune itself"

_2024-03-06_: [LSF/MM/BPF 2024](https://events.linuxfoundation.org/lsfmmbpf/)
DAMON discussion
[topic](https://lore.kernel.org/damon/20240129204749.68549-1-sj@kernel.org/) is
accepted

_2024-03-04_: DAMO v2.2.4 is
[released](https://github.com/damonitor/damo/tree/v2.2.4) with a new feature for
access pattern-based
[profiling](https://github.com/damonitor/damo/blob/v2.2.4/USAGE.md#profile).
For example, users can know which code is making their program's memory usage
unexpectedly high, or which code is intensively accessing memory, and optimize.

_2024-02-27_: DAMON user-space tool, [DAMO](https://damonitor.github.io), has
[downloaded](https://pypistats.org/packages/damo) from PyPI more than 2,000
times last month.
![damo_2000_monthly_downloads](/img/damo_download_2005.png)

_2024-02-21_: Yet another academic
[paper](https://pasalabs.org/papers/2024/Eurosys24_M3_Camera_Ready.pdf)
exploring DAMON for tiered memory management will be presented at
[EuroSys 2024](https://2024.eurosys.org/)

_2023-02-20_: DAMO v2.2.2 is released with a new command,
[`replay`](https://github.com/damonitor/damo/blob/v2.2.2/release_note#L5).  It
will hopefully help reproducing the real-world memory access pattern for
analysis and benchmarks.

_2024-02-14_: DAMON talk for OSSummit NA 2024 has been accepted and
[scheduled](https://sched.co/1aBOg)

_2024-02-09_: DAMON in Amazon Linux 5.10.y
[kernel](https://github.com/amazonlinux/linux/tree/amazon-5.10.y/master/mm/damon)
has updated to that of v6.7 Linux kernel. Major updates on this change include
- DAMOS apply target regions
  [tracing](https://git.kernel.org/torvalds/c/c603c630b509) and
- Sampling interval granularity monitoring results
  [generation](https://git.kernel.org/torvalds/c/78fbfb155d20) and
  [DAMOS](https://git.kernel.org/torvalds/c/affa87c70818).

_2024-01-29_: LSF/MM/BPF 2024 topic proposal for DAMON has
[posted](https://lore.kernel.org/linux-mm/20240129204749.68549-1-sj@kernel.org/)

_2024-01-15_: SK Hynix
[shared](https://lore.kernel.org/damon/20240115045253.1775-1-honggyu.kim@sk.com/)
their DAMOS-based tiered memory management test results showing 4-17%
performance slowdown reduction, with patches for that.

_2024-01-12_: LWN [introduced](https://lwn.net/Articles/957188/) the
feedback-driven DAMOS aggressiveness
[auto-tuning](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9294a037c015)
as one of interesting changes for Linux v6.8

_2024-01-08_: Memory management subsystem pull
[request](https://lore.kernel.org/linux-mm/20240108155039.fd2798712a2a93a108b710ce@linux-foundation.org/)
for Linux v6.8-rc1 has posted. To quote Andrew's summary for DAMON part:

- DAMON/DAMOS feature and maintenance work from SeongJae Park in
the series
  - "mm/damon: let users feed and tame/auto-tune DAMOS"
  - "selftests/damon: add Python-written DAMON functionality tests"
  - "mm/damon: misc updates for 6.8"


2023
----

_2023-12-31_: A retrospect of DAMON development in 2023 for the upstream
community has
[posted](https://lore.kernel.org/damon/20231231222250.140364-1-sj@kernel.org/).

_2023-12-27_: SK Hynix released Heterogeneous Memory Software Development Kit
(HMSDK) [v2.0](https://github.com/skhynix/hmsdk/releases/tag/hmsdk-v2.0) which
utilizes DAMON for tiered memory management.

_2023-11-24_: A [paper](https://arxiv.org/pdf/2311.10275.pdf) exploring DAMON
and finding grateful areas to improve has uploaded to arXiv.

_2023-11-17_: Livestreamed video for DAMON talk at kernel summit 2023 is now
[available](https://www.youtube.com/live/VxaAorwL89c?si=vUk1V5jAZhw8YFdV&t=19455)
at YouTube.

_2023-11-12_: RFC idea for DAMOS-based tiered memory management is
[sent](https://lore.kernel.org/damon/20231112195602.61525-1-sj@kernel.org/).

_2023-11-12_: RFC idea for Access/Contiguity-aware Memory Auto-scaling is
[sent](https://lore.kernel.org/damon/20231112195114.61474-1-sj@kernel.org/).

_2023-11-12_: RFC patchset for Aim-oriented Feedback-driven DAMOS
Aggressiveness Auto Tuning is
[sent](https://lore.kernel.org/damon/20231112194607.61399-1-sj@kernel.org/).

_2023-11-08_: The second in-person DAMON community meetup at LPC has
[accepted](https://lpc.events/event/17/contributions/1652C) and
[announced](https://lore.kernel.org/damon/20231108145525.12650-1-sj@kernel.org/).

_2023-11-02_: Memory management subsystem pull requests for Linux v6.7-rc1,
which contains the changes for DAMON, has
[sent](https://lore.kernel.org/mm-commits/20231101145447.60320c9044e7db4dba2d93e3@linux-foundation.org/).

_2023-10-22_: An SOSP [paper](https://dl.acm.org/doi/10.1145/3600006.3613167)
for tiered memory management that referencing and exploring DAMON has found.

_2023-10-12_: LPC BoF session proposal for DAMON community in-person meetup has
submitted.

_2023-10-04_: DAMON talk for Kernel Summit track of Linux Plumbers Conference
2023 has [accepted](https://lpc.events/event/17/contributions/1624/).

_2023-09-07_: Yet another academic paper
[preprint](https://arxiv.org/pdf/2309.01736.pdf) regarding serverless on CXL
using/citing DAMON has uploaded.  The title of the preprint is "Understanding
and Optimizing Serverless Workloads in CXL-Enabled Tiered Memory"

_2023-08-09_: DAMON community started running its CI test against all stable
kernels and
[report](https://lore.kernel.org/damon/20230809171146.90801-1-sj@kernel.org/)
the results.

_2023-08-08_: DAMON user-space tool (damo) has reached 100 Github stars.
![damo 100 github stars](/img/damo_100_github_stars.png)

_2023-08-07_: DAMON user-space tool (damo) has released its 100th
[version](https://github.com/damonitor/damo/releases/tag/v1.9.3). A mail for the
news, release stats, and appreciation to the DAMON community has also
[posted](https://lore.kernel.org/damon/20230807202044.98700-1-sj@kernel.org/).

_2023-08-03_: DAMON continuous functionality testing started testing stable rc
[kernels](https://github.com/damonitor/damon-tests/commit/acb5f06f861d19b6826e3e339ddf69806da218ee)
and
[report](https://lore.kernel.org/damon/20230802173033.108621-1-sj@kernel.org/)
back the results.

_2023-08-01_: DAMON Beer/Coffee/Tea meeting will be
[postponed](https://lore.kernel.org/damon/20230801012126.6249-1-sj@kernel.org/)
from mid of August to end of OSSummit Euro 2023.

_2023-07-26_: The kernel summit talk proposal for DAMON status and future plans
has
[posted](https://lore.kernel.org/damon/20230726190926.85121-1-sj@kernel.org/)

_2023-07-10_: Hocus wrote an
[article](https://hocus.dev/blog/qemu-vs-firecracker/) introducing DAMON as a
kernel feature that could be useful for memory efficient VM, with its
limitations.

_2023-06-30_: DAMON talk for OSSummit EU 2023 has accepted and
[scheduled](https://sched.co/1OGf9)

_2023-06-25_: DAMON userspace tool, [damo](https://github.com/damonitor/damo) has
[packaged](https://github.com/awslabs/damo/pull/58) for Debian/Ubuntu in
addition to Fedora.  It also turned out it was already packaged for ArchLinux.
Refer to [repology](https://repology.org/project/damo/versions) for detail.

_2023-05-26_: Open Source Summit North America DAMON
[talk](https://sched.co/1K5HS) video is now
[available](https://youtu.be/fImXcHS5PPE) at Youtube

_2023-05-26_: LSF/MM+BPF DAMON
[discussion](https://lore.kernel.org/damon/20230214003328.55285-1-sj@kernel.org/)
video is now
[available](https://www.youtube.com/watch?v=bbC23ApPvow) at Youtube

_2023-05-17_: Now DAMON user space tool (DAMO) is available at
[Fedora Packages](https://packages.fedoraproject.org/pkgs/python-damo/damo/)

_2023-05-16_: Michel from Fedora community is gonna
[package](https://github.com/awslabs/damo/pull/42#issuecomment-1550415746)
DAMON user space tool (DAMO) for Fedora!

_2023-05-16_: An LWN article for LSF/MM+BPF DAMON discussion has
[uploaded](https://lwn.net/Articles/931769/)

_2023-05-04_: The schedule for DAMON talk/discussion at LSFMM is
[available](https://events.linuxfoundation.org/lsfmm/program/schedule-at-a-glance/)
now.

_2023-03-14_: The schedule for DAMON talk at OSSummit NA is
[available](https://sched.co/1K5HS) now.

_2023-03-10_: A DAMON talk proposal for
[OSSummit NA](https://events.linuxfoundation.org/open-source-summit-north-america/)
has accepted.

_2023-03-06_: DAMOS filters feature has introduced as one of the most
significant changes for Linux v6.3 by an LWN
[article](https://lwn.net/Articles/924384/)

_2023-02-24_: A preprint of an academic paper that compares their approach
against DAMON has [uploaded](https://arxiv.org/pdf/2302.09468.pdf) to ArXiv.

_2023-02-13_: LSF/MM/BPF topic proposal for DAMON has
[posted](https://lore.kernel.org/linux-mm/20230214003328.55285-1-sj@kernel.org/)

_2023-02-09_: DAMON debugfs deprecation patchset has
[posted](https://lore.kernel.org/damon/20230209192009.7885-1-sj@kernel.org/)

2022
----

_2022-12-29_: DAMON development summary of 2022 has
[shared](https://lore.kernel.org/lkml/20221229171209.162356-1-sj@kernel.org/)
and [featured](https://www.phoronix.com/news/DAMON-Linux-2022) by Phoronix.

_2022-12-16_: The DAMOS filtering for anon pages and/or memory
cgroups have
[merged](https://lore.kernel.org/mm-commits/20221216235930.526BAC433EF@smtp.kernel.org/)
in mm tree.

_2022-10-19_: An RFC patchset for efficient query-like DAMON monitoring results
have
[posted](https://lore.kernel.org/damon/20221019001317.104270-1-sj@kernel.org/)

_2022-09-15_: The [video](https://youtu.be/e2SZoUPhDRg?t=13245) for my kernel
summit DAMON talk this year is now available at Youtube

_2022-09-09_: The plan for the first in-person DAMON community meetup at LPC
and the in-person office hour at OSSummit EU has
[announced](https://lore.kernel.org/damon/20220909173856.55818-1-sj@kernel.org/)

_2022-09-06_: AL2 5.10 kernel's DAMON code has
[updated](https://github.com/amazonlinux/linux/commit/5441c2036382e1957492a6d762f0dfbd172aa225)
to that of v5.19

_2022-08-30_: AL2 5.10 kernel's DAMON code has
[updated](https://github.com/amazonlinux/linux/commit/8fde5ce7c81c1ecf6c3ac2595774eac0e6784869)
to that of v5.18

_2022-08-22_: LWN [introduced](https://lwn.net/Articles/905370/) DAMON-based
LRU-lists manipulation (DAMON_LRU_SORT) in detail

_2022-08-15_: LWN [introduced](https://lwn.net/Articles/904032/) DAMON’s new
features including 'LRU_SORT' as significant changes for Linux 6.0

_2022-08-12_: Bi-weekly DAMON Beer/Coffee/Tea Chat series for open, regular,
and informal community syncups and discussions has
[announced](https://lore.kernel.org/damon/20220810225102.124459-1-sj@kernel.org/).

_2022-07-29_: Current status, future plans, and possible collaborations for
DAMON will be [presented](https://lpc.events/event/16/contributions/1224/) at
the Kernel Summit 2022.

_2022-06-26_: The poster of the DAOS
[paper](https://www.amazon.science/publications/daos-data-access-aware-operating-system)
is
[available](https://damonitor.github.io/misc/daos_hpdc_2022_poster.pdf) online.

_2022-06-13_: DAMON-based LRU-lists sorting patchset has
[posted](https://lore.kernel.org/damon/20220613192301.8817-1-sj@kernel.org/)
and immediately
[merged](https://lore.kernel.org/mm-commits/20220613194036.C4AC5C34114@smtp.kernel.org/)
in the -mm tree

_2022-05-04_: A paper introducing DAMON and related works have accepted by
[HPDC22](https://www.hpdc.org/2022/program/accepted/)

_2022-05-03_: Now DAMON has its own open mailing
[list](https://lore.kernel.org/damon/)

_2022-04-29_: Patches for DAMON online tuning have
[merged](https://lore.kernel.org/mm-commits/20220429162617.04E08C385A7@smtp.kernel.org/)
in -mm tree

_2022-04-27_: Android has
[backported](https://android.googlesource.com/kernel/common/+log/b3190b539a0845d3b849926b723deeeacc7491a4)
and
[enabled](https://android.googlesource.com/kernel/common/+/0496c13ded02bd72426d189b777bf303fe490f62)
building `DAMON` and `DAMON_RECLAIM` for the common kernel.

_2022-04-27_: Alibaba has
[shared](https://lore.kernel.org/linux-mm/e3c1beb1-e3d5-6e26-bae2-06785080b57e@linux.alibaba.com/)
thier own DAMON user space
[tool](https://github.com/aliyun/data-profile-tools).

_2022-02-28_: The DAMON sysfs interface patchset has
[merged](https://lore.kernel.org/mm-commits/20220228194808.91315C340F3@smtp.kernel.org/)
in -mm tree.

_2022-02-17_: An [RFC
patchset](https://lore.kernel.org/linux-mm/20220217161938.8874-1-sj@kernel.org/)
for sysfs-based DAMON's new user interface has posted.

_2022-01-20_: A
[roadmap](https://lkml.kernel.org/r/20220119133110.24901-1-sj@kernel.org) of
DAMON has shared.

_2022-01-09_: Linux 5.16 is released.  "DAMON-based proactive memory
reclamation, operation schemes and physical memory monitoring" are marked as
prominent features of the release by the [Kernel
newbies](https://kernelnewbies.org/Linux_5.16) and
[LWN](https://kernelnewbies.org/Linux_5.16).

2021
----

_2021-12-23_: A great blog
[post](https://stevescargall.com/2021/12/23/how-to-build-a-custom-linux-kernel-to-test-data-access-monitor-damon/)
for DAMON-enabled kernel has uploaded

_2021-11-07_: DAMON patches for automated memory management
[optimization](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=68536f8e01e571f553f78fa058ba543de3834452),
the physical address space monitoring
[support](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c638072107f52ec35f292c97b6f3df9b9f2ed87d),
and [proactive
reclamation](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bec976b69143)
have merged in the mainline.

_2021-11-01_: DAMON has
[released](https://kernelnewbies.org/Linux_5.15#DAMON.2C_a_data_access_monitor)
with Linux [v5.15](https://lwn.net/Articles/874493).

_2021-10-14_: DAMON_RECLAIM patchset is
[merged](https://github.com/amazonlinux/linux/commit/99c8ec092e82) in the
Amazon Linux 5.10.y kernel tree.

_2021-10-02_: DAMOS patchset is
[merged](https://lore.kernel.org/mm-commits/20211001233339.SV5JeiSqb%25akpm@linux-foundation.org/)
in the -mm tree.

_2021-09-23_: DAMON and DAMOS are presented in the kernel summit.
[Slides](https://linuxplumbersconf.org/event/11/contributions/984/attachments/870/1670/daos_ksummit_2021.pdf),
[Video](https://youtu.be/gpFfJkrrEEs?t=5290),
[Link](https://linuxplumbersconf.org/event/11/contributions/984/)

_2021-09-16_: DAMON development tree on
[kernel.org](https://git.kernel.org/sj/h/damon/next/about) is created.

_2021-09-08_: DAMON patchset is
[merged](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2d338201d5311bcd79d42f66df4cecbcbc5f4f2c)
in the Linus Torvalds' tree, aka
[mainline](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/damon?id=2d338201d5311bcd79d42f66df4cecbcbc5f4f2c)

_2021-09-07_: DAMON/DAMOS will be
[presented](https://linuxplumbersconf.org/event/11/contributions/984/) at
the Kernel Summit 2021

_2021-08-31_: DAMON user-space tool is uploaded to the official Python
packages system, [PyPi](https://pypi.org/project/damo/)

_2021-08-06_: DAMON patchset is
[merged](https://lore.kernel.org/linux-mm/20210805174324.2aaf0fb67cd19da893a86d80@linux-foundation.org/)
in the -mm tree

_2021-07-27_: LWN published a second
[article](https://lwn.net/Articles/863753/) introducing DAMON patchset series

_2021-06-11_: DAMON-based proactive reclamation RFC patchset has shared on the
[hackernews](https://news.ycombinator.com/item?id=27459675) and introduced by a
Phoronix
[article](https://www.phoronix.com/scan.php?page=news_item&px=DAMON-Page-Reclamation-RFC)

_2021-05-31_: DAMON-based proactive reclamation RFC patchset has
[posted](https://lore.kernel.org/linux-mm/20210531133816.12689-1-sj38.park@gmail.com/)

_2021-05-26_: DAMON-enabled Amazon Linux 2 kernels have [deployed to all
users](https://twitter.com/sjpark0x00/status/1397484233413832705)

_2021-05-07_: DAMON has merged in the public source tree for Amazon Linux
v5.4.y
[kernel](https://github.com/amazonlinux/linux/tree/amazon-5.4.y/master/mm/damon)

_2021-04-05_: `damo` now supports heatmap visualization on the
[terminal](https://raw.githubusercontent.com/damonitor/damo/master/for_doc/masim_zigzag_heatmap_ascii.png)

_2021-03-31_: DAMON user-space tool (`damo`) is released as an
[individual open source project](https://github.com/damonitor/damo)

_2021-03-19_: DAMON has merged in the public source tree for Amazon Linux
v5.10.y
[kernel](https://github.com/amazonlinux/linux/tree/amazon-5.10.y/master/mm/damon)

_2021-03-04_: DAMON supports for two latest LTS kernels
[announced](https://lore.kernel.org/linux-mm/20210304100732.7844-1-sjpark@amazon.com/)

_2021-03-03_: DAMON is merged in v5.10 based public Amazon Linux kernel
[tree](https://github.com/amazonlinux/linux/commit/10e0ec07f9085a42f724b28912a1dadc0b5d3c80)

_2021-02-25_: An example usage of DAMON for profiling is
[shared](https://twitter.com/sjpark0x00/status/1364591344300273666)

_2021-01-07_: A runtime system for DAMON-based optimal operation scheme finding
is [released](https://github.com/damonitor/damoos)

2020
----

_2020-12-03_: Further plans around DAMON is
[shared](https://lore.kernel.org/linux-mm/20201202082731.24828-1-sjpark@amazon.com)

_2020-11-17_: A real-world user story of DAMON is
[shared](https://lore.kernel.org/linux-mm/20201117143021.11883-1-sjpark@amazon.com/)

_2020-09-26_: The tests package for DAMON is
[released](https://github.com/damonitor/damon-tests) under GPL v2 license

_2020-08-19_: A demo video is [available](https://youtu.be/l63eqbVBZRY)

_2020-08-05_: DAMON will be
[presented](https://www.linuxplumbersconf.org/event/7/contributions/659/) at
the Kernel Summit 2020

_2020-06-04_: Physical Memory Monitoring is now
[available](https://lore.kernel.org/linux-mm/20200603141135.10575-1-sjpark@amazon.com/)

_2020-05-18_: DAMON showcase website is announced

_2020-05-13_: DAMON official document is uploaded
[online](https://damonitor.github.io/doc/html/latest/admin-guide/mm/damon/)

_2020-02-20_: DAMON has introduced by an LWN
[article](https://lwn.net/Articles/812707/)

_2020-02-10_: The first RFC of Data Access Monitoring-based Operating Schemes
(DAMOS) has posted to
[LKML](https://lore.kernel.org/linux-mm/20200210150921.32482-1-sjpark@amazon.com/)

_2020-01-23_: The RFC of DAMON has introduced by LWN's ['Kernel patches of
interest'](https://lwn.net/Articles/809100/)

_2020-01-20_: The first RFC patchset of DAMON has posted to
[LKML](https://lore.kernel.org/linux-mm/20200110131522.29964-1-sjpark@amazon.com/)
