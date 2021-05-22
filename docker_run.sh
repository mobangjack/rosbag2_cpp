#!/bin/bash

cd $(dirname $0)

cmd="bash"

subcmd=""
if [ $(id -u) != 0 ]; then
    subcmd="groupadd -g $(id -g) $(id -ng)"
    subcmd="$subcmd && useradd -u $(id -u) -g $(id -g) -md $HOME -s /bin/bash $USER"
    subcmd="$subcmd && chown $(id -u):$(id -g) $HOME"
    subcmd="$subcmd && cd $PWD"
    subcmd="$subcmd && su - $USER"
fi

option="-it"
if [ -n "$*" ]; then
    if [ -n "$subcmd" ]; then
        cmd="$cmd -c \"$subcmd\" -c \"$*\""
    else
        cmd="$cmd -c \"$*\""
    fi
    option="--rm"
fi

docker run -v $PWD:$PWD $option mobangjack/colcon-ndk:latest bash -c "$cmd"
