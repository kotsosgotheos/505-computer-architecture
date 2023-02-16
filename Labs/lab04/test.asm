o1 = xor(r1, r2)

$1 $s1
$2 $s2
.
.
.
.
$32

[bss]
..
[heap]
[..]
[..]
[..]
[stack]

->conditional -> if, case, when  -> branch/jump
->assignment -> variables        -> register
->iteration  -> for, while       -> branch/jump

start:
    addi $s1, $zero, 10 -> 0x0141ab -> 000010110101010011
    addi $s1, $s1, -1   -> 0x1f15ae -> 101010001001010010
    bne $s1, 0, start   -> 0x1dab45 -> 101001010010101100


int func(int arg1, int arg2) {
    res = arg1 + arg2;
    res2 = res + 1;
    return res2;
}

v = func(2, 4);
v -> 7



-> $v0 func($a0, $a1) {
    add $t0, $a0, $a1
    addi $t1, $t0, 1
    sw, $v0, 0($t1)
}

matric: .ascii "hello"
