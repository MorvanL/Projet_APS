#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Noeud.h"

// Renvoie un pointeur sur un noeud sans fils de type t(param).
Noeud* creerNoeud (TypeN t) {
	Noeud* n = malloc(sizeof(Noeud));
	n->type = t;
	n->suiv = NULL;
	n->fils = creerListe();	
	n->val = NULL;

	return n;
}

// Libere les ressources memoires associees a un noeud, ainsi que tout ses fils.
void detruireNoeud(Noeud *n) {
	if(n != NULL){
		detruireNoeud(n->fils->tete);
		free(n->fils);
		detruireNoeud(n->suiv);
		free(n);
	}
}

// Renvoie le terme prolog defini a partir de l'AST de racine le noeud n (param) de type prog
char* toStringNoeud(Noeud* n){
	char* str = NULL;
	char* str_tmp = NULL, *str_tmp2 = NULL, *str_tmp3 = NULL;
	
	if(n == NULL)
		return NULL;
	else{
		switch(n->type){
			case Prog: 
                /* On recupere la liste des commandes */
				str_tmp = toStringListe(n->fils);
                /* On ajoute les crochets pour former une liste prolog */
                str = concatene("[",str_tmp,"]");
                free(str_tmp);
				break;
			case DecConst:
				/* Recupere son propre contenu (3 fils pour une dec de const) */
				str_tmp = toStringListe(n->fils);
                str = concatene("const(",str_tmp,")");
       			free(str_tmp);
				break;
			case DecVar:
				str_tmp = toStringListe(n->fils);
				str = concatene("var(",str_tmp,")");	
       			free(str_tmp);
				break;
            case DecProc:
                str_tmp = toStringListe(n->fils);
                str = concatene("proc(",str_tmp,")");
       			free(str_tmp);
				break;
			case Set:
				str_tmp = toStringListe(n->fils);
				str = concatene("set(",str_tmp,")");
                free(str_tmp);                                                               
				break;
			case If:
				str_tmp = toStringListe(n->fils);
				str = concatene("if(",str_tmp,")");	
       			free(str_tmp);
				break;
			case While:
				str_tmp = toStringListe(n->fils);
				str = concatene("while(",str_tmp,")");
     			free(str_tmp);    
				break;
			case Echo:
				str_tmp = toStringListe(n->fils);
				str = concatene("echo(",str_tmp,")");	
       			free(str_tmp);
                break;
            case Call: 
				str_tmp = toStringListe(n->fils);
                str = concatene("call(",str_tmp,")");
       			free(str_tmp);
				break;
			case Not:
				str_tmp = toStringListe(n->fils);
                str = concatene("app(not,[",str_tmp,"])");	
       			free(str_tmp);
				break;
			case And:
				str_tmp = toStringListe(n->fils);
				str = concatene("app(and,[",str_tmp,"])");	
       			free(str_tmp);
				break;
			case Or:
				str_tmp = toStringListe(n->fils);
				str = concatene("app(or,[",str_tmp,"])");		
       			free(str_tmp);
				break;
			case Eq:
				str_tmp = toStringListe(n->fils);
				str = concatene("app(eq,[",str_tmp,"])");		
       			free(str_tmp);
				break;
			case Lt:
				str_tmp = toStringListe(n->fils);
				str = concatene("app(lt,[",str_tmp,"])");		
       			free(str_tmp);
				break;
			case Add:
				str_tmp = toStringListe(n->fils);
				str = concatene("app(add,[",str_tmp,"])");	
       			free(str_tmp);
				break;
			case Sub:
				str_tmp = toStringListe(n->fils);
				str = concatene("app(sub,[",str_tmp,"])");	
       			free(str_tmp);
				break;
			case Mul:
				str_tmp = toStringListe(n->fils);
				str = concatene("app(mul,[",str_tmp,"])");		
       			free(str_tmp);
				break;
			case Di:
				str_tmp = toStringListe(n->fils);
				str = concatene("app(div,[",str_tmp,"])");		
       			free(str_tmp);
				break;
            case Bool:
				str = strdup(n->val);
				break;
			case Num:
				str = strdup(n->val);
				break;
			case Ident:
				str = strdup(n->val);
				break;
        	case Type:
				str = strdup(n->val);
				break;
            case Exprs:
                str_tmp = toStringListe(n->fils);
				str = concatene("[",str_tmp,"]");		
       			free(str_tmp);
                break;
            case Args:
                str_tmp = toStringListe(n->fils);
				str = concatene("[",str_tmp,"]");		
       			free(str_tmp);
                break;
			case Arg:
                str_tmp = toStringListe(n->fils);
				str = concatene("assoc(",str_tmp,")");		
       			free(str_tmp);
                break;
		}
	}

	return str;
}

/* Renvoie la concatenation de 3 chaines de caracteres */
char* concatene(char* debut, char* milieu, char* fin){
    char* res = NULL;
    int taille;

    taille = strlen(debut)+strlen(milieu)+strlen(fin)+1;
    res = (char*)malloc(sizeof(char)*(taille));
    memset(res, '\0', taille);
    sprintf(res, "%s%s%s", debut, milieu, fin); 

    return res;
}












