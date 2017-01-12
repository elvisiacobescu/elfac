%{
#include<stdio.h>
#include "y.tab.h"
%}
%x comm
%%
"##" {BEGIN comm;}
<comm>"##" {BEGIN 0;}
<comm>.|\n {}
"main()" {return MN;}
"integer"|"string"|"char"|"float" {return TIP;}
"const" {return CONST;}
"<"|"="|">"|"<="|">="|"=="|"!=" {return COMPARE;}
"&&"|"||" {return LOGIC;}
"while" {return WHILE;}
"for" {return FOR;}
"if" {return IF;}
"else" {return ELSE;}
"return" {return RET;}
"class" {return CLAS;}
"private" {return PRIV;}
"public" {return PUBL;}
"new" {return NEW;}
"print" {return PRINT;}
"cmmdc" {return CMMDC;}
"maxim" {return MAXIM;}
"sumacfr" {return SUMACFR;}
@[a-zA-Z][a-zA-Z0-9]*\[0|([1-9][0-9]*)\] {return ARRAY} 
@[a-zA-Z][a-zA-Z0-9]* {return ID;}
":=" {return ASSIGN;}
0|([1-9][0-9]*)"."?(0|([1-9][0-9]*))? {return REAL;}
0|([1-9][0-9]*) {yylval=atoi(yytext); return NR;}
[ \t] ;
\n {yylineno++;}
\'.\'  {return CHAR;}
\".*\" {return CHARS;}
. {return yytext[0];}


