#include <stdio.h>
#include <stdlib.h>

int main(){
	int n;
	printf("Digite um numero: ");
	scanf("%d", &n);
	
	if(n % 3 == 0){
		printf("Fizz\n");
	}
	else if(n % 5 == 0){
		printf("Buzz\n");
	}
	else{
		printf("%d\n", n);
	}
}