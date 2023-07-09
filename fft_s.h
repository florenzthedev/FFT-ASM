// Copyright (c) 2023 Zachary Todd Edwards
// MIT License

#ifndef FFT_S_INCLUDED
#define FFT_S_INCLUDED

#include <complex.h>

/**
 * @brief The fast Fourier transform. Performed in-place. This is a
 * decimation-in-time implementation that expects the input set to be in
 * bit-reversal-permutation order.
 *
 * @param X The input set, will be overwritten by results.
 * @param N The size of the input set, must be a power of two greater than 0.
 * @param aux Auxillary information, unused in this implementation.
 */
void fft_asm(double complex *X, long N, int aux);

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

/**
 * @brief Reorders the input dataset into bit-reversal-permutation for use with
 * the FFT.
 *
 * @param x Input dataset.
 * @param N Size of input dataset.
 */
void bit_reversal_permutation(double complex* x, int N);

#endif  // FFT_S_INCLUDED