FROM snowstep/apt-fast:bullseye

ARG MAJOR_VERSION

# Install the latest LLVM
RUN DEBIAN_FRONTEND=noninteractive \
  && apt-fast update \
  && apt-fast upgrade -yqq \
  && apt-fast install --no-install-recommends -y \
    gnupg \
  && keyname=llvm-snapshot.gpg \
  && keydir=/etc/apt/keyrings \
  && llvm=apt.llvm.org \
  && aria2c https://$llvm/$keyname.key \
  && gpg --import $keyname.key \
  && rm -f $keyname \
  && [ -d $keydir ] \
    || mkdir -pv $keydir \
  && gpg --export > /etc/apt/keyrings/$keyname \
  && distro=bullseye \
  && for what in deb deb-src; do \
      printf \
        '%s [signed-by=%s] http://%s/%s/ llvm-toolchain-%s main\n' \
          $what \
          $keydir/$keyname \
          $llvm \
          $distro \
          $distro; \
    done > /etc/apt/sources.list.d/llvm-toolchain.list \
  && apt-fast update \
  && apt-fast install --no-install-recommends -y \
    clang \
    clang-format \
    clang-tidy \
    clangd \
    libc++-dev \
    libc++abi-dev \
    libunwind-${MAJOR_VERSION:-17} \
    lld \
    lldb \
  && apt-fast clean \
  && rm -fr /var/lib/apt/lists/*
