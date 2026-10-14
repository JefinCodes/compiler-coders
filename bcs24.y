
%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);

extern FILE *yyin;
FILE *tac_file;

static int temp_count = 0;

/* Create a new temporary name: t1, t2, t3, ... */
static char *new_temp(void)
{
    char buffer[32];
    char *name;

    sprintf(buffer, "t%d", ++temp_count);

    name = malloc(32);
    if (name != NULL)
        sprintf(name, "%s", buffer);

    return name;
}
%}

/* Values carried by identifiers and numbers */
%union {
    char *text;
}

%token BCSMAIN
%token IF ELSE WHILE
%token INT BOOL
%token <text> ID NUM
%token LT GT LE GE EQ NE
%token INVALID

%type <text> aexpr term factor

%start program

%%

program
    : BCSMAIN '{' declist stmtlist '}'
    ;

declist
    : declist decl
    | decl
    ;

decl
    : type ID ';'
    ;

type
    : INT
    | BOOL
    ;

stmtlist
    : stmtlist ';' stmt
    | stmt
    ;

stmt
    : ID '=' aexpr
      {
          fprintf(tac_file, "%s = %s\n", $1, $3);
      }
    | IF '(' expr ')' '{' stmtlist '}' ELSE '{' stmtlist '}'
    | WHILE '(' expr ')' '{' stmtlist '}'
    ;

expr
    : aexpr LT aexpr
    | aexpr GT aexpr
    | aexpr LE aexpr
    | aexpr GE aexpr
    | aexpr EQ aexpr
    | aexpr NE aexpr
    | aexpr
    ;

aexpr
    : aexpr '+' term
      {
          $$ = new_temp();
          fprintf(tac_file, "%s = %s + %s\n", $$, $1, $3);
      }
    | term
      {
          $$ = $1;
      }
    ;

term
    : term '*' factor
      {
          $$ = new_temp();
          fprintf(tac_file, "%s = %s * %s\n", $$, $1, $3);
      }
    | factor
      {
          $$ = $1;
      }
    ;

factor
    : ID
      {
          $$ = $1;
      }
    | NUM
      {
          $$ = $1;
      }
    ;

%%

void yyerror(const char *s)
{
    /* Stage 1 only requires a general syntax error message. */
}

