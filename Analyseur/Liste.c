#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Noeud.h"

// Renvoie un pointeur sur une liste vide
Liste* creerListe(){
	Liste* l = (Liste*)malloc(sizeof(Liste));
	l->tete = NULL;
	l->queue = NULL;

	return l;
}

// Ajoute un noeud en queue de liste
void addNoeud(Liste* l, Noeud* n){
	if(l->tete == NULL){
		l->tete = n;
	}
	else
		l->queue->suiv = n;
	l->queue = n;
}

// Ajoute un noeud en tete de liste
void addNoeudAhead(Liste* l, Noeud* n){
	if(l->tete == NULL){
		l->queue = n;
	}
	else
		n->suiv = l->tete;
	l->tete = n;
}

/* Transforme la liste en une chaîne de caractères de la forme :
   "noeud1,noeud2,noeud3,noeud4" */
char* toStringListe(Liste* L){
    char* str = NULL;
    char* str_tmp = "", *str_noeud = NULL;
    Noeud* n = NULL;

    /* On recupere les noeuds un par un. A chaque fois on concatene 
       le noeud courant au reste des noeuds deja recuperees */
    n = L->tete;
	while(n != NULL){
		str_noeud = toStringNoeud(n);
		str = (char*)malloc(sizeof(char)*(strlen(str_noeud)+
						                        strlen(str_tmp)+2));
		memset(str, '\0', strlen(str_noeud)+strlen(str_tmp)+2);
		if(str_tmp != ""){
			strcat(str, str_tmp);
			strcat(str,",");
			free(str_tmp);
		}
		strcat(str, str_noeud);
		free(str_noeud);
		str_tmp = NULL;
		str_tmp = strdup(str);
		free(str);
		str = NULL;
		n = n->suiv;				
	}

    return str_tmp;
}

