#!/bin/sh

CONTAINERS=$(docker ps --all --filter=status=exited --format="{{.ID}}" | xargs)
[ -z "$CONTAINERS" ] || docker rm "$CONTAINERS"

IMAGES=$(docker images --filter=dangling=true --format="{{.ID}}" | xargs)
[ -z "$IMAGES" ] || docker rmi "$IMAGES"

for dist in $(ls docker/linux | xargs); do
	docker_file="docker/linux/$dist/Dockerfile"
	base_image=$(head -n1 "$docker_file" | cut -d' ' -f2)
	cp "$docker_file" ./
	docker build -t "snowstep/llvm:$dist" .
	rm -f Dockerfile
done
