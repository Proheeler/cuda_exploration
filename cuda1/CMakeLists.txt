cmake_minimum_required(VERSION 3.5)
#find_package(CUDA)
#SET(CMAKE_CUDA_COMPILER /opt/cuda/bin/nvcc)
project(cuda1)
enable_language(CUDA)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_BUILD_TYPE Debug)

#Tell CMake to run moc when necessary:
set(CMAKE_AUTOMOC ON)
# As moc files are generated in the binary dir, tell CMake
# to always look for includes there:
set(CMAKE_INCLUDE_CURRENT_DIR ON)
find_package(Qt5 COMPONENTS Core Gui REQUIRED)
# The Qt5Widgets_INCLUDES also includes the include directories for
# dependencies QtCore and QtGui
include_directories(
    ${Qt5Core_INCLUDE_DIRS}
    ${Qt5Gui_INCLUDE_DIRS}
    )


# We need add -DQT_WIDGETS_LIB when using QtWidgets in Qt 5.
add_definitions(${Qt5Widgets_DEFINITIONS})


find_package(CUDA QUIET REQUIRED)

set(
    CUDA_NVCC_FLAGS
    ${CUDA_NVCC_FLAGS};
    -O3 -gencode arch=compute_52,code=sm_52
    )
FILE(GLOB SOURCES "kernels/*.cu" "src/*.cpp" "src/*.c" "include/*.h"  "include/*.cuh")

include_directories(
    /opt/cuda/include
    /opt/cuda/samples/common/inc
    )
get_property( core_options TARGET Qt5::Core PROPERTY INTERFACE_COMPILE_OPTIONS )
string( REPLACE "-fPIC" "" new_core_options "${core_options}" )
set_property( TARGET Qt5::Core PROPERTY INTERFACE_COMPILE_OPTIONS ${new_core_options} )
set_property( TARGET Qt5::Core PROPERTY INTERFACE_POSITION_INDEPENDENT_CODE "ON" )
set( CMAKE_CXX_COMPILE_OPTIONS_PIE "-fPIC" )



add_executable(cuda1 ${SOURCES})
target_link_libraries(cuda1
    Qt5::Gui
    Qt5::Core

    )
