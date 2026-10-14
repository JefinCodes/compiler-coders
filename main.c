
#include <stdio.h>

extern FILE *yyin;
extern FILE *tac_file;

int yyparse(void);

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input-file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        perror("Error opening input file");
        return 1;
    }

    tac_file = fopen("tac.txt", "w");
    if (tac_file == NULL) {
        perror("Error creating tac.txt");
        fclose(yyin);
        return 1;
    }

    int result = yyparse();

    fclose(yyin);
    fclose(tac_file);

    if (result == 0)
        printf("Parsing Successful\n");
    else
        printf("Syntax Error\n");

    return result == 0 ? 0 : 1;
}

