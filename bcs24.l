%{
#include "bcs24.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char *copy_lexeme(const char *text)
{
    size_t size = strlen(text) + 1;
    char *copy = malloc(size);

    if (copy != NULL)
        memcpy(copy, text, size);

    return copy;
}
%}

%option noyywrap

letter [a-zA-Z]
digit  [0-9]

%%

[ \t\r\n]+        ;

"BcsMain"         return BCSMAIN;
"if"              return IF;
"else"            return ELSE;
"while"           return WHILE;
"int"             return INT;
"bool"            return BOOL;

{letter}({letter}|{digit})* {
    yylval.text = copy_lexeme(yytext);
    return ID;
}

{digit}+ {
    yylval.text = copy_lexeme(yytext);
    return NUM;
}

"<="              return LE;
">="              return GE;
"=="              return EQ;
"!="              return NE;
"<"               return LT;
">"               return GT;

"="               return '=';
"+"               return '+';
"*"               return '*';

"("               return '(';
")"               return ')';
"{"               return '{';
"}"               return '}';
";"               return ';';

.                 return INVALID;

%%
