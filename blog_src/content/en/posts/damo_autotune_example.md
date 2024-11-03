---

title: "Auto-tuning DAMOS using `damo`"
subtitle: ""
summary: ""
authors: []
tags: ["damo", "auto-tune", "example"]
categories: ["example"]
date: Sun Nov  3 01:02:47 PM PST 2024
lastmod: Sun Nov  3 01:02:47 PM PST 2024
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

Starting from Linux v6.9, DAMON provides DAMOS quota auto-tuning.  It allows
users to set a target metric and value.  Then, DAMOS will adjust its
aggressiveness (effective quota) to achieve the target.

`damo` users can also use the feature using `--damos_quota_goal` option.  But
apparently the usage is not well documented.  Maybe it should be documented
somewhere on [USAGE.md](https://github.com/damonitor/damo/blob/next/USAGE.md)
of `damo`, but I cannot find a good splot for now.  So I'm explaining the usage
in more informal way on this post.  Hopefully this will help users while I make
more formal writeup on the
[USAGE.md](https://github.com/damonitor/damo/blob/next/USAGE.md) file.

First, please read the DAMON design
[document](https://www.kernel.org/doc/html/latest/mm/damon/design.html#aim-oriented-feedback-driven-auto-tuning)
for the feature.  Below sections will assume you know the concepts.

DAMOS self-feedback-driven auto-tuning
--------------------------------------

The usage for self-feedback driven auto-tuning is simple.  You can just set the
target metric and the value.  Currently, only `some_mem_psi_us` metric is
supported for this purpose.  For example, below command asks DAMON to page out
pages of `workload`, aiming 500us of [some memory pressure stall
time](https://docs.kernel.org/accounting/psi.html) per second.

    # damo start $(pidof workload) --damos_action pageout \
            --damos_quota_interval 1s \
            --damos_quota_goal some_mem_psi_us 500us

If the memory pressure stall rate of the system is lower than the target (500
microsecond per second), DAMOS will pageout more pages (coldest one first) per
second.  If the memory pressure stall rate is higher than the target, DAMOS
will pageout less pages (coldest one first) per second.

### Online-updating target

Depending on the cases, you might realize the 500us per second memory pressure
was not the right target you want.  You can update it while DAMON is running
online, using `damo tune` command.  For example,

    # damo tune $(pidof workload) --damos_action pageout \
            --damos_quota_interval 1s \
            --damos_quota_goal some_mem_psi_us 750us

### Reading auto-tuning resulting aggressiveness

You may want to know so how aggressively DAMOS is working under the target.
For this purpose, you can use `effective_bytes` DAMON sysfs
[file](https://www.kernel.org/doc/html/latest/admin-guide/mm/damon/usage.html#schemes-n-quotas).
You can read the file via `damo report damon`, from `effective_sz_bytes` field.
It must be intuitive when you use `json` format.  For example,

    $ sudo damo report damon --json
    [...]
                    "schemes": [
    [...]
                            "quotas": {
    [...]
                                "reset_interval_ms": "1 s",
    [...]
                                "effective_sz_bytes": "256 B",
    [...]

On the above example output, DAMON has set the effective size quota as 256
Bytes per second, as a result of the auto-tuning.

If you use the human-friendly output, the value is on the first line for
quotas.  For example,

    $ sudo damo report damon
    kdamond 0
    [...]
                quotas
                    0 ns / 0 B / 8 B per 1 s
                    goal 0: metric some_mem_psi_us target 500 current 0
                    priority: sz 0.1 %, nr_accesses 0.1 %, age 0.1 %
    [...]

The four numbers on the line after `quotas` line show time quota, size quota,
the effective size quota, and quotas reset interval.  So in this example, DAMON
has set the effective size quota as 8 Bytes per second.

User feedback-driven auto-tuning
--------------------------------

The usage for user feedback driven auto-tuning is similar to system
self-feedback.  Major difference is that the user should provide the feedback
whenever the feedback score is changed.  You can use `damo tune`.

For example, let's say your workload writes its performance score (e.g., number
of processed queries per second) to `score` file per second.  And you want to
do proactive reclaim of the workload, aiming 10,000 of the `score`.

You may first start DAMON.

    # damo start $(pidof workload) --damos_action pageout \
            --damos_quota_interval 1s \
            --damos_quota_goal user_input 10000 $(cat score)

Unlike self-feedback case, `--damos_quota_goal` option receives three arguments
when the `metric` argument is `user_input`.  The additional argument is the
current value of the user metric.  In this example, we just provide the current
content of `score` file.

Now, DAMON will start proactive reclamation.  You should periodically read the
real score and give update to DAMON when needed.  This could be done like
below.

    while true:
    do
    	now_score=$(cat score)
    	if [ "$last_score" -eq 0 ] || [ "$now_score" -ne "$last_score" ]
    	then
    		# damo tune $(pidof workload) --damos_action pageout \
    				--damos_quota_interval 1s \
    				--damos_quota_goal user_input 10000 $(cat score)
    		last_score=now_score
    	fi
    	sleep 1
    done

The above example shell script will read the workload's score every second, and
update the feed score for DAMON if some changes are made.  If the feed score is
same, you don't need to give update to DAMON.
