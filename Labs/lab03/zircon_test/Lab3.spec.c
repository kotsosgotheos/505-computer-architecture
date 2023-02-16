#include "cSpec.h"
#include "Lab3.h"

#define strcmp(s1, s2) zircon_strcmp(t, s1, s2)
#define binary_search(A, left, right, x) zircon_binary_search(t, A, left, right, x)

module(Lab3Test, {
    describe("#strcmp", {
        void *t;

        before({
            __init_Lab3();
            t = zircon_new(Lab3);
        });

        it("returns negative for s1 < s2 same size", {
            char *s1 = "abcda";
            char *s2 = "abcde";
            assert_that(strcmp(s1, s2) < 0);
        });

        it("returns negative for s1 < s2 different size", {
            char *s1 = "abcd";
            char *s2 = "abcde";
            assert_that(strcmp(s1, s2) < 0);
        });

        it("return positive for s1 > s2 same size", {
            char *s1 = "abcde";
            char *s2 = "abcda";
            assert_that(strcmp(s1, s2) > 0);
        });

        it("return positive for s1 > s2 different size", {
            char *s1 = "abcde";
            char *s2 = "abcd";
            assert_that(strcmp(s1, s2) > 0);
        });

        it("returns 0 for s1 = s2", {
            char *s1 = "abcde";
            char *s2 = "abcde";
            assert_that_int(strcmp(s1, s2) equals to 0);
        });

        it("return a value different that 0 if `s1` and `s2` have different sizes", {
            char *s1 = "1234";
            char *s2 = "12345";
            assert_that(strcmp(s1, s2) isnot 0);
        });
    });

    describe("#binary search", {
        void *t;

        before({
            __init_Lab3();
            t = zircon_new(Lab3);
        });

        xit("returns 0 if the array has zero elements", {
            char *A[0] = {};
            int left = 0;
            int right = sizeof(A) / sizeof(A[0]);
            char *x = "element";

            int ret = binary_search(A, left, right, x);
            assert_that_int(ret equals to 0);
        });

        it("returns the position of the only one element if we search an array with a size of 1", {
            char *A[1] = {"only one"};
            int left = 0;
            int right = sizeof(A) / sizeof(A[0]);
            char *x = "only one";

            int ret = binary_search(A, left, right, x);
            assert_that_int(ret equals to 0);
        });

        it("finds the second element with an array of size 2", {
            char *A[2] = {"a", "b"};
            int left = 0;
            int right = sizeof(A) / sizeof(A[0]);
            char *x = "b";

            int ret = binary_search(A, left, right, x);
            assert_that_int(ret equals to 1);
        });

        it("finds the middle element with an array of size 3", {
            char *A[3] = {"a", "b", "c"};
            int left = 0;
            int right = sizeof(A) / sizeof(A[0]);
            char *x = "b";

            int ret = binary_search(A, left, right, x);
            assert_that_int(ret equals to 1);
        });

        it("finds the minimum element", {
            char *A[5] = {"aa", "bb", "cc", "dd", "ee"};
            int left = 0;
            int right = sizeof(A) / sizeof(A[0]);
            char *x = "aa";

            int ret = binary_search(A, left, right, x);
            assert_that_int(ret equals to 0);
        });

        it("finds the maximum element", {
            char *A[5] = {"aa", "bb", "cc", "dd", "ee"};
            int left = 0;
            int right = sizeof(A) / sizeof(A[0]);
            char *x = "ee";

            int ret = binary_search(A, left, right, x);
            assert_that_int(ret equals to 4);
        });

        xit("fails to find the element if the array is not sorted", {
            char *A[5] = {"aa", "cc", "bb", "ee", "dd"};
            int left = 0;
            int right = sizeof(A) / sizeof(A[0]);
            char *x = "ee";

            int ret = binary_search(A, left, right, x);
            assert_that_int(ret equals to 4);
        });
    });
});

spec_suite({
    Lab3Test();
});

spec({
    run_spec_suite("all");
});
