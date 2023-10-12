%{
    
%}

DIGIT [0-9]
LETTER [a-zA-Z]
ALPHA ({LETTER}|_)
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
STRCONST \"(\\.|[^"\\])*\"
CHARCONST '.'
PUNC ";"
COMMENTS "//".*|\/\*.*\*\/

%%

{COMMENTS} ;

int|char|void|int\*|char\*|void\* { printf("<Data Type Keyword, %s > ", yytext); }

{KEYWORD} { printf("<Keyword, %s > ", yytext); }

{CHARCONST} { printf("<Character Literal, %s > ", yytext); }

{STRCONST} { printf("<String Literal, %s > ", yytext); }

[a-zA-z_]{ALPHANUM}* { printf("<Identifier, %s > ", yytext); }

-{DIGIT}+|{DIGIT}+ { printf("<Integer Literal, %s > ", yytext); }

(-{DIGIT}+"."{DIGIT}*)|({DIGIT}+"."{DIGIT}*) { printf("<Float Literal, %s > ", yytext); }

{PUNC} { printf("<Punctuatuation, %s > ", yytext); }

{SPECIAL} { printf("<Special Character, %s > ", yytext); }

{AOP} { printf("<Arithmetic Operator, %s > ", yytext); }

{ROP} { printf("<Realtional Operator, %s > ", yytext); }

{LOP} { printf("<Logical Operator, %s > ", yytext); }

{COP} { printf("<Conditional Operator, %s > ", yytext); }

{POP} { printf("<Pointer Operator, %s > ", yytext); }

{ASOP} { printf("<Assignment Operator, %s > ", yytext); }

{SPACE}+ ; 

"\n" {printf("\n");}

. { printf("<Invalid Token, %s > ", yytext); yyterminate(); /* using yyterminate() to stop the execution of the lexer */}

%%

int yywrap() {
    return 1;
}
