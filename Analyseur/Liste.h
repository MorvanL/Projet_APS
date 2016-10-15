#ifndef __LISTE__
#define __LISTE__

typedef struct Noeud Noeud;

typedef struct{
	struct Noeud* tete;
	struct Noeud* queue;
}Liste;

// Renvoie un pointeur sur une liste vide
Liste* creerListe();

// Ajoute un noeud en queue de liste
void addNoeud(Liste*, Noeud*);

// Ajoute un noeud en tete de liste
void addNoeudAhead(Liste*, Noeud*);

/* Transforme la liste en une chaîne de caractères de la forme :
   "noeud1,noeud2,noeud3,noeud4" */
char* toStringListe(Liste*);

#endif
