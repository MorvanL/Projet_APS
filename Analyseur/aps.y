%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "Noeud.h"
#include "Liste.h"

Noeud* terme;
FILE *result;
FILE *file;
extern FILE * yyin;
%}

%union {
	char* str;
	Noeud* noeud;
	Liste* liste;
}

%token <str>true <str>false <str>num <str>ident <str>not <str>and <str>or <str>eq <str>lt <str>add <str>sub <str>mul <str>di <str>IF <str>SET <str>WHILE <str>ECHO <str>VOID <str>BOOL <str>INT <str>VAR <str>CONST <str>PROC <str>CALL
%type <noeud>Type 
%type <noeud>Arg
%type <noeud>Args
%type <noeud>Exprs 
%type <noeud>Expr 
%type <noeud>Stat  
%type <noeud>Dec 
%type <liste>Cmds
%type <noeud>Prog
%start Prog
%%

Prog:
	'[' Cmds ']' {
		           $$ = creerNoeud(Prog); 
		           $$->fils = $2;
		           terme = $$;
		         }
   ;

Cmds :  
     Stat {
	        Liste* l = creerListe();
	        $$ = l;
	        addNoeud($$, $1);
	      }
     | Dec ';' Cmds {
	                  $$ = $3; 
		              addNoeudAhead($$, $1);
		            }
     | Stat ';' Cmds {
	                   $$ = $3; 
		               addNoeudAhead($$, $1);
		             }  
    ;

Dec :
    VAR ident Type {
		              $$ = creerNoeud(DecVar); 
		              Noeud* id = creerNoeud(Ident); id->val = $2;
		              addNoeud($$->fils, id);
	                  addNoeud($$->fils, $3);
		           }
    | CONST ident Type Expr {
			                   $$ = creerNoeud(DecConst); 
	                   	       Noeud* id = creerNoeud(Ident); id->val = $2;
	                  	       addNoeud($$->fils, id);
	                   	       addNoeud($$->fils, $3);
			                   addNoeud($$->fils, $4);
			                }
    | PROC ident Prog {
                        $$ = creerNoeud(DecProc);
                        Noeud* id = creerNoeud(Ident); id->val = $2;
                        addNoeud($$->fils, id);
                        addNoeud($$->fils, $3);
                      }
    | PROC ident '[' Args ']' Prog {
                                     $$ = creerNoeud(DecProc);
                                     Noeud* id = creerNoeud(Ident); id->val = $2;
		                             addNoeud($$->fils, id);
                                     addNoeud($$->fils, $4);
                                     addNoeud($$->fils, $6);
                                   }
   ;

Stat :
     SET ident Expr {
                       $$ = creerNoeud(Set); 
		               Noeud* id = creerNoeud(Ident); id->val = $2;
		               addNoeud($$->fils, id);
		               addNoeud($$->fils, $3);
                    }
     | IF Expr Prog Prog {
                            $$ = creerNoeud(If); 
	                        addNoeud($$->fils, $2);
	                        addNoeud($$->fils, $3);
	                        addNoeud($$->fils, $4);
                         }
     | WHILE Expr Prog {
                          $$ = creerNoeud(While); 
	                      addNoeud($$->fils, $2);
	                      addNoeud($$->fils, $3);
                       }
     | ECHO Expr {
		            $$ = creerNoeud(Echo); 
		            addNoeud($$->fils, $2);
		         }
     | CALL ident {
                     $$ = creerNoeud(Call);
                     Noeud* id = creerNoeud(Ident); id->val = $2;
                     addNoeud($$->fils, id);
                 }
     | CALL ident Exprs {  
                          $$ = creerNoeud(Call);
                          Noeud* id = creerNoeud(Ident); id->val = $2;
		                  addNoeud($$->fils, id);
                          addNoeud($$->fils, $3); 
                        }
    ;
  
Expr : 
    true {$$ = creerNoeud(Bool); $$->val = "true";}
    | false {$$ = creerNoeud(Bool); $$->val = "false";}
    | num {$$ = creerNoeud(Num); $$->val = $1;}
    | ident {$$ = creerNoeud(Ident); $$->val = $1;}
    | '(' not Expr ')' {
                          $$ = creerNoeud(Not); 
		                  addNoeud($$->fils, $3);
                       }
    | '(' and Expr Expr ')' {
	                           $$ = creerNoeud(And); 
		                       addNoeud($$->fils, $3);
		                       addNoeud($$->fils, $4);
	                        }
    | '(' or Expr Expr ')' {
	                           $$ = creerNoeud(Or); 
		                       addNoeud($$->fils, $3);
		                       addNoeud($$->fils, $4);
	                       }
    | '(' eq Expr Expr ')' {
	                           $$ = creerNoeud(Eq); 
		                       addNoeud($$->fils, $3);
		                       addNoeud($$->fils, $4);
	                       }
    | '(' lt Expr Expr ')' {
	                           $$ = creerNoeud(Lt); 
		                       addNoeud($$->fils, $3);
		                       addNoeud($$->fils, $4);
	                       }
    | '(' add Expr Expr ')' {
	                           $$ = creerNoeud(Add); 
		                       addNoeud($$->fils, $3);
		                       addNoeud($$->fils, $4);
	                        }
    | '(' sub Expr Expr ')' {
	                           $$ = creerNoeud(Sub); 
		                       addNoeud($$->fils, $3);
		                       addNoeud($$->fils, $4);
	                        }
    | '(' mul Expr Expr ')' {
	                           $$ = creerNoeud(Mul); 
		                       addNoeud($$->fils, $3);
		                       addNoeud($$->fils, $4);
	                        }
    | '(' di Expr Expr ')' {
	                           $$ = creerNoeud(Di); 
		                       addNoeud($$->fils, $3);
		                       addNoeud($$->fils, $4);
	                       }
    ;

Exprs :
       Expr {
	           $$ = creerNoeud(Exprs); 
	           addNoeud($$->fils, $1);
	        }
      | Expr Exprs {
	                  $$ = $2; 
		              addNoeudAhead($$->fils, $1);
		           }
     ;

Args :
      Arg {
	         $$ = creerNoeud(Args); 
	         addNoeud($$->fils, $1);
	      }
     | Arg ',' Args {
	                   $$ = $3; 
		               addNoeudAhead($$->fils, $1);
		            }
    ;

Arg :
     ident ':' Type {
                       $$ = creerNoeud(Arg); 
                       Noeud* id = creerNoeud(Ident); id->val = $1;
                       addNoeud($$->fils, id);
                       addNoeud($$->fils, $3);
                    }
    ;

Type :
      VOID {$$ = creerNoeud(Type); $$->val = "void";}
     | BOOL {$$ = creerNoeud(Type); $$->val = "bool";}
     | INT {$$ = creerNoeud(Type); $$->val = "int";}
    ;
    
%%
int yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
 }

int main(int argc, char **argv) {
    if (argc != 2) {
        yyerror("parametres incorrects");
        return 0;
    }

    if (!(file = fopen(argv[1], "r"))) {
        yyerror("Erreur ouverture fichier input.");
        return 0;
    }
    
    yyin = file;
    yyparse();
    fclose(file);
    
    
    if (!(result = fopen("../terme.txt", "w"))) {
        yyerror("Erreur ouverture fichier output.");
        return 0;
    }

    if(result != NULL) {
        fprintf(result, "prog(%s)\n", toStringNoeud(terme));
        fclose(result);
    }

    detruireNoeud(terme);
    return 0;
}

