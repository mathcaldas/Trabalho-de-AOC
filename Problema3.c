#include <stdio.h>

int calc_exp(int b, int e) {
    int y = 1;
    for (int i = e; i > 0; i--)
        y *= b;
    return y;
}

int main() {
    int b, n;
    printf("Digite um valor para a base (b): ");
    scanf("%d", &b);
    printf("Digite um valor para n: ");
    scanf("%d", &n);

    int e = 0;
    while (calc_exp(b, e+1) <= n)
        e++;
    
    printf("Log de %d na base %d eh igual a %d\n", n, b, e);

    return 0;
}