%{
    /* The are the C declarations and definitions for the Bison file*/
    extern int yylex();
    void yyerror(char *s);
%}

%token ID, constant, STRING_LITERAL, OP_PARENTHESIS, CL_PARENTHESIS 

%type // list types here

%%
// First we fill in the grammar rules for expressions
/* The grammar is structured in a hierarchical way with precedences resolved. Associativity is handled
by left or right recursion as appropriate.*/
primary_expression: ID {printf("primary-expression\n");}
    | constant {printf("primary-expression\n");}
    | STRING_LITERAL {printf("primary-expression\n");}
    | OP_PARENTHESIS expression CL_PARENTHESIS {printf("primary-expression\n");}
    ;
// =======================
constant: INTEGER_CONSTANT
    | CHARACTER_CONSTANT;
// =======================
postfix_expression: primary_expression {printf("postfix-expression\n");}
    | postfix_expression OP_SQUARE_BRACKET expression CL_SQUARE_BRACKET {printf("postfix-expression\n");}
    | postfix_expression OP_PARENTHESIS argument_expression_list_opt CL_PARENTHESIS {printf("postfix-expression\n");}
    | postfix_expression OP_ARROW ID {printf("postfix-expression\n");}
    ;

argument_expression_list_opt: argument_expression_list
    | ; // empty (epsilon) production

postfix-expression: // Expressions with postfix operators. Left assoc. in C; non-assoc. here
    primary-expression
    postfix-expression [ expression ] // 1-D array access
    postfix-expression ( argument-expression-listopt ) // Function invocation
    postfix-expression -> identifier // Pointer indirection. Only one level

argument-expression-list:
    assignment-expression
    argument-expression-list , assignment-expression

unary-expression:
    postfix-expression
    unary-operator unary-expression // Expr. with prefix ops. Right assoc. in C; non-assoc. here
    // Only a single prefix op is allowed in an expression here
    unary-operator: one of
    & * + - ! // address op, de-reference op, sign ops, boolean negation op

multiplicative-expression: // Left associative operators
    unary-expression
    multiplicative-expression * unary-expression
    multiplicative-expression / unary-expression
    multiplicative-expression % unary-expression

additive-expression: // Left associative operators
    multiplicative-expression
    additive-expression + multiplicative-expression
    additive-expression - multiplicative-expression

relational-expression: // Left associative operators
    additive-expression
    relational-expression < additive-expression
    relational-expression > additive-expression
    relational-expression <= additive-expression
    relational-expression >= additive-expression

equality-expression: // Left associative operators
    relational-expression
    equality-expression == relational-expression
    equality-expression != relational-expression

logical-AND-expression: // Left associative operators
    equality-expression
    logical-AND-expression && equality-expression

logical-OR-expression: // Left associative operators
    logical-AND-expression
    logical-OR-expression || logical-AND-expression

conditional-expression: // Right associative operator
    logical-OR-expression
    logical-OR-expression ? expression : conditional-expression

assignment-expression: // Right associative operator
    conditional-expression
    unary-expression = assignment-expression // unary-expression must have lvalue

expression:
    assignment-expression
%%

void yyerror(char *s) {
    printf("Error: %s on '%s'\n",s,yytext);
}

int main() {
    yyparse();
    return 0;
}
