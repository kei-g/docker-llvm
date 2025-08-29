#!/usr/bin/env bash
set -e
find /usr/bin \
		\( \
			-name clang\*-${MAJOR_VERSION:-22} \
			-o -name flang\*-${MAJOR_VERSION:-22} \
			-o -name lld\*-${MAJOR_VERSION:-22} \
			-o -name llvm\*-${MAJOR_VERSION:-22} \
		\) \
	-exec bash -c '\
i=1; \
while [[ $i -lt $# ]]; do \
	eval name=\${$i##*/}; \
	eval name=\${name%\-*}; \
	ln -fs $name-${MAJOR_VERSION:-22} /usr/bin/$name; \
	i=$((i + 1)); \
done \
' -- {} +
