ARG MAJOR_VERSION

# Install the latest LLVM
FROM snowstep/apt-fast:bookworm AS common

ENV DEBCONF_NOWARNINGS=yes
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-fast update \
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
' -- {} +

# Build the fortran runtime library
FROM common AS flang_rt-builder

COPY pip.conf /etc/
RUN apt-fast install --no-install-recommends --yes \
    git \
    libedit-dev \
    libxml2-dev \
    libzstd-dev \
    python3-pip \
    zlib1g-dev \
    zstd \
  && pip install \
    cmake \
    ninja \
  && apt clean --yes \
  && rm -fr /var/lib/apt/lists/* \
  && git clone --depth=1 https://github.com/llvm/llvm-project.git \
  && mkdir build dist \
  && cd build \
  && cmake \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_CXX_COMPILER=clang++ \
    -D CMAKE_CXX_STANDARD=17 \
    -D CMAKE_C_COMPILER=clang \
    -D CMAKE_INSTALL_PREFIX=/dist \
    -D LLVM_BUILD_INSTRUMENTED_COVERAGE=OFF \
    -D LLVM_BUILD_TESTS=OFF \
    -D LLVM_BUILD_TOOLS=OFF \
    -D LLVM_ENABLE_LIBCXX=ON \
    -D LLVM_ENABLE_PROJECTS="flang" \
    -D LLVM_ENABLE_RUNTIMES="compiler-rt;flang-rt;openmp" \
    -D LLVM_INCLUDE_BENCHMARKS=OFF \
    -D LLVM_INCLUDE_EXAMPLES=OFF \
    -D LLVM_INCLUDE_TESTS=OFF \
    -D LLVM_INSTALL_UTILS=OFF \
    -D LLVM_TARGETS_TO_BUILD=X86 \
    -G Ninja \
    -S /llvm-project/llvm \
  && ninja flang-rt \
  && ninja install \
  && mv /dist/lib/clang/${MAJOR_VERSION:-21}/lib/x86_64-unknown-linux-gnu/libflang_rt.runtime.a /dist/

# Copy libflang_rt.runtime.a
FROM common
RUN apt-fast install --no-install-recommends --yes \
    flang-${MAJOR_VERSION:-21} \
  && grep -P '/bin/([^-]+-)+21$' /var/lib/dpkg/info/flang-21.list \
    | while read -r full; do \
      dir=${full%/*}; \
      name=${full##*/}; \
      name=${name%\-*}; \
      ln -fs $name-${MAJOR_VERSION:-21} $dir/$name; \
    done \
  && apt clean --yes \
  && rm -fr /var/lib/apt/lists/*
COPY --from=flang_rt-builder /dist/libflang_rt.runtime.a /usr/lib/x86_64-linux-gnu/
