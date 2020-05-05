
#include "../include/cuda_fd_funcs.h"

#include <random>
#include <cuda.h>
#include <iostream>
#include <QImage>
auto main() -> int
{
QImage img("/home/dev/development/cuda_exploration/build/05.jpeg");
img.convertTo(QImage::Format::Format_RGB888);
img.save("/home/dev/development/cuda_exploration/build/test1.jpg");
uint8_t* dst = new uint8_t[img.width()*img.height()];
h_convertRGBtoGrayScale(img.bits(),dst,img.width(),img.height());


QImage frame = QImage(dst, img.width(), img.height(), img.width(), QImage::Format::Format_Grayscale8);
frame.save("/home/dev/development/cuda_exploration/build/test.jpg");
delete[] dst;
}
