LEX = flex
YACC = yacc -d -v -l -t
CC = gcc

Analyseur: y.tab.c lex.yy.c Noeud.o Liste.o
	$(CC) -o Analyseur y.tab.c lex.yy.c Noeud.o Liste.o -ll -lfl

y.tab.c y.tab.h: aps.y
	$(YACC) aps.y 

lex.yy.c: aps.l y.tab.h
	$(LEX) aps.l

Noeud.o: Noeud.c Noeud.h Liste.h
	$(CC) -o Noeud.o -c Noeud.c

Liste.o: Liste.c Liste.h
	$(CC) -o Liste.o -c Liste.c

