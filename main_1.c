// #include <stdio.h>
#include "meuAlocador.h"


/*==================================== MAIN ==================================*/


int main() {
	long int *a, *b, *c;

	iniciaAlocador();
	// _iniciaAlocador();

	imprimeMapa();
	// _imprimeMapa();
	// fflush(stdout);

	a = (long int *) alocaMem(240);
	// a = (long int *) alocaMem(50);
	imprimeMapa();
	// _imprimeMapa();
	// fflush(stdout);

	b = alocaMem(50);
	imprimeMapa();
	// _imprimeMapa();
	// fflush(stdout);

	liberaMem(a);
	imprimeMapa();
	// _imprimeMapa();
	// fflush(stdout);

	a = alocaMem(240);

	imprimeMapa();
	// _imprimeMapa();
	// fflush(stdout);

	c = (long int *) alocaMem(50);
	imprimeMapa();
	// _imprimeMapa();
	// fflush(stdout);

	liberaMem(b);
	imprimeMapa();
	// _imprimeMapa();
	// fflush(stdout);

	liberaMem(c);
	imprimeMapa();
	// _imprimeMapa();
	// fflush(stdout);

	liberaMem(a);
	imprimeMapa();
	// _imprimeMapa();
	// fflush(stdout);

	finalizaAlocador();
	// _finalizaAlocador();
}
