// #include <stdio.h>
#include "meuAlocador.h"


extern void *topo_inicial_heap;
extern void *busca_anterior;


/*==================================== MAIN ==================================*/


int main() {
	long int *a, *b, *c;

	printf("Trabalho de SB\n");
	//iniciaAlocador();
	_iniciaAlocador();

	_imprimeMapa();
	// fflush(stdout);

	// a = (long int *) alocaMem(240);
	a = (long int *) alocaMem(50);
	_imprimeMapa();
	// fflush(stdout);

	b = alocaMem(50);
	_imprimeMapa();
	// fflush(stdout);

	liberaMem(a);
	_imprimeMapa();
	// fflush(stdout);

	a = alocaMem(240);

	_imprimeMapa();
	// fflush(stdout);

	c = (long int *) alocaMem(50);
	_imprimeMapa();
	// fflush(stdout);

	liberaMem(c);
	_imprimeMapa();
	// fflush(stdout);

	liberaMem(b);
	_imprimeMapa();
	// fflush(stdout);

	liberaMem(a);
	_imprimeMapa();
	// fflush(stdout);

	_finalizaAlocador();
	//finalizaAlocador();
}