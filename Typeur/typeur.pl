%%%%% Variables utilisees : %%%%%%%
% T : pour une tete de liste
% Q : pour une queue (suite) de liste
% Ty : pour un type quelconque
% CVar : pour l'environnement des variables
% CConst : pour l'environnement des constantes et procedures
% X : pour un identifiant
% E : pour une expression
% B : pour un block/prog
% A : pour une liste d'arguments
% P : pour un paramètre ou une liste de paramètre
% TA : pour le type d'un argument


%%% Appel principal
type(prog(B), T):- type(B, [], [], T).

%%% Suite de commandes.
type([], _CVar, _CConst, void).
% cas d'une instruction, suite de commandes.
type([T|Q], CVar, CConst, void):- type(T,CVar,CConst,void),
                                  type(Q,CVar,CConst,void).
% cas d'une déclaration de variable, suite de commandes.
type([T|Q], CVar, CConst, void):- addVar(T,CVar,CVar2,CConst,void), 
                                  type(Q,CVar2,CConst,void).
% cas d'une déclaration de constante, suite de commandes.
type([T|Q], CVar, CConst, void):- addConst(T,CVar,CConst,CConst2,void), 
                                  type(Q,CVar,CConst2,void).
% cas d'une déclaration de procedure, suite de commandes.
type([T|Q], CVar, CConst, void):- addProc(T,CVar,CConst,CConst2,void), 
                                  type(Q,CVar,CConst2,void).

%%% Instruction
% SET
type(set(X,E), CVar, CConst, void):- contextFind(X,CVar,Ty), 
                                     type(E,CVar,CConst,Ty).
% IF
type(if(E,B1,B2), CVar, CConst, void):- type(E,CVar,CConst,bool), 
                                        type(B1,CVar,CConst,void), 
                                        type(B2,CVar,CConst,void).
% WHILE
type(while(E,B), CVar, CConst, void):- type(E,CVar,CConst,bool), 
                                       type(B,CVar,CConst,void).
% ECHO
type(echo(E), CVar, CConst, void):- type(E,CVar,CConst,bool).
type(echo(E), CVar, CConst, void):- type(E,CVar,CConst,int).
% CALL
type(call(X), _CVar, CConst, void):- contextFind(X,CConst,void). % Sans argument
type(call(X,P), CVar, CConst, void):- contextFind(X,CConst,A),
                                      verifTypesArgs(P,A,CConst,CVar). % Avec arguments

%%% expression
type(app(not,[E]), CVar, CConst, bool):-type(E,CVar,CConst,bool).
type(app(and,[E1, E2]), CVar, CConst, bool):-type(E1,CVar,CConst,bool), type(E2,CVar,CConst,bool).
type(app(or,[E1, E2]), CVar, CConst, bool):-type(E1,CVar,CConst,bool), type(E2,CVar,CConst,bool).
type(app(eq,[E1, E2]), CVar, CConst, bool):-type(E1,CVar,CConst,bool), type(E2,CVar,CConst,bool).
type(app(eq,[E1, E2]), CVar, CConst, bool):-type(E1,CVar,CConst,int), type(E2,CVar,CConst,int).
type(app(lt,[E1, E2]), CVar, CConst, bool):-type(E1,CVar,CConst,int), type(E2,CVar,CConst,int).
type(app(lt,[E1, E2]), CVar, CConst, bool):-type(E1,CVar,CConst,bool), type(E2,CVar,CConst,bool).
type(app(sub,[E1, E2]), CVar, CConst, int):-type(E1,CVar,CConst,int), type(E2,CVar,CConst,int).
type(app(mul,[E1, E2]), CVar, CConst, int):-type(E1,CVar,CConst,int), type(E2,CVar,CConst,int).
type(app(add,[E1, E2]), CVar, CConst, int):-type(E1,CVar,CConst,int), type(E2,CVar,CConst,int).
type(app(div,[E1, E2]), CVar, CConst, int):-type(E1,CVar,CConst,int), type(E2,CVar,CConst,int).
% type d'une valeur.
type(false, _CVar, _CConst, bool).
type(true, _CVar, _CConst, bool).
type(N, _CVar, _CConst, int):- integer(N).
% type d'un identifiant de variable
type(X, CVar, _CConst, Ty):- contextFind(X,CVar,Ty).
% type d'un identifiant de constante
type(X, _CVar, CConst, Ty):- contextFind(X,CConst,Ty).

%%% Ajout de variables et constantes. 
% On choisit d'empecher la declaration d'une variable ou d'une constante de meme nom
% qu'une variable ou constante deja declaree.
% Pour les constantes on recherche le type de l'expression afin de stocker l'association 
% formee de la constante et du type correspondant.
addVar(var(X,bool), CVar, [assoc(X,bool)|CVar], CConst, void):- not(contextFind(X,CVar,Ty)), 
                                                                not(contextFind(X,CConst,Ty)).
addVar(var(X,int), CVar, [assoc(X,int)|CVar], CConst, void):- not(contextFind(X,CVar,Ty)), 
                                                              not(contextFind(X,CConst,Ty)).
addConst(const(X,bool,E), CVar, CConst, [assoc(X,bool)|CConst], void):- not(contextFind(X,CVar,Ty)), 
                                                                        not(contextFind(X,CConst,Ty)),
                                                                        type(E,CVar,CConst,bool).
addConst(const(X,int,E), CVar, CConst, [assoc(X,int)|CConst], void):- not(contextFind(X,CVar,Ty)),
                                                                      not(contextFind(X,CConst,Ty)),
                                                                      type(E,CVar,CConst,int). 

%%% Recherche d'une variable/constante et de son type dans un environnement (liste d'association).
contextFind(X, [assoc(X,V)|_Q], V).
contextFind(X, [assoc(X2,_V2)|Q], V):- X\==X2, contextFind(X, Q, V).
                          
%%% Ajout et Typage des procedures. 
% Elles sont stockees dans l'environnement des constantes mais leur type est défini
% par la liste de leurs arguments.
% Procedures sans argument
addProc(proc(X,B), CVar, CConst, [assoc(X,[void])|CConst], void):- not(contextFind(X,CVar,Ty)),
                                                                   not(contextFind(X,CConst,Ty)),
                                                                   type(B,CVar,CConst,void).
% Procedures avec argument(s)
addProc(proc(X,A,B), CVar, CConst, [assoc(X,A)|CConst], void):- not(contextFind(X,CVar,Ty)), 
                                                                 not(contextFind(X,CConst,Ty)),
                                                                 append(A,CConst,CConst2),
                                                                 type(B,CVar,CConst2,void).

% Verification du type des parametres lors d'un appel de procedure
verifTypesArgs([], [], _CConst, _CVar).
verifTypesArgs([P|Q1], [assoc(_Arg,TA)|Q2], CConst, CVar):- contextFind(P,CConst,Ty),
                                                            Ty == TA,
                                                            verifTypesArgs(Q1,Q2,CConst,CVar).  
verifTypesArgs([P|Q1], [assoc(_Arg,TA)|Q2], CConst, CVar):- contextFind(P,CVar,Ty),
                                                            Ty == TA,
                                                            verifTypesArgs(Q1,Q2,CConst,CVar). 
                                                                                                    


