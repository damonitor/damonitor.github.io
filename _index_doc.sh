#!/bin/bash

for f in `find doc -maxdepth 3 -name 'index.html' | sort`
do
	echo "<a href=$f>$f</a><br>"
done
