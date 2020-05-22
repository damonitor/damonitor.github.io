#!/bin/bash

for f in `find . -name '*.html' | sort`
do
	echo "<a href=$f>$f</a><br>"
done
