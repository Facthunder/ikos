FROM ubuntu:19.04

ARG njobs=2
ARG build_type=Release
ARG IKOS_VERSION=v2.2

WORKDIR /root/ikos

# Installs the following versions (note that it might be out of date):
# cmake 3.13.4
# gmp 6.1.2
# boost 1.67.0
# python 2.7.16
# sqlite 3.27.2
# llvm 8.0.1
# clang 8.0.1
# gcc 8.3.0

# Upgrade
RUN apt-get update -y \
 && apt-get upgrade -y

# Add ppa for llvm 8.0
RUN echo "deb http://apt.llvm.org/disco/ llvm-toolchain-disco-8 main" >> /etc/apt/sources.list

# Add llvm repository key
RUN apt-get install -y wget gnupg \
 && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
 && apt-get update -y \
 && apt-get install -y gcc g++ cmake libgmp-dev libboost-dev \
        libboost-filesystem-dev libboost-test-dev python python-pygments \
        libsqlite3-dev libz-dev libedit-dev llvm-8 llvm-8-dev llvm-8-tools clang-8 \
        git \
 && git clone --single-branch https://github.com/NASA-SW-VnV/ikos.git . \
 && git checkout tags/${IKOS_VERSION} \
 && rm -rf /root/ikos/build && mkdir /root/ikos/build

WORKDIR /root/ikos/build
ENV MAKEFLAGS "-j$njobs"
RUN cmake \
        -DCMAKE_INSTALL_PREFIX="/opt/ikos" \
        -DCMAKE_BUILD_TYPE="$build_type" \
        -DLLVM_CONFIG_EXECUTABLE="/usr/lib/llvm-8/bin/llvm-config" \
        .. \
 && make \
 && make install \
 && make check

# Add ikos to the path
ENV PATH "/opt/ikos/bin:$PATH"

# Done
WORKDIR /src

LABEL maintainer="begarco"
