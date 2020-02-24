#ifndef CUDA_FD_FUNCS_H
#define CUDA_FD_FUNCS_H

// System includes
#include <stdio.h>
#include <assert.h>
#include <cuda_runtime.h>
#include <iostream>
#include <ctime>
void doCudaKernel(int argc, char **argv);
void doVectorAddition(int *a, int *b, int *c, int N);
void doVectorAddition(float* a ,float* b,float* c,int N);

template<typename T>
class CudaSmartPtr
{
public:
    CudaSmartPtr(int N){
        cudaMalloc((void**)&ptr, N * sizeof(T));
    }
    ~CudaSmartPtr(){
        std::cout<<"Ptr freed"<<std::endl;
        cudaFree(ptr);
    }
    T* get(){
        return ptr;
    }
private:
    T* ptr;
};

#endif // CUDA_FD_FUNCS_H
