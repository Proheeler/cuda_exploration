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
    -O3 -gencode arch=compute_22,code=sm_22
    )
FILE(GLOB SOURCES "kernels/*.cu" "src/*.cpp" "src/*.c" "include/*.h")

include_directories(
#    /opt/cuda/include
    /opt/cuda/samples/common/inc
    )
#link_directories(/opt/cida/lib64

#    )

#CUDA_ADD_EXECUTABLE(cuda0 main.cu)
add_executable(cuda0 ${SOURCES})
