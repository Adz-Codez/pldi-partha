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

// Let us create some basic structures and definitions for the translator
// Define the maximum number of symbols (arbitrary)
#define NSYMS 100

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
symbolTableEntry* symlook(char* s);

// Function to generate a temporary variable
symbolTableEntry* gentemp();

// Updating the symbol table
void updateSymbolTable(symbolTable* table);

// Function to convert int to string
char* intToString(int i);

// Function to convert char to string
char* charToString(char c);

// Function to convert SymbolType to string
char* symbolTypeToString(symType* type);

// Function to print the symbol table
void printSymbolTable(symbolTable* table, const char* scope, const char* parent);

// Structure to represent a quad
typedef enum {
    PLUS = 1,
    MINUS,
    UNARYMINUS,
    MOD,
    MULT,
    DIV
} opcodeType;

typedef struct quad {
    opcodeType op;
    char* result, *arg1, *arg2;
} quad;

quad* new_quad_binary(opcodeType op1, char* result, char* arg1, char* arg2);

quad* new_quad_unary(opcodeType op1, char* result, char* arg1);

void print_quad(quad* q, int index);

#endif // __TRANSLATOR_H
