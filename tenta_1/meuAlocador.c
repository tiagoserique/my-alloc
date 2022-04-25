
long int *topoInicialHeap;


struct no {
	int bloco_ocupado; // 0 - livre, 1 - ocupado
	int tamanho;
	struct no *prox;
};

// Executa syscall brk para obter o endereço do topo
void iniciaAlocador(){
	// se rdi = 0, retorna o endereço do topo da heap em rax
	int rdi = 0;

	// chama a syscall brk, retorno em rax
	// rax = syscall(brk)
	// movq rax, topoInicialHeap
	topoInicialHeap = syscall(brk);
	inicio_heap = topoInicialHeap;
	topo_heap = topoInicialHeap;
}


void finalizaAlocador(){
	int rdi = topoInicialHeap;

	// chama a syscall brk e seta novo valor para ela, o novo valor esta contido
	// em rdi, nesse caso, e o valor inicial da heap guardado em topoInicialHeap
	syscall(brk, rdi);

}


int liberaMem(int *bloco){
	bloco -= 16;
	*bloco = 0;
}


void* alocaMem(int num_bytes){
	int rdi = num_bytes;

	// o primeiro endereco do bloco de memoria que pode ser alocado
	// (desconsiderando a area de gerenciamento do bloco)
	int rax;

	for (int i = inicio_heap; i < topo_heap; i++){
		// se o bloco estiver livre, entao o tamanho do bloco é o tamanho
		// do bloco que esta sendo alocado
		if (bloco_ocupado == 0 && tamanho >= rdi){
			tamanho = rdi;
			// o bloco esta ocupado
			bloco_ocupado = 1;
			// o endereco do bloco é o endereco do bloco que esta sendo alocado
			rax = i;
			// retorna o endereco do bloco que esta sendo alocado
			return rax;
		}
	}


	// caso nao tenha um bloco livre de tamanho >= num_bytes
	if ( ) {
		// Seta novo valor para a altura da heap
		// rdi + 16 -> tamanho do bloco + gerenciamento do bloco
		rdi = topo_heap + (rdi + 16);
		topo_heap = rdi;
		syscall(brk, rdi);
	}

	return rax;
}


void imprimeMapa(){

	// parte gerencial
	for (int i = inicioBloco; i < offset; i++)
		printf("%c", '#');

	// parte do bloco
	if ( blocoLivre )
		for (int i = offset; i < tamBloco; i++)
			printf("%c", '-');
	else
		for (int i = offset; i < tamBloco; i++)
			printf("%c", '+');
}