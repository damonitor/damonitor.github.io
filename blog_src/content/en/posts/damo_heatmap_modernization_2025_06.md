---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "`damo report heatmap` modernization for snapshots, page level monitoring and intervals auto-tuning"
subtitle: ""
summary: ""
authors: []
tags: ["damo", "features", "heatmap"]
categories: ["damo"]
date: Sun, 08 Jun 2025 11:44:52 -0700
lastmod: Sun, 08 Jun 2025 11:44:52 -0700
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
projects: ["damo"]
---

TL; DR: `damo report heatmap` has recently advanced to support modern DAMON
features including age tracking, snapshots, page level monitoring, and moniting
intervals auto-tuning.

DAMON in The Past: Full Recording based Monitoring
--------------------------------------------------

At the beginning, DAMON was providing only access frequency of each memory
region in real time.  Hence heatmap visualization, which shows the access
frequency of each memory area in timeline was the first and one of the best
ways to see the access pattern.  DAMON user-space tool (`damo`) supported such
collections and visualizations of the data via `damo record` and `damo report
heatmap`, like below example.

```
$ sudo damo record "../masim/masim ../masim/configs/stairs.cfg"
[...]
$ sudo damo report heatmap -i damon.data
00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000004777777600000
00000000000000000000000000000000000000000000000000000000000000000005888888700000
00000000000000000000000000000000000000000000000000000000000000000003555555400000
00000000000000000000000000000000000000000000000000000000000048888883000000000000
00000000000000000000000000000000000000000000000000000000000068888883000000000000
00000000000000000000000000000000000000000000000000000000000068888883000000000000
00000000000000000000000000000000000000000000000000000111111100000000000000000000
00000000000000000000000000000000000000000000000000004888888700000000000000000000
00000000000000000000000000000000000000000000000000005888888700000000000000000000
00000000000000000000000000000000000000000000000000001222222100000000000000000000
00000000000000000000000000000000000000000000088888883000000000000000000000000000
00000000000000000000000000000000000000000000088888883000000000000000000000000000
00000000000000000000000000000000000000000000056666662000000000000000000000000000
00000000000000000000000000000000000001777776600000000000000000000000000000000000
00000000000000000000000000000000000004888888700000000000000000000000000000000000
00000000000000000000000000000000000004888888800000000000000000000000000000000000
00000000000000000000000000000023333331000000000000000000000000000000000000000000
00000000000000000000000000000088888883000000000000000000000000000000000000000000
00000000000000000000000000000588888883000000000000000000000000000000000000000000
00000000000000000000011111111332222221000000000000000000000000000000000000000000
00000000000000000000038888888870000000000000000000000000000000000000000000000000
00000000000000000000038888888870000000000000000000000000000000000000000000000000
00000000000000000000037666666650000000000000000000000000000000000000000000000000
00000000000002888888888000000000000000000000000000000000000000000000000000000000
00000000000003888888888000000000000000000000000000000000000000000000000000000000
00000000000003888888888000000000000000000000000000000000000000000000000000000000
00000004444555610000000000000000000000000000000000000000000000000000000000000000
00000005888888820000000000000000000000000000000000000000000000000000000000000000
00000005888888820000000000000000000000000000000000000000000000000000000000000000
44444446722222200000000000000000000000000000000000000000000000000000000000000000
88888888800000000000000000000000000000000000000000000000000000000000000000000000
88888888800000000000000000000000000000000000000000000000000000000000000000000000
66666666600000000000000000000000000000000000000000000000000000000000000000000000
# access_frequency: 0123456789
# x-axis: space [127.934 TiB, 127.934 TiB) (101.930 MiB)
# y-axis: time [2 h 33 m 56.451 s, 2 h 34 m 56.333 s) (59.882 s)
# resolution: 80x40 (1.274 MiB and 1.497 s for each character)
```

Each character on the middle of the output shows when (row) what address range
(column) of the memory was how frequently (number) accessed.  `masim` with
`stairs.cfg` allocated 10 regions of 10 MiB sized region, and access those one
by one.  The above heatmap is hence showing the pattern.

For the visualization, however, users have to record entire DAMON-observed
access frequency of each region for every moment.  For long time recording,
storage usage of the recorded data was not negligible.  Heatmap-visualization
of the huge record data was also time consuming.  Hence this was useful for lab
environments, but arguably not optimized for production environments.

```
$ ls -alh damon.data
-rw------- 1 root root 95K Jun  8 12:11 damon.data
```

Evolvement of Snapshots-based Monitoring
----------------------------------------

DAMON has evolved to provide not only access frequency of each region, but also
how long the current access frequency of the region was kept, namely 'age'.  It
was mainly developed for access-aware system oprations, namely DAMON-based
Operation Schemes (DAMOS).  But, we found the information can also be useful
for lightweight but practical monitoring.  We therefore made yet another DAMON
features for getting only the current snapshot of the DAMON monitoring results.
For easy capturing and visualization of the snapshot data, we implemented yet
another user-space tool feature, namely `damo report access`.  `damo record`,
which is the user-space tool feature for capturing entire DAMON monitoring
results for the heatmap-like visualizations, has also updated to support only
snapshot capturing (`--snapshot` option).  Nowadays, the snapshot based
visualization is the main feature of DAMON user-space tool for production
environments.

For example, users can start DAMON to monitor the workload asynchronously,
using `damo start`.

```
$ sudo damo start "../masim/masim ../masim/configs/stairs.cfg"
```

Then, users can collect and show the snapshot in vairous visualization styles,
using `damo report access`, like below.

```
$ sudo damo report access
heatmap: 00000000000000000000000000000002777777866[...]3333333333333333333333337899965555555447[...]8
# min/max temperatures: -2,210,000,000, 220,010,000, column size: 2.623 MiB
0   addr 85.672 TiB   size 20.957 MiB  access 0 %   age 21.700 s
1   addr 85.672 TiB   size 20.664 MiB  access 0 %   age 22.100 s
2   addr 85.672 TiB   size 20.902 MiB  access 0 %   age 21.800 s
3   addr 85.672 TiB   size 20.617 MiB  access 0 %   age 21.400 s
4   addr 85.672 TiB   size 17.754 MiB  access 0 %   age 1.600 s
5   addr 85.672 TiB   size 2.004 MiB   access 100 % age 1.100 s
6   addr 85.672 TiB   size 4.500 MiB   access 0 %   age 5.100 s
7   addr 127.047 TiB  size 41.785 MiB  access 0 %   age 12.500 s
8   addr 127.047 TiB  size 20.957 MiB  access 0 %   age 11.900 s
9   addr 127.047 TiB  size 4.047 MiB   access 0 %   age 1.800 s
10  addr 127.047 TiB  size 9.516 MiB   access 100 % age 2.200 s
11  addr 127.047 TiB  size 20.855 MiB  access 0 %   age 6.500 s
12  addr 127.047 TiB  size 5.145 MiB   access 0 %   age 10 s
13  addr 127.994 TiB  size 120.000 KiB access 0 %   age 10.900 s
14  addr 127.994 TiB  size 8.000 KiB   access 35 %  age 0 ns
15  addr 127.994 TiB  size 4.000 KiB   access 0 %   age 1.600 s
memory bw estimate: 2.250 GiB per second
total size: 209.832 MiB
monitoring intervals: sample 5 ms, aggr 100 ms
$ sudo damo report access --style hot
heatmap: 00000000000000000000000000000002666666888[...]3222222222222222888998777777764444444448[...]8
# min/max temperatures: -3,020,000,000, 100,010,000, column size: 2.623 MiB
        |99999999999999999999999999999999| 9.266 MiB   access 100 % 1 s
            |9999999999999999999999999999| 368.000 KiB access 100 % 200 ms
             |222222222222222222222222222| 12.000 KiB  access 30 %  100 ms
                                       |6| 1.273 MiB   access 75 %  0 ns
                                       |5| 1.035 MiB   access 65 %  0 ns
                                       |2| 1.730 MiB   access 30 %  0 ns
       |000000000000000000000000000000000| 4.445 MiB   access 0 %   1.900 s
      |0000000000000000000000000000000000| 4.508 MiB   access 0 %   2.200 s
     |00000000000000000000000000000000000| 120.000 KiB access 0 %   4.600 s
    |000000000000000000000000000000000000| 20.168 MiB  access 0 %   5.900 s
    |000000000000000000000000000000000000| 17.082 MiB  access 0 %   7.800 s
  |00000000000000000000000000000000000000| 20.512 MiB  access 0 %   13.100 s
  |00000000000000000000000000000000000000| 4.398 MiB   access 0 %   15.700 s
 |000000000000000000000000000000000000000| 41.785 MiB  access 0 %   20.700 s
 |000000000000000000000000000000000000000| 20.414 MiB  access 0 %   29.600 s
 |000000000000000000000000000000000000000| 20.957 MiB  access 0 %   29.900 s
 |000000000000000000000000000000000000000| 20.898 MiB  access 0 %   29.900 s
|0000000000000000000000000000000000000000| 20.871 MiB  access 0 %   30.200 s
memory bw estimate: 2.300 GiB per second
total size: 209.832 MiB
monitoring intervals: sample 5 ms, aggr 100 ms
$ sudo damo report access --style recency-percentiles
# total recency percentiles
<percentile> <idle time>
  0      0 ns  |                    |
  1      0 ns  |                    |
 25  12.500 s  |*****               |
 50  24.900 s  |**********          |
 75  48.800 s  |******************* |
 99  49.100 s  |********************|
100  49.100 s  |********************|
memory bw estimate: 2.317 GiB per second
total size: 209.832 MiB
monitoring intervals: sample 5 ms, aggr 100 ms
```

Users can also periodically collect snapshots and save those as a file, using
`damo record`.  For example, below command collects the snapshot three times
with five seconds interval between each snapshot, and save the ouptut as
damon.data file.  The size of the file is much smaller than the entire results
record.  `damo report access` can be used for further visualizing the saved data.

```
$ sudo damo record --snapshot 5s 3
[...]
$ ls -alh ./damon.data
-rw------- 1 root root 1.3K Jun  8 12:18 ./damon.data
$ sudo damo report access --input_file ./damon.data --style recency-percentiles
kdamond 0 / context 0 / scheme 0 / target id None / recorded for 100 ms from 485947 h 18 m 12.956 s
# total recency percentiles
<percentile> <idle time>
  0          0 ns  |                    |
  1          0 ns  |                    |
 25      16.800 s  |***                 |
 50      22.100 s  |****                |
 75  1 m 30.300 s  |******************* |
 99  1 m 30.600 s  |********************|
100  1 m 30.600 s  |********************|
memory bw estimate: 2.212 GiB per second
total size: 209.934 MiB
monitoring intervals: sample 5 ms, aggr 100 ms
kdamond 0 / context 0 / scheme 0 / target id None / recorded for 100 ms from 485947 h 18 m 18.051 s
# total recency percentiles
<percentile> <idle time>
  0          0 ns  |                    |
  1          0 ns  |                    |
 25      11.600 s  |**                  |
 50      24.700 s  |*****               |
 75  1 m 35.300 s  |******************* |
 99  1 m 35.600 s  |********************|
100  1 m 35.600 s  |********************|
memory bw estimate: 2.176 GiB per second
total size: 209.934 MiB
monitoring intervals: sample 5 ms, aggr 100 ms
kdamond 0 / context 0 / scheme 0 / target id None / recorded for 100 ms from 485947 h 18 m 23.139 s
# total recency percentiles
<percentile> <idle time>
  0          0 ns  |                    |
  1          0 ns  |                    |
 25      11.800 s  |**                  |
 50          23 s  |****                |
 75  1 m 40.300 s  |******************* |
 99  1 m 40.600 s  |********************|
100  1 m 40.600 s  |********************|
memory bw estimate: 2.175 GiB per second
total size: 209.934 MiB
monitoring intervals: sample 5 ms, aggr 100 ms
```

DAMON has gained more features including page level monitoring and intervals
auto-tuning.  Snapshot collecting and visualization features (`damo report
access` and `damo record`) also advanced together to support the modern
features.  With intervals auto-tuning, we believe DAMON can be enabled on
production environments always, and snapshot-based data collection and
visualization can be useful for system observability.

Meanwhile, heatmap visualization was not actively updated following the new
DAMON features.  It was just not working at all for snapshot data.  Though
snapshot based access visualization was proven to be useful, we recently
learned the old style heatmap visualization is what people can get the intuivie
glance of the access pattern in easier way.  We therefore started working on
updating `damo report heatmap` to support the modern features, starting from
v2.8.3.

Modernized `damo report heatmap`
--------------------------------

By v2.8.4, we expect `damo report heatmap` will show reliable and useful
heatmap visualization of snapshot data.  It shows access frequency of each
memory region like it was doing before.  But if the input is the DAMON
monitoring results of snapshot[s] rather than entire results of every moment,
it fills timeline based on the 'age' information of the region on the
snapshots.  For example, the abovely collected three snapshots data can be
visualized as a heatmap like below.

```
$ sudo damo report heatmap -i damon.data
[...]
00000000000000000000000000000000000000000000000000           0000000000000000000
0000000000000000000000000000000000000000000000000000000000   0000000000000000000
00000000000000000000000000000000000000001100000000000000058881000000000000000000
00000000000000000000000000000000000000000000000000000000000000  0000000000000000
00000000000000000000000000000000000000012000000000000000000007887000000000000000
00000000000000000000000000000000000000000000000000000000000000000   000000000000
00000000000000000000000000000000000000000020000000000000000000000888500000000000
# access_frequency: 0123456789
# x-axis: space [85.672 TiB, 85.672 TiB) (202.891 MiB)
# y-axis: time [485947 h 16 m 42.456 s, 485947 h 18 m 23.239 s) (1 m 40.783 s)
# resolution: 80x40 (2.536 MiB and 2.520 s for each character)
```

The format is same to the above record-based heatmap.  But, now there are blank
characters.  Those are memory regions that we cannot find the access
information from the snapshot.  Each snapshot shows access freuqency of each
region, and how long the access frequency was kept.  Let's say there is an
oldest snapshot saying first 100 MiB region was not accessed at all for 10
seconds, and next 10 MiB region was accessed with a high access frequency level
for 5 seconds.  Then, we cannot know what was the access frequency of the
10 MiB region before the 5 seconds.  The blank columns are showing that.

In more detail, The first three lines of the output are made from the first
(oldest) snapshot.  The snapshot found about 10 MiB of the region (`58881`)
were accessed frequently, for about 2.5 seconds.  The snapshot says the access
frequency was kept only for about 2.5 seconds, hence it's access frequency of
the past is unknown, so filled with blank columns.  This matches with our
understanding of `masim` program's access pattern.

Next two lines (fourth and fifth) are parobably made with the second snapshot.
The third snapshot should made the last two lines.  The expected `masim`
program's access pattern is continue being found there.

The latest version of `damo report heatmap` also supports page level monitoring
and intervals auto-tuning.  If the snapshot is captured with page level DAMOS
filters, users can plot the heatmap for only DAMOS filters-passed pages, by
passing `--df_passed` option to `damo report heatmap`.  The command also
understands monitoring intervals auto-tuning feature, and hence it handles the
dynamically changed intervals in an appropriate way, when handling the 'age'
information.

Wrapup
------

The classic heatmap visualization was not actively updated since DAMON has
changed its strategy for monitoring from full access observation records to
partial time information-captured snapshots.  Now the classic heatmap
visualization is modernized to support the snapshots use case, and expected to
be useful at understanding overall access patterns in a glance.
