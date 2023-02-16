#include <stdio.h>
#include <stdlib.h>

void addi(int *res, int *a, int b)  { *res = *a + b; }
void add(int *res, int *a, int *b)  { *res = *a + *b; }
//void sll(int *res, int *a, int b) { *res = *a << b; }
void srl(int *res, int *a, int b)   { *res = *a >> b; }
void xor(int *res, int *a, int *b)  { *res = *a ^ *b; }
#define bne(a, b, label) if(*a != *b) goto label
#define beq(a, b, label) if(*a == *b) goto label

void swap_elements(int *a0, int *a1) {
    ////////////////////////////////////////
    int *zero = (int*)malloc(sizeof(int));//
    int *t0 = (int*)malloc(sizeof(int));////
    int *t1 = (int*)malloc(sizeof(int));////
    int *t2 = (int*)malloc(sizeof(int));////
    int *t3 = (int*)malloc(sizeof(int));////
    int *t4 = (int*)malloc(sizeof(int));////
    int *t5 = (int*)malloc(sizeof(int));////
    ////////////////////////////////////////

    swapArray:
        beq(a1, zero, exit);     // If a1 is zero then exit
        srl(t5, a1, 1);          // Find the mid of a0, (a1/2)

    loop:
        t1 = a0 + *t0;           // FIXME add(t1, a0, t0);
        t2 = t1 + *t5;           // FIXME add(t2, t1, t5);

        add(t3, zero, t1);       // Swaps t1 with t2
        add(t1, zero, t2);       // using a temp register
        add(t2, zero, t3);       // called t3

        addi(t0, t0, 1);         // Updates the counter by 1
        bne(t0, t5, loop); // Jumps while t0 is not a1 / 2

    exit:;
}

static void print_array(int *a0, int *a1) {
    int i;
    printf("[");
    for(i = 0; i < *a1-1; i++)
        printf("%d,", a0[i]);
    printf("%d]\n", a0[i]);
}

int main(void) {
    int a0[8] = {45, 46, 47, 48, 41, 42, 43, 44};
    int *a1 = (int*)malloc(sizeof(int));
    *a1 = 8;

    print_array(a0, a1);
    swap_elements(a0, a1);
    print_array(a0, a1);
}
