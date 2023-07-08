#include "fft_s.h"

#include <assert.h>

int fourier_transform(double complex* X, long N) {
  assert((N & (N - 1)) == 0);
  assert(N != 0);
  bit_reversal_permutation(X, N);
  fft_asm(X, N);
  return 0;
}

//TODO: Rewrite these in assembly.
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

void bit_reversal_permutation(double complex* x, int N) {
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