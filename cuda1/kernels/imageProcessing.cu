#include <cuda_runtime.h>
#include "../include/cuda_fd_funcs.h"
#include "../include/CudaArray.h"
#include <iostream>
#include <ctime>


__global__ void convertRGBtoGrayScale(uint8_t* src, uint8_t* dst,int width,int height, int channels)
{
    int x = threadIdx.x+ blockIdx.x* blockDim.x;
    int y = threadIdx.y+ blockIdx.y* blockDim.y;
    if(x < width && y < height) {
        int grayOffset= y*width + x;// one can think of the RGB image having
        int rgbOffset= grayOffset*channels;// CHANNEL times columns than the gray scale
        unsigned char r =  src[rgbOffset]; // red value for pixel
        unsigned char g = src[rgbOffset+ 2]; // green value for pixel
        unsigned char b = src[rgbOffset+ 3]; // blue value for pixel// perform the rescaling and store it// We multiply by floating point constants
        dst[grayOffset] = 0.21f*r + 0.71f*g + 0.07f*b;
    }
}

__global__ void blurKernel(uint8_t *out, uint8_t *in, int width, int height,int BLUR_SIZE=5) {
  int col = blockIdx.x * blockDim.x + threadIdx.x;
  int row = blockIdx.y * blockDim.y + threadIdx.y;

  if (col < width && row < height) {
    int pixVal = 0;
    int pixels = 0;

    // Get the average of the surrounding BLUR_SIZE x BLUR_SIZE box
    for (int blurrow = -BLUR_SIZE; blurrow < BLUR_SIZE + 1; ++blurrow) {
      for (int blurcol = -BLUR_SIZE; blurcol < BLUR_SIZE + 1; ++blurcol) {

        int currow = row + blurrow;
        int curcol = col + blurcol;
        // Verify we have a valid image pixel
        if (currow > -1 && currow < height && curcol > -1 &&
            curcol < width) {
          pixVal += in[currow * width + curcol];
          pixels++; // Keep track of number of pixels in the avg
        }
      }
    }

    // Write our new pixel value out
    out[row * width + col] = (unsigned char)(pixVal / pixels);
  }
}
void h_blurImage(uint8_t* src,uint8_t* dst,int TileSize,int && width, int&& height,int blurSize)
{
    assert(src);
    assert(dst);
    CudaArray<uint8_t> dev_src(width*height);
    CudaArray<uint8_t> dev_dst(width*height);
    dev_src.set(src,width*height);
    dev_dst.set(dst,width*height);
    const dim3 blockSize(TileSize, TileSize);
    const dim3 gridSize((width / TileSize) + 1, (height / TileSize) + 1);
    blurKernel<<<gridSize, blockSize>>>(dev_dst.getData(),dev_src.getData(), width,height,blurSize);
    dev_dst.get(dst,width*height);
}
void h_convertRGBtoGrayScale(uint8_t* src,uint8_t* dst,int TileSize,int && width, int&& height,int && channels){
    assert(src);
    assert(dst);
    CudaArray<uint8_t> dev_src(width*height*channels);
    CudaArray<uint8_t> dev_dst(width*height);
    dev_src.set(src,width*height*channels);
    dev_dst.set(dst,width*height);
    const dim3 blockSize(TileSize, TileSize);
    const dim3 gridSize((width / TileSize) + 1, (height / TileSize) + 1);
    convertRGBtoGrayScale<<<gridSize, blockSize>>>(dev_src.getData(), dev_dst.getData(), width,height,channels);
    dev_dst.get(dst,width*height);


}



