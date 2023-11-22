// This is the main translator program
// This is where we will use all the functions defined in the header file
// It is also where the main() function for printing the TAC will also go

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "6_A4_translator.h"

/* Defining the Symbol Table*/
symboltable symtab[NSYMS];

extern void yyerror(char *s);

/* now for symlook and the symbol table*/

symboltable *symlook(char *s){
    // Initializing first
    symboltable *sp;

    for(sp = symtab; sp < &symtab[NSYMS]; sp++){

    }
}