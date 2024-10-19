#!/bin/bash

set -e

if [ ! -d hugo_site ]
then
	hugo new site hugo_site
fi

cp hugo.toml ./hugo_site/
cp -R ./content ./static ./assets ./hugo_site/

pushd hugo_site
if [ ! -d themes/hugo-blog-awesome ]
then
	git clone https://github.com/hugo-sid/hugo-blog-awesome.git themes/hugo-blog-awesome
fi
hugo
# overwrite index page with DAMON intro post
cp public/posts/damon/index.html public/
popd

bindir=$(dirname "$0")
cp -R "$bindir/hugo_site/public"/* "$bindir/../"
