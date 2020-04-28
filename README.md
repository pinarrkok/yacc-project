# Programming Language pin

  **Pinar Kok - 20160808013**

## Syntax

    <if> ::= if (<expression>) <statement>
    
    <while statement> ::= while (<expression>) <statement> 
    
    <expression> ::= <expression> | <assignment>
    
    <assignment operator> ::= =
    
    <term> ::= <number> | <identifier>
    
    <article> ::= <character> | <identifier>
    
    <number> ::= <number> | <digit>
    
    <digit> ::= 0 | 1 |2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 
    
    <boolean> ::= 1 | 0
    
    <math operations> ::= + | - | * | /
    
    <comparison operations> ::= < | > | != | <= | >= | == | && | || 

## Explanations

•	pin takes a file with extension “.pin”.

•	It has if, else, while, print, printchar, comment etc.

•	The token *error* is reserved for error handling. This can be used in grammer rules, to indicate where error might occur, and recovery take place. When an error is detected:

 * 	If an *error* token is specified, the parser pop its stack until it finds a state where the error token is legal. It then behaves as    if error is the current lookahead token, and performs the action encountered.

 * 	If there is no rule using the *error* token, processing halts when an error is encountered.

•	You can run the test program by running the makefile and giving it to “pin” as input:

    make ./pin
    ./pin < test.pin
