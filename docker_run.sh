#!/bin/bash

cd $(dirname $0)

cmd="cd ."
append_cmd() {
    cmd="$cmd && $1"
}

append_cmd "groupadd -g $(id -g)"
append_cmd "useradd -u $(id -u) -g $(id -g) -md -s /bin/bash"
append_cmd "chown $(id -u):$(id -g) /home/$USER"
append_cmd "cd $PWD"
append_cmd "su - $USER"

option="-it"
if [ -n "$*" ]; then
    append_cmd "bash -c \"$*\""
    option="--rm"
fi

docker run -v $PWD:$PWD $option mobangjack/colcon-ndk:latest "$cmd"
