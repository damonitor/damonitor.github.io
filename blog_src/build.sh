#!/bin/bash

bindir=$(dirname "$0")
hugo_site_dir="$bindir/hugo_site"

if [ ! -d "$hugo_site_dir" ]
then
	hugo new site "$hugo_site_dir" --format yaml
else
	rm -fr "$hugo_site_dir/content"
	rm -fr "$hugo_site_dir/static"
	rm -fr "$hugo_site_dir/assets"
	rm -fr "$hugo_site_dir/public"
fi

cp "$bindir/hugo.yaml" "$hugo_site_dir/"
cp -R "$bindir/content" "$bindir/static" "$bindir/assets" "$hugo_site_dir/"

if [ ! -d "$hugo_site_dir/themes/PaperMod" ]
then
	git clone https://github.com/adityatelange/hugo-PaperMod \
		"$hugo_site_dir/themes/PaperMod"
	git -C "$hugo_site_dir/themes/PaperMod" checkout v8.0
fi

pushd "$hugo_site_dir"
hugo
# overwrite index page with DAMON intro post
cp public/posts/damon/index.html public/
popd

cp -R "$hugo_site_dir/public"/* "$bindir/../"
