FROM snowstep/apt-fast:bullseye

# Install the latest LLVM
RUN DEBIAN_FRONTEND=noninteractive \
  && apt-fast update \
  && apt-fast upgrade -yqq \
  && apt-fast install --no-install-recommends -y \
    gnupg \
  && keyname=llvm-snapshot.gpg.key \
  && keypath=/usr/share/keyrings/llvm-snapshot-keyring.gpg \
  && llvm=apt.llvm.org \
  && aria2c -d /tmp https://$llvm/$keyname \
  && gpg --import --keyring=$keypath --no-default-keyring /tmp/$keyname \
  && rm -f /tmp/$keyname \
  && distro=bullseye \
  && printf 'deb [signed-by=%s] http://%s/%s/ llvm-toolchain-%s main\n' $keypath $llvm $distro $distro > /etc/apt/sources.list.d/llvm-toolchain.list \
  && apt-fast update \
  && apt-fast install --no-install-recommends -y \
    clang \
    clangd \
    libc++-dev \
    libc++abi-dev \
    lld \
    lldb \
  && apt-fast clean \
  && rm -fr /var/lib/apt/lists/*
