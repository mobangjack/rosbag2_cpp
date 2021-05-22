#!/bin/bash

cd $(dirname $0)

vcs-import src < rosbag2_cpp.yml
