#!/bin/bash

CONTAINERS=$(docker ps --all --filter=status=exited --format="{{.ID}}" | xargs)
[ -z "$CONTAINERS" ] || docker rm "$CONTAINERS"

IMAGES=$(docker images --filter=dangling=true --format="{{.ID}}" | xargs)
[ -z "$IMAGES" ] || docker rmi "$IMAGES"

codename=bullseye
repo=https://apt.llvm.org/$codename/dists/llvm-toolchain-$codename
declare -A dep
declare -A ver
name=
while read -r line; do
	key=${line%%:\ *}
	value=${line#*:\ }
	case $key in
		Depends) dep[$name]=${value%%\ *};;
		Package) name=$value;;
		Version) ver[$name]=$(grep -E '[0-9]{14}' -o <<< $value | head -n1);;
	esac
done <<< $(curl -s $repo/main/binary-amd64/Packages.gz | gzip -cd)
MAJOR_VERSION=${dep[clang]#*-}

for dist in $(ls docker/linux | xargs); do
	docker_file="docker/linux/$dist/Dockerfile"
	base_image=$(head -n1 "$docker_file" | cut -d' ' -f2)
	cp "$docker_file" ./
	docker build --build-arg MAJOR_VERSION=$MAJOR_VERSION -t "snowstep/llvm:$dist" .
	rm -f Dockerfile
done
