#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void addi(int *res, int *a, int b)  { *res = *a + b; }
// #define addi(res, a, b) *res = *a + b;
void add(int *res, int *a, int *b)  { *res = *a + *b; }
// #define add(res, a, b)  *res = *a + *b;
void sll(int *res, int *a, int b)   { *res = *a << b; }
// #define ssl(res, a, b)  *res = *a << *b;
void srl(int *res, int *a, int b)   { *res = *a >> b; }
// #define srl(res, a, b)  *res = *a >> *b;
void xor(int *res, int *a, int *b)  { *res = *a ^ *b; }
// #define xor(res, a, b)  *res = *a ^ *b;
void slt(int *res, int *a, int *b)  { if(*a < *b) *res = 1; else *res = 0; }
// #define slt(res, a, b)  if(*a < *b) *res = 1; else *res = 0;
#define bne(a, b, label) if(*a != *b) goto label
#define beq(a, b, label) if(*a == *b) goto label
#define jal(function) return function(a0, a1)
#define jr return v0

int *palindrome(char *a0, int *a1) {
    ////////////////////////////////////////
    int *zero = (int*)malloc(sizeof(int));//
    int *v0 = (int*)malloc(sizeof(int));////
    int *t0 = (int*)malloc(sizeof(int));////
    int *t1 = (int*)malloc(sizeof(int));////
    ////////////////////////////////////////

    // xor(t0, t0, t0);
    xor(t1, t1, t1);             /* $t1 = 0 */
    slt(t0, zero, a1);           /* $t0 = 1 if a1 is positive, else $t0 = 0 */
    bne(t0, t1, next_letter);    /* Try the next letter when pointers have NOT reached the middle yet */

palindrome:
    addi(v0, zero, 1);           /* We get here when pointers have reached the middle */
    jr;                          /* and all letter pairs are equal */

next_letter:
    *t0 = *(a0 + 0);             /* add(t0, a0, zero); $t0 pointer advances from the beginning to the middle */
    addi(t1, a1, -1);            /* $t1 is a temp register for calculating the offset from the end */
    *t1 = *(a0 + *t1);           /* add(t1, a0, t1); $t1 pointer advances from the END to the middle */
    bne(t0, t1, not_palindrome); /* Exit when any 2 character pairs are different */

    /* TODO Care that may touch bytes before $a0 */
    addi(a1, a1, -2);            /* Fix a1 towards the middle */
    a0 = a0 + 1;                 /* addi(a0, a0, 1) */
    jal(palindrome);

not_palindrome:
    xor(v0, v0, v0);             /* Zero out $v0 */
    jr;                          /* Return */
}

int main(void) {
    ////////////////////////////////////////
    int *v0 = (int*)malloc(sizeof(int));////
    int *a1 = (int*)malloc(sizeof(int));////
    ////////////////////////////////////////

    char *keno = "";
    *a1 = 0;
    v0 = palindrome(keno, a1);
    printf("keno pal should be 1 -> %d\n", *v0);

    char *mhden = 0;
    *a1 = 0;
    v0 = palindrome(mhden, a1);
    printf("mhden pal should be 1 -> %d\n", *v0);

    char *anna = "anna";
    *a1 = 4;
    v0 = palindrome(anna, a1);
    printf("anna pal should be 1 -> %d\n", *v0);

    char *bobob = "bobob";
    *a1 = 5;
    v0 = palindrome(bobob, a1);
    printf("bobob pal should be 1 -> %d\n", *v0);

    char *a = "a";
    *a1 = 1;
    v0 = palindrome(a, a1);
    printf("a pal should be 1 -> %d\n", *v0);

    char *aa = "aa";
    *a1 = 1;
    v0 = palindrome(aa, a1);
    printf("aa pal should be 1 -> %d\n", *v0);

    char *number = "123-321";
    *a1 = 1;
    v0 = palindrome(number, a1);
    printf("123-321 pal should be 1 -> %d\n", *v0);

    char *random = "random";
    *a1 = 6;
    v0 = palindrome(random, a1);
    printf("random pal should be 0 -> %d\n", *v0);

    char *bigone = "11223344555544332211";
    *a1 = 20;
    v0 = palindrome(bigone, a1);
    printf("bigone pal should be 1 -> %d\n", *v0);

    return 0;
}
