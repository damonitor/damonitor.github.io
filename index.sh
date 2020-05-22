#!/bin/bash

#!/bin/bash

INDEX_FILE='_index.html'

echo '<p>documentations</p>' > $INDEX_FILE

for f in `find doc -maxdepth 3 -name 'index.html' | sort`
do
	echo "<a href=$f>$f</a><br>" >> $INDEX_FILE
done

echo '<br><br><p>test results</p>' >> $INDEX_FILE

for f in `find test -name 'index.html' | sort`
do
	echo "<a href=$f>$f</a><br>" >> $INDEX_FILE
done
