+++
title = 'Major DAMON changes that merged for Linux 6.19'
date = 2025-12-05T17:13:59-08:00
draft = false
tags = ["pullrequest", "changes", "rc1", "6.19", "6.19-rc1"]
categories = ["rc1 changes"]
+++

A number of DAMON changes for Linux 6.19-rc1 has merged into the mainline as a
part of [MM pull
reqeust](https://lore.kernel.org/20251203212918.82f1c9d3947940aeae263878@linux-foundation.org)
for Linux 6.19-rc1, which was sent by Andrew Morton.  To list the changes here
again:

- mm/damon: allow DAMOS auto-tuned for per-memcg per-node
  memory usage
  ([patches](https://lore.kernel.org/20251017212706.183502-1-sj@kernel.org))
- mm/damon: fixes for address alignment issues in
  DAMON_LRU_SORT and DAMON_RECLAIM
  ([patches](https://lore.kernel.org/20251020130125.2875164-1-yanquanmin1@huawei.com))
- mm/damon: misc documentation fixups
  ([patches](https://lore.kernel.org/20251026182216.118200-1-sj@kernel.org))
- mm/damon: support pin-point targets removal
  ([patches](https://lore.kernel.org/20251023012535.69625-1-sj@kernel.org))
- mm/damon/tests: fix memory bugs in kunit tests
  ([patches](https://lore.kernel.org/20251101182021.74868-1-sj@kernel.org))
- mm/damon/tests: add more tests for online parameters commit
  ([patches](https://lore.kernel.org/20251111184415.141757-1-sj@kernel.org))
- mm/damon: misc cleanups
  ([patches](https://lore.kernel.org/20251112154114.66053-1-sj@kernel.org))
