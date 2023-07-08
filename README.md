# FFT-ASM
An optimized implementation of the fast Fourier transform written in x86-64 assembly that utilizes SSE/SIMD. 

This implementation utilizes SSE2 to speed up complex numbers manipulation. Other optimizations such as re-using calculated roots of unity across butterfly operations in the same pass or performing the FFT in-place are also utilized. This function is compatible with C, taking a standard C `double complex` array as input. It is accessible through a provided C header `fft_s.h` that has a prototype and a simple wrapper function for additional safety. This is a decimation-in-time implementation that does expect the input set to be in bit-reversal-permutation order.

This implementation is thread-safe with respect to its own operation. Multiple instances of the FFT function can safely run concurrently on separate threads, provided each instance operates on a different dataset. However, it does not include any internal synchronization and does not support concurrent calls operating on the same data. 

This implementation was written using AT&T syntax and is primarily intended to be compiled with `gcc`. A shared object library can be made by running `make` in the root project directory. This can then be linked against by adding the resulting `libfft_s.so` to your library search path and using the `-lfft_s` flag. Alternatively the source files can be integrated into a larger project directly or the library dynamically loaded.
