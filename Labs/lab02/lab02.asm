
# lab02.asm - Binary search in an array of 32bit signed integers
#   coded in  MIPS assembly using MARS
# for MYΥ-505 - Computer Architecture, Fall 2020
# Department of Computer Science and Engineering, University of Ioannina
# Instructor: Aris Efthymiou

.globl entry_point bsearch # declare the label as global for munit

.data
sarray: .word 1, 5, 9, 20, 321, 432, 555, 854, 940

.text
j entry_point

# int *A    = {1, 5, 9, 20, 321, 432, 555, 854, 940};
# int left  = 0;
# int right = sizeof(A) / sizeof(A[0]);
# int x     = 1;
#
#    (int*) self |> "binary search" |> (int*): A, (int): left, (int): right, (int): x |> {
#        int mid = left + (right-left) / 2;
#
#        if(l > r)        return 0;
#        if(x == A[mid])  return &mid;
#        if(x < A[mid])   return self "binary search" A, left, mid - 1, x;
#        else             return self "binary search" A, mid + 1, right, x;
#    }
#

bsearch:
    xor $a3, $a3, $a3          # First position of array (left)

bsearch_recurse:
    xor $s7, $s7, $s7          # Initialize $s7 as zero (OUTPUT VALUE)

    # if(l > r) return 0;
    slt $t0, $a1, $a3          # Set the flag in the case where left is greater than right
    bne $t0, $zero, exit       # Proceed to exit ($s7 = 0)

    # int mid = left + (right-left) / 2;
    sub $t0, $a1, $a3          # Subtract right from left, $t0 = right - left
    srl $t0, $t0, 1            # Shift once to the right for arithmetic division by 2, $t0 = (right-left) / 2
    add $t0, $a3, $t0          # Add left to $t0
    sll $s7, $t0, 2            # offset for 32bit values [mid * 4]
                               # $t0 = mid        (index)
                               # $s7 = mid*offset (address)
    
    # TODO -> Overflow bug possibly not occuring due to using shifts
    # Code below is faster

    # add $t0, $a3, $a1        # $t0 = left + right
    # srl $t0, $t0, 1          # $t0 = (left + right) / 2 , shift once for division by 2 
    # sll $s7, $t0, 2          # Offset for 32bit values [mid * 4]

    add $s7, $a0, $s7          # Add the offset,  $s7 = &(A + mid)
    lw $t1, 0x00($s7)          # Dereference $s7, $t1 = *(A + mid)

    # if(x == A[mid])
    beq $t1, $a2 exit          # If the middle element equals x return successully ($s7 = &(A + mid))

    # if(x < A[mid])
    slt $t1, $a2, $t1          # Set flag to true if $a2 is less that $t1
    bne $t1, $0, bsearch_less  # If $t1 = [true|false] = (x - A[mid] < 0) != 0, recurse to the left of the array

    # else
    # return self "binary search" A, mid + 1, right, x;
    addi $a3, $t0, 1           # Add 1 to t0, craft the (mid + 1) value and set to $a3
    j bsearch_recurse          # Recurse

bsearch_less:
    # return self "binary search" A, left, mid - 1, x;
    addi $a1, $t0, -1          # Sub t0 by 1, craft the (mid - 1) value and set to $a1
    j bsearch_recurse          # Recurse

entry_point:
    la $a0, sarray             # $a0 -> The address of `sarray` pointer (A)
    li $a1, 9                  # $a1 -> The size of the array (right)
    li $a2, 1                  # $a2 -> The number sought (x)

    # Goto start of tests
    j bsearch                  # Start bsearch on data

exit:
    addiu $v0, $zero, 10       # system service 10 is exit
    syscall                    # we are outta here.
