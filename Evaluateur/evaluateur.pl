%%%%% Variables utilisees : %%%%%%%
% T : pour une tete de liste
% Q : pour une queue (suite) de liste
% Env : pour l'environnement
% V, ValE : pour la valeur d'une expression
% E : pour une expression
% B : pour un block.

%%% Appel principal
eval(prog(B)):- eval(B, [], EnvN), writef("Env/Mem final :\n "), writeln(EnvN).

%%% Suite de commandes
eval([], Env, Env).
% Cas d'une instruction, suite de commandes.
eval([T|Q], Env, Env3):- evalI(T,Env,Env2), eval(Q,Env2,Env3).
% Cas d'une déclaration de variable, suite de commandes.
eval([T|Q], Env, Env3):- addVar(T,Env,Env2), eval(Q,Env2,Env3).
% Cas d'une déclaration de constante, suite de commandes.
eval([T|Q], Env, Env3):- addConst(T,Env,Env2), eval(Q,Env2,Env3).

%%% Instruction
% SET
evalI(set(X,E), Env, Env2):- evalE(E,Env,ValE), modifVal(X,ValE,Env,Env2).
% IF 
evalI(if(E,B1,_B2), Env, Env2):- evalE(E,Env,true), eval(B1,Env,Env2).
evalI(if(E,_B1,B2), Env, Env2):- evalE(E,Env,false), eval(B2,Env,Env2).
% WHILE
evalI(while(E,B), Env, EnvN):- evalE(E,Env,true), 
                               eval(B,Env,Env2),
                               evalI(while(E,B),Env2,EnvN).                
evalI(while(E,_B), Env, Env):- evalE(E,Env,false).
% ECHO
evalI(echo(E), Env, Env):- evalE(E,Env,ValE), writeln(ValE).

%%% Expression
% NOT
evalE(app(not,[E]), Env, true):- evalE(E,Env,false).
evalE(app(not,[E]), Env, false):- evalE(E,Env,true).
% AND
evalE(app(and,[E1, _E2]), Env, false):- evalE(E1,Env,false).
evalE(app(and,[E1, E2]), Env, V):- evalE(E1,Env,true), evalE(E2,Env,V).
% OR
evalE(app(or,[E1, _E2]), Env, true):- evalE(E1,Env,true).
evalE(app(or,[E1, E2]), Env, V):- evalE(E1,Env,false), evalE(E2,Env,V).
% EQ
evalE(app(eq,[E1, E2]), Env, true):- evalE(E1,Env,ValE1),
                                     evalE(E2,Env,ValE2),
                                     ValE1 == ValE2.
evalE(app(eq,[E1, E2]), Env, false):- evalE(E1,Env,ValE1),
                                      evalE(E2,Env,ValE2),
                                      ValE1 \== ValE2.
% LT
evalE(app(lt,[E1, E2]), Env, true):- evalE(E1,Env,ValE1),
                                     evalE(E2,Env,ValE2),
                                     ValE1 < ValE2.
evalE(app(lt,[E1, E2]), Env, false):- evalE(E1,Env,ValE1),
                                     evalE(E2,Env,ValE2),
                                     ValE2 =< ValE1.
% ADD
evalE(app(add,[E1, E2]), Env, Res):- evalE(E1,Env,ValE1),
                                     evalE(E2,Env,ValE2),
                                     Res is ValE1+ValE2.
% SUB
evalE(app(sub,[E1, E2]), Env, Res):- evalE(E1,Env,ValE1),
                                     evalE(E2,Env,ValE2),
                                     Res is ValE1-ValE2.
% MUL
evalE(app(mul,[E1, E2]), Env, Res):- evalE(E1,Env,ValE1),
                                     evalE(E2,Env,ValE2),
                                     Res is ValE1*ValE2.
% DIV
evalE(app(div,[E1, E2]), Env, Res):- evalE(E1,Env,ValE1),
                                     evalE(E2,Env,ValE2),
                                     Res is ValE1//ValE2.
% Valeurs
evalE(false, _Env, false).
evalE(true, _Env, true).
evalE(N, _Env, N):- integer(N).
% Variables et constantes
evalE(X, Env, Val):- trouveVal(X,Env,Val).

%%% Ajout, recherche et modification de var/const dans l'envrionnement et la mémoire.
% Le nom de la variable est utilisé comme adresse mémoire.
% _T car on ne s'occupe plus du type. On sait que le prgramme est déjà corectement typé.
addVar(var(X,_T), Env, [assoc(X,new)|Env]).
addConst(const(X,_T,E), Env, [assoc(X,ValE)|Env]):- evalE(E,Env,ValE).
% Recherche d'une variable/constante et de sa valeur dans un environnement (liste d'association).
trouveVal(X, [assoc(X,V)|_Q], V).
trouveVal(X, [assoc(Y,_V2)|Q], V):- X\==Y, trouveVal(X, Q, V).
% Modifie la valeur d'une variable dans la mémoire.
% On cherche directement la variable dans la mémoire car dans notre cas l'adresse
% est le nom de la variable. Si ce n'étais pas le cas il faudrait tout d'abord rechercher
% l'adresse de la variable dans l'environnement puis rechercher la valeur de la variable
% dans la mémoire à partir de l'adresse récupérée.
modifVal(X, Val, [assoc(X,_V)|Q], [assoc(X,Val)|Q]).
modifVal(X, Val, [assoc(Y,V)|Q], [assoc(Y,V)|Env2]):- X\==Y, modifVal(X, Val, Q, Env2).



