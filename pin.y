%{

void yyerror (char *s);
int yylex();

#include <stdio.h>    
#include <stdlib.h>
#include <ctype.h>
#include <string.h>


void newIntegerVariable(char* varname);
void newCharacterVariable(char* varname);
int isDeclaredBefore(char* varname);
int ValueOfIntegerVariable(char* varname);
char ValueOfCharacterVariable(char* varname);
int isValidVariable(char* varname);
void UpdateIntegerVariable(char* varname, int newValue);
void UpdateCharacterVariable(char* varname, char newValue);
void PrintLinkedList();

struct intNode
{
	char* variableName;
	int value;
	struct intNode* Next;
};

typedef struct intNode intNode;
intNode* headIntegerTable = NULL;

struct charNode
{
	char* variableName;
	char value;
	struct charNode* Next;

};

typedef struct charNode charNode;
charNode* headCharacterTable = NULL;

%}

%union {int num; char* id; char karakter; char* text;}     

%start line

%token print
%token printchar
%token exit_command
%token CURLYOPEN
%token CURLYCLOSE 
%token WHILE
%token IF
%token THEN
%token ELSE
%token COLON
%token SEMICOL
%token MINUS
%token PLUS
%token MULT
%token MODUL
%token ISEQ
%token ISNOTEQ
%token EQ
%token GRE
%token GREOREQ
%token SMAL
%token SMALOREQ
%token OPENBRACKET 
%token CLOSEBRACKET 
%token INT
%token CHAR
%token <num> number
%token <id> identifier
%token <karakter> character 

%type <num> line exp term if_statement decleration while_statement initialization
%type <id> assignment
%type <karakter> article

%%

line    :  decleration SEMICOL
		| line decleration SEMICOL	{;}
		| initialization SEMICOL	{;}
		| line initialization SEMICOL	{;}
		|assignment SEMICOL		{;}
		| exit_command   		{exit(EXIT_SUCCESS);}
		| print exp SEMICOL		{printf(">> %d\n", $2);}
		| printchar article SEMICOL  {printf(">> %c\n", $2);}
		| line printchar article SEMICOL  {printf(">> %c\n", $3);}
		| line print exp SEMICOL	{printf(">> %d\n", $3);}
		| line assignment SEMICOL	{;}
		| line exit_command      	{exit(EXIT_SUCCESS);}
		| if_statement SEMICOL          	 {printf(">> if well-formed\n"); if ($1) printf(">> Condition is true.\n"); else printf(">> Condition is false.\n");}
		| line if_statement SEMICOL              {printf(">> if well-formed\n"); if ($2) printf(">> Condition is true.\n"); else printf(">> Condition is false.\n");}
		| while_statement SEMICOL	{printf(">> while well-formed\n"); if ($1) printf(">> Condition is true.\n"); else printf(">> Condition is false.\n");}
		| line while_statement SEMICOL {printf(">> while well-formed\n"); if ($2) printf(">> Condition is true.\n"); else printf(">> Condition is false.\n");}
		
        ;

decleration : CHAR identifier {$$ = 1 ; newCharacterVariable($2);}
	    | INT identifier {$$ = 1 ; newIntegerVariable($2);}
	;

assignment : identifier EQ exp  { UpdateIntegerVariable($1,$3); }
	   | identifier EQ character {UpdateCharacterVariable($1, $3);}
	;

initialization: INT identifier EQ exp {$$ = 1 ; newIntegerVariable($2); UpdateIntegerVariable($2,$4); }
		| CHAR identifier EQ character {$$ = 1 ; newCharacterVariable($2); UpdateCharacterVariable($2,$4);}
		;

if_statement : IF OPENBRACKET exp CLOSEBRACKET CURLYOPEN line CURLYCLOSE                    {$$ = $3;}
	     | IF OPENBRACKET exp CLOSEBRACKET CURLYOPEN line CURLYCLOSE ELSE CURLYOPEN line CURLYCLOSE    {$$ = $3;}
;

while_statement : WHILE OPENBRACKET  exp CLOSEBRACKET CURLYOPEN line CURLYCLOSE           {$$ = $3;}

exp    	: term                  {$$ = $1;}
       	| exp PLUS term          {$$ = $1 + $3;}
       	| exp MINUS term          {$$ = $1 - $3;}
	| exp MULT term          {$$ = $1 * $3;}
	| exp MODUL term          {$$ = $1 % $3;}
	| exp ISEQ term          {$$ = $1 == $3; }
	| exp ISNOTEQ term          {$$ = $1 != $3; }
	| exp GRE term          {$$ = $1 > $3;}
	| exp GREOREQ term          {$$ = $1 >= $3; }
	| exp SMAL term          {$$ = $1 < $3;}	
	| exp SMALOREQ term          {$$ = $1 <= $3; }
       	;

term   	: number               {$$ = $1;}
	| identifier	       {$$ = ValueOfIntegerVariable($1);} 
        ;

article : character 	 	{$$ = $1;}
	| identifier	       {$$ = ValueOfCharacterVariable($1);} 
        ;

%%                     

void newIntegerVariable(char* varname){

	int data = 0;
	if (isDeclaredBefore(varname) == 1){
		return;	
	}
	else{

		intNode* newInteger = (intNode*) malloc(sizeof(intNode));
		newInteger->variableName = varname;
		newInteger->value = data;
		newInteger->Next = NULL;
		
		if (headIntegerTable == NULL){
			headIntegerTable = newInteger;
			
			return;
		}
		else{
		
		intNode* iterator = headIntegerTable;
		while(iterator->Next != NULL){
			iterator = iterator->Next;
		}
		
		iterator->Next = newInteger;
		return;
		}
	}
}

void newCharacterVariable(char* varname){

	char data = '\0';

	if (isDeclaredBefore(varname) == 1){
		yyerror ("Error: Re-declaration of a variable!");
		return;
	}
	else{
		charNode* newChar = (charNode*) malloc(sizeof(charNode));
		newChar->variableName = varname;
		newChar->value = data;
		newChar->Next = NULL;
		
		if (headCharacterTable == NULL){
			headCharacterTable = newChar;
			
			return;		
		}
		else{
		
		charNode* iterator = headCharacterTable;
		while(iterator->Next != NULL){
			iterator = iterator->Next;
		}

		iterator->Next = newChar;
		return;
		}
	}
}

int isDeclaredBefore(char* varname){

	intNode* iteratorInt = headIntegerTable;

	while(iteratorInt != NULL){
		if (!strcmp(varname, iteratorInt->variableName)){
			return 1;
		}
		else 
			iteratorInt = iteratorInt->Next;;
	}

	charNode* iteratorChar = headCharacterTable;

	while(iteratorChar != NULL){
		if (!strcmp(varname, iteratorChar->variableName)){
			return 1;
		}
		else 
			iteratorChar = iteratorChar->Next;;
	}
	return 0;	
}

void UpdateIntegerVariable(char* varname, int newValue){
	
	if (isValidVariable(varname)){

		intNode* iteratorInt = headIntegerTable;

		while(iteratorInt != NULL){
			if (!strcmp(varname, iteratorInt->variableName)){
				iteratorInt->value = newValue;
				return;
			}
			else 
				iteratorInt = iteratorInt->Next;
		}		
	}	
}

void UpdateCharacterVariable(char* varname, char newValue){
	
	if (isValidVariable(varname)){
		
		charNode* iteratorChar = headCharacterTable;

		while(iteratorChar != NULL){
			if (!strcmp(varname, iteratorChar->variableName)){
	
				iteratorChar->value = newValue;
				return;
			}
			else 
				iteratorChar = iteratorChar->Next;
		}		
	}	
}

int isValidVariable(char* varname){

	intNode* iteratorInt = headIntegerTable;

	while(iteratorInt != NULL){
		if (!strcmp(varname, iteratorInt->variableName)){
			return 1; 
		}
		else 
			iteratorInt = iteratorInt->Next;
	}
	
	charNode* iteratorChar = headCharacterTable;

	while(iteratorChar != NULL){
		if (!strcmp(varname, iteratorChar->variableName)){
			return 1; 
		}
		else 
			iteratorChar = iteratorChar->Next;;
	}
	
	yyerror ("Error: NON-VALID variable.\nVariable does not exist!");
	return 0;
}

int ValueOfIntegerVariable(char* varname){

	intNode* iteratorInt = headIntegerTable;

	while(iteratorInt != NULL){
		if (!strcmp(varname, iteratorInt->variableName)){

			return iteratorInt->value ;
			}
			else 
				iteratorInt = iteratorInt->Next;
		}
	return 0;		
}

char ValueOfCharacterVariable(char* varname){

	charNode* iteratorChar = headCharacterTable;

	while(iteratorChar != NULL){
		if (!strcmp(varname, iteratorChar->variableName)){

			return iteratorChar->value ;
			}
			else 
				iteratorChar = iteratorChar->Next;
		}
	return 0;
}

void PrintLinkedList(){
	intNode* iteratorInt = headIntegerTable;
	printf("< ");

	while(iteratorInt != NULL){
		printf("%d ", iteratorInt->value);
		iteratorInt = iteratorInt->Next;
	}

	printf(" >\n");

	charNode* iteratorChar = headCharacterTable;
	printf("CHAR: < ");

	while(iteratorChar != NULL){
		printf("%c ", iteratorChar->value);
		iteratorChar = iteratorChar->Next;
	}

	printf(" >\n");
}

int main (void) {
	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

