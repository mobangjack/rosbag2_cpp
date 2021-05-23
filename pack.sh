#!/bin/bash

cd $(dirname $0)

if [ -z "$ARCH" ]; then
    export ARCH="arm"
fi

set -e
set -x

install_base="$PWD/install/$ARCH"

pushd "$install_base"
tar -vczf "librosbag2-dev-${ARCH}.tar.gz" *
popd

release_dir="$PWD/release/$ARCH"
if [ ! -d "$release_dir" ]; then
    mkdir -p "$release_dir"
fi

mv "$install_base/librosbag2-dev-${ARCH}.tar.gz" "$release_dir/"
