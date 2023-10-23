# Makefile for lexer

# Compiler
CC = gcc

# Flex
FLEX = flex

# Source files
LEX_FILE = 6_A2.l
C_FILE = 6_A2.c

# Output binary
OUTPUT_BINARY = lexer

# Compile commands
all: lex.yy.c
	$(CC) lex.yy.c $(C_FILE) -o $(OUTPUT_BINARY)

lex.yy.c: $(LEX_FILE)
	$(FLEX) $(LEX_FILE)

test:
	./$(OUTPUT_BINARY) < 6_A2.nc

clean:
	rm -f lex.yy.c $(OUTPUT_BINARY)

build: clean all
