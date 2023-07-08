// Copyright (c) 2023 Zachary Todd Edwards
// MIT License

#ifndef FFT_ASM_INCLUDED
#define FFT_ASM_INCLUDED

#include <complex.h>

/**
 * @brief The fast Fourier transform. Performed in-place. This is a
 * decimation-in-time implementation that expects the input set to be in
 * bit-reversal-permutation order.
 *
 * @param X The input set, will be overwritten by results.
 * @param N The size of the input set, must be a power of two greater than 0.
 */
void fft_asm(double complex *X, long N);

/**
 * @brief Performs the Fourier transform. This interface is intended to be used
 * with dynamic loading. This function handles putting the input into
 * bit-reversal-permutation order.
 *
 * @param X The input set, will be overwritten by results.
 * @param N The size of the input set, must be a power of two greater than 0.
 *
 * @return 0 on success, this implementation will never reasonably fail.
 */
int fourier_transform(double complex *X, long N);

#endif  // FFT_ASM_INCLUDED