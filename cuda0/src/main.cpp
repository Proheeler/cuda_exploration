
#include "../include/cuda_fd_funcs.h"
#include <random>
float RandomFloat(float a, float b) {
    float random = ((float) rand()) / (float) RAND_MAX;
    float diff = b - a;
    float r = random * diff;
    return a + r;
}
int main(int argc, char **argv)
{
    //    doCudaKernel(argc,argv);
    int N=100000;
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
        b1[i] = RandomFloat(i,i+1) * RandomFloat(i,i+1);
    }

    doVectorAddition(a1,b1,c1,N);
    doVectorAddition(a,b,c,N);



}
