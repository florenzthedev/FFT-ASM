# FFT-ASM
An optimized implementation of the fast Fourier transform written in x86-64 assembly that utilizes SSE/SIMD. 

This implementation utilizes SSE2 features to load and process both parts of complex numbers at the same time. It also includes other optimizations such as re-using calculated roots of unity across butterfly operations in the same pass and performing the FFT in-place. This function is callable from C and uses a standard C double complex array as input data, there is a C header `fft_asm.h` including a prototype and a simple wrapper function for safety. This is a decimation-in-time implementation that does expect the input set to be in bit-reversal-permutation order.

This implementation was written using AT&T syntax and compiled with `gcc -c -o fft.o fft.s`, it is compatible with `-fcx-limited-range`, `-fPIC`, and `-g`. After this it can be linked like a usual object file.

A small demo program is included for testing, run `make` from inside of the `demo` folder. The resulting executable can be run with `./demo [filename]` where the file has a list of complex numbers, one on each line separated by a comma eg `1.23,4.56`. The demo program handles bit-reversal-permutation ordering.
