%{
    /* Any definitions and/or declarations that are required by the lexer to work correctly*/
    #include "y.tab.h"
%}

DIGIT [0-9]
LETTER [_a-zA-Z]
ALPHA ({LETTER})
ALPHANUM ({ALPHA}|{DIGIT})
SPACE [ \t]
AOP [\-\+\/\*\%]
ROP (>=)|(<=)|(!=)|(==)|\>|\<
LOP (\|\|)|(&&)|!
COP \?|\:
POP &|\*|(->)
ASOP [^=><!]=[^=]
KEYWORD for|do|while|if|else
SPECIAL [(){}\[\],]
STRCONST \"(\\['"?\\abfnrtv]|[^"\\\n])*\"
CHARCONST \'(\\['"?\\abfnrtv]|[^'\\\n])*\'
PUNC ";"
COMMENTS \/\/[^\n]*
M-COMMENTS "/*"([^*]|\*+[^*/])*\*+"/"

%%

{COMMENTS} ;

{M-COMMENTS} ;

int|char|void|int\*|char\*|void\* { return KEYWORD; } // It should all be of this type 

{KEYWORD} { return KEYWORD; }

{CHARCONST} { return CHARACTER_CONSTANT; }

{STRCONST} { return STRING_LITERAL; }

{ALPHA}{ALPHANUM}* { return ID; }

-{DIGIT}+|{DIGIT}+ { return INTEGER_CONSTANT; }

(-{DIGIT}+"."{DIGIT}*)|({DIGIT}+"."{DIGIT}*) { return INTEGER_CONSTANT; }

{PUNC} { printf("<PUNCTUATUATION,%s>", yytext); }

{SPECIAL} { printf("<PUNCTUATUATION,%s>", yytext); }

{AOP} { printf("<PUNCTUATUATION,%s>", yytext); }

{ROP} { printf("<PUNCTUATUATION,%s>", yytext); }

{LOP} { printf("<PUNCTUATUATION,%s>", yytext); }

{COP} { printf("<PUNCTUATUATION,%s>", yytext); }

{POP} { printf("<PUNCTUATUATION,%s>", yytext); }

{ASOP} { printf("<PUNCTUATUATION,%s>", yytext); }

{SPACE}+ ; 

"\n" {printf("\n");}

. { printf("<Invalid Token,%s>", yytext); yyterminate(); /* using yyterminate() to stop the execution of the lexer */}

%%

int yywrap() {
    return 1;
}
