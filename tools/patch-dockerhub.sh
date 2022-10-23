#!/bin/bash

repo="$1"
[[ -z "$repo" ]] && {
	echo "$0 repository [short-description] ..." >&2
	exit 1
}

readme=$(< README.md)
[[ -z "$readme" ]] && {
	echo "$0 README.md is empty" >&2
	exit 1
}

desc=$(echo "$2" | { read line && echo "$line"; })
fulldesc="${readme//$'\n'/$'\\n'}"
hub=https://hub.docker.com/v2

token=$(curl \
	-H "Content-type: application/json" \
	-X POST \
	-d "{\"username\":\"$DOCKERHUB_USERNAME\",\"password\":\"$DOCKERHUB_PASSWORD\"}" \
	-s \
	$hub/users/login \
| jq -cr .token)

curl \
	-H "Authorization: JWT $token" \
	-H "Content-type: application/json" \
	-L \
	-X PATCH \
	-d "{\"description\":\"$desc\",\"full_description\":\"$fulldesc\"}" \
	-s \
	$hub/repositories/$DOCKERHUB_USERNAME/$repo/
