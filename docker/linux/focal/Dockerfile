FROM snowstep/apt-fast:focal

COPY assets/llvm-snapshot.gpg /etc/apt/trusted.gpg.d/

# Install the latest LLVM
RUN DEBIAN_FRONTEND=noninteractive \
  && distro=focal \
  && listpath=/etc/apt/sources.list.d/llvm-toolchain.list \
  && llvm=apt.llvm.org \
  && for what in deb deb-src; do \
      echo $what http://$llvm/$distro/ llvm-toolchain-$distro main; \
    done > $listpath \
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
