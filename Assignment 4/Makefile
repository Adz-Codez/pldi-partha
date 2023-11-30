# Compiler
CC = gcc

# Bison and Flex files
BISON_FILE = 6_A4.y
FLEX_FILE = 6_A4.l

# Output files
BISON_OUTPUT = 6_A4.tab.c
FLEX_OUTPUT = lex.yy.c
EXECUTABLE = translator

# Action file and header file
ACTION_FILE = 6_A4_translator.c
HEADER_FILE = 6_A4_translator.h

# Flags
BISON_FLAGS = --defines=$(BISON_OUTPUT:.c=.h) -o $(BISON_OUTPUT)
FLEX_FLAGS = -o $(FLEX_OUTPUT)
CFLAGS = -Werror

# Build rule
build: clean compile

compile: $(EXECUTABLE)

$(EXECUTABLE): $(FLEX_OUTPUT) $(BISON_OUTPUT) $(ACTION_FILE) $(HEADER_FILE)
	$(CC) -o $@ $^ -lfl $(CFLAGS)

$(BISON_OUTPUT): $(BISON_FILE)
	bison $(BISON_FLAGS) $<

$(FLEX_OUTPUT): $(FLEX_FILE)
	flex $(FLEX_FLAGS) $<

# Clean rule
clean:
	rm -f $(FLEX_OUTPUT) $(BISON_OUTPUT) $(BISON_OUTPUT:.c=.h) $(EXECUTABLE)

.PHONY: build compile clean
