#!/bin/bash

bindir=$(realpath $(dirname "$0"))
pushd "$bindir/.."
for f in $(ls ./)
do
	case "$f" in
	"blog_src" | "test" | "_index.html")
		continue
		;;
	*)
		git rm -f "$f"
		;;
	esac
done

"$bindir/build.sh"
git add *
git commit -as -m "build blog"
