cmake_minimum_required(VERSION 3.5)
#find_package(CUDA)
#SET(CMAKE_CUDA_COMPILER /opt/cuda/bin/nvcc)
project(cuda0)
enable_language(CUDA)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
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

add_executable(cuda0 ${SOURCES})
