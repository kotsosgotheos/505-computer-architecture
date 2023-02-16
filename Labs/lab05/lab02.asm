# lab02.asm - Pairwise swap in an array of 32bit integers
# coded in  MIPS assembly using MARS
# for MYΥ-505 - Computer Architecture, Fall 2021
# Department of Computer Science and Engineering, University of Ioannina
# Instructor: Aris Efthymiou

.globl swapArray # declare the label as global for munit

.data
    array: .word 5, 6, 7, 8, 1, 2, 3, 4

.text
    la $a0, array
    li $a1, 8 

swapArray:
    beq $a1, $zero, exit # Exits if $a1 is zero
    xor $t0, $t0, $t0    # Zeros out $t0
    srl $t5, $a1, 1      # Finds the mid of $a0, ($a1 / 2)

loop:
    sll $t1, $t0, 2      # Fixes the memory offset
    add $t1, $a0, $t1    # Reads the first half of the array
    sll $t2, $t5, 2      # Fixes the memory offset
    add $t2, $t1, $t2    # Reads the second half of the array

    lw $t3, 0x00($t1)    # Load value of $t1 into $t3
    lw $t4, 0x00($t2)    # Load value of $t2 into $t4
    sw $t3, 0x00($t2)    # Store value of $t3 into &($t2)
    sw $t4, 0x00($t1)    # Store value of $t4 into &($t1)

    addi $t0, $t0, 1     # Updates the counter
    bne $t0, $t5, loop   # Jumps while $t0 is not $a1/2

exit:
    addiu $v0, $zero, 10 # system service 10 is exit
    syscall              # we are outta here.
