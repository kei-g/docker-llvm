#!/usr/bin/env bash
set -e
image=snowstep/llvm
for key in debian:bookworm debian:bullseye ubuntu:focal ubuntu:jammy ubuntu:noble; do
	distro=${key%:*}
	codename=${key#*:}
	version=$(
		grep -P ",$codename," \
			< /usr/share/distro-info/$distro.csv \
			| sed -r 's/(\s+[^,]*)?,.*$//'
	)
	src=$image:$codename
	tag=$distro-$version
	docker pull --quiet $src > /dev/null
	datetime=$(
		docker run --interactive --rm --tty $src clang --version \
			| grep version \
			| grep -E '[0-9]{14}' -o \
			| head -n1
	)
	for suffix in $datetime latest; do
		dest=$image:$tag-$suffix
		docker tag $src $dest
		docker push $dest
	done
done
