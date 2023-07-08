#include "fft_s.h"
#include <assert.h>

int fourier_transform(double complex *X, long N) {
  assert((N & (N - 1)) == 0);
  assert(N != 0);
  fft_asm(X, N);
  return 0;
}