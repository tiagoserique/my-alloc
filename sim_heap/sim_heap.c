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


void *topo_inicial_heap;
void *busca_anterior;


/*==================================== MAIN ==================================*/


int main() {
	long int *a, *b, *c;

	printf("Trabalho de SB\n");
	iniciaAlocador();

	imprimeMapa();
	fflush(stdout);

	// a = (long int *) alocaMem(240);
	a = (long int *) alocaMem(50);
	imprimeMapa();
	fflush(stdout);

	b = alocaMem(50);
	imprimeMapa();
	fflush(stdout);

	liberaMem(a);
	imprimeMapa();
	fflush(stdout);

	a = alocaMem(240);

	imprimeMapa();
	fflush(stdout);

	c = (long int *) alocaMem(50);
	imprimeMapa();
	fflush(stdout);

	liberaMem(c);
	imprimeMapa();
	fflush(stdout);

	liberaMem(b);
	imprimeMapa();
	fflush(stdout);

	liberaMem(a);
	imprimeMapa();
	fflush(stdout);

	finalizaAlocador();
}


/*================================== FUNCOES =================================*/


// Executa syscall brk para obter o endereço do topo
// corrente da heap e o armazena em uma
// variável global, topo_inicial_heap.
void iniciaAlocador(){
	topo_inicial_heap = sbrk(0);
	busca_anterior = topo_inicial_heap;                                                                               
}


// Executa syscall brk para restaurar o valor
// original da heap contido em topo_inicial_heap.
void finalizaAlocador(){
	brk(topo_inicial_heap);
}


// indica que o bloco está livre.
int liberaMem(void* bloco){
	long int *bloco_aux = bloco;
	bloco_aux[-2] = 0;
	bloco_aux = NULL;

	long int *ini_heap = (long int *)topo_inicial_heap;
	long int *topo_heap = (long int *)sbrk(0);

	while ( ini_heap != topo_heap ){

		if ( ini_heap[0] == 0 ){
			long int *aux = (void *)ini_heap + 16 + ini_heap[1];
			
			while ( aux[0] == 0 && aux != topo_heap ){
				ini_heap[1] = ini_heap[1] + 16 + aux[1];
				aux = (void *)aux + 16 + aux[1]; 
			}
		}

		ini_heap = (void *)ini_heap + 16 + ini_heap[1];
	}

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
// void *alocaMem(int num_bytes){
// 	long int *endereco;
	
// 	endereco = sbrk(8);
// 	*endereco = 1;

// 	endereco = sbrk(8);
// 	*endereco = num_bytes;
	
// 	endereco = (void *)endereco;
// 	endereco = sbrk(num_bytes);
	
// 	return endereco;
// }

void *alocaMem(int num_bytes){
	long int *inicio_busca = busca_anterior;
	void *topo_heap = sbrk(0);

	long int *busca_atual = busca_anterior;

	int volta = 0;

	// loop para percorrer a lista duas vezes
	while ( volta < 2 ){
		// loop para percorrer os nos da lista
		while ( inicio_busca != topo_heap ){
			// se o bloco estiver livre
			if ( busca_atual[0] == 0 ){
				// se o tamanho do bloco for maior que numero de bytes + 16
				// garante que nao vai ter um bloco de tamanho 0 na heap
				// parte o bloco grande em menores
				if ( busca_atual[1] > num_bytes + 16 ){
					long int bloco_atual_tam = busca_atual[1];
					busca_atual[0] = 1;
					busca_atual[1] = num_bytes;

					long int *novo_bloco = (void *)busca_atual + 16 + num_bytes;
					novo_bloco[0] = 0;
					novo_bloco[1] = bloco_atual_tam - num_bytes - 16;

					return (void *)busca_atual + 16;
				}
				// se o tamanho do bloco for maior ou igual ao numero de bytes
				// reserva o bloco inteiro, mesmo se passar do valor de num_bytes
				else if ( busca_atual[1] >= num_bytes ){
					busca_atual[0] = 1;

					return (void *)busca_atual + 16;
				}
			}

			inicio_busca = (void *)inicio_busca + 16 +inicio_busca[1];
		}
		inicio_busca = topo_inicial_heap;

		volta++;
	} 

	// atribuicao de dados para o blooco de memoria achado ou alocado
	long int *gerenciador;
	
	gerenciador = (long int *)sbrk(8);
	*gerenciador = 1;

	gerenciador = (long int *)sbrk(8);
	*gerenciador = num_bytes;
	
	void *endereco;
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
	long int *heap = topo_inicial_heap;
	void *topo_heap = sbrk(0);
	char bloco;


	while ( heap != topo_heap ){

		for (int i = 0; i < 16; i++)
			putchar('#');
		
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

