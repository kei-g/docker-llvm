ARG MAJOR_VERSION

# Upgrade packages as a common environment
FROM snowstep/apt-fast:noble AS common

COPY pip.conf /etc/
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
    build-essential \
    g++ \
    git \
    gnupg \
    libedit-dev \
    liblzma-dev \
    libxml2-dev \
    libzstd-dev \
    ocaml \
    python3-dev \
    swig \
  && apt clean --yes \
  && rm -fr /var/lib/apt/lists/* \
  && git clone --depth=1 https://github.com/llvm/llvm-project.git \
  && gitref=$( \
    cd llvm-project; \
    TZ=UTZ0 git log --pretty=format:%H -1 | head -c12; \
  ) \
  && timestamp=$( \
    cd llvm-project; \
    TZ=UTC0 git log --date='format-local:%Y%m%d%H%M%S' --pretty=format:%cd -1; \
  ) \
  && mkdir build dist \
  && cd build \
  && cmake \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_CXX_STANDARD=17 \
      -D CMAKE_INSTALL_PREFIX=/dist \
      -D LLVM_BUILD_INSTRUMENTED_COVERAGE=OFF \
      -D LLVM_BUILD_TESTS=OFF \
      -D LLVM_BUILD_TOOLS=ON \
      -D LLVM_ENABLE_LIBCXX=OFF \
      -D LLVM_ENABLE_LLD=OFF \
      -D LLVM_ENABLE_PROJECTS="bolt;clang;clang-tools-extra;flang;lld;lldb;mlir;polly" \
      -D LLVM_ENABLE_RUNTIMES="libc;libunwind;libcxxabi;libcxx;compiler-rt;openmp;flang-rt;libclc" \
      -D LLVM_INCLUDE_BENCHMARKS=OFF \
      -D LLVM_INCLUDE_EXAMPLES=OFF \
      -D LLVM_INCLUDE_TESTS=OFF \
      -D LLVM_INSTALL_UTILS=ON \
      -D LLVM_LIBGCC_EXPLICIT_OPT_IN=Yes \
      -D LLVM_TARGETS_TO_BUILD=X86 \
      -D LLVM_VERSION_SUFFIX="++$timestamp+$gitref" \
      -G Ninja \
      -S /llvm-project/llvm \
  && ninja \
  && ninja install

# Copy the built source and create symbolic links
FROM common

COPY --from=builder /dist/ /
RUN apt clean --yes \
  && rm -fr /var/lib/apt/lists/*
