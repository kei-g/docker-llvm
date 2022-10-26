FROM snowstep/apt-fast:focal

COPY assets/llvm-snapshot.gpg /etc/apt/trusted.gpg.d/

# Install the latest LLVM
RUN DEBIAN_FRONTEND=noninteractive \
  && distro=focal \
  && listpath=/etc/apt/sources.list.d/llvm-toolchain.list \
  && llvm=apt.llvm.org \
  && printf 'deb http://%s/%s/ llvm-toolchain-%s main\n' $llvm $distro $distro > $listpath \
  && printf 'deb-src http://%s/%s/ llvm-toolchain-%s main\n' $llvm $distro $distro >> $listpath \
  && apt-fast update \
  && apt-fast upgrade -yqq \
  && apt-fast install --no-install-recommends -y \
    clang \
    clang-format \
    clang-tidy \
    clangd \
    libunwind-dev \
    lld \
    lldb \
  && apt-fast clean \
  && rm -fr /var/lib/apt/lists/*
