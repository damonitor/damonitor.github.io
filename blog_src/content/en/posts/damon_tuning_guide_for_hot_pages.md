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
