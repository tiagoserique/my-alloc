#include <string.h>
#include "meuAlocador.h"


/*==================================== MAIN ==================================*/


// exemplo do livro
int main(){
	void *a, *b;

	iniciaAlocador();

	a = alocaMem(100);
	b = alocaMem(200);

	strcpy(a, "Preenchimento de Vetor");
	strcpy(b, a);

	liberaMem(a);
	liberaMem(b);

	a = alocaMem(50);

	liberaMem(a);

	finalizaAlocador();
}