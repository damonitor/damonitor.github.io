---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "DAMON for Write-only or Given CPUs-only Monitoring"
subtitle: ""
summary: ""
authors: []
tags: ["damon", "linux", "kernel", "write-only", "cpus-only"]
categories: ["damon"]
date: Sun, 03 Aug 2025 12:26:10 -0700
lastmod: Sun, 03 Aug 2025 12:26:10 -0700
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

From the very early days of DAMON, there were attempts to extend it for
cpus-aware monitoring and write-only monitoring.

In 2022, Xin Hao
[proposed](https://lore.kernel.org/linux-mm/cover.1645024354.git.xhao@linux.alibaba.com/)
extending DAMON for NUMA access statistics.

In
[2022](https://lore.kernel.org/lkml/20220203131237.298090-1-pedrodemargomes@gmail.com/)
and
[2025](https://lore.kernel.org/damon/20250129044041.25884-1-pedrodemargomes@gmail.com),
Pedro Demarchi Gomes proposed extending DAMON for writes-only monitoring.

Those proposals are not yet upstreamed though.  We continued similar DAMON
extension discussions publicly and privately, with multiple parties, though.

I was recently taking some time on these, and happy to announce the first
working prototype for the extensions.  Please note that it is working in a way
that you can at least try, but the implementation is gross, unupstreamable, and
may contain many bugs.

On Linux kernel that built with some hacks that exist in damon/next tree as of
this writing (2025-08-03), users can do data access monitoring for only writes,
or for accesses made by given set of CPUs using the latest version of DAMON
user-space tool, damo, on its development
[branch](https://github.com/damonitor/damo/tree/next).

Write-only Access Monitoring
----------------------------

Users can do write-only data access monitoring by adding
`--exp_ops_use_reports` and `--exp_ops_write_only` options with value `y` to
the usual DAMON parameters setup commands including `damo start` and `damo
tune`, like below.

```
damo start --exp_ops_use_reports y --exp_ops_write_only y
```

Then DAMON will silently ignore read accesses, and show only the accesses that
made for writes.

Note that only physical address space monitoring is supported for now.

CPUs-only Access Monitoring
---------------------------

Users can monitor the data accesses made by only specific CPUs by adding
`--exp_ops_use_reports` and `--exp_ops_cpus options` to the usual DAMON
parameters setup commands including `damo start` and `damo tune`, like below.

```
damo start --exp_ops_use_reports y --exp_ops_cpus 0-3,5-7,9
```

`--exp_ops_use_reports` argument should always be y.

`--exp_ops_cpus` option should be given with a list of the desired CPUs. In
this example, accesses that made by only CPUs of id 0, 1, 2, 3, 5, 6, 7, or 9
will be monitored and reported. The format of the cpus list is same to that for
[cpuset.cpus](https://docs.kernel.org/admin-guide/cgroup-v2.html#cpuset-interface-files)
file of cgroup v2.

Note that only physical address space monitoring is supported for now.

Cautions and Plan to Drop Experimental Tag
------------------------------------------

The write-only and cpus-only monitoring features require changes in Linux
kernel that not yet upstreamed. The changes are available at
[damon/next](https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git/log/?h=damon/next)
tree, which is for containing under-development DAMON works, as of this writing
(2025-08-03). To make those upstreamed, we may need significant amount of
efforts. Many changes could be made on the upstreamed version. In the worst
case, we would forgive upstreaming the changes to mainline kernel, and drop the
support on the damon/next tree.

The user interface for these features on damo will definitely be changed in
future. At least, `--exp_` part will be removed.

Finally, as of this writing (2025-08-03), the features are nearly not tested,
so there could be many bugs.

So, please feel free to try and let us know bugs that you found, and if it is
useful and worthy enough to make the upstream efforts. But, please don't make
your long term important works depend on these.
