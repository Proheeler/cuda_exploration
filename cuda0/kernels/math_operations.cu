#include <cuda_runtime.h>
#include "../include/cuda_fd_funcs.h"
#include <iostream>
#include <ctime>

template <typename T>
__global__ void VecAdd(T* A, T* B, T* C)
{
    int i = threadIdx.x;
    C[i] = A[i] + B[i];
}

template <typename T>
__global__ void MatAdd(T** A, T **B,
                       T** C)
{
    int i = threadIdx.x;
    int j = threadIdx.y;
    C[i][j] = A[i][j] + B[i][j];
}


void doVectorAddition(int* a ,int* b,int* c,int N)
{
    std::clock_t start;
    double duration;
    start = std::clock();

    // allocate memory on GPU
    CudaArray<int> dev_a(N);
    CudaArray<int> dev_b(N);
    CudaArray<int> dev_c(N);

    // copy 2 arrays to device memory
    dev_a.set(a,N);
    dev_b.set(b,N);

    // <<< first element is the # of parallel blocks to launch
    // second >>> the # of threads per block
    VecAdd<<<1, N>>>(dev_a.getData(), dev_b.getData(), dev_c.getData());

    // copy from device to host
    dev_c.get(c,N);
    //    cudaMemcpy(c, dev_c.getData(), N * sizeof(N), cudaMemcpyDeviceToHost);


    std::cout << "DONE INT" << "\n";
    duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;
    for (int i = 0; i < N; i++) {
        std::cout << a[i] << " + " << b[i] << " = " << c[i] << "\n";
    }
    std::cout<<"printf: "<< duration <<'\n';

}

void doVectorAddition(float* a ,float* b,float* c,int N)
{
    std::clock_t start;
    double duration;
    start = std::clock();

    // allocate memory on GPU
    CudaArray<float> dev_a(N);
    CudaArray<float> dev_b(N);
    CudaArray<float> dev_c(N);

    // copy 2 arrays to device memory
    dev_a.set(a,N);
    dev_b.set(b,N);

    // <<< first element is the # of parallel blocks to launch
    // second >>> the # of threads per block
    VecAdd<<<1, N>>>(dev_a.getData(), dev_b.getData(), dev_c.getData());

    // copy from device to host
    dev_c.get(c,N);

    std::cout << "DONE FLOAT" << "\n";
    duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;
    for (int i = 0; i < N; i++) {
        std::cout << a[i] << " + " << b[i] << " = " << c[i] << "\n";
    }
    std::cout<<"printf: "<< duration <<'\n';

}
