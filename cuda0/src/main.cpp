
#include "../include/cuda_fd_funcs.h"

#include <random>
#include <cuda.h>
auto RandomFloat(float a, float b) -> float {
    float random = ((float) rand()) / (float) RAND_MAX;
    float diff = b - a;
    float r = random * diff;
    return a + r;
}
auto main(int argc, char **argv) -> int
{
    doCudaKernel(argc,argv);
    int N=10;
    int a[N];
    int b[N];
    int c[N];
    for (int i = 0; i < N; i++) {
        a[i] = -1;
        b[i] = i * i;
    }
    float a1[N];
    float b1[N];
    float c1[N];
    for (int i = 0; i < N; i++) {
        a1[i] = -1;
        b1[i] = RandomFloat(static_cast<float>(i),static_cast<float>(i+1)) * RandomFloat(static_cast<float>(i),static_cast<float>(i+1));
    }
//    doVectorAddition(a,b,c,N);
//    doVectorAddition(a1,b1,c1,N);
//    int devID;
//    cudaDeviceProp props;






}
