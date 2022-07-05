#!/bin/bash

for doc in *
do
	if [ ! -d $doc ]
	then
		continue
	fi
	cd $doc

	for dir in *
	do
		if [ ! -d "$dir" ] || [ "$dir" = "mm" ] ||
			[ "$dir" = "admin-guide" ] || [ "$dir" = "_static" ] ||
			[ "$dir" = "_images" ]
		then
			continue
		fi

		echo "$dir"
		rm -fr "$dir"
	done

	cd ".doctrees"
	for dir in *
	do
		if [ ! -d "$dir" ] || [ "$dir" = "mm" ] ||
			[ "$dir" = "admin-guide" ] || [ "$dir" = "_static" ]
		then
			continue
		fi

		echo "$dir"
		rm -fr "$dir"
	done

	cd ../..
done
