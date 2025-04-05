#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int getDigit(long int number, int digitPos) {
    // Returns the digit in a number given the number and digit position
    // Ex: Number: 612 Digit position: 2 
    // Returns 6
    long int divisor = 1;
    for (int i = 0; i < digitPos; i++) {
        divisor *= 10;
    }
    return (number / divisor) % 10;
}

void countingSort(long int A[], long int B[], int k, int currentDigit, int len) {

    // Initialize output array C with zeros
    // This will always be an array from 0-9
    int *C = (int *)calloc(k + 1, sizeof(int));
    
    // Count occurrences of each digit
    for (int i = 0; i < len; i++) {
        int digit = getDigit(A[i], currentDigit);
        C[digit]++;
    }
    
    // Calculate the cummalative counts
    for (int i = 1; i <= k; i++) {
        C[i] = C[i] + C[i-1];
    }
    
    // Place elements in sorted order
    for (int i = len - 1; i >= 0; i--) {
        int digit = getDigit(A[i], currentDigit);
        B[C[digit] - 1] = A[i];
        C[digit]--;   
    }

    // Copy the sorted array back to A
    for (int i = 0; i < len; i++) {
        A[i] = B[i];
    }
    
    // Free the C array in the end
    free(C);
}

void radixSort(long int A[], int d, int len) {

    // Initialize output array B, must be long int to store 10 digit numbers
    long int *B = (long int *)calloc(len, sizeof(long int));

    for (int i = 0; i < d; i++) {
        // Call the counting sort on each digit 
        countingSort(A, B, 9, i, len);
    }
    
    // Free the B array at the end
    free(B);
}

int main() {
    // Initialize array A
    long int A[] = {1701234567, 4509876543, 75123456, 90128, 802389, 2412348, 212349, 6612345};

    // Calculate the length of the array
    int len = sizeof(A) / sizeof(A[0]);    

    // Maximum number of digits in the array
    int d = 10;

    radixSort(A, d, len);

    printf("Sorted array: ");
    for (int i = 0; i < len; i++) {
        printf("%ld ", A[i]);
    }
    printf("\n");

    return 0;
}
