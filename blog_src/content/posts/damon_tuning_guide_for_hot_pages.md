---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: A guide to DAMON tuning and results interpretation for hot pages
subtitle: ""
summary: ""
authors: []
tags: ["damon", "tuning", "hot", "aggregation interval", "age", "monitoring"]
categories: ["damon"]
date: Fri, 08 Nov 2024 17:19:32 -0800
lastmod: Fri, 08 Nov 2024 17:19:32 -0800
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

The initial version of this post was initially posted to DAMON mailing list as
https://lore.kernel.org/20241108232536.73843-1-sj@kernel.org

Posting it here too, for visibility and after-posting updates for any needs.

---

One of common issues that I received from DAMON users is that DAMON's
monitoring results show hot regions much less than expected.  Specifically, the
users find regions of only zero or low 'nr_accesses' value from the
DAMON-generated access pattern snapshots.

In some cases, it turned out the problem can be alleviated by tuning DAMON
parameters or changing the way to interpret the results.  I'd like to share the
details and possible future improvements here.

Note that I'm not saying this is users' tuning fault.  I admit that the real
root cause of the issue is the poor interface and lack of guides that makes
correct tuning difficult, and the suboptimality of DAMON's mechanisms.  We will
continue working on advancing it in long term.  Sharing some of the plans and
status at the end of this email.

TL; DR
------

Users show only low or zero nr_accesses regions mainly because they set
'aggregation intrval' too short compared to the workload's memory access
intensiveness.  Please increase the aggregation interval, or treat
'nr_accesses' zero regions of short 'age' as hot regions.

Now let's walk through more details.  The below sections assume you're familiar
with DAMON's monitoring mechanisms including 'Access Frequency Monitoring',
'Regions Based Sampling', 'Adaptive Regions Adjustment', and 'Age Tracking'.
You should particularly be familiar with terms including 'sampling interval',
'aggregation interval', 'nr_accesses', and 'age'.  If you're not familiar with
those, you can refer to the document
(https://www.kernel.org/doc/html/next/mm/damon/design.html#monitoring).

Problem
-------

Some users reported that they expected DAMON will be useful for finding both
cold memory regions and hot memory regions.  And they found it indeed works for
finding cold memory regions.  But, they found difficulties at finding hot
memory regions.  Some detailed reported cases are as below.

Case 1: Proactive Reclamation

A user tried to use DAMOS for proactively reclaiming cold memory regions.  They
hence specified maximum access rate (nr_accesses) and minimum age of target
regions for the DAMOS scheme as zero and 2 minutes, respectively.  It means
asking DAMON to find regions that not accessed for two minutes or more and
reclaim those as soon as found.  If they use DAMON user-space tool, damo, they
would used a command like below.

    # damo start --damos_action pageout --damos_access rate 0% 0% --damos_age 2m max

The result was as the user expected.  The user reported me that they were able
to save memory without performance degradation.

My test setup also showed good results from similar DAMOS schemes, even though
my setup was using even more aggressive approach (minimum age as 5 seconds).

Case 2: Heatmap Visualization

A user has recorded data access pattern of their workloads using DAMON
user-space tool, damo, and draw heatmap using 'damo report heatmap' command.
The workload was active and therefore the user expected the heatmap to show
some heats.  But the output was showing nearly zero heats.  It was nearly
always only dark.

On my test setup, some workloads indeed showed very dark heatmap.  But on
multiple workloads, meaningful access patterns were identifiable using the
heatmaps
(https://damonitor.github.io/test/result/visual/next/rec.heatmap.1.png.html).

Case 3: Prioritizing Hot Pages

A user tried to use DAMOS for finding hot memory regions and make a
prioritization action like backing the regions with THP, migrating the pages
from CXL node to DRAM node, or moving the page from inactive LRU list to active
LRU list.  They hence specified minimum access rate (nr_accesses) for the DAMOS
scheme with a high value.  For example, a command like below was used:

    # damo start --damos_action hugepage --damos_access_rate 50% max $(pidof workload)

However, they found DAMOS is doing nearly nothing.  They reduced the minimum
access_rate, and situation has been better, but still DAMOS was not finding
expected amount of hot memory regions.

Case 2 and 3 mean that they expected to show regions of high 'nr_accesses'
value from DAMON-generated access pattern snapshots.  But it showed only zero
or low 'nr_accesses' values.

On my test setup (https://damonitor.github.io/posts/damon_evaluation/), similar
approach showed good results, though.

One common thing that I found from the reports was that they were using default
values for 'aggregation interval', which is 100 milliseconds.  My test setup is
also using the default values.

Meaning of 'aggregation interval'
---------------------------------

For every 'aggregation interval', DAMON generates one complete access pattern
snapshot.  That means 'aggregation interval' can be though of as the time
amount of information that a single snapshot can contain.  The value should
hence be decided depending on how much information the user wants each snapshot
to have.  If it is too short, each snapshot contains nearly no information, so
not be useful.  If it is too long, each snapshot contains too much information
that coarsely cumulated, so again not useful.

The meaningful length of time depends on the data access intensiveness of the
workload.  The intensiveness should be measured with two factors: frequency and
footprint.

The frequency is how frequently the workload is making accesses.  If the
workload makes zero or only a low number of accesses per given 'aggregation
interval', the snapshot will of course show zero or low number of accesses, due
to 'Access Frequency Monitoring' mechanism.

The footprint is the total amount of memory that the workload has accessed at
least once.  Due to 'Region Based Sampling' mechanism, it should be
meaningfully large compared to the size of total monitoring target regions.
For example, if DAMON is requested to monitor 1 TiB memory and the workload is
accessing 1 MiB region of it, DAMON's sampling based approach will have
difficulty at finding the 1 MiB region.  'Adaptive Regions Adjustment'
mechanism will make DAMON to find the 1 MiB region eventually.  But it will
take time.  The workload could stop accessing the 1 MiB region and starts
accessing another 1 MiB region before the 'Adaptive Regions Adjustment'
mechanism finds it.

Note that the frequency and footprint of accesses from workloads would depend
on not only the source code but also many factors.  The system's total memory
bandwidth,  the extent of load and noisy neighbor workloads could be a few
examples.

So, if the desired maximum 'nr_accesses' on each snapshot is fixed,
'aggregation interval' should be increased as the access aggressiveness is
decreased, and vice versa.

Root Causes 1: Suboptimal Aggregation Interval Tuning
-----------------------------------------------------

I suspect in many of the reported problematic cases, the 'aggregation interval'
was too short.  The default value is good enough for my test setup, but it
would need tuning on different systems.  Especially on large systems having
limited bandwidth, 100 millisecond 'aggregation interval' could be not long
enough to make meaningful amount of accesses in terms of both frequency and
footprint within the interval.

I actually suggested some of the reporters to increase 'aggregation interval',
and it was helpful at alleviating the issue in some degree.  I cannot know
exactly who are using DAMON with what parameters.  But at least one
open-sourced usage from HMSDK is setting 'aggregation interval' as two seconds
(https://github.com/skhynix/hmsdk/blob/hmsdk-v3.0/tools/gen_migpol.py#L14).

Root Cause 2: Ignorance of Recency ('age')
------------------------------------------

The 'nr_accesses' represents the access frequency, and hence it is natural to
assume hot memory regions would have high 'nr_accesses'.

DAMON provides not only frequency.  It also informs users how long the
'nr_accesses' of the regions is maintained, namely 'age', using 'Age Tracking'
mechanism.  If 'nr_accesses' is non-zero, 'age' can be used to calculate actual
access hotness of the region (if we turn fire on for longer time, the
temperature will be higher).  If 'nr_accesses' is zero, 'age' can represent a
sort of the recency information (when the regions has last accessed).

The recency information can be useful for finding cold pages like case 1
(proactive reclaim).  The opposite of finding cold pages is finding hot pages,
so the recency information can also be used for finding relatively hot pages.
In other words, if for any reason DAMON cannot generate a snapshot having
enough non-zero 'nr_accesses' divergence for given purpose, users could further
differentiate hot regions among zero 'nr_accesses' regions, using 'age'
information.  It would be not ideal, but still reasonable like a sort of
LRU-based appraoches could be.

So I suspect some of the problems occur from not using 'age' for zero
'nr_accesses' regions.  Actually reports from case 3 (prioritizing hot pages),
which were successful only on my test setup, were commonly using non-zero
minimum 'nr_accesses' for DAMOS schemes, so were ignoring 'age' of zero
'nr_accesses' regions.  Meanwhile, case 2 (proactive reclaim) was using 'age'
information for zero 'nr_accesses' regions, and no negative results have
reported so far.

This might seem like not addressing case 2 (heatmap visualization), because
heatmap shows 'nr_accesses' change of regions over time.  But if the record is
collected for long time, regions that shown non-zero 'nr_accesses' for a short
period may look a very small dot on the low-resolution picture that not easy to
shown with human eyes.  The users might be able to get different results using
'age' information on the collected snapshot, like recency or temperation based
histogram
(https://github.com/damonitor/damo/blob/v2.5.4/USAGE.md#access-report-styles).

Tuning Guide
------------

Based on above root cause theories, I suggest to try below tuning guides.

If you show DAMON is not working well at finding hot pages,

1. Ensure your workload is making meaningfully intensive data accesses.
2. Gradually increase aggregation interval and show if it makes change.
3. Try using 'age' information even if 'nr_accesses' is zero.
4. If nothing works, report the problem to sj@kernel.org, damon@lists.linux.dev
   and/or linux-mm@kvack.org.

If increasing aggregation interval alleviates your problem, you can further
consider increasing 'sampling interval'.  If it doesn't harm the quality of the
access pattern snapshots, having low 'sampling interval' will only increase
DAMON's CPU usage.

For using 'age' information of zero 'nr_accesses' regions, different approaches
could be used for profiling use case and DAMOS use case.  For profiling use
case, users can try reading recency or access temperature based histograms
(https://github.com/damonitor/damo/blob/v2.5.4/USAGE.md#access-report-styles)
of snapshots from record, or live-captured snapshots.

If the use case is for DAMOS, applying the 'age' information on DAMOS target
access pattern would be straightforward.  Using DAMOS Quotas together can be
useful, since it provides its own under-quota-prioritization logic that
utilizes 'age' information for zero 'nr_accesses' regions, and further provides
auto-tuning of the quota for given target metric/value.

Tuning Example
--------------

The initial version of this section is also posted to the mailing list:
https://lore.kernel.org/20241202175459.2005526-1-sj@kernel.org

I tried monitoring the access patterns on the physical address space of a
system running a real-world server workload.  I was able to reproduce the
reported poor quality of hot pages detection using default parameter.  And I
was also able to improve the quality following the above tuning guide.  I'm
sharing the details as an example.

### 5ms/100ms intervals: Reproduce Problem

Initially, I captured the access pattern snapshot on the physical address
space using DAMON, with the default interval parameters (5 milliseconds and 100
milliseconds for the sampling and the aggregation intervals, respectively).  I
wait ten minutes after starting DAMON, to show a meaningful time-wise access
patterns.

```
# damo start
# sleep 600
# damo record --snapshot 0 1
# damo stop
```

Then, I listed the DAMON-found regions of different access patterns, sorted by
the access temperature.  Access temperature is
[calculated](https://github.com/damonitor/damo/blob/v2.5.8/src/damo_report_access.py#L643)
as a weighted sum of the access frequency and the age of the region.  If the
access frequency is 0 %, the temperature is multipled by minus one.  That is,
if a region is not accessed, it gets minus temperature and it gets lower as not
accessed for longer time.  The sorting is in temperature-ascendint order, so
the region at the top of the list is the coldest, and the one at the bottom is
the hottest one.

```
# damo report access --sort_regions_by temperature
0   addr 16.052 GiB   size 5.985 GiB   access 0 %   age 5.900 s    # coldest
1   addr 22.037 GiB   size 6.029 GiB   access 0 %   age 5.300 s
2   addr 28.065 GiB   size 6.045 GiB   access 0 %   age 5.200 s
3   addr 10.069 GiB   size 5.983 GiB   access 0 %   age 4.500 s
4   addr 4.000 GiB    size 6.069 GiB   access 0 %   age 4.400 s
5   addr 62.008 GiB   size 3.992 GiB   access 0 %   age 3.700 s
6   addr 56.795 GiB   size 5.213 GiB   access 0 %   age 3.300 s
7   addr 39.393 GiB   size 6.096 GiB   access 0 %   age 2.800 s
8   addr 50.782 GiB   size 6.012 GiB   access 0 %   age 2.800 s
9   addr 34.111 GiB   size 5.282 GiB   access 0 %   age 2.300 s
10  addr 45.489 GiB   size 5.293 GiB   access 0 %   age 1.800 s    # hottest
total size: 62.000 GiB
```

The list shows not seemingly hot regions, and only minimum access pattern
diversity.  Every region has zero access frequency.  The number of region is
10, which is the default `min_nr_regions` value.  Size of each region is also
nearly idential.  We can suspect this is because "adaptive regions adjustment"
mechanism was not well working.  As the guide suggested, we can get relative
hotness of regions using 'age' as the recency information.  That would be
better than nothing, but given the fact that the longest age is only about 6
seconds while we waited about ten minuts, it is unclear how useful this will
be.

The temperature ranges to total size of regions of each range histogram
[visualization](https://github.com/damonitor/damo/blob/v2.5.7/USAGE.md#access-report-styles)
of the results also shows no interesting distribution pattern.

```
# damo report access --style temperature-sz-hist
<temperature> <total size>
[-,590,000,000, -,549,000,000) 5.985 GiB  |**********          |
[-,549,000,000, -,508,000,000) 12.074 GiB |********************|
[-,508,000,000, -,467,000,000) 0 B        |                    |
[-,467,000,000, -,426,000,000) 12.052 GiB |********************|
[-,426,000,000, -,385,000,000) 0 B        |                    |
[-,385,000,000, -,344,000,000) 3.992 GiB  |*******             |
[-,344,000,000, -,303,000,000) 5.213 GiB  |*********           |
[-,303,000,000, -,262,000,000) 12.109 GiB |********************|
[-,262,000,000, -,221,000,000) 5.282 GiB  |*********           |
[-,221,000,000, -,180,000,000) 0 B        |                    |
[-,180,000,000, -,139,000,000) 5.293 GiB  |*********           |
total size: 62.000 GiB
```

In short, the result is very similar to the reported problems: poor quality
monitoring results for hot regions detection.  According to the above guide,
this is due to the too short aggregation interval.

### 100ms/2s intervals: Starts Showing Small Hot Regions

Following the guide, I increased the interval 20 times (100 milliseocnds and 2
seconds for sampling and aggregation intervals, respectively).

```
# damo start -s 100ms -a 2s
# sleep 600
# damo record --snapshot 0 1
# damo stop
# damo report access --sort_regions_by temperature
0   addr 10.180 GiB   size 6.117 GiB   access 0 %   age 7 m 8 s    # coldest
1   addr 49.275 GiB   size 6.195 GiB   access 0 %   age 6 m 14 s
2   addr 62.421 GiB   size 3.579 GiB   access 0 %   age 6 m 4 s
3   addr 40.154 GiB   size 6.127 GiB   access 0 %   age 5 m 40 s
4   addr 16.296 GiB   size 6.182 GiB   access 0 %   age 5 m 32 s
5   addr 34.254 GiB   size 5.899 GiB   access 0 %   age 5 m 24 s
6   addr 46.281 GiB   size 2.995 GiB   access 0 %   age 5 m 20 s
7   addr 28.420 GiB   size 5.835 GiB   access 0 %   age 5 m 6 s
8   addr 4.000 GiB    size 6.180 GiB   access 0 %   age 4 m 16 s
9   addr 22.478 GiB   size 5.942 GiB   access 0 %   age 3 m 58 s
10  addr 55.470 GiB   size 915.645 MiB access 0 %   age 3 m 6 s
11  addr 56.364 GiB   size 6.056 GiB   access 0 %   age 2 m 8 s
12  addr 56.364 GiB   size 4.000 KiB   access 95 %  age 16 s
13  addr 49.275 GiB   size 4.000 KiB   access 100 % age 8 m 24 s   # hottest
total size: 62.000 GiB
# damo report access --style temperature-sz-hist
<temperature> <total size>
[-42,800,000,000, -33,479,999,000) 22.018 GiB |*****************   |
[-33,479,999,000, -24,159,998,000) 27.090 GiB |********************|
[-24,159,998,000, -14,839,997,000) 6.836 GiB  |******              |
[-14,839,997,000, -5,519,996,000)  6.056 GiB  |*****               |
[-5,519,996,000, 3,800,005,000)    4.000 KiB  |*                   |
[3,800,005,000, 13,120,006,000)    0 B        |                    |
[13,120,006,000, 22,440,007,000)   0 B        |                    |
[22,440,007,000, 31,760,008,000)   0 B        |                    |
[31,760,008,000, 41,080,009,000)   0 B        |                    |
[41,080,009,000, 50,400,010,000)   0 B        |                    |
[50,400,010,000, 59,720,011,000)   4.000 KiB  |*                   |
total size: 62.000 GiB
```

DAMON found two distinct 4 KiB regions that pretty hot.  The regions are also
well aged.  The hottest 4 KiB region was keeping the access frequency for about
8 minutes, and the coldest region was keeping no access for about 7 minutes.
The distribution on the histogram also looks like having a pattern.

Especially, the finding of the 4 KiB regions shows DAMON's adaptive regions
adjustment is working as designed.

Still the number of regions is close to the `min_nr_regions`, and sizes of cold
regions are similar, though.  Apparently it is improved, but it still has rooms
to improve.

### 400ms/8s intervals: Pretty Improved Results

I further increased the intervals four times (400 milliseconds and 8 seconds
for sampling and aggregation intervals, respectively).

```
# damo start -s 400ms -a 8s
# sleep 600
# damo record --snapshot 0 1
# damo stop
# damo report access --sort_regions_by temperature
0   addr 64.492 GiB   size 1.508 GiB   access 0 %   age 6 m 48 s    # coldest
1   addr 21.749 GiB   size 5.674 GiB   access 0 %   age 6 m 8 s
2   addr 27.422 GiB   size 5.801 GiB   access 0 %   age 6 m
3   addr 49.431 GiB   size 8.675 GiB   access 0 %   age 5 m 28 s
4   addr 33.223 GiB   size 5.645 GiB   access 0 %   age 5 m 12 s
5   addr 58.321 GiB   size 6.170 GiB   access 0 %   age 5 m 4 s
[...]
25  addr 6.615 GiB    size 297.531 MiB access 15 %  age 0 ns
26  addr 9.513 GiB    size 12.000 KiB  access 20 %  age 0 ns
27  addr 9.511 GiB    size 108.000 KiB access 25 %  age 0 ns
28  addr 9.513 GiB    size 20.000 KiB  access 25 %  age 0 ns
29  addr 9.511 GiB    size 12.000 KiB  access 30 %  age 0 ns
30  addr 9.520 GiB    size 4.000 KiB   access 40 %  age 0 ns
[...]
41  addr 9.520 GiB    size 4.000 KiB   access 80 %  age 56 s
42  addr 9.511 GiB    size 12.000 KiB  access 100 % age 6 m 16 s
43  addr 58.321 GiB   size 4.000 KiB   access 100 % age 6 m 24 s
44  addr 9.512 GiB    size 4.000 KiB   access 100 % age 6 m 48 s
45  addr 58.106 GiB   size 4.000 KiB   access 100 % age 6 m 48 s    # hottest
total size: 62.000 GiB
# damo report access --style temperature-sz-hist
<temperature> <total size>
[-40,800,000,000, -32,639,999,000) 21.657 GiB  |********************|
[-32,639,999,000, -24,479,998,000) 17.938 GiB  |*****************   |
[-24,479,998,000, -16,319,997,000) 16.885 GiB  |****************    |
[-16,319,997,000, -8,159,996,000)  586.879 MiB |*                   |
[-8,159,996,000, 5,000)            4.946 GiB   |*****               |
[5,000, 8,160,006,000)             260.000 KiB |*                   |
[8,160,006,000, 16,320,007,000)    0 B         |                    |
[16,320,007,000, 24,480,008,000)   0 B         |                    |
[24,480,008,000, 32,640,009,000)   0 B         |                    |
[32,640,009,000, 40,800,010,000)   16.000 KiB  |*                   |
[40,800,010,000, 48,960,011,000)   8.000 KiB   |*                   |
total size: 62.000 GiB
```

The number of regions having different access patterns has significantly
increased.  Size of each region is also more varied.  Total size of non-zero
access frequency regions is also significantly increased.  Maybe this is
already good enough to make some meaningful memory management efficieny
changes.

### 800ms/16s intervals: Another bias

Further doubling the intervals (800 milliseconds and 16 seconds for sampling
and aggregation intervals, respectively) mor improved the hot regions
detection, but starts looking degrading cold regions detection.

```
# damo start -s 800ms -a 16s
# sleep 600
# damo record --snapshot 0 1
# damo stop
# damo report access --sort_regions_by temperature
0   addr 64.781 GiB   size 1.219 GiB   access 0 %   age 4 m 48 s
1   addr 24.505 GiB   size 2.475 GiB   access 0 %   age 4 m 16 s
2   addr 26.980 GiB   size 504.273 MiB access 0 %   age 4 m
3   addr 29.443 GiB   size 2.462 GiB   access 0 %   age 4 m
4   addr 37.264 GiB   size 5.645 GiB   access 0 %   age 4 m
5   addr 31.905 GiB   size 5.359 GiB   access 0 %   age 3 m 44 s
[...]
20  addr 8.711 GiB    size 40.000 KiB  access 5 %   age 2 m 40 s
21  addr 27.473 GiB   size 1.970 GiB   access 5 %   age 4 m
22  addr 48.185 GiB   size 4.625 GiB   access 5 %   age 4 m
23  addr 47.304 GiB   size 902.117 MiB access 10 %  age 4 m
24  addr 8.711 GiB    size 4.000 KiB   access 100 % age 4 m
25  addr 20.793 GiB   size 3.713 GiB   access 5 %   age 4 m 16 s
26  addr 8.773 GiB    size 4.000 KiB   access 100 % age 4 m 16 s
total size: 62.000 GiB
# damo report access --style temperature-sz-hist
<temperature> <total size>
[-28,800,000,000, -23,359,999,000) 12.294 GiB  |*****************   |
[-23,359,999,000, -17,919,998,000) 9.753 GiB   |*************       |
[-17,919,998,000, -12,479,997,000) 15.131 GiB  |********************|
[-12,479,997,000, -7,039,996,000)  0 B         |                    |
[-7,039,996,000, -1,599,995,000)   7.506 GiB   |**********          |
[-1,599,995,000, 3,840,006,000)    6.127 GiB   |*********           |
[3,840,006,000, 9,280,007,000)     0 B         |                    |
[9,280,007,000, 14,720,008,000)    136.000 KiB |*                   |
[14,720,008,000, 20,160,009,000)   40.000 KiB  |*                   |
[20,160,009,000, 25,600,010,000)   11.188 GiB  |***************     |
[25,600,010,000, 31,040,011,000)   4.000 KiB   |*                   |
total size: 62.000 GiB
```

It found more non-zero access frequency regions.  The number of regions is
still much higher than the `min_nr_regions`, but it is reduced from that of the
previous setup.  And apparently the distribution seems bit biased to hot
regions.

### Conclusion

Because the workload is live, the above results are not always consistent.
But, the tendency of the quality for the interval changes was consistent.

With the above experimental tuning results, I conclude the theory and the guide
makes sense to at least this workload, and could be applied to similar cases.

This also gives us an idea for automated tuning of the intervals.  If the
interval is too short, results are biased to cold regions.  If the interval is
too long, results are biased to hot regions.  Maybe DAMON can moitor to which
direction the current snapshot is biased, and adjust the intervals.  I will
develop the idea more.

Future Plans
------------

Again, I admit that the real root cause of the issue is the poor interface and
lack of guides that makes correct tuning difficult, and the suboptimality of
DAMON's mechanisms.  We will continue working on advancing it in long term.

For easy use of 'age' information for zero 'nr_accesses' regions, DAMON is
already providing its Quotas feature with auto-tuning.  We will continue making
the auto-tuning more advanced, and adding new features for ease of uses.

One obvious hidden root cause is the absence of the guideline.  I will collect
more inputs and write an official document for this.  I actually thought about
writing the official document first, but this writing this mail took already
over two weeks.  So posting this mail first.

For interval setting, we are planning a sort of auto-tuning.  Like DAMOS quota
auto-tuning, users will be able to set more intuitive knobs (e.g., how much
diversity of regions they want) instead of directly setting the intervals.
Then, DAMON will automatically tune the intervals and other low level knobs.
This is in very early stage, so no specific design is made so far, and will
take long time.  Don't expect delivery of this in near future.  Use the tuning
guide for short term and/or ask prioritization of this project if needed.

In my humble opinion, 'Adaptive Regions Adjustment' mechanism is not a root
cause of the issue.  Nonetheless, it also has many rooms for improvement that
can make DAMON more lightweight and accurate.  And any DAMON accuracy
improvements would alleviate the hot page detection issue.  We plan to do this
together, and this is again a long term project that has no specific design
yet.  Nonetheless, we recently shared two simple short term features for this
(https://lore.kernel.org/20241027204910.155254-1-sj@kernel.org).  If you are
interested in implementing the short term features, please step up.
