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


template <typename T>
class CudaArray
{
// public functions
public:
    explicit CudaArray()
        : start_(0),
          end_(0)
    {}

    // constructor
    explicit CudaArray(size_t size)
    {
        allocate(size);
    }
    // destructor
    ~CudaArray()
    {
        free();
    }

    // resize the vector
    void resize(size_t size)
    {
        free();
        allocate(size);
    }

    // get the size of the array
    size_t getSize() const
    {
        return end_ - start_;
    }

    // get data
    T* getData() const
    {
        return start_;
    }

    T* getData()
    {
        return start_;
    }

    // set
    void set(const T* src, size_t size)
    {
        size_t min = std::min(size, getSize());
        cudaError_t result = cudaMemcpy(start_, src, min * sizeof(T), cudaMemcpyHostToDevice);
        if (result != cudaSuccess)
        {
            throw std::runtime_error("failed to copy to device memory");
        }
    }
    // get
    void get(T* dest, size_t size)
    {
        size_t min = std::min(size, getSize());
        cudaError_t result = cudaMemcpy(dest, start_, min * sizeof(T), cudaMemcpyDeviceToHost);
        if (result != cudaSuccess)
        {
            throw std::runtime_error("failed to copy to host memory");
        }
    }


// private functions
private:
    // allocate memory on the device
    void allocate(size_t size)
    {
        cudaError_t result = cudaMalloc((void**)&start_, size * sizeof(T));
        if (result != cudaSuccess)
        {
            start_ = end_ = 0;
            throw std::runtime_error("failed to allocate device memory");
        }
        end_ = start_ + size;
    }

    // free memory on the device
    void free()
    {
        if (start_ != 0)
        {
            cudaFree(start_);
            start_ = end_ = 0;
        }
    }

    T* start_;
    T* end_;
};

#endif // CUDA_FD_FUNCS_H
