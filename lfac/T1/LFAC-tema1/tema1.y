%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token MN TIP COMPARE LOGIC CLAS WHILE NEW PRIV PUBL FOR CONST IF ELSE ID ASSIGN NR REAL RET CHARS ARRAY CHAR
%start program
%left COMPARE
%left '+' '-'
%left '*' '%' '/'
%%

program: declaratii MN corp {printf("corect sintactic\n");}
| MN corp {printf("corect sintactic\n");}
;

declaratii:
 declaratie
 | declaratii declaratie
 
declaratie:
 TIP ID ';'
 | ID ASSIGN expr ';'
 | ID tabl ASSIGN expr ';'
 | cls ASSIGN expr ';'
 | TIP ID tabl ';'
 | CONST TIP ID tabl ';'
 | TIP ID ASSIGN expr ';'
 | TIP ID tabl ASSIGN expr ';'
 | CONST TIP ID ';'
 | CONST TIP ID ASSIGN expr ';'
 | TIP ID '(' lista ')' ';'
 | TIP ID '(' lista ')' corp
 | CLAS ID '{' inclass '}' ';'
 | CLAS ID '{' inclass '}' IDS ';'
 ;
 
inclass :
 instr
 | inclass instr
 ;
 
instr:
 PRIV ':'
 | PUBL ':'
 | declincls
 ;
 
declincls:
 TIP ID ';'
 | cls ASSIGN expr ';'
 | TIP ID ASSIGN expr ';'
 | TIP ID tabl ASSIGN expr ';'
 | CONST TIP ID ';'
 | CONST TIP ID tabl ';'
 | CONST TIP ID ASSIGN expr ';'
 | CONST TIP ID tabl ASSIGN expr ';'
 | TIP ID tabl ';'
 | TIP ID '(' lista ')' ';'
 | TIP ID '(' lista ')' corp
 ;
 
tabl:
 '[' NR ']'
 | tabl '[' NR ']'
 ;
 
IDS :
 ID
 | IDS ',' ID tabl
 | IDS ',' ID
 ;

lista:
 /*empty*/
 | TIP ID
 | TIP ID tabl
 | CONST TIP ID
 | CONST TIP ID tabl
 | lista ',' TIP ID
 | lista ',' TIP ID tabl
 | lista ',' CONST TIP ID
 | lista ',' CONST TIP ID tabl
 ;
 
corp:
 '{' instructiuni '}'
 | '{' /*empty */ '}'
 ;
 
instructiuni:
 instructiune
 | instructiuni instructiune
 ;
 
instructiune:
 TIP ID ';'
 | cls ASSIGN expr ';'
 | ID ID ASSIGN NEW ID ';'
 | TIP ID tabl ';'
 | RET ID ';'
 | RET ID tabl ';'
 | CONST TIP ID ';'
 | CONST TIP ID tabl ';'
 | TIP ID ASSIGN expr ';'
 | TIP ID tabl ASSIGN expr ';'
 | ID ASSIGN expr ';'
 | ID tabl ASSIGN expr ';'
 | CONST TIP ID ASSIGN expr ';'
 | CONST TIP ID tabl ASSIGN expr ';'
 | IF '(' conditii ')' corp ELSE corp 
 | FOR '(' TIP ID ASSIGN expr ';' conditii ';' actiune ')' corp
 | FOR '(' ID ASSIGN expr ';' conditii ';' actiune ')' corp
 | FOR '(' TIP ID tabl ASSIGN expr ';' conditii ';' actiune ')' corp
 | FOR '(' ID tabl ASSIGN expr ';' conditii ';' actiune ')' corp
 | WHILE '(' conditii ')' corp
 | ID '(' listap ')' ';'
 | TIP ID ASSIGN ID '(' listap ')'
 ;


listap:
 expr
 | listap ',' expr
 ;

expr:
 expr '+' expr
 | expr '-' expr
 | expr '*' expr
 | expr '/' expr
 | expr '%' expr
 | expr COMPARE expr
 | '(' expr ')'
 | NR
 | REAL
 | CHARS
 | ID
 | ID tabl
 | ID '(' listap ')'
 | cls
 ;

cls:
 IDD '.' ID
 | IDD '.' ID tabl
 | IDD '.' ID '(' listap ')'
 ;
 
IDD : ID
 | IDD '.' ID
 ;
 

conditii:
 expr COMPARE expr
 | conditii LOGIC expr COMPARE expr
 ;
 
 
actiune:
 ID '++'
 | ID '--'
 | ID ASSIGN expr
 | ID tabl '++'
 | ID tabl '--'
 | ID tabl ASSIGN expr
 | cls '++'
 | cls '--'
 | cls ASSIGN expr
 ;
%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
}/*
@[a-zA-Z][a-zA-Z0-9]*\[0|([1-9][0-9]*)\] {return ARRAY;} 
\'.\'  {return CHAR;}
*/
