# custom toolchain file

if (NOT DEFINED ARCH)
    if (DEFINED ENV{ARCH})
        set(ARCH $ENV{ARCH})
    else()
        set(ARCH arm)
    endif()
endif()

if (NOT DEFINED ANDROID_ABI)
    if (${ARCH} EQUAL "arm")
        set(ANDROID_ABI armeabi-v7a)
    else()
        set(ANDROID_ABI arm64-v8a)
    endif()
endif()

if (NOT DEFINED ANDROID_NDK)
    if (DEFINED ENV{ANDROID_NDK})
        set(ANDROID_NDK $ENV{ANDROID_NDK})
    else()
        message(FATAL_ERROR "ANDROID_NDK/ENV{ANDROID_NDK} is not defined")
    endif()
endif()

if (NOT DEFINED ANDROID_NATIVE_API_LEVEL)
    if (${ANDROID_ABI} EQUAL "armeabi-v7a")
        set(ANDROID_NATIVE_API_LEVEL 23)
    else()
        set(ANDROID_NATIVE_API_LEVEL 28)
    endif()
endif()

if (NOT DEFINED ANDROID_STL)
    set(ANDROID_STL c++_static)
endif()

include(${ANDROID_NDK}/build/cmake/android.toolchain.cmake)
