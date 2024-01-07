#!/bin/bash

#!/bin/bash

INDEX_FILE='_index.html'

echo "
<pre>
Git Branches and Patchsets
==========================

Development of DAMON is mainly done in 'damon/next' branch of sj's Linux kernel
git tree (https://github.com/sjp38/linux).  The commits for DAMON on the
branch, which is based on a upstream kernel, are periodically rebased and
grouped into three different parts of DAMON, organized as normal patchsets, and
posted to LKML if necessary.

The three patchsets are:
- DAMON: The core monitoring part,
- DAMOS: DAMON-based Operation Schemes, implemented on DAMON, and
- CDAMON: Configurable DAMON, implemented on DAMOS.

For each posting of any patchset, 'damon/master' is updated to point the latest
commit of 'damon/next', and 'damon/next' continues development.


Documents
=========

This site used to host documents for DAMON before.  Now, it's deprecated.
Please use https://damonitor.github.io, https://docs.kernel.org/next and/or
https://docs.kernel.org/latest instead.


Test Results
============

- <a href=./test/result/perf/index.html>Performance</a>
- <a href=./test/result/visual/index.html>Monitoring ResultsVisaulization</a>
</pre>
" > "$INDEX_FILE"
