# Copyright (c) 2023 Zachary Todd Edwards
# MIT License

.data
TAU:
  .double -6.28318530717958647692
X:
  .quad 0
N:
  .quad 0
exponent:
  .double 0
temp:
  .double 0

.text
.global fft_asm
# Arguments:
#   rdi - pointer to start of double complex array with input values, will be overwritten with results
#   rsi - the number of complex numbers in array pointed to by rdi
fft_asm:
  push  %r12
  push  %r13
  push  %r14
  push  %r15
  # Register usage:
  #   r11 - temporary, usually the offset between the even/odd pairings 
  #   r12 - current block size, starts with 2 and doubles each pass until size of N
  #   r13 - current element pair in block, starts at 0 and counts to r12/2
  #   r14 - start of current block, starts at 0 and has r12 added each pass until size N
  #   r15 - index of start of current element pair
  #   xmm0  - the real part of omega for the current iteration
  #   xmm1  - the imaginary part of omega for current iteration
  #   xmm2  - temporary, usually the last loaded odd real portion from the array
  #   xmm3  - temporary, usually the last loaded odd imaginary portion from the array
  #   xmm4  - temporary, usually scratch space for complex multiplication
  #   xmm5  - temporary, usually scratch space for complex multiplication
  #   xmm6  - temporary, usually the last loaded even real portion from the array
  #   xmm7  - temporary, usually the last loaded even imaginary portion from the array  
  movq  %rdi,   X(%rip)
  movq  %rsi,   N(%rip)
  movq  $2,     %r12

block_loop:
  xorl  %r13d,  %r13d # Its how Intel and AMD recommend setting a register to 0

element_loop:
  xorl  %r14d,  %r14d

  # Calculate omega
  movsd TAU(%rip),  %xmm0
  cvtsi2sdq %r13,   %xmm1
  mulsd     %xmm1,  %xmm0
  cvtsi2sdq %r12,    %xmm1
  divsd     %xmm1,  %xmm0
  movsd     %xmm0,  exponent(%rip)
  call sin
  movsd %xmm0,          temp(%rip)
  movsd exponent(%rip), %xmm0
  call cos
  movsd temp(%rip), %xmm1

  # Reload N from memory so we don't have to again later
  movq  N(%rip), %rsi

pair_loop:
  # Load next even entry from array 
  xorl  %r15d,          %r15d
  addq  %r13,           %r15
  addq  %r14,           %r15
  shl   $1,             %r15
  movq  X(%rip),        %rdi
  movsd (%rdi,%r15,8),  %xmm6 # real portion, the C99 standard does guarantee this ordering
  movsd 8(%rdi,%r15,8), %xmm7 # imaginary portion

  # Load next odd entry from array
  addq  %r12,   %r15            # no need to /2 because we are working with complex addresses
  movsd (%rdi,%r15,8),  %xmm2
  movsd 8(%rdi,%r15,8), %xmm3

  # Multiply odd element by omega, (a + b)(c + d)
  movsd %xmm3,  %xmm4
  mulsd %xmm0,  %xmm4 # ad
  movsd %xmm1,  %xmm5
  mulsd %xmm2,  %xmm5 # bc
  addsd %xmm5,  %xmm4 # ad + bc
  mulsd %xmm0,  %xmm2 # ac
  mulsd %xmm1,  %xmm3 # bd              
  subsd %xmm3,  %xmm2 # ac + bd (i^2)
  movsd %xmm4,  %xmm3
  # omega * odd now in xmm2 and xmm3 (i)

  # even - omega * odd
  movsd %xmm6,  %xmm4
  movsd %xmm7,  %xmm5
  subsd %xmm2,  %xmm4
  subsd %xmm3,  %xmm5
  movsd %xmm4,  (%rdi,%r15,8)  
  movsd %xmm5,  8(%rdi,%r15,8) 

  # even + omega * odd
  addsd %xmm2,  %xmm6
  addsd %xmm3,  %xmm7
  subq  %r12,   %r15
  movsd %xmm6,  (%rdi,%r15,8)  
  movsd %xmm7,  8(%rdi,%r15,8) 

  addq  %r12, %r14
  cmpq  %rsi, %r14
  jl    pair_loop

  inc   %r13
  movq  %r13, %rax
  shl   $1,   %rax
  cmpq  %r12, %rax
  jl    element_loop

  shl   $1, %r12
  cmpq  %rsi, %r12
  jle   block_loop
  
  pop %r15
  pop %r14
  pop %r13
  pop %r12
  ret
