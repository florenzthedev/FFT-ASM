# FFT-ASM
An optimized implementation of the fast Fourier transform written in x86-64 assembly that utilizes SSE/SIMD. 

This implementation utilizes SSE2 to speed up complex numbers manipulation. Other optimizations such as re-using calculated roots of unity across butterfly operations in the same pass or performing the FFT in-place are also utilized. This function is compatible with C, taking a standard C `double complex` array as input. It is accessible through a provided C header `fft_asm.h` that has a prototype and a simple wrapper function for additional safety. This is a decimation-in-time implementation that does expect the input set to be in bit-reversal-permutation order.

This implementation was written using AT&T syntax and is primarily intended to be compiled with `gcc`. A shared object library can be made by running `make` in the root project directory. This can then be linked against by adding the resulting `libfft_asm.so` to your library search path and using the `-lfft_asm` flag. Alternatively the source files can be integrated into a larger project directly.

A small demo program is included for testing, run `make demo` from inside of the root project folder. The resulting executable can be run with `./demo [filename]` from inside of the `demo` directory. The file is expected to be a plain text list of complex numbers, one on each line separated by a comma eg `1.23,4.56`. The demo program handles bit-reversal-permutation ordering.
