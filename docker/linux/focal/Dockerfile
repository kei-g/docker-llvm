FROM snowstep/apt-fast:focal

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
  && gpg --export > $keydir/$keyname \
  && distro=focal \
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
  && apt-fast upgrade -yqq \
  && apt-fast install --no-install-recommends -y \
    clang \
    clang-format \
    clang-tidy \
    clangd \
    libunwind-dev \
    lld \
    lldb \
  && apt-fast install --no-install-recommends -y \
    libc++-${MAJOR_VERSION:-17}-dev \
    libc++abi-${MAJOR_VERSION:-17}-dev \
    libclang-${MAJOR_VERSION:-17}-dev \
    libclang-rt-${MAJOR_VERSION:-17}-dev \
    llvm-${MAJOR_VERSION:-17}-tools \
  && apt autoremove --purge -y \
  && apt clean -y \
  && rm -fr /var/lib/apt/lists/* \
  && find /usr/bin \
    -name llvm\-\*\-${MAJOR_VERSION:-17} \
    -exec bash -c '\
i=1; \
while [[ $i -lt $# ]]; do \
  eval name=\${$i##*/}; \
  eval name=\${name%\-*}; \
  ln -fs $name-${MAJOR_VERSION:-17} /usr/bin/$name; \
  i=$((i + 1)); \
done \
' -- {} +
