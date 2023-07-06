// Copyright (c) 2023 Zachary Todd Edwards
// MIT License

#ifndef FFT_ASM_INCLUDED
#define FFT_ASM_INCLUDED
#include <assert.h>
#include <complex.h>

void fft_asm(double complex *X, long N);

void fft(double complex *X, long N) {
  assert((N & (N - 1)) == 0);
  fft_asm(X, N);
}

#endif  // FFT_ASM_INCLUDED