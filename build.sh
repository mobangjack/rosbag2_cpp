#!/bin/bash

cd $(dirname $0)

# android build configuration
if [ -z "$ANDROID_ABI" ]; then
    export ANDROID_ABI=armeabi-v7a
fi

if [ -z "$ANDROID_NATIVE_API_LEVEL" ]; then
    if [ "$ANDROID_ABI" == "armeabi-v7a" ]; then
        export ANDROID_NATIVE_API_LEVEL=23
    else
        export ANDROID_NATIVE_API_LEVEL=28
    fi
fi

build_base="$PWD/build/$ANDROID_ABI"
install_base="$PWD/install/$ANDROID_ABI"

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
    --packages-ignore ros2bag \
    --packages-ignore rosbag2 \
    --packages-ignore rosbag2_converter_default_plugins \
    --packages-ignore rosbag2_test_common \
    --packages-ignore rosbag2_tests \
    --packages-ignore rosbag2_transport \
    $packages_select \
    --cmake-args \
        --no-warn-unused-cli \
        -DPYTHON_EXECUTABLE=/usr/bin/python3 \
        -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK}/build/cmake/android.toolchain.cmake" \
        -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL} \
        -DANDROID_ABI="${ANDROID_ABI}" \
        -DANDROID_NDK="${ANDROID_NDK}" \
        -DANDROID_STL=c++_static \
        -DBUILD_TESTING:BOOL=OFF \
        -DBUILD_SHARED_LIBS:BOOL=ON \
        -DCMAKE_FIND_ROOT_PATH="$install_base"
