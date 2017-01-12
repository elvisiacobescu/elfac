%{
#include <stdio.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
%}
%token ID TIP BGIN END ASSIGN NR NR_REAL NR_INT NR_INT_POZ TIP_VID START_FUNC SFARSIT_FUNC RETURNEAZA TIP_CLASA START_CLASA SFARSIT_CLASA OPERATOR_COMPARARE OPERATOR_INEGALITATE VAL_BOOL DACA ATUNCI SFARSIT_ATUNCI ALTFEL SFARSIT_ALTFEL EXECUTA CAT_TIMP SFARSIT_CAT_TIMP PENTRU SFARSIT_PENTRU VAL_CARACTER VAL_SIR_CARACTERE OPERATOR_BOOL
%start progr
%%
progr: declaratii bloc {printf("program corect sintactic\n");}
     ;
declaratii : declaratie ';'
	   | declaratii declaratie ';'
	   ;
declaratie : declarare_variabila
	   | functie corp_functie
           | declarare_clasa
	   ;

declarare_clasa : TIP_CLASA ID START_CLASA declaratii SFARSIT_CLASA
	        ;

declarare_variabila : TIP ID 
	  	    | TIP ID ASSIGN asignare_valoare
		    | TIP ID declarare_vector
		    | TIP_CLASA ID ID
		    ;
asignare_valoare: NR_INT_POZ 
		| VAL_BOOL
                | NR_INT 
		| NR_REAL 
		| VAL_CARACTER 
		| VAL_SIR_CARACTERE
 	        | ID '(' lista_apel ')'
      	 	| ID '.' ID '(' lista_apel ')'
		;
/*declararea functiilor */
functie : TIP ID '(' lista_param ')'
       | TIP ID '(' ')'
       | TIP_VID ID '(' lista_param ')'
       | TIP_VID ID '(' ')'
       ;

corp_functie: START_FUNC list_functie SFARSIT_FUNC
	    ;
list_functie : RETURNEAZA expresie ';'
	     | list_functie RETURNEAZA expresie ';'
	     | statement ';' 
     	     | list_functie statement ';'
	     | bloc_logic_functie
    	     | list bloc_logic_functie
             ;
bloc_logic_functie: DACA expresie_logica 
				ATUNCI list_functie SFARSIT_ATUNCI
			   	ALTFEL list_functie SFARSIT_ALTFEL
	  	  | CAT_TIMP expresie_logica
				list_functie 
	    	    SFARSIT_CAT_TIMP
          	  | PENTRU statement CAT_TIMP expresie_logica EXECUTA statement
				list_functie
	    	     SFARSIT_PENTRU
	  	  ;



/*declararea tablourilor multidimensionale*/
declarare_vector : '[' NR_INT_POZ ']'
    	         | declarare_vector '[' NR_INT_POZ ']'
       ;
vector : '[' expresie ']'
       | vector '[' expresie ']'
       ;

lista_param : param
            | lista_param ','  param 
            ;
            
param : TIP ID      
      ; 
      
/* bloc */
bloc : BGIN list END  
     ;
     
/* lista instructiuni */
list : bloc_logic
     | list bloc_logic
     | statement ';' 
     | list statement ';'	
     ;
bloc_logic: DACA expresie_logica 
		ATUNCI list SFARSIT_ATUNCI
	        ALTFEL list SFARSIT_ALTFEL
	  | CAT_TIMP expresie_logica
		list 
	    SFARSIT_CAT_TIMP
          | PENTRU statement CAT_TIMP expresie_logica EXECUTA statement
		list
	    SFARSIT_PENTRU
	  ;

/* instructiune */
statement: declarare_variabila
	 | ID ASSIGN ID
         | ID ASSIGN NR_INT_POZ
         | ID ASSIGN NR_INT
         | ID ASSIGN NR_REAL 
		 | ID ASSIGN VAL_BOOL
         | ID ASSIGN expresie
	 | ID vector ASSIGN expresie
         | ID '(' lista_apel ')'
	 | ID '.' ID '(' lista_apel ')'
         ;

expresie: simbol
	| expresie '+' expresie
	| '('expresie '+' expresie ')'
	| expresie '-' expresie
	| '('expresie '-' expresie ')'
	| expresie '*' expresie
	| '('expresie '*' expresie ')'
	| expresie ':' expresie
	| '('expresie ':' expresie ')'
	;
simbol: ID
      | '-' ID
      | '-' ID vector
      | ID vector
      | NR_INT_POZ
      | NR_INT
      | NR_REAL
      | ID '(' lista_apel ')'
      | ID '.' ID '(' lista_apel ')'
      ;
expresie_logica : conditie_logica
		| '(' conditie_logica ')'
		| expresie_logica OPERATOR_BOOL expresie_logica
		| '(' expresie_logica OPERATOR_BOOL expresie_logica ')'
		;
conditie_logica : VAL_BOOL OPERATOR_INEGALITATE VAL_BOOL
		| VAL_BOOL OPERATOR_INEGALITATE expresie
 		| expresie OPERATOR_COMPARARE expresie  
		| expresie OPERATOR_INEGALITATE expresie 
		| expresie OPERATOR_INEGALITATE VAL_BOOL
		;
lista_apel : expresie
           | lista_apel ',' expresie
           | VAL_SIR_CARACTERE
 	   | lista_apel ',' VAL_SIR_CARACTERE
           | VAL_CARACTER
 	   | lista_apel ',' VAL_CARACTER
	   | VAL_BOOL
	   | lista_apel ',' VAL_BOOL
	   |  /*empty*/
           ;
%%
int yyerror(char * s){
printf("eroare: %s la linia:%d\n",s,yylineno);
}

int main(int argc, char** argv){
yyin=fopen(argv[1],"r");
yyparse();
} 
