#!/usr/bin/env bash
set -e
for codename in $(ls docker/linux | xargs); do
	repo=https://apt.llvm.org/$codename/dists/llvm-toolchain-$codename
	datetime=$(
		curl -s $repo/main/binary-amd64/Packages.gz \
			| gzip -cd \
			| grep -P '(?<=Version:).+$' -o \
			| sort -u \
			| grep -P '(?<=\~\+\+)[0-9]{14}' -o
	)
	matched=$(grep -PR ",$codename," /usr/share/distro-info/)
	filepath=${matched%%:*}
	filename=${filepath##*/}
	distro=${filename%.*}
	matched=${matched#*:}
	version=$(sed -r 's/(\s+[^,]*)?,.*$//' <<< $matched)
	cp docker/linux/$codename/Dockerfile ./
	docker build -t snowstep/llvm:$distro-$version-$datetime .
	rm -f Dockerfile
done
