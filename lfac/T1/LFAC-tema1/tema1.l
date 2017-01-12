%{
#include <stdio.h>
#include "y.tab.h"
%}
%x comm
%%
"##" {BEGIN comm;}
<comm>"##" {BEGIN 0;}
<comm>.|\n {}
"main()" {return MN;}
"integer"|"real"|"char" {return TIP;}
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
@[_a-zA-Z][_a-zA-Z0-9]* {return ID;}
":=" {return ASSIGN;}
0|([1-9][0-9]*) {return NR;}
0|([1-9][0-9]*)"."?(0|([1-9][0-9]*))? {return REAL;}
[ \t] ;
\n {yylineno++;}
\".*\" {return CHARS;}
. {return yytext[0];}
