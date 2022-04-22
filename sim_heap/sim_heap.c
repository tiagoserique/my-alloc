#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


/*================================== HEADERS =================================*/

void iniciaAlocador();
void finalizaAlocador();
int liberaMem(void* bloco);
void* alocaMem(int num_bytes);
void imprimeMapa();


/*============================= VARIAVES GLOBAIS =============================*/


void *topoInicialHeap;


/*==================================== MAIN ==================================*/


int main() {
	void *a, *b;

	printf("Trabalho de SB\n");
	iniciaAlocador();

	imprimeMapa();
	// fflush(stdout);

	a = alocaMem(240);

	imprimeMapa();
	// fflush(stdout);

	b = alocaMem(50);

	imprimeMapa();
	fflush(stdout);

	liberaMem(a);

	imprimeMapa();
	fflush(stdout);

	// a = alocaMem(sizeof(long int) * 50);

	// imprimeMapa();
	// fflush(stdout);

	finalizaAlocador();
}


/*================================== FUNCOES =================================*/


// Executa syscall brk para obter o endereço do topo
// corrente da heap e o armazena em uma
// variável global, topoInicialHeap.
void iniciaAlocador(){
	topoInicialHeap = sbrk(0);
}


// Executa syscall brk para restaurar o valor
// original da heap contido em topoInicialHeap.
void finalizaAlocador(){
	brk(topoInicialHeap);
}


// indica que o bloco está livre.
int liberaMem(void* bloco){
	long int *bloco_aux = bloco;
	bloco_aux[-2] = 0;
	bloco_aux = NULL;
	return 1;
}


// 1. Procura um bloco livre com tamanho maior ou
//    igual à num_bytes.
// 2. Se encontrar, indica que o bloco está
//    ocupado e retorna o endereço inicial do bloco;
// 3. Se não encontrar, abre espaço
//    para um novo bloco usando a syscall brk,
//    indica que o bloco está ocupado e
//    retorna o endereço inicial do bloco.
void *alocaMem(int num_bytes){
	long int *endereco;
	
	endereco = sbrk(8);
	*endereco = 1;

	endereco = sbrk(8);
	*endereco = num_bytes;
	
	endereco = (void *)endereco;
	endereco = sbrk(num_bytes);
	
	return endereco;
}


// imprime um mapa da memória da região da heap.
// Cada byte da parte gerencial do nó deve ser impresso
// com o caractere "#". O caractere usado para
// a impressão dos bytes do bloco de cada nó depende
// se o bloco estiver livre ou ocupado. Se estiver livre, imprime o
// caractere -". Se estiver ocupado, imprime o caractere "+".
void imprimeMapa(){
	long int *heap = topoInicialHeap;
	void *topo_heap = sbrk(0);
	char bloco;


	while ( heap != topo_heap ){
		printf("################");
		if ( heap[0] == 1 )
			bloco = '+';
		else
			bloco = '-';

		for (int i = 0; i < heap[1]; i++)
			putchar(bloco);

		heap = (void *)heap + heap[1] + 16; 
	}

	printf("\n\n");
	fflush(stdout);
}

