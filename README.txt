****** ANALYSEUR ******
    * compilation : make
    * execution : ./Analyseur chemin_du_fichier

    * Le terme prolog créé est disponible dans le fichier terme.txt à la racine du projet.

****** TYPEUR ******
    * Pour lancer le typeur :
        - aller dans le dossier "Typeur"
        - lancer prolog 
        - charger le fichier : [typeur].
	    - executer : type(mon_programme,T).

    *Le typeur répond "T = void" si le programme est correctement typé.

****** EVALUATEUR ******
    * Pour lancer l'evaluateur :
        - aller dans le dossier "Evaluateur"
        - lancer prolog 
        - charger le fichier : [evaluateur].
	    - executer : eval(mon_programme).

     * Le resultat est l'affichage demandé par les instructions "ECHO" ainsi que 
        l'environnement/mémoire final.


****** Exemple de programmes de test (programmes qui fonctionnent) ******

* Puissance par dichotomie
[
  CONST x int 5;
  CONST n int 9;

  IF (eq n 0)
    [
      ECHO 1
    ]
    [
      VAR i int;
      VAR r int;

      SET i n;
      SET r x;
      WHILE (lt 1 i)
        [
	      SET r (mul r r);
	      SET i (div i 2)
	    ];
      IF (eq n (mul (div n 2) 2))
        [
	      ECHO r
	    ]
	    [
	      ECHO (mul r x)
	    ]
    ]
]

* Puissance par dichotomie + appel d'une procédure avec paramètres.
[
  CONST x int 5;
  CONST n int 9;
  
  VAR argu int;
  VAR b bool;
  
  PROC g [j:int, m:bool] 
    [
        ECHO m;
        ECHO j
    ];
    
  SET argu 10;
  SET b true;
  CALL g argu b; 
  ECHO argu;

  IF (eq n 0)
    [
      ECHO 1
    ]
    [
      VAR i int;
      VAR r int;

      SET i n;
      SET r x;
      WHILE (lt 1 i)
        [
	      SET r (mul r r);
	      SET i (div i 2)
	    ];
      IF (eq n (mul (div n 2) 2))
        [
	      ECHO r
	    ]
	    [
	      ECHO (mul r x)
	    ]
    ]
]

























