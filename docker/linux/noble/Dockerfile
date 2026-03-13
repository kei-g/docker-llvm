# Install the latest LLVM
FROM snowstep/apt-fast:noble

ARG MAJOR_VERSION
ENV MAJOR_VERSION=${MAJOR_VERSION:-23}

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
  && rm -f $keyname.key \
  && [ -d $keydir ] \
    || mkdir -pv $keydir \
  && gpg --export > $keydir/$keyname \
  && codename=$(grep -P '(?<=VERSION_CODENAME=).+$' -o < /etc/os-release) \
  && for what in deb deb-src; do \
      printf \
        '%s [signed-by=%s] http://%s/%s/ llvm-toolchain-%s main\n' \
          $what \
          $keydir/$keyname \
          $llvm \
          $codename \
          $codename; \
    done > /etc/apt/sources.list.d/llvm-toolchain.list \
  && apt-fast update \
  && apt-fast upgrade --yes \
  && apt-fast install --no-install-recommends --yes \
    clang-${MAJOR_VERSION} \
    clang-format-${MAJOR_VERSION} \
    clang-tidy-${MAJOR_VERSION} \
    clangd-${MAJOR_VERSION} \
    flang-${MAJOR_VERSION} \
    libunwind-${MAJOR_VERSION}-dev \
    lld-${MAJOR_VERSION} \
    lldb-${MAJOR_VERSION} \
  && apt-fast install --no-install-recommends --yes \
    libc++-${MAJOR_VERSION}-dev \
    libc++abi-${MAJOR_VERSION}-dev \
    libclang-${MAJOR_VERSION}-dev \
    libclang-rt-${MAJOR_VERSION}-dev \
    libclc-${MAJOR_VERSION}-dev \
    libomp-${MAJOR_VERSION}-dev \
    llvm-${MAJOR_VERSION} \
    llvm-${MAJOR_VERSION}-tools \
  && find /usr/bin \
    \( -name clang\*-${MAJOR_VERSION} -o -name lld\*-${MAJOR_VERSION} -o -name llvm\*-${MAJOR_VERSION} \) \
    -exec bash -c '\
i=1; \
while [[ $i -lt $# ]]; do \
  eval name=\${$i##*/}; \
  eval name=\${name%\-*}; \
  ln -fs $name-${MAJOR_VERSION} /usr/bin/$name; \
  i=$((i + 1)); \
done \
' -- {} + \
  && grep -P "/bin/([^-]+-)+${MAJOR_VERSION}\$" /var/lib/dpkg/info/flang-${MAJOR_VERSION}.list \
    | while read -r full; do \
      dir=${full%/*}; \
      name=${full##*/}; \
      name=${name%\-*}; \
      ln -fs $name-${MAJOR_VERSION} $dir/$name; \
    done \
  && apt clean --yes \
  && rm -fr /var/lib/apt/lists/* \
  && echo /usr/lib/llvm-${MAJOR_VERSION}/lib > /etc/ld.so.conf.d/llvm.conf \
  && ldconfig
