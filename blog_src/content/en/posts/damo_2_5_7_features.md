---

title: "damo v2.5.7 new features: temperature filtering and formatting"
subtitle: ""
summary: ""
authors: []
tags: ["damo", "features", "temperature", "filtering", "formatting"]
categories: ["release"]
date: Mon, 25 Nov 2024 21:12:13 -0800
lastmod: Mon, 25 Nov 2024 21:12:13 -0800
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

damo v2.5.7 is
[released](https://github.com/damonitor/damo/blob/v2.5.7/release_note#L4) on
2024-11-25.  Two new major features on this version are temperature-based
regions filtering and formatting.

Temperature
-----------

"Temperature" of each memory region represents relative access hotness of the
region.  It is
[calculated](https://github.com/damonitor/damo/blob/v2.5.7/src/damo_report_access.py#L637)
as weighted sum of size, access rate
(a.k.a
[`nr_accesses`](https://docs.kernel.org/mm/damon/design.html#access-frequency-monitoring))
and age of each region.  By default, the weights for the three properties are
0, 100, and 100.  Users can manually set it using `--temperature_weights`
option.

Temperature-based regions filtering
-----------------------------------

This feature allows users filter regions of specific temperature range.  For
example, below shows the access pattern of a Java-based server workload's
access pattern in the temperature range to total size of regions of the range
histogram visualization format (a.k.a `temperature-sz-hist`
[style](https://github.com/damonitor/damo/blob/v2.5.7/USAGE.md#access-report-styles)).

```
$ sudo damo report access --style temperature-sz-hist
<temperature> <total size>
[-571000000000, -509579999000) 108.000 KiB |*                   |
[-509579999000, -448159998000) 4.000 KiB   |*                   |
[-448159998000, -386739997000) 20.000 KiB  |*                   |
[-386739997000, -325319996000) 0 B         |                    |
[-325319996000, -263899995000) 84.000 KiB  |*                   |
[-263899995000, -202479994000) 0 B         |                    |
[-202479994000, -141059993000) 3.271 GiB   |**                  |
[-141059993000, -79639992000)  2.953 GiB   |**                  |
[-79639992000, -18219991000)   10.412 GiB  |******              |
[-18219991000, 43200010000)    40.116 GiB  |********************|
[43200010000, 104620011000)    84.000 KiB  |*                   |
total size: 56.752 GiB
```

From the result, we can know there are warm memory regions of about 40 GiB
total size, and hot memory region of 84 KiB total size.  Now users would want
to know further what access pattern is inside the 40 GiB regions.  Users can
use the temperature filter feature for the purpose, like below.

```
$ sudo damo report access --temperature -18219991000 43200010000 --style temperature-sz-hist
<temperature> <total size>
[-18,000,000,000, -11,879,999,000) 3.874 GiB   |****                |
[-11,879,999,000, -5,759,998,000)  11.585 GiB  |**********          |
[-5,759,998,000, 360,003,000)      23.979 GiB  |********************|
[360,003,000, 6,480,004,000)       693.363 MiB |*                   |
[6,480,004,000, 12,600,005,000)    40.000 KiB  |*                   |
[12,600,005,000, 18,720,006,000)   100.000 KiB |*                   |
[18,720,006,000, 24,840,007,000)   0 B         |                    |
[24,840,007,000, 30,960,008,000)   8.000 KiB   |*                   |
[30,960,008,000, 37,080,009,000)   28.000 KiB  |*                   |
[37,080,009,000, 43,200,010,000)   12.000 KiB  |*                   |
[43,200,010,000, 49,320,011,000)   84.000 KiB  |*                   |
total size: 40.116 GiB
```

Note that `damo report access` supports more types of region filters.  Refer to
the usage
[document](https://github.com/damonitor/damo/blob/v2.5.7/USAGE.md#sorting-and-filtering-regions-based-on-access-pattern)
for more details.

Regions formatting with temperature
-----------------------------------

The filtered histogram shows more details.  In some cases, users may want to
further know not only the total size but every detail of each region, including
address, size, access rate, age, and the calculated temperature.  The size and
address would be specifically interesting if the user is interested in some
contiguity-related optimizations like THP.

`damo report access` allows users formatting the output in a flexible way.
From damo v2.5.7, the command supports showing temperature of each region.
For example, users can show each region's start address, size, access rate,
age, and the temperature like below.

```
$ sudo damo report access --format_region "<start address> <size> <access rate> <age> <temperature>"
16.219 GiB   93.281 MiB  0 %   22 s -2,200,000,000
16.310 GiB   32.000 KiB  100 % 1 m 36 s 9,600,010,000
16.310 GiB   28.000 KiB  0 %   2 s -,200,000,000
16.310 GiB   32.000 KiB  40 %  4 s 400,004,000
16.310 GiB   84.000 KiB  10 %  0 ns 1,000
[...]
```
