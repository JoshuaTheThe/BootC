
# an attempt to make a tiny C compiler, in 8086 assembly
- it must support these basic features

```c

// declarations
int     x;

// assignment
x = 65;

// function declaration and invokation
int main()(
        int k;
        k = 32;
)

// only operators are +,-,*,/,* (deref), & (lea rhs)
// only type of assignment, is direct and expression. (e.g. *(a) = 0)
// notice that (){} are the same, a list of expressions where the result is pushed to the stack

```

