FROM snowstep/apt-fast:bullseye

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
  && distro=$(grep -E '^VERSION_CODENAME=.+$' < /etc/os-release) \
  && distro=${distro#*=} \
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
  && apt-fast install --no-install-recommends --yes \
    clang-${MAJOR_VERSION:-21} \
    clang-format-${MAJOR_VERSION:-21} \
    clang-tidy-${MAJOR_VERSION:-21} \
    clangd-${MAJOR_VERSION:-21} \
    flang-${MAJOR_VERSION:-21} \
    libc++-${MAJOR_VERSION:-21}-dev \
    libc++abi-${MAJOR_VERSION:-21}-dev \
    libclang-${MAJOR_VERSION:-21}-dev \
    libclang-rt-${MAJOR_VERSION:-21}-dev \
    libclc-${MAJOR_VERSION:-21}-dev \
    libomp-${MAJOR_VERSION:-21}-dev \
    libunwind-${MAJOR_VERSION:-21}-dev \
    lld-${MAJOR_VERSION:-21} \
    lldb-${MAJOR_VERSION:-21} \
    llvm-${MAJOR_VERSION:-21} \
    llvm-${MAJOR_VERSION:-21}-tools \
  && apt clean --yes \
  && rm -fr /var/lib/apt/lists/* \
  && find /usr/bin \
    \( -name clang\*-${MAJOR_VERSION:-21} -o -name lld\*-${MAJOR_VERSION:-21} -o -name llvm\*-${MAJOR_VERSION:-21} \) \
    -exec bash -c '\
i=1; \
while [[ $i -lt $# ]]; do \
  eval name=\${$i##*/}; \
  eval name=\${name%\-*}; \
  ln -fs $name-${MAJOR_VERSION:-21} /usr/bin/$name; \
  i=$((i + 1)); \
done \
' -- {} + \
  && grep -P '/bin/([^-]+-)+21$' /var/lib/dpkg/info/flang-21.list \
    | while read -r full; do \
      dir=${full%/*}; \
      name=${full##*/}; \
      name=${name%\-*}; \
      ln -fs $name-${MAJOR_VERSION:-21} $dir/$name; \
    done
