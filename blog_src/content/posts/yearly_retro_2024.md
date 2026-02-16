+++
title = 'DAMON Yearly Retrospect (2024)'
date = 2026-02-16T13:23:14-08:00
draft = true
tags = ['statistic', 'yearly_retro']
category = 'yearly_retro'
+++

This is also
[posted](https://lore.kernel.org/20260216210625.68098-1-sj@kernel.org) to DAMON
mailing list.

---

After DAMON has upstreamed in 2021, I shared yearly retrospects for 2022 [1]
and 2023 [2].  And somehow I forgot to do that for 2024 and 2025.  Let me share
the retrospect of 2024, before my memory goes away.

Summary
=======

2024 was a year that DAMON has been more publicly and widely adopted.  AWS
published their usage of DAMON as a VLDB paper.  SK hynix developed and
upstreamed DAMON features for memory tiering.  Debian kernel team has enabled
DAMON build config on their kernels.  Citations of DAMON papers have also
increased from 10 in 2023 to 17 in 2024.

DAMON's status and future plans have presented and discussed on multiple
conferences, including OSSummit NA, LSF/MM/BPF, OSSummit EU, and LPC.

Number of development participants and commits have reduced compared to 2023,
though.  Hopefully that reflects how DAMON continues being stabilized.

Events
======

In January, Linux 6.8-rc1 has released, with feedback-driven DAMOS
aggressiveness auto-tuning [3] feature.  The feature allows users simply feed
DAMOS rewards for current aggressiveness, and DAMOS can automatically tune the
aggressiveness to convince the user.

In March, Linux 6.9-rc1 has released, with DAMOS aggressiveness self-tuning [4]
feature.  It makes the aggressiveness auto-tuning can work itself, without
user's feedback.

In April, DAMON was presented [4] at OSSummit North America.  The presentation
was focusing on the feedback-driven DAMOS auto/self-tuning.

In May, DAMON updates and future plans were discussed [5] at LSF/MM/BPF.  The
plan was including DAMON-based memory tiering and holistic access-aware memory
autoscaling for cloud providers.

In July, Linux 6.11-rc1 has released, with DAMON changes [6] for CXL memory
tiering.  The change is developed by SK hynix for their heterogeneous memory
software development kit.

In July, AWS published a paper [7] introducing their DAMON usage as a part of
it, at VLDB.  The paper introduces AWS Aurora Serverless V2, which uses DAMON
as its core part of memory auto-scaling.  Specifically, they use DAMON for
proactively reclaiming cold pages inside guests.

In August, DAMON project repositories on GitHub has moved [8] from awslabs
organization to damonitor organization.

In September, DAMON use cases were presented [9] at OSSummit EU.  The talk was
mainly covering DAMON usages from AWS and SK hynix.  Honggyu Kim, an SK hynix
engineer who developed DAMON-based memory tiering, has shared their use case on
the talk.

In September, DAMON long term development plan was presented [10] at LPC Kernel
Memory Management Micro-conference.  The plan was about how DAMON will be
flexible but also just works.

In September, Debian enabled [11] DAMON build configuration on their kernels.

In December, DAMON monitoring intervals tuning guide has published [12].  The
guide includes the monitoring and tuning results on real world server
workloads.

Features
========

In 2024, a few new DAMON features have landed on the mainline.  Among those,
below two features are noticeable to  me.

DAMOS aggressiveness auto-tuning feature have landed in two parts.  The first
part [3] on v6.8, and the second part [4] on v6.9.  This feature makes access
aware system operations nearly self-driving.

DAMON changes for CXL memory tiering has developed by SK hynix and landed [6]
on v6.11.  The feature allows users to setup DAMOS for migrating hot and cold
pages for appropriate tiers.

Statistics
==========

In 2024, 20 people made 157 commits for DAMON on the mainline.  I got the
numbers with name of the contributors using my script [13] as below.

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --since 2024-01-01 --until 2024-12-31 --linux_subsystems DAMON
    1. SeongJae Park <sj@kernel.org>: 133 commits
    2. Zheng Yejian <zhengyejian@huaweicloud.com>: 2 commits
    3. Anna-Maria Behnsen <anna-maria@linutronix.de>: 2 commits
    4. Honggyu Kim <honggyu.kim@sk.com>: 2 commits
    5. Hyeongtak Ji <hyeongtak.ji@sk.com>: 2 commits
    6. Barry Song <v-songbaohua@oppo.com>: 2 commits
    7. Akinobu Mita <akinobu.mita@gmail.com>: 1 commits
    8. Maximilian Heyne <mheyne@amazon.de>: 1 commits
    9. Andrew Paniakin <apanyaki@amazon.com>: 1 commits
    10. James Houghton <jthoughton@google.com>: 1 commits
    11. Ba Jing <bajing@cmss.chinamobile.com>: 1 commits
    12. Leo Stone <leocstone@gmail.com>: 1 commits
    13. Jinjie Ruan <ruanjinjie@huawei.com>: 1 commits
    14. Diederik de Haas <didi.debian@cknow.org>: 1 commits
    15. Liam R. Howlett <Liam.Howlett@oracle.com>: 1 commits
    16. Peng Hao <flyingpeng@tencent.com>: 1 commits
    17. Christophe Leroy <christophe.leroy@csgroup.eu>: 1 commits
    18. Alex Rusuf <yorha.op@gmail.com>: 1 commits
    19. Javier Carrasco <javier.carrasco.cruz@gmail.com>: 1 commits
    20. Vincenzo Mezzela <vincenzo.mezzela@gmail.com>: 1 commits
    # 20 authors, 157 commits in total

Huge appreciation to all the developers.  It was a grateful year to work with
you.

The last line of the output for 2023 was like below:

    $ ./lazybox/version_control/authors.py ./linux --skip_merge_commits \
            --since 2023-01-01 --until 2023-12-31 --linux_subsystems DAMON
    [...]
    # 25 authors, 180 commits in total

So, both the number of developers (25 -> 20) and commits (180 -> 157) have
reduced.  Hopefully this means that DAMON is becoming more stabilized and
reliable.

DAMON User-space Tool
---------------------

DAMON user-space tool is also an important part of DAMON project.  In 2024,
eight people made 1,031 commits for DAMON user-space tool.  The list of the
developers are as below:

    $ ./lazybox/version_control/authors.py ./damo --skip_merge_commits \
            --since 2024-01-01 --until 2024-12-31
    1. SeongJae Park <sj@kernel.org>: 753 commits
    2. SeongJae Park <sj38.park@gmail.com>: 264 commits
    3. Mithun Veluri <velurimithun38@gmail.com>: 4 commits
    4. Honggyu Kim <honggyu.kim@sk.com>: 3 commits
    5. m8 <umusasadik@gmail.com>: 2 commits
    6. Yunjeong Mun <yunjeong.mun@sk.com>: 2 commits
    7. Akinobu Mita <akinobu.mita@gmail.com>: 1 commits
    8. Alex Rusuf <yorha.op@gmail.com>: 1 commits
    9. Piyush Thange <pthange19@gmail.com>: 1 commits
    # 9 authors, 1031 commits in total

Note that I was counted twice due to different email address usages.

The tool's output for 2023 was like below:

    $ ./lazybox/version_control/authors.py ./damo --skip_merge_commits \
            --since 2023-01-01 --until 2023-12-31
    1. SeongJae Park <sj38.park@gmail.com>: 1793 commits
    2. SeongJae Park <sj@kernel.org>: 58 commits
    3. Honggyu Kim <honggyu.kp@gmail.com>: 8 commits
    4. sjpark <sjpark@amazon.com>: 5 commits
    5. Michel Alexandre Salim <salimma@fedoraproject.org>: 4 commits
    6. SeongJae Park <sjpark@amazon.com>: 3 commits
    7. Honggyu Kim <honggyu.kim@sk.com>: 2 commits
    8. Andrew Paniakin <apanyaki@amazon.com>: 1 commits
    9. fdu <1050329+fdu@users.noreply.github.com>: 1 commits
    10. Puranjay Mohan <pjy@amazon.com>: 1 commits
    11. Puranjay Mohan <pjy@amazon.de>: 1 commits
    # 11 authors, 1877 commits in total

Note that I was counted four times, and Puranjay was counted twice.  So, seven
people made 1,877 commits for DAMON user-space tool in 2023.  The number of
contributors have increased, while the number of total commits have quite
reduced.  The reduction of the commits was mainly from my side.  I was making
~1,800 commits in 2023, but only ~1,000 commits in 2024.  I actually feel DAMON
user-space tool is being more stabilized.  I also spent quite amount of my time
that I used to use for DAMON user-space tool for another tool, hkml [16].

Paper Citations
---------------

Yet another interesting statistics about the number of DAMON paper citations.
I published two academic papers introducing DAMON in 2019 [14] and 2022 [15].

The number of citations for the two papers have quite increased, as below.

2019-published paper: 6 (2023) -> 10 (2024)
2022-published paper: 4 (2023) -> 7  (2024)

Conclusion
==========

So, 2024 was a year DAMON has more publicly and widely adopted, and extended
itself for more use cases.

References
==========

[1] 2022 retrospect: https://lore.kernel.org/20221229171209.162356-1-sj@kernel.org/<br>
[2] 2023 retrospect: https://lore.kernel.org/20231231222250.140364-1-sj@kernel.org/<br>
[3] DAMOS auto-tune: https://git.kernel.org/torvalds/c/9294a037c01564786<br>
[4] DAMOS self-tune: https://git.kernel.org/torvalds/c/78f2f60377ee43b7f<br>
[5] OSSummit NA talk: https://ossna2024.sched.com/event/1aBOg<br>
[6] DAMOS memory-tiering: https://git.kernel.org/torvalds/c/a00ce85af2a1be49<br>
[7] VLDB AWS paper: https://www.amazon.science/publications/resource-management-in-aurora-serverless<br>
[8] awslabs to damonitor GitHub repos move: https://lore.kernel.org/all/20240813232158.83903-1-sj@kernel.org/<br>
[9] OSSummit EU talk: https://osseu2024.sched.com/event/1ej2S<br>
[10] LPC talk: https://lpc.events/event/18/contributions/1768/<br>
[11] Debian DAMON enablement: https://salsa.debian.org/kernel-team/linux/-/merge_requests/1172<br>
[12] DAMON tuning guide: https://lore.kernel.org/all/20241202175459.2005526-1-sj@kernel.org/<br>
[13] https://github.com/sjp38/lazybox/blob/master/version_control/authors.py<br>
[14] 2019 DAMON paper: https://dl.acm.org/doi/abs/10.1145/3366626.3368125<br>
[15] 2022 DAMON paper: https://dl.acm.org/doi/abs/10.1145/3502181.3531466<br>
[16] hkml: https://github.com/sjp38/hackermail<br>
