#include <string.h>
#include "meuAlocador.h"


/*==================================== MAIN ==================================*/


// exemplo do livro
int main(){
	void *a, *b;

	iniciaAlocador();

	a = alocaMem(100);

	imprimeMapa();

	b = alocaMem(200);

	imprimeMapa();

	strcpy(a, "Preenchimento de Vetor");
	strcpy(b, a);

	liberaMem(a);

	imprimeMapa();

	liberaMem(b);

	imprimeMapa();

	a = alocaMem(50);

	imprimeMapa();
	
	liberaMem(a);

	imprimeMapa();

	finalizaAlocador();
}