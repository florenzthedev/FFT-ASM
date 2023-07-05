.data
TAU:
  .double 6.28318530717958647692
exponent:
  .double 0
temp:
  .double 0

.text
.global fft
# Arguments:
#   rdi - pointer to start of double complex array with input values, will be overwritten with results
#   rsi - the number of complex numbers in array pointed to by rdi
fft:
  push  %r12
  push  %r13
  push  %r14
  push  %r15
  # Register usage:
  #   r12 - current block size, starts with 2 and doubles each pass until size of N
  #   r13 - start of current block, starts at 0 and has r8 added each pass until size N
  #   r14 - current element pair in block, starts at 0 and counts to r8/2
  #   r15 - index of start of current element pair
  #   xmm0  - the real part of omega for the current iteration
  #   xmm1  - the imaginary part of omega for current iteration
  movq  $2, %r12
  movq  $0, %r13
  movq  $0, %r14
  
  # Calculate omega
  movsd TAU(%rip),  %xmm0
  cvtsi2sdq %r10,   %xmm1
  mulsd     %xmm1,  %xmm0
  cvtsi2sdq %r8,    %xmm1
  divsd     %xmm1,  %xmm0
  movsd     %xmm0,  exponent(%rip)
  call cos
  movsd %xmm0,          temp(%rip)
  movsd exponent(%rip), %xmm0
  call sin
  movsd temp(%rip), %xmm1

  pop %r15
  pop %r14
  pop %r13
  pop %r12
  ret
