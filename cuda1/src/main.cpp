
#include "../include/cuda_fd_funcs.h"

#include <random>
#include <cuda.h>
#include <iostream>
#include <QImage>
#include <chrono>
class Profiler
{
public:
    Profiler(){
        start = std::chrono::system_clock::now();
    }
    ~Profiler(){
        std::chrono::time_point<std::chrono::system_clock> end = std::chrono::system_clock::now();
        std::chrono::duration<float> difference = end - start;
        std::cout<<difference.count()*1000<<std::endl;
    }
private:
    std::chrono::time_point<std::chrono::system_clock> start;
};


auto main() -> int
{
    QImage img("/home/dev/development/cuda_exploration/build/SeaSunset.jpg");
    QImage img2("/home/dev/development/cuda_exploration/build/SeaSunset.jpg");
    {
        Profiler p;
        img2.convertTo(QImage::Format::Format_Grayscale8);
    }
    img.save("/home/dev/development/cuda_exploration/build/test_rgb.jpg");
    uint8_t* dst = new uint8_t[img.width()*img.height()];
    h_convertRGBtoGrayScale(img.bits(),dst,16,img.width(),img.height(),img.depth()/8);
    {
        Profiler p;
        h_convertRGBtoGrayScale(img.bits(),dst,16,img.width(),img.height(),img.depth()/8);
    }
    QImage frame = QImage(dst, img.width(), img.height(), img.width(), QImage::Format::Format_Grayscale8);
    frame.save("/home/dev/development/cuda_exploration/build/test_gray.jpg");
    uint8_t* dst_blur = new uint8_t[img.width()*img.height()];
    {
        Profiler p;
        h_blurImage(dst,dst_blur,16,img.width(),img.height(),5);
    }
    QImage frame_blur = QImage(dst_blur, img.width(), img.height(), img.width(), QImage::Format::Format_Grayscale8);
    frame_blur.save("/home/dev/development/cuda_exploration/build/test_blur.jpg");

    delete[] dst;
    delete [] dst_blur;
}
