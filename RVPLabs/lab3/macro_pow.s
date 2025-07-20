    .section .data
    result:  .word 0  # Memory space to store the result
    .section .text
    .globl _start
    # Macro Definition: Computes result = base ^ exponent
    .macro power_mult result, base, exponent
        li      \result, 1          # Initialize result with 1
        beqz    \exponent, end_\@   # If exponent is 0, jump to end (result = 1)
    loop_\@:
        mul     \result, \result, \base # result *= base
        addi    \exponent, \exponent, -1 # Decrement exponent
        bnez    \exponent, loop_\@     # Repeat until exponent == 0
    end_\@:
    .endm

_start:
    .option  norelax
    la  gp, __global_pointer$
    # Load base and exponent
    li      t1, 3           # t1 = base = 3
    li      t2, 4           # t2 = exponent = 4
    # Call the power_mult macro: power_mult t3, t1, t2
    power_mult t3, t1, t2
    # Store result in memory
    la      t0, result      # Load address of result in t0
    sw      t3, 0(t0)       # Store t3 (result) to memory
    # Exit the program (using an environment call)
    li      a7, 93          # ECALL for exit
    ecall

