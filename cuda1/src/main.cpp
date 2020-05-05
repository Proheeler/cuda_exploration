
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
    {
        Profiler p;
        img.convertTo(QImage::Format::Format_RGB888);
    }
    img.save("/home/dev/development/cuda_exploration/build/test1.jpg");
    std::cout<<img.depth()<<std::endl;
    uint8_t* dst = new uint8_t[img.width()*img.height()];
    h_convertRGBtoGrayScale(img.bits(),dst,16,img.width(),img.height(),img.depth()/8);
    {
        Profiler p;
        h_convertRGBtoGrayScale(img.bits(),dst,16,img.width(),img.height(),img.depth()/8);
    }
    QImage frame = QImage(dst, img.width(), img.height(), img.width(), QImage::Format::Format_Grayscale8);
    frame.save("/home/dev/development/cuda_exploration/build/test.jpg");
    delete[] dst;
}
