ARG MAJOR_VERSION

# Install the latest LLVM
FROM snowstep/apt-fast:trixie

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
  && apt-fast install --no-install-recommends --yes \
    clang-${MAJOR_VERSION:-22} \
    clang-format-${MAJOR_VERSION:-22} \
    clang-tidy-${MAJOR_VERSION:-22} \
    clangd-${MAJOR_VERSION:-22} \
    flang-${MAJOR_VERSION:-22} \
    libc++-${MAJOR_VERSION:-22}-dev \
    libc++abi-${MAJOR_VERSION:-22}-dev \
    libclang-${MAJOR_VERSION:-22}-dev \
    libclang-rt-${MAJOR_VERSION:-22}-dev \
    libclc-${MAJOR_VERSION:-22}-dev \
    libomp-${MAJOR_VERSION:-22}-dev \
    libunwind-${MAJOR_VERSION:-22}-dev \
    lld-${MAJOR_VERSION:-22} \
    lldb-${MAJOR_VERSION:-22} \
    llvm-${MAJOR_VERSION:-22} \
    llvm-${MAJOR_VERSION:-22}-tools \
  && find /usr/bin \
    \( -name clang\*-${MAJOR_VERSION:-22} -o -name lld\*-${MAJOR_VERSION:-22} -o -name llvm\*-${MAJOR_VERSION:-22} \) \
    -exec bash -c '\
i=1; \
while [[ $i -lt $# ]]; do \
  eval name=\${$i##*/}; \
  eval name=\${name%\-*}; \
  ln -fs $name-${MAJOR_VERSION:-22} /usr/bin/$name; \
  i=$((i + 1)); \
done \
' -- {} + \
  && grep -P '/bin/([^-]+-)+22$' /var/lib/dpkg/info/flang-22.list \
    | while read -r full; do \
      dir=${full%/*}; \
      name=${full##*/}; \
      name=${name%\-*}; \
      ln -fs $name-${MAJOR_VERSION:-22} $dir/$name; \
    done \
  && apt clean --yes \
  && rm -fr /var/lib/apt/lists/* \
  && echo /usr/lib/llvm-${MAJOR_VERSION:-22}/lib > /etc/ld.so.conf.d/llvm.conf \
  && ldconfig
