# docker command usage

- `--platform` seems useful for multi-platform
- Probably, we can regard the expression 'platform' as having the same meaning as 'architecture'
- This article, [docker-buildxとmulti-platform build周りについてまとめ](https://zenn.dev/bells17/articles/docker-buildx), from 4 years ago might be helpful

## pull

```shell-session
$ docker pull --help
Usage:  docker pull [OPTIONS] NAME[:TAG|@DIGEST]

Download an image from a registry

Aliases:
  docker image pull, docker pull

Options:
  -a, --all-tags          Download all tagged images in the repository
      --platform string   Set platform if server is multi-platform capable
  -q, --quiet             Suppress verbose output
```

## build

```shell-session
$ docker build --help
Usage:  docker buildx build [OPTIONS] PATH | URL | -

Start a build

Aliases:
  docker build, docker builder build, docker image build, docker buildx b

Options:
      --add-host strings              Add a custom host-to-IP mapping (format: "host:ip")
      --allow stringArray             Allow extra privileged entitlement (e.g., "network.host",
                                      "security.insecure", "device", "buildx.local.delete")
      --annotation stringArray        Add annotation to the image
      --attest stringArray            Attestation parameters (format: "type=sbom,generator=image")
      --build-arg stringArray         Set build-time variables
      --build-context stringArray     Additional build contexts (e.g., name=path)
      --builder string                Override the configured builder instance (default "default")
      --cache-from stringArray        External cache sources (e.g., "user/app:cache", "type=local,src=path/to/dir")
      --cache-to stringArray          Cache export destinations (e.g., "user/app:cache",
                                      "type=local,dest=path/to/dir")
      --call string                   Set method for evaluating build ("check", "outline", "targets") (default
                                      "build")
      --cgroup-parent string          Set the parent cgroup for the "RUN" instructions during build
      --check                         Shorthand for "--call=check"
  -D, --debug                         Enable debug logging
  -f, --file string                   Name of the Dockerfile (default: "PATH/Dockerfile")
      --iidfile string                Write the image ID to a file
      --label stringArray             Set metadata for an image
      --load                          Shorthand for "--output=type=docker"
      --metadata-file string          Write build result metadata to a file
      --network string                Set the networking mode for the "RUN" instructions during build (default
                                      "default")
      --no-cache                      Do not use cache when building the image
      --no-cache-filter stringArray   Do not cache specified stages
  -o, --output stringArray            Output destination (format: "type=local,dest=path")
      --platform stringArray          Set target platform for build
      --policy stringArray            Policy configuration (format:
                                      "filename=path[,filename=path][,reset=true|false][,disabled=true|false][,strict=true|false][,log-level=level]")
      --progress string               Set type of progress output ("auto", "none",  "plain", "quiet", "rawjson",
                                      "tty"). Use plain to show container output (default "auto")
      --provenance string             Shorthand for "--attest=type=provenance"
      --pull                          Always attempt to pull all referenced images
      --push                          Shorthand for "--output=type=registry,unpack=false"
  -q, --quiet                         Suppress the build output and print image ID on success
      --resource stringArray          Resource limits for build containers (format: "memory=2g", "cpu-quota=50000")
      --sbom string                   Shorthand for "--attest=type=sbom"
      --secret stringArray            Secret to expose to the build (format: "id=mysecret[,src=/local/secret]")
      --shm-size bytes                Shared memory size for build containers
      --ssh stringArray               SSH agent socket or keys to expose to the build (format:
                                      "default|<id>[=<socket>|<key>[,<key>]]")
  -t, --tag stringArray               Image identifier (format: "[registry/]repository[:tag]")
      --target string                 Set the target build stage to build
      --ulimit ulimit                 Ulimit options (default [])
```

## push

```shell-session
$ docker push --help
Usage:  docker push [OPTIONS] NAME[:TAG]

Upload an image to a registry

Aliases:
  docker image push, docker push

Options:
  -a, --all-tags          Push all tags of an image to the repository
      --platform string   Push a platform-specific manifest as a single-platform image to the registry.
                          Image index won't be pushed, meaning that other manifests, including attestations won't
                          be preserved.
                          'os[/arch[/variant]]': Explicit platform (eg. linux/amd64)
  -q, --quiet             Suppress verbose output
```
