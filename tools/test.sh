#!/usr/bin/env bash
set -e
for dist in $(ls docker/linux | xargs); do
	echo "[$dist]"
	dir=$(mktemp -d)
	docker run --rm --tty --volume $dir:/mnt snowstep/llvm:$dist flang -o /mnt/hello -v << _EOT_
PROGRAM hello
    DO 10, i=1, 10
    PRINT *,'Hello World'
10  CONTINUE
    STOP
END
_EOT_
	[[ -x $dir/hello ]] && {
		$dir/hello
		sudo rm -fv $dir/hello
	}
	rm -frv $dir
done
