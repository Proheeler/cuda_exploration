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

//      int *dev_a;
//      int *dev_b;
//      int *dev_c;

      // allocate memory on GPU
      CudaSmartPtr<int> dev_a(N);
      CudaSmartPtr<int> dev_b(N);
      CudaSmartPtr<int> dev_c(N);
//      cudaMalloc((void**)&dev_a, N * sizeof(int));
//      cudaMalloc((void**)&dev_b, N * sizeof(int));
//      cudaMalloc((void**)&dev_c, N * sizeof(int));

      // copy 2 arrays to device memory
      cudaMemcpy(dev_a.get(), a, N * sizeof(N), cudaMemcpyHostToDevice);
      cudaMemcpy(dev_b.get(), b, N * sizeof(N), cudaMemcpyHostToDevice);

      // <<< first element is the # of parallel blocks to launch
      // second >>> the # of threads per block
      VecAdd<<<1, N>>>(dev_a.get(), dev_b.get(), dev_c.get());

      // copy from device to host
      cudaMemcpy(c, dev_c.get(), N * sizeof(N), cudaMemcpyDeviceToHost);

//       for (int i = 0; i < N; i++) {
//           std::cout << a[i] << " + " << b[i] << " = " << c[i] << "\n";
//       }

      std::cout << "DONE INT" << "\n";
      duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;
      std::cout<<"printf: "<< duration <<'\n';

//      cudaFree(dev_a);
//      cudaFree(dev_b);
//      cudaFree(dev_c);
}

void doVectorAddition(float* a ,float* b,float* c,int N)
{
      std::clock_t start;
      double duration;
      start = std::clock();

      float *dev_a;
      float *dev_b;
      float *dev_c;

      // allocate memory on GPU
      cudaMalloc((void**)&dev_a, N * sizeof(float));
      cudaMalloc((void**)&dev_b, N * sizeof(float));
      cudaMalloc((void**)&dev_c, N * sizeof(float));

      // copy 2 arrays to device memory
      cudaMemcpy(dev_a, a, N * sizeof(N), cudaMemcpyHostToDevice);
      cudaMemcpy(dev_b, b, N * sizeof(N), cudaMemcpyHostToDevice);

      // <<< first element is the # of parallel blocks to launch
      // second >>> the # of threads per block
      VecAdd<<<1, N>>>(dev_a, dev_b, dev_c);

      // copy from device to host
      cudaMemcpy(c, dev_c, N * sizeof(N), cudaMemcpyDeviceToHost);

//       for (int i = 0; i < N; i++) {
//           std::cout << a[i] << " + " << b[i] << " = " << c[i] << "\n";
//       }

      std::cout << "DONE FLOAT" << "\n";
      duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;
      std::cout<<"printf: "<< duration <<'\n';

      cudaFree(dev_a);
      cudaFree(dev_b);
      cudaFree(dev_c);
}
