#ifndef __NOEUD__
#define __NOEUD__

#include "Liste.h"

typedef enum TypeN {Prog, DecConst, DecVar, DecProc, Set, If, While, Echo, Call, Not, And, Or, Eq, Lt, Add, Sub, Mul, Di, Bool, Num, Ident, Exprs, Args, Arg, Type,} TypeN;

struct Noeud{
	TypeN type;  
	Noeud* suiv; // Noeud suivant dans la liste fils du noeud parent.
	Liste* fils; // Suite de commande pour Prog. Voir grammaire pour autres types.
	char* val; // Pour Type, num, ident, bool
};

// Renvoie un pointeur sur un noeud sans fils de type t(param).
Noeud* creerNoeud (TypeN t);

// Libere les ressources memoires associees a un noeud, ainsi que tout ses fils.
void detruireNoeud(Noeud* n);

// Renvoie le terme prolog defini a partir de l'AST de racine le noeud n(param) de type prog
char* toStringNoeud(Noeud* n);

/* Renvoie la concatenation de 3 chaines de caracteres */
char* concatene(char* debut, char* milieu, char* fin);

#endif
