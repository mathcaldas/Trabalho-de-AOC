#include <stdio.h>

int main() {
    int m, n, primeiro = 1, segundo = 1;
    printf("Digite o primeiro numero: ");
    scanf("%d", &m);
    printf("Digite o segundo numero: ");
    scanf("%d", &n);

    do {
        int aux = segundo;
        segundo += primeiro;
        primeiro = aux;
    } while(m > segundo);

    int i;
    printf("Os numeros da sequencia sao: ");
    for (i = 0; n >= segundo; i++) {
        printf("%d", segundo);
        int aux = segundo;
        segundo += primeiro;
        primeiro = aux;
        if (n >= segundo)
            printf(",");
    }
    printf("\nQuantidade de numeros printados: %d\n", i);
    return 0;
}