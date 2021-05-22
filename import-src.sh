#!/bin/bash

cd $(dirname $0)

if [ ! -d src ]; then
    mkdir src
fi

vcs-import src < rosbag2_cpp.yml
