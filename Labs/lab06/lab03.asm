# lab03.asm - Recursive palindrome string tester
#   coded in  MIPS assembly using MARS
# for MYΥ-505 - Computer Architecture, Fall 2021
# Department of Computer Science and Engineering, University of Ioannina
# Instructor: Aris Efthymiou

.globl pdrome

###############################################################################
.data
    anna:  .asciiz "anna"
    bobob: .asciiz "bobob"

###############################################################################
.text
    la $a0, anna
    addi $a1, $zero, 4
    jal pdrome
    add $s0, $v0, $zero  # keep the return value

    la $a0, bobob
    addi $a1, $zero, 5
    jal pdrome
    add $s1, $v0, $zero  # keep the return value
    # both s1 and s0 must be 1 here
    
    addiu $v0, $zero, 10 # system service 10 is exit
    syscall              # we are outa here.

pdrome:
###############################################################################
# Write you code here.
# Any code above the label pdrome is not executed by the tester! 
###############################################################################
    xor $v0, $v0, $v0            # Default return value as 0

    xor $t0, $t0, $t0            # Zero out $t0
    xor $t1, $t1, $t1            # and $t1
    slt $t0, $zero, $a1          # $t0 = 1 if $a1 is positive or zero
    bne $t0, $t1, next_letter    # Try next letter when pointers have NOT reached the middle yet

is_palindrome:
    addi $v0, $zero, 1           # We get here when pointers have reached the middle 
    jr $ra                       # and all letter pairs are equal

next_letter:
    lbu $t0, 0($a0)              # $t0 pointer advances from beginning to middle
    add $t1, $a0, $a1            # $t1 pointer advances from end to middle
    lbu $t1, -1($t1)             # Load value of *($a0 + $a1-1), e.g. on a 4 letter string we skip 3 chars -> $a1-1
    bne $t0, $t1, not_palindrome # Exit when any 2 character pairs are different

    # Store
    addi $sp, $sp, -12
    sw $ra, 8($sp)               # IP
    sw $a0, 4($sp)               # array
    sw $a1, 0($sp)               # size

    # Care that we may touch bytes before $a0
    addi $a1, $a1, -2            # Fix $a1 towards the middle.
                                 # We subtract by 2 because of the now reduced $a0
    addi $a0, $a0, 1             # Fix $a0 towards the middle
    jal pdrome

    # Restore
    lw $a1, 0($sp)               # size
    lw $a0, 4($sp)               # array
    lw $ra, 8($sp)               # IP
    addi $sp, $sp, 12

not_palindrome:
###############################################################################
# End of your code.
###############################################################################
jr $ra                           # Return as a non palindrome

