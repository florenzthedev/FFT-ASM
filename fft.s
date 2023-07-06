# Copyright (c) 2023 Zachary Todd Edwards
# MIT License

.data
.align 16
NEGAPD:
  .double -0.0, 0.0
TAU:
  .double -6.28318530717958647692
X:
  .quad 0
N:
  .quad 0
exp:
  .double 0
temp:
  .double 0

.text
.global fft_asm
# Arguments:
#   rdi - pointer to start of double complex array with input values, will be overwritten with results
#   rsi - the number of complex numbers in array pointed to by rdi
fft_asm:
  push    %r12
  push    %r13
  push    %r14
  push    %r15

  # Register usage:
  #   r12 - current block size, starts with 2 and doubles each pass until size of N
  #   r13 - current element pair in block, starts at 0 and counts to r12/2
  #   r14 - start of current block, starts at 0 and has r12 added each pass until size N
  #   r15 - index of start of current element pair
  #   xmm0  - Omega
  #   xmm1  - Even complex number entry in pair
  #   xmm2  - Odd complex number entry in pair
  #   xmm3  - temporary, used for complex multiplication
  #   xmm4  - temporary, used for negating the i^2 portion of complex multiplication

  movq  %rdi,   X(%rip)
  movq  %rsi,   N(%rip)
  movq  $2,     %r12

block_loop:
  xorl  %r13d,  %r13d # set register to 0

element_loop:
  xorl  %r14d,  %r14d

  # Calculate omega
  movsd     TAU(%rip),  %xmm0
  cvtsi2sdq %r13,       %xmm1
  mulsd     %xmm1,      %xmm0
  cvtsi2sdq %r12,       %xmm1
  divsd     %xmm1,      %xmm0
  movsd     %xmm0,      exp(%rip)
  call sin
  movsd     %xmm0,      temp(%rip)
  movsd     exp(%rip),  %xmm0
  call cos
  movhpd    temp(%rip), %xmm0

  # Reload N from memory so we don't have to again later
  movq  N(%rip), %rsi

pair_loop:
  # Load next even entry from array 
  xorl    %r15d,          %r15d
  addq    %r13,           %r15
  addq    %r14,           %r15
  shl     $1,             %r15
  movq    X(%rip),        %rdi
  # the C99 standard does guarantee [real, double] ordering
  movupd  (%rdi,%r15,8),  %xmm1 

  # Load next odd entry from array
  addq    %r12,           %r15
  movupd  (%rdi,%r15,8),  %xmm2

  # Multiply odd element by omega
  movapd  %xmm2,        %xmm3
  movlhps %xmm2,        %xmm2
  movhlps %xmm3,        %xmm3
  mulpd   %xmm0,        %xmm2
  mulpd   %xmm0,        %xmm3
  shufpd  $0x1,         %xmm3,  %xmm3
  
  xorpd   NEGAPD(%rip), %xmm3
  addpd   %xmm3,        %xmm2

  # even - omega * odd
  movapd  %xmm1,  %xmm3
  subpd   %xmm2,  %xmm3
  movupd  %xmm3,  (%rdi,%r15,8)  
  
  # even + omega * odd
  addpd   %xmm2,  %xmm1
  subq    %r12,   %r15
  movupd  %xmm1,  (%rdi,%r15,8)  

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
  
  pop     %r15
  pop     %r14
  pop     %r13
  pop     %r12
  ret
