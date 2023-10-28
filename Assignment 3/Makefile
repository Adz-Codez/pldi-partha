# Makefile for 6_A3

# Compiler
CC = gcc

# Bison and Flex files
BISON_FILE = 6_A3.y
FLEX_FILE = 6_A3.l

# Output files
BISON_OUTPUT = 6_A3.tab.c
FLEX_OUTPUT = lex.yy.c
EXECUTABLE = parser

# Flags
BISON_FLAGS = --defines=$(BISON_OUTPUT:.c=.h) -o $(BISON_OUTPUT)
FLEX_FLAGS = -o $(FLEX_OUTPUT)
CFLAGS = -Werror

# Build rule
build: $(EXECUTABLE)

$(EXECUTABLE): $(FLEX_OUTPUT) $(BISON_OUTPUT) 6_A3.c
	$(CC) -o $@ $^ -lfl $(CFLAGS)

$(BISON_OUTPUT): $(BISON_FILE)
	bison $(BISON_FLAGS) $<

$(FLEX_OUTPUT): $(FLEX_FILE)
	flex $(FLEX_FLAGS) $<

# Clean rule
clean:
	rm -f $(FLEX_OUTPUT) $(BISON_OUTPUT) $(BISON_OUTPUT:.c=.h) $(EXECUTABLE)

.PHONY: build clean
