// This is the main translator program
// This is where we will use all the functions defined in the header file
// It is also where the main() function for printing the TAC will also go

#include "6_A4_translator.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

extern int yyparse();
extern int yylex();
extern int yyget_leng();
extern int yyget_text();

// Array to represent the global symbol table
symbolTable symtab[NSYMS];

// Function to look up a symbol in the symbol table
symbolTable* symlook(char* s) {
    symbolTable* sp;
    for (sp = symtab; sp < &symtab[NSYMS]; sp++) {
        // Check if it exists
        if (sp->symbols->name && strcmp(sp->symbols->name, s) == 0)
            return sp;
        // Check whether it is free
        if (!sp->symbols->name) {
            // Allocate memory for the symbol using strdup() and return the symbol table entry pointer
            sp->symbols->name = strdup(s);
            return sp;
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
    // Add temporary to the symbol table
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
void printSymbolTable(symbolTable* table) {
    printf("===========================\n");
    printf("Table Name: %s\t Parent Name: %s\n", table->name, (table->parent ? table->parent->name : "None"));
    printf("===========================\n");
    printf("%-20s%-20s%-20s%-20s%-20s%-20s\n", "Name", "Type", "Initial Value", "Offset", "Size", "Child");

    // Iterate over symbols in the current table
    for (int i = 0; i < NSYMS; i++) {
        if (table->symbols[i].name != NULL) {
            printf("%-20s", table->symbols[i].name);
            fflush(stdout);
            printf("%-20s", (table->symbols[i].symbol->isFunc ? "function" : symbolTypeToString(table->symbols[i].symbol->type)));
            printf("%-20s%-20d%-20d", table->symbols[i].symbol->initVal, table->symbols[i].symbol->offset, table->symbols[i].symbol->size);
            printf("%-20s\n", (table->symbols[i].symbol->nestedTable ? table->symbols[i].symbol->nestedTable->name : "NULL"));
        }
    }

    printf("===========================\n\n");

    // Recursively print children tables
    for (int i = 0; i < NSYMS; i++) {
        if (table->symbols[i].name != NULL && table->symbols[i].symbol->nestedTable != NULL) {
            printSymbolTable(table->symbols[i].symbol->nestedTable);
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

int main() {
    char input[512];
    char code[4096]; 
    int codeIndex = 0;

    // Loop to take user input until "exit" is typed
    printf("Enter your code line by line. Type 'exit' to start semantic analysis:\n");
    while (1) {
        // Read a line of input
        if (fgets(input, sizeof(input), stdin) == NULL) {
            printf("Error reading input.\n");
            exit(EXIT_FAILURE);
        }

        // Check if the user wants to exit
        if (strcmp(input, "exit\n") == 0) {
            break;
        }

        // Append the line to the code
        strcpy(code + codeIndex, input);
        codeIndex += strlen(input);
    }

    // Call the lexer
    yylex();

    // Check lexer errors
    if (yyget_leng() > 0) {
        fprintf(stderr, "Lexer Error: %d\n", yyget_text());
        exit(EXIT_FAILURE);
    }

    // Call the parser
    if (yyparse() != 0) {
        fprintf(stderr, "Parser Error: Unable to parse the input.\n");
        exit(EXIT_FAILURE);
    }

    // Example: Print symbol table
    printf("Symbol Table:\n");
    printSymbolTable(&symtab[0]); // Assuming symtab is your global symbol table

   

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