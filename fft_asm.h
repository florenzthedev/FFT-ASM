// Copyright (c) 2023 Zachary Todd Edwards
// MIT License

#ifndef FFT_ASM_INCLUDED
#define FFT_ASM_INCLUDED
#include <assert.h>
#include <complex.h>

/**
 * @brief The fast Fourier transform. Performed in-place. This is a
 * decimation-in-time implementation that expects the input set to be in
 * bit-reversal-permutation order.
 *
 * @param X The input set, will be overwritten by results.
 * @param N The size of the input set, must be a power of two.
 */
void fft_asm(double complex *X, long N);

/**
 * @brief A small wrapper function for fft_asm that asserts that the input size
 * given is a power of two. This is a decimation-in-time implementation that
 * expects the input set to be in bit-reversal-permutation order.
 *
 * @param X The input set, will be overwritten by results.
 * @param N The size of the input set, must be a power of two.
 */
void fft(double complex *X, long N) {
  assert((N & (N - 1)) == 0);
  fft_asm(X, N);
}

#endif  // FFT_ASM_INCLUDED