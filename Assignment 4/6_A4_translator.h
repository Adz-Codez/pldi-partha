// This is the header file for the translator
// It contains the class definition for the translator
// It also contains the function definitions for the translator

#ifndef __TRANSLATOR_H
#define __TRANSLATOR_H

/* The Symbol Table structure*/
typedef struct symtab
{
    char *name;
    int value;
    struct symbol_table *next; // Include a pointer to the next symbol table entry
} symboltable;

// We need to define the symlook function
symboltable *symlook(char *);

// Now we define the limit for NSYMS
#define NSYMS 20
extern symboltable symtab[NSYMS]; 
// This is the symbol table

// Before we initialise the symbol table, we need to create a function that can generate temp addr.
// This is to support the generation of Three Address Codes

symboltable *gentemp();

// Now we define the structure for the Three Address Code

// The Three Address Code structure for binary operators
void emit_binary(
    char *result,
    char *arg1,
    char *op,
    char *arg2
);

// Now for Unary operators
void emit_unary(
    char *result,
    char *arg1,
    char *op
);

// Now for the assignment operator
void emit_assign(
    char *result,
    char *arg1
);

// According to the supplied examples, we also need to support lazy TAC gen
// This is through the quad array
typedef enum {
    OP_PLUS = 1,
    OP_MINUS,
    OP_MULT,
    OP_DIV,
    OP_UNARYMINUS,
    OP_COPY,
    OP_DEREF,
    OP_SIGNP,
    OP_SIGNN,
    OP_NOT,
    OP_ADDR,
    OP_SLASH,
    OP_MOD,
    OP_SLESS,
    OP_SGREAT,
    OP_LEQ,
    OP_GEQ,
    OP_EQUALITY,
    OP_NEQ,
    OP_AND,
    OP_OR,
    OP_COLON,
    OP_QUES,
    OP_ASSIGN
} opcodeType;

typedef struct quad_tag {
    opcodeType op;
    char *result, *arg1, *arg2;
} quad;

quad *new_quad_binary(opcodeType op1, char *result, char *arg1, char *arg2);

quad *new_quad_unary(opcodeType op1, char *result, char *arg1);

void print_quad(quad* q);
#endif // __TRANSLATOR_H