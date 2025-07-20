   .data
      result: .word 0               # Reserve space to store the multiplication result
    .text
    .globl _start
    .macro multiply_add_shift, result, multiplicand, multiplier
    # Initialize result to 0
    li \result, 0
    # Iterate through each bit of the multiplier
    .set loop_counter, 32            # Assuming 32-bit multiplier
    li a1, loop_counter
loop:
    # Check if the least significant bit of the multiplier is set
    and t0, \multiplier, 1
    beq t0, zero, skip_add
    # Add the current value of the multiplicand to the result
    add \result, \result, \multiplicand
skip_add:
    # Shift multiplicand left (equivalent to multiplying by 2)
    sll \multiplicand, \multiplicand, 1
    # Shift multiplier right (to check the next bit)
    srl \multiplier, \multiplier, 1
    # Decrement the loop counter
    addi a1, a1, -1
    bnez a1, loop
    .endm
_start:
.option  norelax
la  gp, __global_pointer$
    # Load values into registers for multiplication
    li t1, 6                  # Load multiplicand (6) into t1
    li t2, 7                  # Load multiplier (7) into t2
    # Use the macro to perform multiplication
    multiply_add_shift t3, t1, t2
    # Store the result in memory for verification
    la t0, result             # Load address of result into t0
    sw t3, 0(t0)              # Store the value in t3 (result) to memory
    mv a0, t3
    call itoa
    # Exit the program
    li a7, 93                 # Load exit ecall code
    ecall                     # Make the exit system call to terminate the program

