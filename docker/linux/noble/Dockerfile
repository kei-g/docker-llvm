FROM snowstep/apt-fast:noble

ARG MAJOR_VERSION

# Install the latest LLVM
RUN DEBCONF_NOWARNINGS=yes \
  && DEBIAN_FRONTEND=noninteractive \
  && apt-fast update \
  && apt-fast upgrade --yes \
  && apt-fast install --no-install-recommends --yes \
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
  && distro=noble\
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
  && apt-fast upgrade --yes \
  && apt-fast install --no-install-recommends --yes \
    clang-${MAJOR_VERSION:-18} \
    clang-format-${MAJOR_VERSION:-18} \
    clang-tidy-${MAJOR_VERSION:-18} \
    clangd-${MAJOR_VERSION:-18} \
    libunwind-${MAJOR_VERSION:-18}-dev \
    lld-${MAJOR_VERSION:-18} \
    lldb-${MAJOR_VERSION:-18} \
  && apt-fast install --no-install-recommends --yes \
    libc++-${MAJOR_VERSION:-18}-dev \
    libc++abi-${MAJOR_VERSION:-18}-dev \
    libclang-${MAJOR_VERSION:-18}-dev \
    libclang-rt-${MAJOR_VERSION:-18}-dev \
    libclc-${MAJOR_VERSION:-18}-dev \
    libomp-${MAJOR_VERSION:-18}-dev \
    llvm-${MAJOR_VERSION:-18} \
    llvm-${MAJOR_VERSION:-18}-tools \
  && apt clean --yes \
  && rm -fr /var/lib/apt/lists/* \
  && find /usr/bin \
    -name llvm\-\*\-${MAJOR_VERSION:-18} \
    -exec bash -c '\
i=1; \
while [[ $i -lt $# ]]; do \
  eval name=\${$i##*/}; \
  eval name=\${name%\-*}; \
  ln -fs $name-${MAJOR_VERSION:-18} /usr/bin/$name; \
  i=$((i + 1)); \
done \
' -- {} +
