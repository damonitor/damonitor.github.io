---

title: "Upcoming feature: Page level peroperties based access monitoring"
subtitle: ""
summary: ""
authors: []
tags: ["damon", "damo", "features", "temperature", "filtering", "formatting"]
categories: ["features"]
date: Mon, 23 Dec 2024 11:10:19 -0800
lastmod: Mon, 23 Dec 2024 11:10:19 -0800
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

We're working on making DAMON to be used for page level properties based access
monitoring.  The idea is to let users describe specific page level properties
that are interested in, and provides the size of the type of memory in each
regions that DAMON found unique access pattern.

Hence, users can know how much of memory of specific access temperature is
having the type.  For example, you can know how much of memory that not
accessed for more than 20 minutes are having how much file-backed pages of a
cgroup.

An RFC patch series for implementing this feature has posted a few days ago,
and [available](https://lore.kernel.org/20241219040327.61902-1-sj@kernel.org)
at the mailing list.  The patches assembled tree is also available at the DAMON
development
[tree](https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git/log/?h=damon/next).
Note that there is a bug that restricts some usage of the features.  The
[fix](https://lore.kernel.org/20241222231222.85060-3-sj@kernel.org) is
available at mailing list.

DAMON user-space tool, [`damo`](https://github.com/damonitor/damo) is also
updated to support the feature and provide a dedicated visualization The
updated `damo` is released as
[v2.6.1](https://github.com/damonitor/damo/blob/v2.6.1/release_note#L4).  Refer
to the
[USAGE](https://github.com/damonitor/damo/blob/v2.6.1/USAGE.md#damo-report-access-page-level-properties-based-access-monitoring)
for detailed usages.

With the version of `damo` on a kernel that built with a kernel tree that based
on latest version of DAMON development
[tree](https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git/log/?h=damon/next)
of manually applied the RFC patch
[series](https://lore.kernel.org/20241219040327.61902-1-sj@kernel.org) and the
[fix](https://lore.kernel.org/20241222231222.85060-3-sj@kernel.org), therefore,
you can try the feature.

For example, you can know how much of anonymous and `PG_young` pages reside in
regions of different acces patterns, like below:

```
$ sudo ./damo report access --damos_filter anon nomatching --damos_filter young nomatching
heatmap: 00000000000000000000000000000000000000000000000000019999999999999622222222222222
# min/max temperatures: -144,860,000,000, -96,980,000,000, column size: 441.765 MiB
0   addr 29.355 GiB   size 4.475 GiB   access 0 %   age 24 m 8.600 s  anon and young 0 B
1   addr 33.830 GiB   size 5.958 GiB   access 0 %   age 24 m 7.900 s  anon and young 0 B
2   addr 39.788 GiB   size 5.972 GiB   access 0 %   age 24 m 7.300 s  anon and young 0 B
3   addr 45.760 GiB   size 5.953 GiB   access 0 %   age 24 m 3.700 s  anon and young 24.000 KiB
4   addr 51.714 GiB   size 5.978 GiB   access 0 %   age 16 m 9.800 s  anon and young 16.000 KiB
5   addr 57.692 GiB   size 5.986 GiB   access 0 %   age 21 m 50.700 s anon and young 64.000 KiB
6   addr 63.678 GiB   size 194.375 MiB access 0 %   age 21 m 13.200 s anon and young 0 B
total size: 34.513 GiB
```

From the above example output, for example, we can know there are 64 KiB
anonymous and young pages, in a memory region of about 6 GiB, that DAMON finds
as not accessed for about 22 minutes.

The example output is retrieved on a machine that doing nearly nothing, so it
looks quite boring.  On systems having realistic workloads that dynamic,
however, more interesting findings and optimizations based on those would be
available.
