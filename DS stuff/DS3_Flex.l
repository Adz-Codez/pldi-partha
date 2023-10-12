%{
	#include <stdio.h>
	#include <stdlib.h> // dont put for assignment
%}

DIGIT [0-9]	
%{
	// Character class [az] : a + z
	// [a-z] : a + .... + z
%}

ALPH [a-z]

%%

{DIGIT} {
	printf("Digit : %s\n", yytext);
	return 5;
}

{ALPH} {
	printf("Alph: %s\n", yytext);
	return 6;
}

{DIGIT}{ALPH} {
	printf("AlphaBEAT %s\n", yytext);
	return 7;
}

. {
	printf("Invalid Input: %s\n", yytext);
	return yywrap();
}

%%

int yywrap() {
	return 1;
}

// why the fuck is there c code in the c compiler LMAO
// Yeah this is the c-code section lol
int main() {
	int token;
	while(token = yylex()){
		printf("%d\n", token);
	}
	yylex();
}