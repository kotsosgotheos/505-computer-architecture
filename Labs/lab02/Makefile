LAB = lab02
NAME = Lab02TestBSearch

CC = java
OPT =
VERSION =
OUTPUT = $(NAME).class

LIBS = munit.jar
WARNINGS =

JAVA = $(NAME).java
ASM = $(LAB).asm

all: run

compile:
	javac -cp $(LIBS) $(JAVA)

run: compile
	java -jar $(LIBS) $(ASM) $(OUTPUT)

clean:
	rm -rf $(OUTPUT)
