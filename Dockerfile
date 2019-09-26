#------------------------------#
# BUILD STAGE
#------------------------------#

FROM ubuntu:19.04 AS base

ARG njobs=2
ARG build_type=Release
ARG IKOS_VERSION=v2.2

WORKDIR /root/ikos

# Upgrade
RUN apt-get update -y \
 && echo "deb http://apt.llvm.org/disco/ llvm-toolchain-disco-8 main" >> /etc/apt/sources.list \
 && apt-get install -y wget gnupg \
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

#------------------------------#
# FINAL STAGE
#------------------------------#

FROM ubuntu:19.04

COPY --from=base /opt/ikos /opt/ikos

RUN apt-get update -y && apt-get install -y \
    python \
    clang-8 \
    libboost-filesystem-dev \
    libgmp-dev \
 && rm -rf /var/lib/apt/lists/*

ENV PATH "/opt/ikos/bin:$PATH"

WORKDIR /src
LABEL maintainer="begarco"
