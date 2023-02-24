%{
/*Lexical Analyzer for HTML and CSS*/
/*Name: Mahima Lanka(18MCME06), Shravani V S Sista(19MCME01)*/
#include<stdio.h>
%}

ident	[-]?{nmstart}{nmchar}*
name	{nmchar}+
nmstart	[_a-z]|{nonascii}|{escape}
nonascii	[^\0-\237]
unicode	\\[0-9a-f]{1,6}(\r\n|[ \n\r\t\f])?
escape	{unicode}|\\[^\n\r\f0-9a-f]
nmchar	[_a-z0-9-]|{nonascii}|{escape}
num	[0-9]+|[0-9]*\.[0-9]+
string	{string1}|{string2}
string1	\"([^\n\r\f\\"]|\\{nl}|{escape})*\"
string2	\'([^\n\r\f\\']|\\{nl}|{escape})*\'
badstring	{badstring1}|{badstring2}
badstring1	\"([^\n\r\f\\"]|\\{nl}|{escape})*\\?
badstring2	\'([^\n\r\f\\']|\\{nl}|{escape})*\\?
badcomment	{badcomment1}|{badcomment2}
badcomment1	\/\*[^*]*\*+([^/*][^*]*\*+)*
badcomment2	\/\*[^*]*(\*+[^/*][^*]*)*
baduri	{baduri1}|{baduri2}|{baduri3}
baduri1	url\({w}([!#$%&*-~]|{nonascii}|{escape})*{w}
baduri2	url\({w}{string}{w}
baduri3	url\({w}{badstring}
nl	\n|\r\n|\r|\f
s	[ \t\r\n\f]+
w	{s}?
comment	\/\*[^*]*\*+([^/*][^*]*\*+)*\/


%%
{w} /*Ignore white spaces*/
comment {printf("%s\tCOMMENT\n", yytext);}
{ident} {printf("%s\tIDENT(identifier)\n", yytext);}
@{ident} {printf("%s\tATKEYWORD\n", yytext);}
{string} {printf("%s\tSTRING\n", yytext);}
{badstring} {printf("%s\tBAD_STRING\n", yytext);}
{baduri} {printf("%s\tBAD_URI\n", yytext);}
{badcomment} {printf("%s\tBAD_COMMENT\n", yytext);}
#{name} {printf("%s\tHASH\n", yytext);}
{num} {printf("%s\tNUMBER\n", yytext);}
{num}% {printf("%s\tPERCENTAGE\n", yytext);} 
{num}{ident} {printf("%s\tDIMENSION\n", yytext);}
url\({w}{string}{w}\)|url\({w}([!#$%&*-\[\]-~]|{nonascii}|{escape})*{w}\) {printf("%s\tURI\n", yytext);}
u\+[0-9a-f?]{1,6}(-[0-9a-f]{1,6})? {printf("%s\tUNICODE-RANGE\n", yytext);}
: {printf("%s\t:\n", yytext);}
; {printf("%s\t;\n", yytext);}
\{ {printf("%s\t{\n", yytext);}
\} {printf("%s\t}\n", yytext);}
\( {printf("%s\t(\n", yytext);}
\) {printf("%s\t)\n", yytext);}
\[ {printf("%s\t[\n", yytext);}
\] {printf("%s\t]\n", yytext);}
{ident}\( {printf("%s\tFUNCTION\n", yytext);}
~= {printf("%s\tINCLUDES\n", yytext);}
!= {printf("%s\tDASHMATCH\n", yytext);};
.  {printf("%s\tDELIM\n", yytext);}
%%
int yywrap() {
    return 1;
}

void main(int argc, char* argv[]) {
	char* fileName;
    	if (argc != 2) {
		printf("Number of arguments has to be 1. The file path/name.\n");
		return;
	}
	
	fileName = argv[1];	
    	yyin = fopen(fileName, "r");
    	if (yyin == NULL) {
		printf("Error in opening file: %s\n", strerror(errno));
		return;	
	}
	yylex();
}

