%{
#include <stdio.h>
#include <string.h>
#include "prime.h"

#ifndef YYSTYPE
#define YYSTYPE int
#endif
char idulcurent[20];

extern YYSTYPE yylval;
extern int yylineno;
int yyerror(char *s)
{printf("Eroare de sintaxa la linia %d\n",yylineno);}

extern FILE* yyin;
extern char* yytext;

typedef struct Identificatori{
	char nume[20];
	int init;//0 sau 1 daca variab a fost sau nu initializata
	int val;//valoarea stocata in variabila
	} Lista;
Lista lista[20];
int ind=0;//indice pt urmarit variabilele din lista

int erori=0;//contor erori

%}


%start program
%token MN ID NR REAL RET CHARS PRINT CMMDC SUMACFR MAXIM TIP ASSIGN COMPARE LOGIC CLAS WHILE NEW PRIV PUBL FOR CONST IF ELSE
%left COMPARE
%left '+' '-'
%left '*' '/' '%'
%left NEG

%%

program: declaratii MN '{' instructiuni '}' {if(erori) printf("Compilare esuata.\n"); else printf("Compilare reusita.Executat.\n");}
 | declaratii MN '{' /*empty*/ '}' {if(erori) printf("Compilare esuata.\n"); else printf("Compilare reusita.Executat.\n");}
 | MN '{' /*empty*/'}' {printf("Compilare reusita.Executat.\n");}
 ;
 
declaratii: declaratie
 | declaratii declaratie
 ;
 
 corp:
 '{' instructiuni '}'
 | '{' /*empty */ '}'
 ;
 
 
idd: ID {$$=strdup(yytext);}//intoarce un pointer--adica tot 4B ca int
;

tabl:
 '[' NR ']'
 | tabl '[' NR ']'
 ;
 
declaratie: TIP idd ';' {
			strcpy(idulcurent,$2);
			if(ind>0)
			    {int i=0;
			    while(i<ind && strcmp(lista[i].nume,idulcurent)!=0)	i++;
			    if(i==ind)
			    {
				strcpy(lista[ind].nume,$2);
				lista[ind].init=0;
	    		lista[ind].val=0;
				ind++;
				}
			    else
			    {
				printf("Linia %d: variabila %s declarata de multiple ori\n",yylineno,idulcurent);
				++erori;
				exit(1);
				}
			    }
			else
			{
			    strcpy(lista[ind].nume,idulcurent);
			    lista[ind].init=0;
			    lista[ind].val=0;
			    ind++;
			    }
			}
	| TIP idd ASSIGN expr ';' {
			strcpy(idulcurent,$2);
			if(ind>0)
			    {int i=0;
			    while(i<ind && strcmp(lista[i].nume,idulcurent)!=0)	i++;
			    if(i==ind)
			    {
				strcpy(lista[ind].nume,$2);
				lista[ind].init=1;
	    			lista[ind].val=$4;
				ind++;
				}
			    else
			    {
				printf("Linia %d: variabila %s declarata de multiple ori\n",yylineno,idulcurent);
				++erori;
				exit(1);
				}
			    }
			else
			{
			    strcpy(lista[ind].nume,idulcurent);
			    lista[ind].init=1;
			    lista[ind].val=$4;
			    ind++;
			    }
			 }
 | TIP idd ASSIGN '-' NR ';' {
			strcpy(idulcurent,$2);
			if(ind>0)
			    {int i=0;
			    while(i<ind && strcmp(lista[i].nume,idulcurent)!=0)	i++;
			    if(i==ind)
			    {
				strcpy(lista[ind].nume,$2);
				lista[ind].init=1;
	    			lista[ind].val=-$5;
				ind++;
				}
			    else
			    {
				printf("Linia %d: variabila %s declarata de multiple ori\n",yylineno,idulcurent);
				++erori;
				exit(1);
				}
			    }
			else
			{
			    strcpy(lista[ind].nume,idulcurent);
			    lista[ind].init=1;
			    lista[ind].val=-$5;
			    ind++;
			    }
			} 
 /*
 | idd ASSIGN expr ';' {}
 | idd tabl ASSIGN expr ';' {}
 | cls ASSIGN expr ';' {}
 | TIP idd tabl ';' {}
 | CONST TIP idd tabl ';' {}
 | TIP idd tabl ASSIGN expr ';' {}
 | CONST TIP idd ';' {}
 | CONST TIP idd ASSIGN expr ';' {}
 | TIP idd '(' lista ')' ';' {}
 | TIP idd '(' lista ')' corp {}
 | CLAS idd '{' inclass '}' ';' {}
 | CLAS idd '{' inclass '}' idds ';' {}
 | TIP idd ASSIGN expr ';' {
			strcpy(idulcurent,$2);
			if(ind>0)
			    {int i=0;
			    while(i<ind && strcmp(lista[i].nume,idulcurent)!=0)	i++;
			    if(i==ind)
			    {
				strcpy(lista[ind].nume,$2);
				lista[ind].init=1;
	    			lista[ind].val=$4;
				ind++;
				}
			    else
			    {
				printf("Linia %d: variabila %s declarata de multiple ori\n",yylineno,idulcurent);
				++erori;
				exit(1);
				}
			    }
			else
			{
			    strcpy(lista[ind].nume,idulcurent);
			    lista[ind].init=1;
			    lista[ind].val=$4;
			    ind++;
			    }
			}
 			 		*/
 ;
 
 cls:
 idd '.' id 
 | idd '.' id tabl 
 | idd '.' id '(' listap ')' 
 ;
 
inclass :
 instr
 | inclass instr
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
 
 
instr:
 PRIV ':'
 | PUBL ':'
 | declincls
 ;
 
 listap:
 expr
 | listap ',' expr
 ;

 
declincls:
 TIP idd ';' 
 | cls ASSIGN expr ';'
 | TIP idd ASSIGN expr ';'
 | TIP idd tabl ASSIGN expr ';'
 | CONST TIP idd ';'
 | CONST TIP idd tabl ';'
 | CONST TIP idd ASSIGN expr ';'
 | CONST TIP idd tabl ASSIGN expr ';'
 | TIP idd tabl ';'
 | TIP idd '(' lista ')' ';'
 | TIP idd '(' lista ')' corp
 ;
 
 idds :
 idd
 | idds ',' idd tabl
 | idds ',' idd
 ;
 
instructiuni: instructiune ';'
 | instructiuni instructiune ';'
 ;
 
 
id: ID {
	int i=0;
	strcpy(idulcurent,strdup(yytext));
    while(i<ind && strcmp(lista[i].nume,idulcurent)!=0)	i++;
    if(i==ind) {printf("Linia %d: variabila %s nedeclarata\n",yylineno,idulcurent); ++erori; exit(1);}
    else	
    if(lista[i].init==1)	$$=lista[i].val;
    else	{printf("Linia %d: variabila %s neinitializata\n",yylineno,lista[i].nume); ++erori; exit(1);}
}
;
 
instructiune: idd ASSIGN expr {
		      int i=0;
			  strcpy(idulcurent,$1);
			  while(i<ind && strcmp(lista[i].nume,idulcurent)!=0)	i++;
			  if(i==ind) {printf("Linia %d: variabila %s nedeclarata\n",yylineno,idulcurent); ++erori; exit(1);}
			  else	{lista[i].val=$3; lista[i].init=1;}				  
			  }	
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
 | PRINT '(' idd ')' {
			 int i=0;
			 strcpy(idulcurent,$3);
			 while(i<ind && strcmp(lista[i].nume,idulcurent)!=0)	i++;
			 if(i==ind) {printf("Linia %d: variabila %s nedeclarata\n",yylineno,idulcurent); ++erori; exit(1);}
			 else	
				if(lista[i].init==1)	printf("%s: %d\n",lista[i].nume,lista[i].val);
				else	{printf("Linia %d: variabila %s neinitializata\n",yylineno,lista[i].nume); ++erori; exit(1);}
			 }
 ;
 
 conditii:
 expr COMPARE expr
 | conditii LOGIC expr COMPARE expr
 ;
 
expr: expr '-' expr {$$=$1-$3;}
 | expr '+' expr {$$=$1+$3;}
 | expr '*' expr {$$=$1*$3;}
 | expr '%' expr {$$=$1%$3;}
 | expr '/' expr {$$=$1/$3;}
 | id {$$=$1;}
 | NR {$$=$1;}
 |'(' expr ')'
 | CMMDC '(' expr ',' expr ')' {$$=cmmdc($3,$5);}
 | SUMACFR '(' expr ')' {$$=sumacfr($3);}
 | MAXIM '(' expr ',' expr ',' expr ')' {$$=maxim($3, $5, $7);}
 | '(' expr ')' {$$=$2;}
 | '-' expr %prec NEG {$$=-$2;}
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

int main(int argc, char** argv){
    yyin=fopen(argv[1],"r");
    yyparse();
}