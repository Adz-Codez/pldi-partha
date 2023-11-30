// This is the header file for the translator
// It contains the struct definitions and function declarations for the translator

#ifndef __TRANSLATOR_H
#define __TRANSLATOR_H

// Enum to represent different types of symbols
typedef enum {
    CHAR,
    INT,
    POINTER,
    ARRAY,
    FUNCTION,
    BLOCK
} typeEnum;

// Representing a symbol type
typedef struct symbolType {
    typeEnum type;
    struct symbolType* arrayType;
    int width;
} symType;

// Representing a symbol
typedef struct Symbol {
    char* name;
    symType* type;
    int offset;
    struct SymbolTable* nestedTable;
    char* initVal;
    int isFunc;
    int size;
} symbol;

// Representing a symbol table entry
typedef struct SymbolTableEntry {
    char* name;
    symbol* symbol;
} symbolTableEntry;

// Struct to represent a symbol table
typedef struct SymbolTable {
    char* name;
    struct SymbolTable* parent;
    symbolTableEntry symbols[NSYMS];
} symbolTable;

// Function to look up a symbol in the symbol table
symbolTable* symlook(char* s);

// Function to generate a temporary variable
symbolTable* gentemp();

// Updating the symbol table
void updateSymbolTable(symbolTable* table);

// Function to convert int to string
char* toString(int i);

// Function to convert char to string
char* toString(char c);

// Function to convert SymbolType to string
char* symbolTypeToString(symType* type);

// Function to print the symbol table
void printSymbolTable(symbolTable* table);

// Structure to represent a quad
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

typedef struct quad {
    opcodeType op;
    char* result, *arg1, *arg2;
} quad;

quad* new_quad_binary(opcodeType op1, char* result, char* arg1, char* arg2);

quad* new_quad_unary(opcodeType op1, char* result, char* arg1);

void print_quad(quad* q);

#endif // __TRANSLATOR_H
