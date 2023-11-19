// Forward declaration
int factorial(int n);

/* Driver program to test the factorial function
testing comments */
int main() {
    int num;
    /*print statement
    testing the comments
    regex rule
    */
    printStr("Enter a number to calculate its factorial: \n");
    readInt(&num);

    if (num < 0) {
        printStr("Factorial is not defined for negative numbers.\n");
    } else {
        int result = factorial(num);
        printStr("Factorial of ");
        printInt(num);
        printStr(" is: ");
        printInt(result);
        printStr("\n");
    }

    return 0;
}

// Recursive function to calculate factorial
int factorial(int n) {
    if (n == 0 || n == 1) {
        return 1;
    } else {
        return n * factorial(n - 1);
    }
}
