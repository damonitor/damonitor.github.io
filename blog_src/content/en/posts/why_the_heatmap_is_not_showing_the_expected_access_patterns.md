---

title: "Why the heatmap is not showing the expected access patterns?"
subtitle: ""
summary: ""
authors: []
tags: ["damo", "heatmap", "tip"]
categories: ["faq"]
date: Sun, 16 Mar 2025 10:19:49 -0700
lastmod: Sun, 16 Mar 2025 10:19:49 -0700
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

TL; DR: try `--draw_range all` option of `damo report heatmap` if it shows not
what you expected.

`damo report heatmap` outputs sometimes show no expected access pattern.  It is
sometimes just entirely black, or shows some access pattern but not what the
user expected.  This post is for explaining the reason and how you can work around.

The problem usually happens when user tries to draw the heatmap for access
pattern that recorded for a virtual address space of a process.  Each virtual
address space is very huge.  And usually those have two wide regions that not
really mapped to physical memory. That's because the stack and the heap are
mapped from the two ends of the address space, and do so for mmap()-ed regions
from the middle of the space.  The resulting mapping looks like below:

```
<heap>
<BIG UNMAPPED REGION 1>
<uppermost mmap()-ed region>
(small mmap()-ed regions and munmap()-ed regions)
<lowermost mmap()-ed region>
<BIG UNMAPPED REGION 2>
<stack>
```

If we try to draw the heatmap for the entire address space, the two wide
unmapped regions will cover most of the graph. And it will only show black,
because the unmapped wide regions will never get accessed.

To draw heatmap for only the address ranges that meaningful accesses were made,
`damo report heatmap` allows users to specify what address ranges they want
draw heampa for, using `--address_range` option.

Because it is not easy to know to what address range specific data objects of
the program is mapped, the command also provides a few features for helping it.

`damo report heatmap --guide` or `damo record_info` shows high level
information about the record file.  The three address ranges excepting the two
huge gaps are included there.  For example:

```
$ sudo ./damo record_info --info ./damon.data
target_id:0
time: 67900017466000-67959790343999 (59.773 s)
region   0: 00000093925306740736-00000093925678731264 (354.758 MiB)
region   1: 00000139965707698176-00000139965814927360 (102.262 MiB)
region   2: 00000140730699452416-00000140730699587584 (132.000 KiB)
```

To help easier selection, `damo report heatmap` also provides `--draw_range`
option.  As of this writing, the option allows two inputs, namely `hottest` and
`all`.  If `all` is passed, `damo` will draw heatmaps for all the mapped
regions.  If `hottest` is passed to the option, `damo` will find a mapped
region that most access has happened, and draw the heatmap for only the hottest
region.

As of this writing, `damo report heatmap` works as `--draw_range hottest` is
given by default.  Note that that the default behavior could be changed in
future.  Also, `--draw_range` option will be available from v2.7.2.

Wrapup
------

So, if `damo report heatmap` output is different from what you expected, please
try running it again with `--draw_range all`.  If you don't want to draw all
the maps but hottest one, please use `--draw_range hottest`.  Or, if you want
to draw the map for only specific region, use `--guide` option for high level
information that will help you what region you really want to understand in
dtail, and use `--address_range` option.
