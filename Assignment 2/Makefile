CC = gcc # CC = C Compiler
LEX = flex # LEX = fLEX

# Target binary name
TARGET = 6_A2

# List of secondary files that should not be deleted on failure
.SECONDARY: $(TARGET).c

all: $(TARGET) test # Remove 'test' if you don't want to run it automatically, clean just removes the out file and lex.yy.c

$(TARGET): $(TARGET).c lex.yy.c
	$(CC) -o $@ $^ 

$(TARGET).c: $(TARGET).l
	$(LEX) -o$@ $<

lex.yy.c: $(TARGET).l
	$(LEX) $<

clean:
	rm -f $(TARGET) lex.yy.c

test: $(TARGET)
	./$(TARGET) < $(TARGET).nc

.PHONY: all clean test
