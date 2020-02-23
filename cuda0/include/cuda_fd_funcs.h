#ifndef CUDA_FD_FUNCS_H
#define CUDA_FD_FUNCS_H

// System includes
#include <stdio.h>
#include <assert.h>

void doCudaKernel(int argc, char **argv);
void doVectorAddition(int *a, int *b, int *c, int N);
void doVectorAddition(float* a ,float* b,float* c,int N);
#endif // CUDA_FD_FUNCS_H
