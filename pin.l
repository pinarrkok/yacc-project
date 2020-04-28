%{
#include "y.tab.h"
#include <string.h>
void yyerror (char *s);
int yylex();
char* copyString(char* from);
%}

%%

"print"				   {return print;}
"printchar"                        {return printchar;}
"exit"				   {return exit_command;}
"int"  				   {return INT;}
"char"  			   {return CHAR;}
"if"				   {return IF;}
"then"                             {return THEN;}
"else"                             {return ELSE;}
"while"                            {return WHILE;}
"#"(.*?)                         {;} //comment 


"{"                     {return CURLYOPEN;}
"}"                     {return CURLYCLOSE;}
"-" 			{return MINUS;}
"+" 			{return PLUS;}
"*" 			{return MULT;}
"%"  			{return MODUL;}
"=" 			{return EQ;}
"==" 		        {return ISEQ;} 
"!=" 		        {return ISNOTEQ;}
";" 			{return SEMICOL;}
":"                     {return COLON;}
">"                     {return GRE;}
">="                     {return GREOREQ;}
"<"                     {return SMAL;}
"<="                     {return SMALOREQ;}
"("  			{return OPENBRACKET ;}
")"  			{return CLOSEBRACKET ;}


"'"[a-zA-Z0-9]"'"     {yylval.karakter = yytext[1]; return character;} 
[a-zA-Z_][a-zA-Z0-9_]*      {yylval.id = copyString(yytext); return identifier;}
[0-9]+                      {yylval.num = atoi(yytext); return number;}
[ \t\n]                ;
.                      {ECHO; yyerror ("SYNTAX ERROR");}

%%

int yywrap (void) {return 1;}
char* copyString(char* from){

	int length = strlen(from);
	char* copied = NULL;
	copied = (char*) malloc( sizeof(char) * length + 1 );
	strcpy(copied, from);
	return copied;
}
