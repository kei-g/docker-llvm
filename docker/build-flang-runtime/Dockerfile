FROM snowstep/clang:__BASE__

RUN cd /usr/lib/llvm-23/lib/clang/23 \
  && mkdir finclude lib/x86_64-unknown-linux-gnu

COPY bin/ /usr/lib/llvm-23/bin/
COPY lib/ /usr/lib/llvm-23/lib/

RUN chmod 755 /usr/lib/llvm-23/bin/flang-23
