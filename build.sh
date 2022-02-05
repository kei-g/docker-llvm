#!/bin/sh

CONTAINERS=$(docker ps --all --filter=status=exited --format="{{.ID}}" | xargs)
[ -z "$CONTAINERS" ] || docker rm "$CONTAINERS"

IMAGES=$(docker images --filter=dangling=true --format="{{.ID}}" | xargs)
[ -z "$IMAGES" ] || docker rmi "$IMAGES"

docker build -t snowstep/llvm .
