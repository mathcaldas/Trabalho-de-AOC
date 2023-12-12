#include <stdio.h>

int main(){
	int n;
	printf("Digite um numero: ");
	scanf("%d", &n);

	if(n % 3 == 0)
		printf("FIZZ");
	if(n % 5 == 0)
		printf("BUZZ");
	if (n % 3 != 0 && n % 5 != 0)
		printf("FUDEU");
	printf("\n");

	return 0;
}