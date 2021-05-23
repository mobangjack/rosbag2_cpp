#!/bin/bash

cd $(dirname $0)

# build configuration
if [ -z "$ARCH" ]; then
    export ARCH=arm
fi

build_base="$PWD/build/$ARCH"
install_base="$PWD/install/$ARCH"

sed_append() {
    ref="$1"
    line="$2"
    file="$3"
    grep "$line" "$file"
    if [ $? -ne 0 ]; then
        sed -i "/${ref}/a\\${line}" "$file"
    fi
}

# magic operations
magic_ops() {
    ./generate_package_xml.py base.yml
    sed_append "<buildtool_depend>ament_cmake<\/buildtool_depend>" "<depend>yaml_cpp</depend>" src/ros2/yaml_cpp_vendor/package.xml
    sed -i "s/build_yaml_cpp()/find_package(yaml_cpp)/g" src/ros2/yaml_cpp_vendor/CMakeLists.txt
    sed -i "s/stdc++fs//g" src/ros/pluginlib/pluginlib/CMakeLists.txt
    sed -i "s/stdc++fs//g" src/ros/pluginlib/pluginlib/pluginlib-extras.cmake


    touch \
        src/ros2/rosbag2/rosbag2/COLCON_IGNORE \
        src/ros2/rosbag2/ros2bag/COLCON_IGNORE \
        src/ros2/rosbag2/rosbag2_transport/COLCON_IGNORE \
        src/ros2/rosbag2/rosbag2_tests/COLCON_IGNORE \
        src/ros2/rosbag2/rosbag2_test_common/COLCON_IGNORE \
        src/ros2/rosbag2/rosbag2_converter_default_plugins/COLCON_IGNORE
}

if [ $# -gt 0 ]; then
    packages_select="--packages-select $@"
else
    packages_select=""
    magic_ops
fi

colcon build \
    --merge-install \
    --build-base "$build_base" \
    --install-base "$install_base" \
    $packages_select \
    --cmake-args \
        --no-warn-unused-cli \
        -DPYTHON_EXECUTABLE=/usr/bin/python3 \
        -DCMAKE_TOOLCHAIN_FILE="${PWD}/custom.toolchain.cmake" \
        -DBUILD_TESTING:BOOL=OFF \
        -DBUILD_SHARED_LIBS:BOOL=ON \
        -DCMAKE_FIND_ROOT_PATH="$install_base"
