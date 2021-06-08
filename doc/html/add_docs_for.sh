#!/bin/bash

if [ $# -ne 6 ]
then
	echo "Usage: $0 <linux repo> <version> <damon commit> <damos commit> <paddr commit> <damon_reclaim commit>"
	exit 1
fi

linux_repo=$1
patch_version=$2
damon_hashid=$3
damos_hashid=$4
paddr_hashid=$5
darc_hashid=$6

gen_doc() {
	repo=$1
	hashid=$2
	pushd "$repo"
	sphinx_activate="sphinx_2.4.4/bin/activate"
	if [ ! -e $sphinx_activate ]
	then
		echo "$sphinx_activate not found"
		exit 1
	fi

	source "$sphinx_activate"
	git checkout "$hashid"
	if ! make htmldocs
	then
		echo "htmldocs gen failed"
		exit 1
	fi
	popd
}

copy_doc() {
	generated=$1
	patch_version=$2
	suffix=$3

	cp -R "$generated" "next$suffix"
	cp -R "$generated" "latest$suffix"
	cp -R "$generated" "$patch_version$suffix"
}

gen_copy_doc() {
	linux_repo=$1
	hashid=$2
	patch_version=$3
	suffix=$4

	gen_doc "$linux_repo" "$hashid"
	copy_doc "$linux_repo/Documentation/output" "$patch_version" "$suffix"
}

git rm -rq next*
git rm -rq latest*

gen_copy_doc "$linux_repo" "$damon_hashid" "$patch_version" "-damon"
gen_copy_doc "$linux_repo" "$damos_hashid" "$patch_version" "-damos"
gen_copy_doc "$linux_repo" "$paddr_hashid" "$patch_version" "-paddr"
gen_copy_doc "$linux_repo" "$darc_hashid" "$patch_version" ""

./cleanup.sh
git add next*
git add latest*
git add "$patch_version"*

echo "Check changes and git-commit"
