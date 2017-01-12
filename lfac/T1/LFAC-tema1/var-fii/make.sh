#!/bin/bash

lex tema.l
yacc -d tema.y 2>/dev/null
gcc y.tab.c lex.yy.c -ll
./a.out <prog2.txt