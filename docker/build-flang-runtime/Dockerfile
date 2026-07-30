FROM snowstep/clang:__BASE__

RUN cd /usr/lib/llvm-__MAJOR_VERSION__/lib/clang/__MAJOR_VERSION__ \
  && mkdir finclude lib/x86_64-unknown-linux-gnu

COPY bin/ /usr/lib/llvm-__MAJOR_VERSION__/bin/
COPY lib/ /usr/lib/llvm-__MAJOR_VERSION__/lib/

RUN chmod 755 /usr/lib/llvm-__MAJOR_VERSION__/bin/flang-__MAJOR_VERSION__
