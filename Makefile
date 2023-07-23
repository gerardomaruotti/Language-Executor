default: scanner parser

	javac *.java

scanner:
	jflex scanner.jflex

parser:
	java java_cup.MainDrawTree -parser parser parser.cup

clean:

	rm -fr parser.java Yylex.java sym.java
	rm -vfr *.class
	rm -vfr *.*~

init:
	mkdir source build

run:
	java Main input.txt

new: default run