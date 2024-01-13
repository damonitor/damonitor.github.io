#!/bin/bash

bindir=$(dirname "$0")

INDEX_FILE="$bindir/index.html"

echo "
<pre>

Performance Test Results
========================

Below are links to the past DAMON performance test results of damon/next tree
snapshots.  The source code for the performanced test is <a href=https://github.com/awslabs/damon-tests>available</a>.

</pre>
" > $INDEX_FILE

pushd "$bindir/after_merge"
results=$(find . -name 'index.html' | sort --reverse --version-sort)
popd

for f in $results
do
	echo "<a href=./after_merge/$f>$f</a><br>" >> $INDEX_FILE
done
