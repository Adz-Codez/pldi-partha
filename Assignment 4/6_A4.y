%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "6_A4_translator.h"
    /* The are the C declarations and definitions for the Bison file*/
    
    extern char* yytext;
    extern int yylex();
    
    void yyerror(char *s);
    void yyerror(char *s) {
    printf("Error: %s on '%s'\n", s, yytext);
    }

    quad *qArray[NSYMS]; // This is the store of quads
    // We also need pointer/index to the next quad
    int nextquad = 0;

    symbolTable* symTable; // Include symbol table if needed for parsing
%}

%union {
    int intval;
    char *strval;
    symbolTable *symp;
}

%token <symp> ID
%token <strval> STRING_LITERAL
%token OP_PARENTHESIS
%token CL_PARENTHESIS
%token OP_ARROW
%token OP_SQUARE_BRACKET
%token CL_SQUARE_BRACKET
%token OP_COMMA
%left OP_DEREF
%left OP_SIGNP
%left OP_SIGNN
%token OP_NOT
%token OP_ADDR
%left OP_SLASH
%left OP_MOD
%left OP_SLESS
%left OP_SGREAT
%left OP_LEQ
%left OP_GEQ
%left OP_EQUALITY
%left OP_NEQ
%left OP_AND
%left OP_OR
%left OP_COLON
%left OP_QUES
%right OP_ASSIGN
%token OP_SEMICOLON
%token KEY_VOID
%token KEY_CHAR
%token KEY_INT
%token KEY_IF
%token KEY_ELSE
%token KEY_FOR
%token KEY_RETURN
%token OP_CURLY_BRACE
%token CL_CURLY_BRACE
%token <intval> INTEGER_CONSTANT
%token <strval> CHARACTER_CONSTANT

%%

translation_unit: external_declaration {printf("translation-unit\n");}
                | translation_unit external_declaration {printf("translation-unit\n");}
                ;

external_declaration: declaration {printf("external-declaration\n");}
                    | function_definition {printf("external-declaration\n");}
                    ;

function_definition: type_specifier declarator compound_statement {printf("function-definition\n");}
                    ;

statement: compound_statement {printf("statement\n");}
        | expression_statement {printf("statement\n");}
        | selection_statement {printf("statement\n");}
        | iteration_statement {printf("statement\n");}
        | jump_statement {printf("statement\n");}
        ;

compound_statement: OP_CURLY_BRACE block_item_list_opt CL_CURLY_BRACE {printf("compound-statement\n");}
                ;

block_item_list_opt: block_item_list
                    |
                    ;

block_item_list: block_item {printf("block-item-list\n");}
                | block_item_list block_item {printf("block-item-list\n");}
                ;

block_item: declaration {printf("block-item\n");}
            | statement {printf("block-item\n");}
            ;

expression_statement: expression_opt OP_SEMICOLON {printf("expression-statement\n");}
                  ;

expression_opt: expression
                | 
                ;

selection_statement: KEY_IF OP_PARENTHESIS expression CL_PARENTHESIS statement {printf("selection-statement\n");}
                 | KEY_IF OP_PARENTHESIS expression CL_PARENTHESIS statement KEY_ELSE statement {printf("selection-statement\n");}
                 ;

iteration_statement: KEY_FOR OP_PARENTHESIS expression_opt OP_SEMICOLON expression_opt OP_SEMICOLON expression_opt CL_PARENTHESIS statement {printf("iteration-statement\n");}
                 ;

jump_statement: KEY_RETURN expression_opt OP_SEMICOLON {printf("jump-statement\n");}
             ;

declaration: type_specifier init_declarator OP_SEMICOLON {printf("declaration\n");}
          ;

init_declarator: declarator {printf("init-declarator\n");}
              | declarator OP_ASSIGN initializer {printf("init-declarator\n");}
              ;

type_specifier: KEY_VOID {printf("type-specifier\n");}
             | KEY_CHAR {printf("type-specifier\n");}
             | KEY_INT {printf("type-specifier\n");}
             ;

declarator: pointer_opt direct_declarator {printf("declarator\n");}
         ;

pointer_opt: pointer
            |
            ;

pointer: OP_DEREF {printf("pointer\n");}
        ;

direct_declarator: ID { printf("direct-declarator for %s\n", $1->name);}
                | ID OP_SQUARE_BRACKET INTEGER_CONSTANT CL_SQUARE_BRACKET {printf("direct-declarator %s\n", $1->name);}
                | ID OP_PARENTHESIS parameter_list_opt CL_PARENTHESIS {printf("direct-declarator %s\n", $1->name);}
                ;

parameter_list_opt: parameter_list
                    |
                    ;

parameter_list: parameter_declaration {printf("parameter-list\n");}
             | parameter_list OP_COMMA parameter_declaration {printf("parameter-list\n");}
             ;

parameter_declaration: type_specifier pointer_opt identifier_opt {printf("parameter-declaration\n");}
                   ;

identifier_opt: ID
            |
            ;

initializer: assignment_expression {printf("initializer\n");}
          ;

primary_expression: ID {printf("primary-expression\n");}
    | constant {printf("primary-expression\n");}
    | STRING_LITERAL {printf("primary-expression\n");}
    | OP_PARENTHESIS expression CL_PARENTHESIS {printf("primary-expression\n");}
    ;

constant: INTEGER_CONSTANT
    | CHARACTER_CONSTANT;

postfix_expression: primary_expression {printf("postfix-expression\n");}
    | postfix_expression OP_SQUARE_BRACKET expression CL_SQUARE_BRACKET {printf("postfix-expression\n");}
    | postfix_expression OP_PARENTHESIS argument_expression_list_opt CL_PARENTHESIS {printf("postfix-expression\n");}
    | postfix_expression OP_ARROW ID {printf("postfix-expression\n");}
    ;

argument_expression_list_opt: argument_expression_list
    | ;

argument_expression_list: assignment_expression {printf("argument-expression-list\n");}
                        | argument_expression_list OP_COMMA assignment_expression {printf("argument-expression-list\n");}
                        ;

unary_expression: postfix_expression {printf("unary-expression\n");}
                | unary_operator unary_expression {printf("unary-expression\n");}
                ;

unary_operator: OP_ADDR {printf("unary-operator\n");}
            | OP_DEREF {printf("unary-operator\n");}
            | OP_SIGNP {printf("unary-operator\n");}
            | OP_SIGNN {printf("unary-operator\n");}
            | OP_NOT {printf("unary-operator\n");}
            ;

multiplicative_expression: unary_expression {printf("multiplicative-expression\n");}
                      | multiplicative_expression OP_DEREF unary_expression {printf("multiplicative-expression\n");}
                      | multiplicative_expression OP_SLASH unary_expression {printf("multiplicative-expression\n");}
                      | multiplicative_expression OP_MOD unary_expression {printf("multiplicative-expression\n");}
                      ;

additive_expression: multiplicative_expression {printf("additive-expression\n");}
                | additive_expression OP_SIGNP multiplicative_expression {printf("additive-expression\n");}
                | additive_expression OP_SIGNN multiplicative_expression {printf("additive-expression\n");}
                ;

relational_expression: additive_expression {printf("relational-expression\n");}
                  | relational_expression OP_SLESS additive_expression {printf("relational-expression\n");}
                  | relational_expression OP_SGREAT additive_expression {printf("relational-expression\n");}
                  | relational_expression OP_LEQ additive_expression {printf("relational-expression\n");}
                  | relational_expression OP_GEQ additive_expression {printf("relational-expression\n");}
                  ;

equality_expression: relational_expression {printf("equality-expression\n");}
                | equality_expression OP_EQUALITY relational_expression {printf("equality-expression\n");}
                | equality_expression OP_NEQ relational_expression {printf("equality-expression\n");}
                ;

logical_AND_expression: equality_expression {printf("logical-AND-expression\n");}
                   | logical_AND_expression OP_AND equality_expression {printf("logical-AND-expression\n");}
                   ;

logical_OR_expression: logical_AND_expression {printf("logical-OR-expression\n");}
                    | logical_OR_expression OP_OR logical_AND_expression {printf("logical-OR-expression\n");}
                    ;

conditional_expression: logical_OR_expression OP_QUES expression OP_COLON conditional_expression {printf("conditional-expression\n");}
                        | logical_OR_expression {printf("conditional-expression\n");}
                        ;

assignment_expression: unary_expression OP_ASSIGN assignment_expression {printf("assignment-expression\n");}
                    | conditional_expression {printf("assignment-expression\n");}
                    ;

expression: assignment_expression {printf("expression\n");}
            ;

%%

