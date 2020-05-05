#include <cuda_runtime.h>
#include "../include/cuda_fd_funcs.h"
#include "../include/CudaArray.h"
#include <iostream>
#include <ctime>


__global__ void convertRGBtoGrayScale(uint8_t* src, uint8_t* dst,int width,int height)
{
    int x = threadIdx.x+ blockIdx.x* blockDim.x;
    int y = threadIdx.y+ blockIdx.y* blockDim.y;
    if(x < width && y < height) {
        int grayOffset= y*width + x;// one can think of the RGB image having
        int rgbOffset= grayOffset*3;// CHANNEL times columns than the gray scale
        unsigned char r =  src[rgbOffset]; // red value for pixel
        unsigned char g = src[rgbOffset+ 2]; // green value for pixel
        unsigned char b = src[rgbOffset+ 3]; // blue value for pixel// perform the rescaling and store it// We multiply by floating point constants
        dst[grayOffset] = 0.21f*r + 0.71f*g + 0.07f*b;
    }
}
void h_convertRGBtoGrayScale(uint8_t* src,uint8_t* dst,int && width, int&& height){
    assert(src);
    assert(dst);
    CudaArray<uint8_t> dev_src(width*height*3);
    CudaArray<uint8_t> dev_dst(width*height);
    dev_src.set(src,width*height*3);
    dev_dst.set(dst,width*height);
    const int BS = 32;
    const dim3 blockSize(BS, BS);
    const dim3 gridSize((width / BS) + 1, (height / BS) + 1);
    convertRGBtoGrayScale<<<gridSize, blockSize>>>(dev_src.getData(), dev_dst.getData(), width,height);
    dev_dst.get(dst,width*height);


}



