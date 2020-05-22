#!/bin/bash

for f in `find test -name '*.html' | sort`
do
	echo "<a href=$f>$f</a><br>"
done
