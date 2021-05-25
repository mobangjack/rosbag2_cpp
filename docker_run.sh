#!/bin/bash

cd $(dirname $0)

cmd="cd $PWD"

subcmd=""
if [ $(id -u) != 0 ]; then
    subcmd="groupadd -g $(id -g) $(id -ng)"
    subcmd="$subcmd && useradd -u $(id -u) -g $(id -g) -md $HOME -s /bin/bash $USER"
    subcmd="$subcmd && chown $(id -u):$(id -g) $HOME"
    subcmd="$subcmd && su $USER"
    cmd="$cmd && $subcmd"
fi

option=""
if [ -z "$*" ]; then
    option="-it"
    if [ -z "$subcmd" ]; then
        cmd="$cmd && bash"
    fi
else
    option="--rm"
    if [ -z "$subcmd" ]; then
        cmd="$cmd && bash -c \"$*\""
    else
        cmd="$cmd -c \"$*\""
    fi
fi

image=mobangjack/colcon-ndk:latest

set -x
docker run -v $PWD:$PWD -e ARCH=${ARCH} $option $image bash -c "$cmd"
