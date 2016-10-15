%{
  #include "Noeud.h"
  #include "y.tab.h"
  #include <stdlib.h>
  #include <stdio.h>
  #include <string.h>
%}

num -?[0-9]+
ident [a-zA-Z][a-zA-Z0-9]*

%%

false {return false;}
true {return true;}

void {return VOID;}
bool {return BOOL;}
int {return INT;}

not {return not;}
and {return and;}
or {return or;}
eq {return eq;}
lt {return lt;}
add {return add;}
sub {return sub;}
mul {return mul;}
div {return di;}

CONST {return CONST;}
VAR {return VAR;}
SET {return SET;}
IF {return IF;}
WHILE {return WHILE;}
ECHO {return ECHO;}

PROC {return PROC;}
CALL {return CALL;}

{num} {yylval.str = strdup(yytext); return num;}
{ident} {yylval.str = strdup(yytext); return ident;}

[ \t\n] ;
. {return yytext[0];}



%%
