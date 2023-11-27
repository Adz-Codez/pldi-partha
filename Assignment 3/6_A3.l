%{
    #include <stdio.h>
    /* Any definitions and/or declarations that are required by the lexer to work correctly*/
    #include "6_A3.tab.h"
%}

DIGIT 0|([1-9][0-9]*)
LETTER [_a-zA-Z]
ALPHA ({LETTER})
ALPHANUM ({ALPHA}|{DIGIT})
SPACE [ \t]
STRCONST \"(\\['"?\\abfnrtv]|[^"\\\n])*\"
CHARCONST \"(\\['"?\\abfnrtv]|[^"\\\n])?\"
COMMENTS \/\/[^\n]*
M_COMMENTS \/\*([^*]|\*[^/])*\*\/

%%

{COMMENTS} ;

{M_COMMENTS} ;

"int" { return KEY_INT; }

"char" { return KEY_CHAR; }

"void" { return KEY_VOID; }

"for" { return KEY_FOR; }

"if" { return KEY_IF; }

"else" { return KEY_ELSE; }

"return" { return KEY_RETURN; }

{CHARCONST} { return CHARACTER_CONSTANT; }

{DIGIT}+ { return INTEGER_CONSTANT; }

{STRCONST} { return STRING_LITERAL; }

{ALPHA}{ALPHANUM}* { return ID; }

(-{DIGIT}+"."{DIGIT}*)|({DIGIT}+"."{DIGIT}*) { return INTEGER_CONSTANT; }

";" { return OP_SEMICOLON; }

"," { return OP_COMMA; }

"(" { return OP_PARENTHESIS; }

")" { return CL_PARENTHESIS; }

"[" { return OP_SQUARE_BRACKET; }

"]" { return CL_SQUARE_BRACKET; }

"{" { return OP_CURLY_BRACE; }

"}" { return CL_CURLY_BRACE; }

"=" { return OP_ASSIGN; }

"==" { return OP_EQUALITY; }

"!=" { return OP_NEQ; }

">" { return OP_SGREAT; }

"<" { return OP_SLESS; }

">=" { return OP_GEQ; }

"<=" { return OP_LEQ; }

"?" { return OP_QUES; }

":" { return OP_COLON; }

"&&" { return OP_AND; }

"||" { return OP_OR; }

"!" { return OP_NOT; }

"+" { return OP_SIGNP; }

"-" { return OP_SIGNN; }

"*" { return OP_DEREF; }

"&" { return OP_ADDR; }

"/" { return OP_SLASH; }

"%" { return OP_MOD; }

"->" { return OP_ARROW; }

{SPACE}+ ; 

"\n" ;

. { yyterminate(); /* using yyterminate() to stop the execution of the lexer */}

%%

int yywrap() {
    return 1;
}
