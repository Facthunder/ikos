#------------------------------#
# BUILD STAGE
#------------------------------#

FROM ubuntu:19.10 AS base

ARG njobs=2
ARG build_type=Release
ARG IKOS_VERSION=v3.0

WORKDIR /root/ikos

# Upgrade
RUN apt-get update -y \
 && echo "deb http://apt.llvm.org/disco/ llvm-toolchain-disco-9 main" >> /etc/apt/sources.list \
 && apt-get install -y wget gnupg \
 && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
 && apt-get update -y \
 && apt-get install -y gcc g++ cmake libgmp-dev libboost-dev libtbb-dev \
        libboost-filesystem-dev libboost-test-dev libboost-thread-dev python python-pygments \
        libsqlite3-dev libz-dev libedit-dev llvm-9 llvm-9-dev llvm-9-tools clang-9 \
        git \
 && git clone --single-branch https://github.com/NASA-SW-VnV/ikos.git . \
 && git checkout tags/${IKOS_VERSION} \
 && rm -rf /root/ikos/build && mkdir /root/ikos/build

WORKDIR /root/ikos/build
ENV MAKEFLAGS "-j$njobs"

RUN cmake \
        -DCMAKE_INSTALL_PREFIX="/opt/ikos" \
        -DCMAKE_BUILD_TYPE="$build_type" \
        -DLLVM_CONFIG_EXECUTABLE="/usr/lib/llvm-9/bin/llvm-config" \
        .. \
 && make \
 && make install \
 && make check

#------------------------------#
# FINAL STAGE
#------------------------------#

FROM ubuntu:19.10

COPY --from=base /opt/ikos /opt/ikos

RUN apt-get update -y && apt-get install -y \
    python \
    clang-9 \
    libboost-filesystem-dev \
    libgmp-dev \
 && rm -rf /var/lib/apt/lists/*

ENV PATH "/opt/ikos/bin:$PATH"

WORKDIR /src
LABEL maintainer="begarco"
