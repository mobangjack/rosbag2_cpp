#!/bin/bash

set -e
set -x

if [ -z "$ARCH" ]; then
    export ARCH="arm"
fi

install_base="$PWD/install/$ARCH"

pushd "$install_base"
tar -cfz "librosbag2-dev-${ARCH}.tar.gz" *
popd

release_dir="$PWD/release/$ARCH"
if [ ! -d "$release_dir" ]; then
    mkdir -p "$release_dir"
fi

mv "$install_base/librosbag2-dev-${ARCH}.tar.gz" "$release_dir/"
