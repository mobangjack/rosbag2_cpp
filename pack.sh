#!/bin/bash

set -e
set -x

if [ -z "$ANDROID_ABI" ]; then
    export ANDROID_ABI="armeabi-v7a"
fi

install_base="$PWD/install/$ANDROID_ABI"

pushd "$install_base"
tar -cfz "librosbag2-dev-${ANDROID_ABI}.tar.gz" *
popd

release_dir="$PWD/release/$ANDROID_ABI"
if [ ! -d "$release_dir" ]; then
    mkdir -p "$release_dir"
fi

mv "$install_base/librosbag2-dev-${ANDROID_ABI}.tar.gz" "$release_dir/"
