#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "6_A4_translator.h"

// Initialize the symbol table
symboltable symtab[NSYMS] = {0}; // Initializing to 0

// Index for the next available temporary variable
int tempIndex = 0;

// Function to look up or create a symbol in the symbol table
symboltable *symlook(char *s) {
    symboltable *sp;

    for (sp = symtab; sp < &symtab[NSYMS]; sp++) {
        if (sp->name != NULL && strcmp(sp->name, s) == 0) {
            return sp; // Symbol found, return its entry
        }
    }

    // Symbol not found, create a new entry
    for (sp = symtab; sp < &symtab[NSYMS]; sp++) {
        if (sp->name == NULL) {
            sp->name = strdup(s);
            if (sp->name == NULL) {
                fprintf(stderr, "Error: Memory allocation failure\n");
                exit(1);
            }
            sp->value = 0; // Initialize other fields as needed
            return sp;    // Return the newly created entry
        }
    }

    // Symbol table is full
    fprintf(stderr, "Error: Symbol table overflow\n");
    exit(1);
}

// Function to generate a new temporary symbol
symboltable *gentemp() {
    char tempName[10];
    sprintf(tempName, "t%d", tempIndex++);
    return symlook(tempName);
}

// Function to emit a binary quad
void emit_binary(char *result, char *arg1, char *op, char *arg2) {
    quad *q = new_quad_binary(op, result, arg1, arg2);
    // Add the quad to the quad array or perform other necessary actions
    // (implementation depends on your design)
    print_quad(q); // For demonstration purposes, print the quad
    free_quad(q);  // Free the quad's memory
}

// Function to emit a unary quad
void emit_unary(char *result, char *arg1, char *op) {
    quad *q = new_quad_unary(op, result, arg1);
    // Add the quad to the quad array or perform other necessary actions
    // (implementation depends on your design)
    print_quad(q); // For demonstration purposes, print the quad
    free_quad(q);  // Free the quad's memory
}

// Function to emit an assignment quad
void emit_assign(char *result, char *arg1) {
    quad *q = new_quad_binary("=", result, arg1, NULL);
    // Add the quad to the quad array or perform other necessary actions
    // (implementation depends on your design)
    print_quad(q); // For demonstration purposes, print the quad
    free_quad(q);  // Free the quad's memory
}

// Function to create a new binary quad
quad *new_quad_binary(char *op, char *result, char *arg1, char *arg2) {
    quad *q = malloc(sizeof(quad));
    if (q == NULL) {
        fprintf(stderr, "Error: Memory allocation failure\n");
        exit(1);
    }
    q->op = strdup(op);
    q->result = strdup(result);
    q->arg1 = strdup(arg1);
    q->arg2 = strdup(arg2);
    if (q->op == NULL || q->result == NULL || q->arg1 == NULL || q->arg2 == NULL) {
        fprintf(stderr, "Error: Memory allocation failure\n");
        exit(1);
    }
    return q;
}

// Function to create a new unary quad
quad *new_quad_unary(char *op, char *result, char *arg1) {
    return new_quad_binary(op, result, arg1, NULL);
}

// Function to print a quad (for demonstration purposes)
void print_quad(quad *q) {
    printf("(%s, %s, %s, %s)\n", q->op, q->result, q->arg1, q->arg2);
}

// Function to free the memory occupied by a quad
void free_quad(quad *q) {
    free(q->op);
    free(q->result);
    free(q->arg1);
    free(q->arg2);
    free(q);
}
