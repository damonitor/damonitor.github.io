---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "DAMON: Data Access Monitor"
subtitle: ""
summary: ""
authors: []
tags: ["damon", "linux", "kernel", "mm", "projects"]
categories: ["damon"]
date: 2019-12-27T18:21:07+01:00
lastmod: Sat, 27 Sep 2025 10:36:05 -0700
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
projects: ["damon"]
---

DAMON is a Linux kernel subsystem for efficient data access monitoring and
access-aware system operations.

---

With increasingly data-intensive workloads and limited DRAM capacity, optimal
memory management based on dynamic access patterns is becoming increasingly
important.  Such mechanisms are only possible if accurate and efficient dynamic
access pattern monitoring is available.

DAMON is a Linux kernel subsystem for such data access monitoring and
access-aware system operations.  It is designed with its key access monitroing
[mechanisms](https://docs.kernel.org/mm/damon/design.html) and a major feature
called [DAMOS](https://docs.kernel.org/mm/damon/design.html#operation-schemes),
that make it

- accurate (for DRAM level memory management),
- light-weight (enough to be applied online in production),
- scalable (keeps above properties regardless of memory size) and
- automated (tuning and access-aware memory maangement operations).

Simple mechanisms based on DAMOS can
[achieve](https://www.amazon.science/publications/daos-data-access-aware-operating-system)
up to 12% performance improvement and 91% memory savings.  Detailed evaluation
of DAMON and DAMON-based system optimizations are available at another
[post]({{< ref "damon_evaluation.md" >}}).

DAMON is being used in real-world products including AWS [Aurora
Serverless](https://www.amazon.science/publications/resource-management-in-aurora-serverless)
and SK hynix [HMSDK](https://github.com/skhynix/hmsdk/) for proactive
reclamation and CXL memory tiering.  A number of academic researches are also
utilizing DAMON for profiling and prototyping, as show by citations of the two
([1](https://scholar.google.com/scholar?oi=bibs&hl=en&cites=5046280136836673051&as_sdt=5),
[2](https://scholar.google.com/scholar?oi=bibs&hl=en&cites=12959341493842439999&as_sdt=5))
DAMON intro papers.

DAMON is available on Linux mainline since v5.15, and multiple major
[distros](https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=DAMON)
including Alma, Amazon, Android, Arch, CentOS, Debian, Fedora, open SUSE,
Oracle.


Demo Video/Screenshots
----------------------

### Demo Video

![damo monitor for water_nsquared](/img/damo_monitor_water_nsquared.gif)

{{< youtube l63eqbVBZRY >}}


### Demo Screenshot

![masim stairs snapshot](/img/masim_stairs_snapshot.png)
![masim stairs heatmap in ascii](/img/masim_stairs_heatmap_ascii.png)


Recent News
-----------

Below are only a short list of recent news.  For __complete list of the news__,
please refer to a dedicated [post]({{< ref "damon_news.md" >}}).

_2026-02-10_: An LSF/MM/BPF topic proposal for DAMON-based access-aware
Transparent Hugepages is
[posted](https://lore.kernel.org/20260211022845.68865-1-sj@kernel.org).

_2026-02-10_: DAMON has
[nominated](https://lore.kernel.org/c24a209d5a4af0c4cc08f30098998ce16c668b58.camel@ibm.com)
as one of Linux kernel ML library demonstration targets.

_2026-01-18_: DAMON user-space tool will start command line
[auto-completion](https://github.com/damonitor/damo/blob/next/USAGE.md#command-line-auto-completion)
support.

_2025-12-29_: DAMON user-space tool v3.0.9 is released with support of
`trace-cmd` for access pattern recording.

_2025-12-08_: Third RFC [patch
series](https://lore.kernel.org/damon/20251208062943.68824-1-sj@kernel.org/)
for per-CPU/threads/read/write monitoring is posted.


Getting Started
---------------

You can start using DAMON by
- installing its [user-space tool](#user-space-tool) and
- following the [tutorial](https://github.com/damonitor/damo#getting-started)
  of the user-space tool.

Further read [official documents](#official-document) to better understand
DAMON's design and usages.  If you prefer more informal videos, slides, or
papers, those from past DAMON [presentations](#publications-and-presentations)
are also available.

Depending on your system and your desired use case, you might need to
- install [DAMON-enabled and newer kernel](#install), and/or
- run the automated [tests suite](#tests-package).

You can also [participate](#contribution) in DAMON development.


User-space Tool
---------------

A user-space tool for DAMON, which is called DAMO (Data Access Monitoring
Operator), is available at
[Github](https://github.com/damonitor/damo),
[PyPi](https://pypi.org/project/damo/) and Linux distro [package
systems](https://repology.org/project/damo/versions).  You may start using
DAMON by following the
[Getting Started](https://github.com/damonitor/damo#getting-started) of the
tool for start.


Official Document
-----------------

The official document of DAMON in the latest mainline for
[users/sysadmins](https://docs.kernel.org/admin-guide/mm/damon/index.html) and
[kernel programmers](https://docs.kernel.org/mm/damon/index.html) are
available.  Those for next major release are also available([users/sysadmins
doc](https://docs.kernel.org/next/admin-guide/mm/damon/index.html), [kernel
programmers doc](https://docs.kernel.org/next/mm/damon/index.html)).


Publications and Presentations
------------------------------

Below are featured publications and presentations covering DAMON.  For __full
list__ of the past and upcoming presentations, please refer to another
dedicated [post]({{< ref "damon_publications_talks.md" >}}).

### Academic papers

For people who more familiar to academic papers, DAMON papers for
[Middleware'19 Industry](https://dl.acm.org/doi/abs/10.1145/3366626.3368125)
and
[HPDC'22](https://dl.acm.org/doi/abs/10.1145/3502181.3531466) are recommended to
read and/or cite.  The paper for Middleware'19 covers DAMON's monitoring
mechanisms and access pattern profiling-guided optimizations.  The paper for
HPDC'22 extends the coverage to DAMOS (automated access-aware system
operations) and user-space driven auto-tuning.

### Talks for beginners and users

If you are looking for a resources to start with, below talks are recommended.

- SeongJae Park, __Page-level and Fleet-wide Data Access Monitoring for Meta.__
  In _Linux Plumbers Refereed Track_, Dec 2025.
  [Slides](https://lpc.events/event/19/contributions/2075/attachments/1914/4138/damon_pagelevel_fleetwide_observability_lpc25.pdf),
  [Video](https://youtu.be/GolUxZZrVsU?si=qdPFE1RZAaNZ0lsY),
  [Link](https://lpc.events/event/19/contributions/2075/)
- SeongJae Park, __Overcoming Observer Effects in Memory Management with
  DAMON.__ In _Kernel Recipes_, Sep 2025.
  [Slides](https://github.com/damonitor/talks/blob/master/2025/kernel_recipes/damon_kernel_recipes2025.pdf),
  [Video](https://youtu.be/lvRuBxli_yU?si=QfeLZOn6Cx49qqqL),
  [Link](https://kernel-recipes.org/en/2025/schedule/overcoming-observer-effects-in-memory-management-with-damon/)
- SeongJae Park, __DAMON: Kernel Subsystem for Data Access Monitoring and
  Access-aware System Operations.__ In Fosdem, Feb 2025.
  [Slides](https://archive.fosdem.org/2025/events/attachments/fosdem-2025-4396-damon-kernel-subsystem-for-data-access-monitoring-and-access-aware-system-operations/slides/238776/damon_fos_tfIr9t8.pdf),
  [Video](https://video.fosdem.org/2025/ud2208/fosdem-2025-4396-damon-kernel-subsystem-for-data-access-monitoring-and-access-aware-system-operations.av1.webm),
  [Link](https://fosdem.org/2025/schedule/event/fosdem-2025-4396-damon-kernel-subsystem-for-data-access-monitoring-and-access-aware-system-operations/)

### Talks for experts and developers

If you want to track recent DAMON developmeent status and plans, below talks
are recommended.

- SeongJae Park, __DAMON-based Pages Migration for {C,G,X}PU [un]attached NUMA
  nodes.__ In _Device and Specific PurposeMemory MC at Linux Plumbers_, Dec
  2025.
  [slides](https://lpc.events/event/19/contributions/2066/attachments/1775/3961/damon_numa_migrate_lpc25.pdf),
  [Video](https://youtu.be/0jWF8Ogi4Fk?si=k6cpJy3ALo2H6lA1),
  [Link](https://lpc.events/event/19/contributions/2066/)
- SeongJae Park, __DAMON Requirements for Access-aware MM of Future.__ In
  _Linux Storage | Filesystem | MM & BPF Summit_, Mar 2025.
  [Slides](https://github.com/damonitor/talks/blob/master/2025/lsfmmbpf/damon_requirements_lsfmmbpf_2025.pdf),
  [Link](https://docs.google.com/spreadsheets/d/1PgjzaPOnIHgRIfqgwDNiftY5Xr6aU3NLWtDs7zFoIvc/edit?gid=1852749899#gid=1852749899)
- SeongJae Park, __DAMON Updates and Plans: Monitoring Parameters Auot-tuning
  and Memory Tiering.__ In _Linux Storage | Filesystem | MM & BPF Summit_,
  Mar 2025.
  [Slides](https://github.com/damonitor/talks/blob/master/2025/lsfmmbpf/damon_updates_plans_lsfmmbpf_2025.pdf),
  [Link](https://docs.google.com/spreadsheets/d/1PgjzaPOnIHgRIfqgwDNiftY5Xr6aU3NLWtDs7zFoIvc/edit?gid=1852749899#gid=1852749899)

Community
---------

DAMON is maintained and developed by its own community, which is a sub-set of
the linux kernel development community.

The community is mainly driven by the mailing list (damon@lists.linux.dev).
All the patches are posted there and reviewed.  Almost every discussions are
also made there.

For easy communication, a mailing tool called
[HacKerMaiL](https://github.com/sjp38/hackermail) is recommended.  The tool
is maintained by DAMON maintainer and committed to support DAMON community.

If you prefer web-based interface for reading the mails, you can use
[lore](https://lore.kernel.org/damon/).  If you prefer the traditional
subscription based mailing workflow, you can subscribe to the mailing list via
[subspace.kernel.org](https://subspace.kernel.org/lists.linux.dev.html)
following the [instruction](https://subspace.kernel.org/#subscribing).

The community also have an open, regular, and informal virtual bi-weekly
meeting series for DAMON community called DAMON Beer/Coffee/Tea chat
[series](https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing).


Contribution
------------

DAMON and its related projects including
[`damo`](https://github.com/damonitor/damo) and
[`hackermail`](https://github.com/sjp38/hackermail) are open source projects.
You can contribute to the development following the guidelines.  Please refer
to below contribution guidelines of each project to further look into the
process.

- [DAMON](https://www.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html)
- [damo](https://github.com/damonitor/damo/blob/next/CONTRIBUTING)
- [hkml](https://github.com/sjp38/hackermail/blob/master/CONTRIBUTING)


Setup for Advanced Use Cases
----------------------------

### Install

DAMON is a part of Linux kernel.  To use DAMON, therefore, you should ensure
your system is running with a DAMON-enabled Linux kernel.

To check if your kernel is a DAMON-enabled one, you could:

    $ if grep -q '^CONFIG_DAMON=y' /boot/config-$(uname -r);
    then
        echo "installed"
    else
        echo "not installed"
    fi

As of 2025-11-25, kernels of major Linux distros including Alma Linux, Amazon
Linux, Android, Arch, CentOS, Debian, Fedora, openSUSE and Oracle Linux
[enabled](https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=DAMON)
DAMON.  If your distro provides an appropriate DAMON-enabled kernel, install it
using the package manager of the distro.

If your package system doesn't support DAMON-enabled kernel, you can
fetch a DAMON-merged Linux kernel [source tree](#source-code), build, and
install it.  Note that you should enable kernel configuration options for
DAMON, depending on your demands.  For example:

    $ cd $THE_FETCHED_DAMON_KERNEL_SOURCE_TREE
    $ make olddefconfig
    $ echo 'CONFIG_DAMON=y' >> ./.config
    $ echo 'CONFIG_DAMON_VADDR=y' >> ./.config
    $ echo 'CONFIG_DAMON_PADDR=y' >> ./.config
    $ echo 'CONFIG_DAMON_SYSFS=y' >> ./.config
    $ echo 'CONFIG_DAMON_DBGFS=y' >> ./.config
    $ echo 'CONFIG_DAMON_RECLAIM=y' >> ./.config
    $ echo 'CONFIG_DAMON_LRU_SORT=y' >> ./.config
    $ echo 'CONFIG_DAMON_STAT=y' >> ./.config
    $ make -j$(nproc)
    $ sudo make modules_install install


### Source Code

There are several Linux kernel source trees having DAMON for different users.
You may pick one among those based on your needs.

For users who want a __stable__ version of DAMON, Linus Torvalds'
[mainline tree](https://git.kernel.org/torvalds/h/master) or [stable
kernels](https://www.kernel.org/category/releases.html) are recommended.
Note that DAMON has merged into mainline since v5.15.

If you have interests in DAMON features under __development__, refer to
developement source trees
[section](https://www.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees)
of DAMON official documents.


### Tests Package

There is a [tests suite](https://github.com/damonitor/damon-tests) for
correctness verification and performance evaluation of DAMON.  Those are
actively used for the development of DAMON.  Using that, you can test DAMON on
your machine with only a few simple commands or deeply understand the user
interface of DAMON.

So, if you finished the
[tutorial](https://github.com/damonitor/damo#getting-started) but have no idea
about what to do next, running the tests would be a good start.  If any test
fails, please report that to the maintainer via mail (sj@kernel.org or
damon@lists.linux.dev) or
[github](https://github.com/damonitor/damon-tests/issues).


Showcase Website
----------------

There is a showcase [website](https://damonitor.github.io/_index) that you can
get more information of DAMON.
The site hosts

- the heatmap format dynamic access pattern of various realistic workloads for
  [heap](https://damonitor.github.io/test/result/visual/latest/rec.heatmap.0.png.html)
  area,
  [mmap()-ed](https://damonitor.github.io/test/result/visual/latest/rec.heatmap.1.png.html)
  area,
  and
  [stack](https://damonitor.github.io/test/result/visual/latest/rec.heatmap.2.png.html)
  area,
- the dynamic working set size
  [distribution](https://damonitor.github.io/test/result/visual/latest/rec.wss_sz.png.html)
  and chronological working set
  size [changes](https://damonitor.github.io/test/result/visual/latest/rec.wss_time.png.html),
  and
- daily performance test
  [results](https://damonitor.github.io/test/result/perf/index.html).


Good to Read
------------

### Evaluation Results

Evaluation of DAMON and DAMON-based system optimizations are
[available]({{< ref "damon_evaluation.md" >}}).


### DAMON-based System Optimization Guide

A guide for DAMON-based system optimizations are also
[available]({{< ref "damon_optimization_guide.md" >}}).


### Profile-Guided Optimization Example

An example of DAMON-based profile-guided optimization is also
[available]({{<ref
"damon_profile_callstack_example.md#full-list-of-upcoming-and-past-publications-and-talks"
>}}).
