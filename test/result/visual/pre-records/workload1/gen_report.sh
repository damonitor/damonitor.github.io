#!/bin/bash

for f in damon.data.nofilter.2025-05-01-06-36-20 damon.data.unmapped.2025-05-01-06-34-40 damon.data.active.2025-05-01-06-35-11 damon.data.hugepage.2025-05-01-07-04-52
do
	echo $f
	~/damo/damo report access --input "$f" --address 10.5G max --style recency-sz-hist
	echo
done

for f in damon.data.nofilter.2025-05-01-06-36-20 damon.data.unmapped.2025-05-01-06-34-40 damon.data.active.2025-05-01-06-35-11 damon.data.hugepage.2025-05-01-07-04-52
do
	echo $f
	~/damo/damo report access --input "$f" --address 10.5G max --style recency-percentiles
	echo
done
