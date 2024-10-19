#!/bin/bash

set -e

bindir=$(dirname "$0")
hugo_site_dir="$bindir/hugo_site"

if [ ! -d "$hugo_site_dir" ]
then
	hugo new site "$hugo_site_dir"
fi

cp "$bindir/hugo.toml" "$hugo_site_dir/"
cp -R "$bindir/content" "$bindir/static" "$bindir/assets" "$hugo_site_dir/"

if [ ! -d "$hugo_site_dir/themes/hugo-blog-awesome" ]
then
	git clone https://github.com/hugo-sid/hugo-blog-awesome.git \
		"$hugo_site_dir/themes/hugo-blog-awesome"
fi
pushd "$hugo_site_dir"
hugo
# overwrite index page with DAMON intro post
cp public/posts/damon/index.html public/
popd

cp -R "$hugo_site_dir/public"/* "$bindir/../"
