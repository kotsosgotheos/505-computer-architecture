
# DO NOT DELCARE main IN THE .globl DIRECTIVE. BREAKS MUNIT!
.globl strcmp, rec_b_search

.data

aadvark:  .asciiz "aadvark"
ant:      .asciiz "ant"
elephant: .asciiz "elephant"
gorilla:  .asciiz "gorilla"
hippo:    .asciiz "hippo"
empty:    .asciiz ""

          # make sure the array elements are correctly aligned
          .align 2
sarray:   .word aadvark, ant, elephant, gorilla, hippo
endArray: .word 0  # dummy

.text

main:
    la $a0, empty        # $a0 -> first string
    addi $a1, $a0, 0     # $a1 -> second string, 16
    jal strcmp           # Call
    
    la $a0, sarray       # $a0 -> array of words            (array) -> (left)
    la $a1, endArray     # nil value
    addi $a1, $a1, -4    # $a1 -> Point to the last element (right)
    la $a2, hippo        # $a2 -> Word to search for        (x)
    jal rec_b_search     # Call
    
    addiu $v0, $zero, 10 # system service 10 is exit
    syscall              # we are outa here.

#
#    (int) self |> "strcmp" |> (char*): p1, (char*): p2) |> {
#        if(*p1 == '\0' || *p1 != *p2)
#            return *p1 - *p2;
#        self "strcmp" (p1 + 1), (p2 + 1);
#    }
#
strcmp:
    # Dereference
    lbu $t0, 0x00($a0)       # Get the pointer value on p1
    lbu $t1, 0x00($a1)       # Get the pointer value on p2

    # if(*p1 == '\0')
    beq $t0, $zero find_diff # If we reach a null pointer, setup v0

    # if(*p2 == '\0')
    # beq $t1, $zero find_diff # >>

    # if(*p1 != *p2)
    bne $t0, $t1 find_diff   # If the characters differ, setup v0

    # Setup parameters
    addi $a0, $a0, 0x01      # Move the pointer by offset sizeof(char)
    addi $a1, $a1, 0x01      # >>

    # self "strcmp" (p1 + 1), (p2 + 1);
    j strcmp       # Recurse

find_diff:
    # return *p1 - *p2
    sub $v0, $t0, $t1        # Subtract the ascii values of the current pointer positions
    jr $ra                   # Return to previous stack frame

#
# char **A  = {"aadvark", "ant", "elephant", "gorilla", "hippo"};
# int left  = 0;
# int right = sizeof(A) / sizeof(A[0]);
# char *x   = "hippo";
#
#    (int) self |> "binary search" |> (char**): A, (int): left, (int): right, (char*): x |> {
#        int mid = left + (right-left) / 2;
#
#        if(left > right)
#            return 0;
#
#        int res = self "strcmp" x, A[mid];
#        if(res == 0)
#            return &mid;
#        if(res < 0)
#            return self "binary search" A, left, mid - 1, x;
#        else
#            return self "binary search" A, mid + 1, right, x;
#    }
#
rec_b_search:
    li $t9, -4                 # Clear lsb -> b &= ~(1 * sizeof(word))
    xor $v0, $v0, $v0          # Initialize $v0 as zero (OUTPUT VALUE FOR STRCMP)
    xor $v1, $v1, $v1          # Initialize $v1 as zero (SELF OUTPUT VALUE)

    # if(left > right)
    slt $t0, $a1, $a0          # Set the flag in the case where left is greater than right
    bne $t0, $zero, return_to_stack_frame # Proceed to exit ($v0 = 0)

    # int mid = left + (right-left) / 2;
    sub $v0, $a1, $a0          # Subtract right from left, $v0 = right - left
    srl $v0, $v0, 0x01         # Shift once to the right, $v0 = (right-left) / 2
    add $v0, $a0, $v0          # Add left to $v0
    and $v0, $v0, $t9          # Clear 2 bits off the bitmask
                               # $v0 = mid*offset (address)

    lw $t0, 0x00($v0)          # Dereference $v0, $t0 = *(A + mid)

    # Save valuables to stack
    addi $sp, $sp, -0x10       # Allocate space for 4 elements
    sw $ra, 0x0c($sp)          # 0x0c -> Return address
    sw $v0, 0x08($sp)          # 0x08 -> mid*offset (address)
    sw $a1, 0x04($sp)          # 0x04 -> current value of (right)
    sw $a0, 0x00($sp)          # 0x00 -> pointer to the initial array (left)

    # Setup parameters
    add $a0, $a2, $zero        # a0 gets the value of (x)
    add $a1, $t0, $zero        # a1 gets the value of *(A + mid)

    # int res = self "strcmp" x, A[mid];
    jal strcmp                 # $v0 = (0 | neg | pos)

    # Reset valuables
    lw $a0, 0x00($sp)
    lw $a1, 0x04($sp)
    lw $v1, 0x08($sp)          # Load previous return value to $v1 since we are using $v0 as well
    lw $ra, 0x0c($sp)
    addi $sp, $sp, 0x10        # Reset stack pointer
    
    # if(res == 0)
    beq $v0, $zero return_to_stack_frame     # If the middle element equals x, setup v0

    # if(res < 0)
    slt $t0, $v0, $zero             # Set flag to true if $v0 is less than $zero
    bne $t0, $0, rec_b_search_less  # If $t0 = [true|false] = ((self "strcmp" x, A[mid]) < 0) != 0,
                                    # recurse to the left of the array

    # else
    # return self "binary search" A, mid + 1, right, x;
    addi $a0, $v1, 0x04        # Add 1 * sizeof(word) to v0, craft the (mid + 1) value and set to $a0
    j rec_b_search_recurse     # Setup function return address and recurse to the right of the array

rec_b_search_less:
    # return self "binary search" A, left, mid - 1, x;
    addi $a1, $v1, -0x04       # Sub v0 by 1 * sizeof(word), craft the (mid - 1) value and set to $a1
    ## j rec_b_search_recurse     # Setup function return address and recurse

rec_b_search_recurse:
    addi $sp, $sp, -0x04       # Allocate space for 1 element
    sw $ra, 0x00($sp)          # Store return address
    jal rec_b_search           # Recurse
    lw $ra, 0x00($sp)          # Load return address
    addi $sp, $sp, 0x04        # Reset stack pointer
    ## j return_to_stack_frame

return_to_stack_frame:
    # return mid;
    # return 0;
    add $v0, $v1, $zero        # Get the found value back into $v0 for the tests
                               # Case 1 where we need zero, $v1 is zero so $v0 is correct
                               # Case 2 where we need the mid address, $v1 got the address from the stack

    jr $ra                     # Return to previous stack frame
