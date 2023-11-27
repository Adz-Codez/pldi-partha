%{
    
%}

DIGIT 0|([1-9][0-9]*)
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
CHARCONST \'(\\['"?\\abfnrtv]|[^'\\\n])?\'
PUNC ";"
COMMENTS \/\/[^\n]*
M_COMMENTS \/\*([^*]|\*[^/])*\*\/

%%

{COMMENTS} ;

{M_COMMENTS} ;

int|char|void|int\*|char\*|void\* { printf("<KEYWORD,%s>", yytext); }

{KEYWORD} { printf("<KEYWORD,%s>", yytext); }

{CHARCONST} { printf("<CONSTANT,%s>", yytext); }

{STRCONST} { printf("<STRING-LITERAL,%s>", yytext); }

{ALPHA}{ALPHANUM}* { printf("<IDENTIFIER,%s>", yytext); }

-{DIGIT}+|{DIGIT}+ { printf("<CONSTANT,%s>", yytext); }

(-{DIGIT}+"."{DIGIT}*)|({DIGIT}+"."{DIGIT}*) { printf("<CONSTANT,%s>", yytext); }

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
