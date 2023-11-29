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
symboltable *symlook(char *s) {
	symboltable *sp;
	for (sp = symtab; sp < &symtab[NSYMS]; sp++) {
		/* is it already here? */
		if (sp->name &&
			!strcmp(sp->name, s))
			return sp;
		if (!sp->name) {
			/* is it free */
			sp->name = strdup(s);
			return sp;
		}
		/* otherwise continue to next */
	}
	yyerror("Too many symbols");
	exit(1); /* cannot continue */
} /* symlook */

/* Generate temporary variable */
symboltable *gentemp() {
	static int c = 0; /* Temp counter */
	char str[10]; /* Temp name */
	/* Generate temp name */
	sprintf(str, "t%02d", c++);
	/* Add temporary to symtab */
	return symlook(str);
}

/* Output 3-address codes */
void emit_binary(
	char *result,
	char *arg1,
	char op,
	char *arg2)
{
	/* Assignment with Binary operator */
	printf("\t%s = %s %c %s\n", result, arg1, op, arg2);
}

void emit_unary(
	char *result,
	char *arg1,
	char op)
{
	/* Assignment with Unary operator */
	printf("\t%s = %c %s\n", result, op, arg1);
}

void emit_copy(
	char *result,
	char *arg1)
{
	/* Simple Assignment */
	printf("\t%s = %s\n", result, arg1);
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