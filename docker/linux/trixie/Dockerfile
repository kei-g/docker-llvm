ARG MAJOR_VERSION

# Upgrade packages as a common environment
FROM snowstep/apt-fast:trixie AS common

COPY pip.conf symlink.sh /etc/
ENV DEBCONF_NOWARNINGS=yes
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-fast update \
  && apt-fast upgrade --yes \
  && apt-fast install --no-install-recommends --yes \
    liblzma5 \
    python3-pip \
    xz-utils \
    zlib1g-dev \
    zstd \
  && pip install \
    cmake \
    ninja

# Install LLVM by `apt-fast` and build the main branch
FROM common AS builder

RUN apt-fast install --no-install-recommends --yes \
    git \
    gnupg \
    libedit-dev \
    liblzma-dev \
    libxml2-dev \
    libzstd-dev \
    ocaml \
    python3-dev \
    swig \
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
    clang-${MAJOR_VERSION:-19} \
    clang-format-${MAJOR_VERSION:-19} \
    clang-tidy-${MAJOR_VERSION:-19} \
    clangd-${MAJOR_VERSION:-19} \
    libc++-${MAJOR_VERSION:-19}-dev \
    libc++abi-${MAJOR_VERSION:-19}-dev \
    libclang-${MAJOR_VERSION:-19}-dev \
    libclang-rt-${MAJOR_VERSION:-19}-dev \
    libclc-${MAJOR_VERSION:-19}-dev \
    libomp-${MAJOR_VERSION:-19}-dev \
    libunwind-${MAJOR_VERSION:-19}-dev \
    lld-${MAJOR_VERSION:-19} \
    lldb-${MAJOR_VERSION:-19} \
    llvm-${MAJOR_VERSION:-19} \
    llvm-${MAJOR_VERSION:-19}-tools \
  && MAJOR_VERSION=${MAJOR_VERSION:-19} /etc/symlink.sh \
  && apt clean --yes \
  && rm -fr /var/lib/apt/lists/* \
  && git clone --depth=1 https://github.com/llvm/llvm-project.git \
  && timestamp=$( \
    cd llvm-project; \
    TZ=UTC0 git log --date='format-local:%Y%m%d%H%M%S' --pretty=format:%cd -1; \
  ) \
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
      -D LLVM_BUILD_TOOLS=ON \
      -D LLVM_ENABLE_LIBCXX=ON \
      -D LLVM_ENABLE_LLD=ON \
      -D LLVM_ENABLE_PROJECTS="bolt;clang;clang-tools-extra;flang;lld;lldb;mlir;polly" \
      -D LLVM_ENABLE_RUNTIMES="libc;libunwind;libcxxabi;libcxx;compiler-rt;openmp;flang-rt;libclc" \
      -D LLVM_INCLUDE_BENCHMARKS=OFF \
      -D LLVM_INCLUDE_EXAMPLES=OFF \
      -D LLVM_INCLUDE_TESTS=OFF \
      -D LLVM_INSTALL_UTILS=ON \
      -D LLVM_LIBGCC_EXPLICIT_OPT_IN=Yes \
      -D LLVM_TARGETS_TO_BUILD=X86 \
      -G Ninja \
      -S /llvm-project/llvm \
  && ninja \
  && ninja install \
  && major_version=$( \
    grep -P '^\s+set\(LLVM_VERSION_MAJOR\s+[1-9][0-9]*\)$' \
      < /llvm-project/cmake/Modules/LLVMVersion.cmake \
      | sed -r 's/^\s+set\(LLVM_VERSION_MAJOR\s([1-9][0-9]*)\)$/\1/' \
  ) \
  && dir=/dist/usr/local/etc/llvm \
  && mkdir -p $dir \
  && echo $major_version > $dir/major_version.txt \
  && echo $timestamp > $dir/timestamp.txt

# Copy the built source and create symbolic links
FROM common

COPY --from=builder /dist/ /
RUN /etc/symlink.sh \
  && apt clean --yes \
  && rm -fr /etc/symlink.sh /var/lib/apt/lists/*
