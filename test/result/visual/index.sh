#!/bin/bash

INDEX_FILE='index.html'

echo "
<pre>

Monitoring Results Visualization
================================

Below are links to the past DAMON monitoring results visualizations of
damon/next tree snapshots.  The monitoring results are generated as a part of
the results of the performance test[1].

[1] <a href=https://github.com/awslabs/damon-tests/tree/next/perf>DAMON performance tests suite</a>

</pre>
" > $INDEX_FILE

results=$(find . -name 'index.html' | sort --reverse --version-sort)

for f in $results
do
	echo "<a href=$f>$f</a><br>" >> $INDEX_FILE
done
