
## UoI-CSE-MYY505 lab03

## First-Name Last-Name

**TODO - Update your name in this readme. Leave 1 space after the ## to preserve the text formating**


## Problem statement:
Write a **recursive** MIPS assembly subroutine which tests if a string is a palindrome.
Register `$a0` will provide the address of the string and `$a1` its length.
Return 1 if it is a palindrome, 0 otherwise.

Let a string S be represented as S = S<sub>1</sub> S<sub>2</sub> ... S<sub>N</sub>, 
here N is the length of the string.
S is a palindrome if:
- N = 0, or 
- N = 1, or
- N >= 2 and S<sub>1</sub> = S<sub>N</sub> and the substring (S<sub>2</sub> ... S<sub>N-1</sub>) is a palindrome.
 
A null pointer in `$a0` is also considered a palindrome.

 
## Files to work on
* `lab03.asm` 
* `README.md` to add your name<br/>
Please **DO NOT MODIFY** any other files. 
      
## Running 
* To run the program interactively, start MARS: `java -jar MarsMYY505_4_5.jar`, and load the .asm file
* To run the test using munit: <br/>
```
    javac -cp munit.jar Lab03TestPalindrome.java
    java -jar munit.jar lab03.asm Lab03TestPalindrome.class
```

## Automatic testing 
Every commit pushed is automatically tested, by running the above commands on a virtual machine.
To view the test results, click on the "Actions" tab and you will see the list of commits.
Next to each commit there will be a red x if the test fails, or a green tick, if it passes. Click on a commit name and then "Autograding", on the left. You can then expand the logs (little ">"s in the dark area of the window) to view the error messages.

## Notes
* Make sure your solution assembles and runs.
* Make sure your last push is before the deadline. Your last push will be considered as your final submission.
* If you need a deadline extension for any reason, use the [provided form.](https://forms.gle/mNZjzfxBsYS9kH9G9)
* Post questions on [Piazza!](https://piazza.com/uoi.gr/fall2021/myy505/home).

