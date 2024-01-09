#!/bin/bash

# Copy daily perf test results report here

if [ $# -ne 1 ]
then
	echo "Usage: $0 <daily report directory path>"
	exit 1
fi

bindir=$(dirname "$0")
daily_reports=$1

# The daily report directory contains report in
# $daily_reports/<kernel version>/<timestamp>/report
for report_dir in "$daily_reports"/*/*/report
do
	version_timestamp=$(echo "$report_dir" | \
		awk -F"/" '{print $(NF - 2)"/"$(NF - 1)}')
	dir_to_copy="$bindir/after_merge/$version_timestamp"
	if [ -d "$dir_to_copy" ]
	then
		continue
	fi

	echo "Add $version_timestamp report"
	mkdir -p "$dir_to_copy"
	cp -R "$report_dir" "$dir_to_copy"
	git add "$dir_to_copy"
	git commit -m "test/results/perf: Add $version_timestamp report"
	"$bindir/index.sh"
	git add index.html
	git commit -m "test/results/perf: Update index.html"
done
