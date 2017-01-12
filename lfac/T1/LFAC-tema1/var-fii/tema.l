%{
#include <stdio.h>
#include "y.tab.h"
%}
%x comment
%x comment_linie
%%

"//" {BEGIN comment_linie;}
<comment_linie>\n {BEGIN 0;}
<comment_linie>. ;
"/*" {BEGIN comment;} 
<comment>"*/" {BEGIN 0;}
<comment>. ;

"bool"|"constanta"|"intreg"|"real"|"caracter"|"sir_caractere" {return TIP;}
"vid" {return TIP_VID;}
"clasa" {return TIP_CLASA;}
\'.\' {return VAL_CARACTER;}
\".*\" {return VAL_SIR_CARACTERE;}
"start_program" {return BGIN;}
"sfarsit_program" {return END;}
"start_func" {return START_FUNC;}
"sfarsit_func" {return SFARSIT_FUNC;}
"start_clasa" {return START_CLASA;}
"sfarsit_clasa" {return SFARSIT_CLASA;}
"daca" {return DACA;}
"atunci" {return ATUNCI;}
"sfarsit_atunci" {return SFARSIT_ATUNCI;}
"altfel" {return ALTFEL;}
"sfarsit_altfel" {return SFARSIT_ALTFEL;}
"cat_timp" {return CAT_TIMP;}
"executa" {return EXECUTA;};
"sfarsit_cat_timp" {return SFARSIT_CAT_TIMP;}
"pentru" {return PENTRU;}
"sfarsit_pentru" {return SFARSIT_PENTRU;}
"returneaza" {return RETURNEAZA;}
"adevarat"|"fals" {return VAL_BOOL;}
"si"|"sau" {return OPERATOR_BOOL;}
"<"|">"|"<="|"=>" {return OPERATOR_COMPARARE;}
"=="|"!=" {return OPERATOR_INEGALITATE;}
"<-" {return ASSIGN;}
[_a-zA-Z][_a-zA-Z0-9]* {return ID;}
0|[1-9][0-9]* {return NR_INT_POZ;}
-?0|([1-9][0-9]*) {return NR_INT;}
-?(0|[1-9][0-9]*)","[0-9]* {return NR_REAL;}
[0-9]+ {return NR;}
[ \t] ;
\n {yylineno++;}
. { return yytext[0];}

 

