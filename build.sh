#!/bin/bash

cd $(dirname $0)

# android build configuration
if [ -z "$ANDROID_ABI" ]; then
    export ANDROID_ABI=armeabi-v7a
    export ANDROID_NATIVE_API_LEVEL=23
fi

build_base="$PWD/build/$ANDROID_ABI"
install_base="$PWD/install/$ANDROID_ABI"

if [ -n "$@" ]; then
    packages_select="--packages-select $@"
else
    packages_select=""
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
    "$packages_select" \
    --cmake-args \
        --no-warn-unused-cli \
        -DPYTHON_EXECUTABLE=/usr/bin/python3 \
        -DCMAKE_TOOLCHAIN_FILE="${ANDROID_NDK}/build/cmake/android.toolchain.cmake" \
        -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL} \
        -DANDROID_ABI="${ANDROID_ABI}" \
        -DANDROID_NDK="${ANDROID_NDK}" \
        -DANDROID_STL=c++_static \
        -DBUILD_TESTING:BOOL=OFF \
        -DCMAKE_FIND_ROOT_PATH="$install_base"
