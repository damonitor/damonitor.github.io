+++
title = 'damo supports recording data access patterns on Android'
date = 2026-01-10T15:02:17-08:00
draft = false
+++

DAMON exports data access pattern of the system and workload to the user space
in multiple ways.  Tracepoint is one such way DAMON is using to provide the
full access pattern monitoring results in real time.

DAMON user-space tool ([damo](https://github.com/damonitor/damo)) collects and
visualizes the information in a handy and human-friendly way.  For the
collection, `damo` was internally using `perf`.  On some environments including
Android, `perf` is not available.  This made use of DAMON on Android and
similar platforms difficult.  Kernel version dependency of `perf` was also one
problem of poor `damo` user experience.  Some people had to make their
downstream hacks on `damo`, or add some
[workarounds](https://github.com/damonitor/damo/commit/855ae0188cb37809).

On 2025-12-29, `damo` v3.0.9 is released.  The version drops the `perf`
dependency by alternatively using `trace-cmd` if available.  Because
`trace-cmd` is more universal than `perf` and has less dependency to kernel
versions, users on Android and a few restricted environments can more easily
use DAMON.
