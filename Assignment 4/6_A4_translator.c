// This is the main translator program
// This is where we will use all the functions defined in the header file
// It is also where the main() function for printing the TAC will also go

#include "6_A4_translator.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

extern int yyparse();
extern int yylex();
extern int yyleng();
extern char* yytext();

// Array to represent the global symbol table
symbolTable symtab[NSYMS];

// Function to look up a symbol in the symbol table
symbolTable* symlook(char* s) {
    symbolTable* table;
    symbolTableEntry* entry;

    // Iterate over symbol tables
    for (int i = 0; i < NSYMS; i++) {
        // Check if the symbol already exists in the current table
        for (entry = symtab[i].symbols; table->symbols < &symtab[i].symbols[NSYMS]; entry++) {
            if (entry->name && strcmp(entry->name, s) == 0)
                return table;
        }

        // Check if there is space to append a new table in the current table
        for (entry = symtab[i].symbols; entry < &symtab[i].symbols[NSYMS]; entry++) {
            if (!entry->name) {
                // Allocate memory for the symbol using strdup()
                table->symbols->name = strdup(s);
                table->symbols->symbol = (symbol*)malloc(sizeof(symbol)); // Allocate memory for the symbol
                table->symbols->symbol->name = table->symbols->name; // Link the name in symbol to the table name
                table->symbols->symbol->offset = 0; // Set initial offset
                table->symbols->symbol->nestedTable = NULL; // Initialize nested table to NULL (you can set it as needed)
                table->symbols->symbol->initVal = NULL; // Initialize initVal as needed
                table->symbols->symbol->isFunc = 0; // Initialize isFunc as needed
                table->symbols->symbol->size = 0; // Initialize size as needed

                return table;
            }
        }
    }

    // Too many symbols
    printf("Too many symbols\n");
    exit(1);
}


// Function to generate a temporary variable
symbolTable* gentemp() {
    static int c = 0; // Temp counter
    char str[10]; // Temp name
    // Generate temp name
    sprintf(str, "t%02d", c++);
    // Add temporary to the global symbol table
    return symlook(str);
}

// Updating the symbol table
void updateSymbolTable(symbolTable* table) {
    int offset = 0; // Initial offset

    // Iterate over symbols in the current table
    for (int i = 0; i < NSYMS; i++) {
        if (table->symbols[i].name != NULL) {
            table->symbols[i].symbol->offset = offset;
            offset += table->symbols[i].symbol->size;
        }
    }

    // Recursively update children tables if they exist
    for (int i = 0; i < NSYMS; i++) {
        if (table->symbols[i].name != NULL && table->symbols[i].symbol->nestedTable != NULL) {
            updateSymbolTable(table->symbols[i].symbol->nestedTable);
        }
    }
}


// Output: symbol table

// Function to convert int to string
char* intToString(int i) {
    char* result;
    asprintf(&result, "%d", i);
    return result;
}

// Function to convert char to string
char* charToString(char c) {
    char* result;
    asprintf(&result, "%c", c);
    return result;
}

// Function to convert SymbolType to string
char* symbolTypeToString(symType* type) {
    switch(type->type) {
        case CHAR:
            return "char";
        case INT:
        case POINTER:
            return "int";
case ARRAY:
	{
		char* arrayTypeString = symbolTypeToString(type->arrayType);
		char* widthString = intToString(type->width);
		char* result;
		asprintf(&result, "array(%s, %s)", widthString, arrayTypeString);
		free(arrayTypeString);
		free(widthString);
		return result;
	}
        default:
            return "unknown";
    }
}


// Function to print the symbol table
void printSymbolTable(symbolTable* table, const char* scope, const char* parent) {
    printf("--------------------\n");
    printf("ST:%s, Parent:%s\n", table->name, parent ? parent : "null");
    printf("--------------------\n");
    printf("%-20s%-20s%-20s%-20s\n", "Name", "Type", "Scope", "Nested ST");

    // Iterate over symbols in the current table
    for (int i = 0; i < NSYMS; i++) {
        if (table->symbols[i].name != NULL) {
            printf("%-20s", table->symbols[i].name);
            printf("%-20s", (table->symbols[i].symbol->isFunc ? "function" : symbolTypeToString(table->symbols[i].symbol->type)));
            printf("%-20s%-20s\n", scope, (table->symbols[i].symbol->nestedTable ? table->symbols[i].symbol->nestedTable->name : "null"));
        }
    }

    printf("--------------------\n\n");

    // Recursively print children tables
    for (int i = 0; i < NSYMS; i++) {
        if (table->symbols[i].name != NULL && table->symbols[i].symbol->nestedTable != NULL) {
            printSymbolTable(table->symbols[i].symbol->nestedTable, "local", table->name);
        }
    }
}

// Assuming quadArray is a global array of quads
quad quadArray[NSYMS];
int quadIndex = 0;

// Function to emit binary operation quad
void emitBinary(char* result, char* arg1, char op, char* arg2) {
    if (quadIndex < NSYMS) {
        quadArray[quadIndex++] = *new_quad_binary(op, result, arg1, arg2);
    } else {
        printf("Error: quadArray is full\n");
        exit(EXIT_FAILURE); 
    }
}

// Function to emit unary operation quad
void emitUnary(char* result, char* arg1, char op) {
    if (quadIndex < NSYMS) {
        quadArray[quadIndex++] = *new_quad_unary(op, result, arg1);
    } else {
        printf("Error: quadArray is full\n");
        exit(EXIT_FAILURE); 
    }
}

// Function to emit copy quad
void emitCopy(char* result, char* arg1) {
    if (quadIndex < NSYMS) {
        quadArray[quadIndex++] = *new_quad_binary('=', result, arg1, "");
    } else {
        printf("Error: quadArray is full\n");
        exit(EXIT_FAILURE); 
    }
}

quad *new_quad_binary(opcodeType op1, char *s1, char *s2, char *s3) {
    quad *q = (quad *)malloc(sizeof(quad));
    q->op = op1;
    q->result = strdup(s1);
    q->arg1 = strdup(s2);
    q->arg2 = strdup(s3);
    return q;
}

quad *new_quad_unary(opcodeType op1, char *s1, char *s2) {
    quad *q = (quad *)malloc(sizeof(quad));
    q->op = op1;
    q->result = strdup(s1);
    q->arg1 = strdup(s2);
    q->arg2 = 0;
    return q;
}

void print_quad(quad* q, int index) {
    printf("%d:\t", index);

    switch (q->op) {
        case PLUS:
            printf("%s = %s + %s\n", q->result, q->arg1, q->arg2);
            break;
        case MINUS:
            printf("%s = %s - %s\n", q->result, q->arg1, q->arg2);
            break;
        case UNARYMINUS:
            printf("%s = -%s\n", q->result, q->arg1);
            break;
        case MOD:
            printf("%s = %s %% %s\n", q->result, q->arg1, q->arg2);
            break;
        case MULT:
            printf("%s = %s * %s\n", q->result, q->arg1, q->arg2);
            break;
        case DIV:
            printf("%s = %s / %s\n", q->result, q->arg1, q->arg2);
            break;
        // Add cases for other operators as needed
        default:
            printf("Unknown operation\n");
            break;
    }
}


int main(int argc, char *argv[]) {

    // Call the lexer
    if (yylex() != 0) {
    fprintf(stderr, "Lexer Error: Unable to lex the input: %s\n", yytext());
    printf("Line no: %d", yyleng());
    exit(EXIT_FAILURE);
}


    // Call the parser
    if (yyparse() != 0) {
        fprintf(stderr, "Parser Error: Unable to parse the input.\n");
        exit(EXIT_FAILURE);
    }

/*     yylex();
    yyparse(); */

    // print SymbolTable
    printf("Symbol Table:\n");
    printSymbolTable(&symtab[0], "global", "null"); // Assuming symtab is the global symbol table

    // Print the TAC/quads
    printf("TAC:\n");
    for (int i = 0; i < quadIndex; i++) {
        print_quad(&quadArray[i], i);
    }

    // Free allocated memory

    // Free symbol table
    for (int i = 0; i < NSYMS; i++) {
        if (symtab[i].symbols[0].name != NULL) {
            free(symtab[i].symbols[0].name);
            free(symtab[i].symbols[0].symbol);
        }
    }

    // Free quads
    for (int i = 0; i < NSYMS; i++) {
        free(quadArray[i].result);
        free(quadArray[i].arg1);
        free(quadArray[i].arg2);
    }

    return 0;
}