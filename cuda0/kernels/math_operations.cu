#include <cuda_runtime.h>
#include "../include/cuda_fd_funcs.h"
#include <iostream>
#include <ctime>



__global__ void VecAdd(int* A, int* B, int* C)
{
    int i = threadIdx.x;
    C[i] = A[i] + B[i];
}

__global__ void VecAdd(float* A, float* B, float* C)
{
    int i = threadIdx.x;
    C[i] = A[i] + B[i];
}

__global__ void MatAdd(float** A, float **B,
                       float** C)
{
    int i = threadIdx.x;
    int j = threadIdx.y;
    C[i][j] = A[i][j] + B[i][j];
}

__global__ void MatAdd(int** A, int **B,
                       int** C)
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

      int *dev_a;
      int *dev_b;
      int *dev_c;

      // allocate memory on GPU
      cudaMalloc((void**)&dev_a, N * sizeof(int));
      cudaMalloc((void**)&dev_b, N * sizeof(int));
      cudaMalloc((void**)&dev_c, N * sizeof(int));

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

      std::cout << "DONE INT" << "\n";
      duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;
      std::cout<<"printf: "<< duration <<'\n';

      cudaFree(dev_a);
      cudaFree(dev_b);
      cudaFree(dev_c);
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
