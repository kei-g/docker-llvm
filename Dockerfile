FROM snowstep/apt-fast:latest

# Install the latest LLVM
RUN DEBIAN_FRONTEND=noninteractive \
   && apt-fast update \
   && apt-fast install --no-install-recommends -y \
     gnupg \
   && keyname=llvm-snapshot.gpg.key \
   && keypath=/usr/share/keyrings/llvm-snapshot-keyring.gpg \
   && llvm=apt.llvm.org \
   && aria2c -d /tmp https://$llvm/$keyname \
   && gpg --import --keyring=$keypath --no-default-keyring /tmp/$keyname \
   && rm -f /tmp/$keyname \
   && distro=bullseye \
   && printf 'deb [signed-by=%s] http://%s/%s/ llvm-toolchain-%s-14 main\n' $keypath $llvm $distro $distro > /etc/apt/sources.list.d/llvm-toolchain.list \
   && apt-fast update \
   && apt-fast install --no-install-recommends -y \
     clang-14 \
     clangd-14 \
     libc++-14-dev \
     libc++abi-14-dev \
     libunwind-14-dev \
     lld-14 \
     lldb-14 \
   && rm -fr /var/lib/apt/lists/* \
   && echo '[ -d /usr/lib/llvm-14/bin ] && export PATH=/usr/lib/llvm-14/bin:$PATH' \
     tee /root/.bashrc \
     > /root/.profile
