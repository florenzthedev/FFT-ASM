#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "fft_asm.h"

#define MAX_SAMPLES 127

unsigned int bit_length(unsigned int x) {
  unsigned int bits = 0;
  while (x) {
    bits++;
    x >>= 1;
  }
  return bits;
}

unsigned int bit_reverse(unsigned int x, unsigned int n) {
  unsigned int r = 0;
  for (unsigned int i = 0; i < n; ++i) {
    if (x & (1 << i)) r |= 1 << ((n - 1) - i);
  }
  return r;
}

void bit_reversal_permutation(double complex *x, int N) {
  assert((N & (N - 1)) == 0);  // Must be a power of two

  // Don't forget bit_length is one indexed!
  int bl = bit_length(N) - 1;

  // We can skip the first and last index, they never need to be moved
  for (int i = 1; i < N - 1; i++) {
    int ri = bit_reverse(i, bl);
    if (i < ri) {
      double complex temp = x[i];
      x[i] = x[ri];
      x[ri] = temp;
    }
  }
}

int main(int argc, char *argv[]){
  if(argc != 2){
    printf("Usage %s [filename]\n",argv[0]);
    return EXIT_FAILURE;
  }

  FILE* fp = fopen(argv[1], "r");
  if(fp == NULL){
    printf("Error opening file.");
    return EXIT_FAILURE;
  }

  double complex x[MAX_SAMPLES];
  double temp_real, temp_imag;
  int N = 0;
  while(fscanf(fp, "%lf,%lf", &temp_real, &temp_imag) > 0 
        && N < MAX_SAMPLES) {
        x[N++] = CMPLX(temp_real,temp_imag);
    }
  fclose(fp);

  double complex X[N];
  for(int j = 0; j < N; j++)
  	X[j] = x[j];
  bit_reversal_permutation(X,N);

  fft(X,N);

  printf("x:\n");
  for(int j = 0; j < N; j++)
    printf("%f%+fi\n",creal(x[j]),cimag(x[j]));
  printf("X:\n");
  for(int j = 0; j < N; j++)
    printf("%f%+fi\n",creal(X[j]),cimag(X[j]));

  return EXIT_SUCCESS;
}
