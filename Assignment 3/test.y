%{
#include <stdio.h>
%}

%token ID INTEGER_CONSTANT CHAR_CONSTANT STRING_LITERAL
%token OP_PARENTHESIS CL_PARENTHESIS OP_SQUARE_BRACKET CL_SQUARE_BRACKET OP_ARROW
%token PLUS MINUS TIMES DIVIDE MOD AND OR NOT
%token LESS GREATER LESS_EQUAL GREATER_EQUAL EQUAL NOT_EQUAL
%token SEMICOLON COMMA COLON

%%

primary_expression: ID {printf("primary-expression\n");}
                 | constant {printf("primary-expression\n");}
                 | STRING_LITERAL {printf("primary-expression\n");}
                 | OP_PARENTHESIS expression CL_PARENTHESIS {printf("primary-expression\n");}
                 ;

constant: INTEGER_CONSTANT {printf("constant\n");}
        | CHAR_CONSTANT {printf("constant\n");}
        ;

postfix_expression: primary_expression {printf("postfix-expression\n");}
                 | postfix_expression OP_SQUARE_BRACKET expression CL_SQUARE_BRACKET {printf("postfix-expression\n");}
                 | postfix_expression OP_PARENTHESIS argument_expression_list_opt CL_PARENTHESIS {printf("postfix-expression\n");}
                 | postfix_expression OP_ARROW ID {printf("postfix-expression\n");}
                 ;

argument_expression_list_opt: /* empty */
                         | argument_expression_list
                         ;

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
