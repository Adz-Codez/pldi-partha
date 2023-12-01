%{
    #include "6_A4_translator.h"
    #include "6_A4.tab.h"
    #include <stdio.h>
    #include <stdlib.h>
%}


DIGIT 0|([1-9][0-9]*)
LETTER [_a-zA-Z]
ALPHA ({LETTER})
ALPHANUM ({ALPHA}|{DIGIT})
SPACE [ \t]
STRCONST \"(\\['"?\\abfnrtv]|[^"\\\n])*\"
CHARCONST \'(\\['"?\\abfnrtv]|[^'\\\n])?\'
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

{CHARCONST} { yylval.symp = symlook(yytext); return CHARACTER_CONSTANT; }

{DIGIT}+ { yylval.intval = atoi(yytext); return INTEGER_CONSTANT; }

{STRCONST} { yylval.strval = strdup(yytext); return STRING_LITERAL; }

{ALPHA}{ALPHANUM}* { yylval.symp = symlook(yytext); return ID; }

(-{DIGIT}+"."{DIGIT}*)|({DIGIT}+"."{DIGIT}*) { yylval.intval = atof(yytext); return INTEGER_CONSTANT; }

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
