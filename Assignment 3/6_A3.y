%{
    /* The are the C declarations and definitions for the Bison file*/
    extern int yylex();
    void yyerror(char *s);
%}

%token ID, constant, STRING_LITERAL, OP_PARENTHESIS, CL_PARENTHESIS, OP_ARROW, OP_SQUARE_BRACKET
%token CL_SQUARE_BRACKET, INTEGER_CONSTANT, CHARACTER_CONSTANT, OP_COMMA, OP_ASSIGNMENT, OP_ADDITION
%token OP_SUBTRACTION, OP_MULTIPLICATION, OP_DIVISION, OP_MODULO, OP_LESS_THAN, OP_GREATER_THAN
%token OP_LESS_THAN_EQUAL, OP_GREATER_THAN_EQUAL, OP_EQUAL, OP_NOT_EQUAL, OP_LOGICAL_AND, OP_LOGICAL_OR
%token OP_LOGICAL_NOT, OP_BITWISE_AND, OP_BITWISE_OR, OP_BITWISE_XOR, OP_BITWISE_NOT, OP_SHIFT_LEFT
%token OP_SHIFT_RIGHT, OP_INCREMENT, OP_DECREMENT, OP_COMPOUND_ASSIGNMENT, OP_ADDITION_ASSIGNMENT
%token SEMICOLON, OP_CURLY_BRACE, CL_CURLY_BRACE, OP_COLON, OP_QUESTION_MARK, OP_DOT, OP_ELLIPSIS

%type primary_expression, constant, postfix_expression, argument_expression_list_opt, argument_expression_list
%type unary_expression, multiplicative_expression, additive_expression, relational_expression, equality_expression
%type logical_AND_expression, logical_OR_expression, conditional_expression, assignment_expression, expression
%type declaration, init_declarator, type_specifier, declarator, pointer_opt, direct_declarator, parameter_list_opt
%type parameter_list, parameter_declaration, initializer, statement, compound_statement, block_item_list_opt
%type block_item_list, block_item, expression_statement, expression_opt, selection_statement, iteration_statement
%type jump_statement, translation_unit, external_declaration, function_definition

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

postfix-expression: primary_expression {printf("primary-expression\n");}
    | postfix_expression OP_SQUARE_BRACKET expression CL_SQUARE_BRACKET {printf("postfix-expression\n");}
    | postfix_expression OP_PARENTHESIS argument_expression_list_opt CL_PARENTHESIS {printf("postfix-expression\n");}
    | postfix_expression OP_ARROW ID {printf("postfix-expression\n");}

argument_expression_list: assignment_expression {printf("argument-expression-list\n");}
                        | argument_expression_list ',' assignment_expression {printf("argument-expression-list\n");}
                        ;

unary_expression: postfix_expression {printf("unary-expression\n");}
                | unary_operator unary_expression {printf("unary-expression\n");}
                ;

unary_operator: '&' {printf("unary-operator\n");}
            | '*' {printf("unary-operator\n");}
            | '+' {printf("unary-operator\n");}
            | '-' {printf("unary-operator\n");}
            | '!' {printf("unary-operator\n");}
            ;

multiplicative_expression: unary_expression {printf("multiplicative-expression\n");}
                      | multiplicative_expression '*' unary_expression {printf("multiplicative-expression\n");}
                      | multiplicative_expression '/' unary_expression {printf("multiplicative-expression\n");}
                      | multiplicative_expression '%' unary_expression {printf("multiplicative-expression\n");}
                      ;

additive_expression: multiplicative_expression {printf("additive-expression\n");}
                | additive_expression PLUS multiplicative_expression {printf("additive-expression\n");}
                | additive_expression MINUS multiplicative_expression {printf("additive-expression\n");}
                ;

relational_expression: additive_expression {printf("relational-expression\n");}
                  | relational_expression LESS additive_expression {printf("relational-expression\n");}
                  | relational_expression GREATER additive_expression {printf("relational-expression\n");}
                  | relational_expression LESS_EQUAL additive_expression {printf("relational-expression\n");}
                  | relational_expression GREATER_EQUAL additive_expression {printf("relational-expression\n");}
                  ;

equality_expression: relational_expression {printf("equality-expression\n");}
                | equality_expression EQUAL relational_expression {printf("equality-expression\n");}
                | equality_expression NOT_EQUAL relational_expression {printf("equality-expression\n");}
                ;

logical_AND_expression: equality_expression {printf("logical-AND-expression\n");}
                   | logical_AND_expression AND equality_expression {printf("logical-AND-expression\n");}
                   ;

logical_OR_expression: logical_AND_expression {printf("logical-OR-expression\n");}
                  | logical_OR_expression OR logical_AND_expression {printf("logical-OR-expression\n");}
                  ;

conditional_expression: logical_OR_expression {printf("conditional-expression\n");}
                   | logical_OR_expression '?' expression COLON conditional_expression {printf("conditional-expression\n");}
                   ;

assignment_expression: conditional_expression {printf("assignment-expression\n");}
                  | unary_expression '=' assignment_expression {printf("assignment-expression\n");}
                  ;

expression: assignment_expression {printf("expression\n");}
         ;

declaration: type_specifier init_declarator SEMICOLON {printf("declaration\n");}
          ;

init_declarator: declarator {printf("init-declarator\n");}
              | declarator '=' initializer {printf("init-declarator\n");}
              ;

type_specifier: VOID {printf("type-specifier\n");}
             | CHAR {printf("type-specifier\n");}
             | INT {printf("type-specifier\n");}
             ;

declarator: pointer_opt direct_declarator {printf("declarator\n");}
         ;

pointer_opt: /* empty */
          | pointer {printf("pointer\n");}
          ;

direct_declarator: ID {printf("direct-declarator\n");}
                | ID OP_SQUARE_BRACKET INTEGER_CONSTANT CL_SQUARE_BRACKET {printf("direct-declarator\n");}
                | ID OP_PARENTHESIS parameter_list_opt CL_PARENTHESIS {printf("direct-declarator\n");}
                ;

parameter_list_opt: /* empty */
                | parameter_list {printf("parameter-list\n");}
                ;

parameter_list: parameter_declaration {printf("parameter-list\n");}
             | parameter_list COMMA parameter_declaration {printf("parameter-list\n");}
             ;

parameter_declaration: type_specifier pointer_opt ID {printf("parameter-declaration\n");}
                   ;

initializer: assignment_expression {printf("initializer\n");}
          ;

statement: compound_statement {printf("statement\n");}
        | expression_statement {printf("statement\n");}
        | selection_statement {printf("statement\n");}
        | iteration_statement {printf("statement\n");}
        | jump_statement {printf("statement\n");}
        ;

compound_statement: OP_CURLY_BRACE block_item_list_opt CL_CURLY_BRACE {printf("compound-statement\n");}
                ;

block_item_list_opt: /* empty */
                | block_item_list {printf("block-item-list\n");}
                ;

block_item_list: block_item {printf("block-item-list\n");}
             | block_item_list block_item {printf("block-item-list\n");}
             ;

block_item: declaration {printf("block-item\n");}
          | statement {printf("block-item\n");}
          ;

expression_statement: expression_opt SEMICOLON {printf("expression-statement\n");}
                  ;

expression_opt: /* empty */
             | expression {printf("expression-opt\n");}
             ;

selection_statement: IF OP_PARENTHESIS expression CL_PARENTHESIS statement {printf("selection-statement\n");}
                 | IF OP_PARENTHESIS expression CL_PARENTHESIS statement ELSE statement {printf("selection-statement\n");}
                 ;

iteration_statement: FOR OP_PARENTHESIS expression_opt SEMICOLON expression_opt SEMICOLON expression_opt CL_PARENTHESIS statement {printf("iteration-statement\n");}
                 ;

jump_statement: RETURN expression_opt SEMICOLON {printf("jump-statement\n");}
             ;

translation_unit: external_declaration {printf("translation-unit\n");}
               | translation_unit external_declaration {printf("translation-unit\n");}
               ;

external_declaration: declaration {printf("external-declaration\n");}
                 | function_definition {printf("external-declaration\n");}
                 ;

function_definition: type_specifier declarator compound_statement {printf("function-definition\n");}
                 ;

%%
int main() {
    yyparse();
    return 0;
}

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}

