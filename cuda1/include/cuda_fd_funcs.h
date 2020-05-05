#ifndef CUDA_FD_FUNCS_H
#define CUDA_FD_FUNCS_H
#include <cstdint>
// System includes

void h_convertRGBtoGrayScale(uint8_t* src,uint8_t* dst,int TileSize,int && width, int&& height,int && channels);


#endif // CUDA_FD_FUNCS_H
