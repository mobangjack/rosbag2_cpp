#!/bin/bash

cd $(dirname $0)

set -e
set -x

if [ -z "${ANDROID_NDK}" ]; then
    echo "ENV{ANDROID_NDK} is not set"
    exit 1
fi

if [ -z "$ARCH" ]; then
    export ARCH="arm"
fi

arch=$ARCH
if [ "$arch" == "arm64" ]; then
    arch="aarch64"
fi

install_base="$PWD/install/$ARCH"
strip="${ANDROID_NDK}/toolchains/llvm/prebuilt/linux-x86_64/${arch}-linux-androideabi/bin/strip"

find "$install_base/lib" -name *.so* -exec $strip {} \;
