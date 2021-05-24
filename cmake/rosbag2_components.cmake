
if ("${rosbag2_components_DIR}" STREQUAL "")
    message(FATAL_ERROR "rosbag2_components_DIR is not set")
endif()

set(rosbag2_components_INCLUDE_DIRS ${rosbag2_components_DIR}/include)
set(rosbag2_components_LIBRARY_DIRS ${rosbag2_components_DIR}/lib)
set(rosbag2_components_LIBRARIES
    rosbag2_cpp
    rosbag2_storage
    rosidl_typesupport_cpp
    rosidl_typesupport_introspection_cpp
    ament_index_cpp
    class_loader
    console_bridge
    tinyxml2
    yaml-cpp
    rosidl_typesupport_c
    rcpputils
    rosidl_runtime_c
    rcutils
    rosidl_typesupport_introspection_c
    )

set(rosbag2_components_SYSTEM_LIBRARIES
    dl
    m
    )