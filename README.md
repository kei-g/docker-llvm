[![GitHub][github-repo-image]][github-repo-url] [![DockerHub][docker-image]][docker-url]

# docker-llvm  [![license][license-image]][license-url]

[`docker-llvm`][github-repo-url] - Debian/Ubuntu with the latest [llvm][llvm-url] installed.

This image depends on [![`snowstep/apt-fast`][dockerhub-apt-fast-image]][dockerhub-apt-fast-url]

## Naming Conventions

- `snowstep/clang`: Without flang runtime
- `snowstep/llvm`: With flang runtime

### Tags

Docker image tags for specific points in time use the format `<distro>-<version>-<yyyyMMddHHmmSS>`.
For each `<distro>-<version>` combination, the latest image is assigned two additional tags: `<distro>-<version>-latest` and the corresponding `<codename>` tag, as shown below.

| distro | version | codename |
| :---: | :---: | :---: |
| debian | 11 | bullseye |
| debian | 12 | bookworm |
| debian | 13 | trixie |
| ubuntu | 20.04 | focal |
| ubuntu | 22.04 | jammy |
| ubuntu | 24.04 | noble |

[docker-image]:https://img.shields.io/docker/v/snowstep/llvm?logo=docker
[docker-url]:https://hub.docker.com/r/snowstep/llvm
[dockerhub-apt-fast-image]:https://img.shields.io/docker/v/snowstep/apt-fast?label=snowstep%2Fapt-fast&logo=docker
[dockerhub-apt-fast-url]:https://hub.docker.com/r/snowstep/apt-fast
[github-repo-image]:https://img.shields.io/badge/github-kei--g%2Fdocker--llvm-brightgreen?logo=github
[github-repo-url]:https://github.com/kei-g/docker-llvm
[license-image]:https://img.shields.io/github/license/kei-g/docker-llvm
[license-url]:https://github.com/kei-g/docker-llvm/blob/main/LICENSE
[llvm-url]:https://llvm.org/
