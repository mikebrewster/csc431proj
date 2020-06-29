# Makefile for building and running the mini compiler on Windows.

# Set the ANTLRJAR variable to point to your ANTLR Java binaries .jar file (download from https://www.antlr.org/download.html).
# If your PATH environment variable does not include javac.exe and java.exe (included with the JDK), either add them to
# your PATH, or update the JAVAC and JAVA variables below to point to the locations of javac.exe and java.exe respectively.

# Execute "make" in the directory of this Makefile to build.
# Execute "make run in=<mini-file> out=<json-file>" to run the parser on the given input file and save the AST into a JSON file.

# Tested with Java version 13.0.2

JAVAC=javac
JAVA=java
ANTLRJAR=./antlr-4.7.2-complete.jar

FILES=MiniCompiler.java MiniToJsonVisitor.java MiniToAstDeclarationsVisitor.java MiniToAstExpressionVisitor.java MiniToAstFunctionVisitor.java MiniToAstProgramVisitor.java MiniToAstStatementVisitor.java MiniToAstTypeDeclarationVisitor.java MiniToAstTypeVisitor.java

GENERATED=MiniBaseVisitor.java MiniLexer.java MiniLexer.tokens Mini.tokens MiniVisitor.java MiniParser.java MiniBaseListener.java MiniListener.java

all : MiniCompiler.class

MiniCompiler.class : antlr.generated ${FILES}
	$(JAVAC) -cp ${CLASSPATH};$(ANTLRJAR) *.java ast/*.java

antlr.generated : Mini.g4
	$(JAVA) -cp ${CLASSPATH};$(ANTLRJAR) org.antlr.v4.Tool -visitor Mini.g4
	echo > antlr.generated

clean:
	del *.generated ${GENERATED} *.class ast\*.class 2>NUL

run: MiniCompiler.class
	$(JAVA) -cp ${CLASSPATH};$(ANTLRJAR) MiniCompiler $(in) > $(out)
