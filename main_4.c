#include <stdio.h>
#include "meuAlocador.h"


/*==================================== MAIN ==================================*/


int main(){
	void *a,*b ,*c, *d, *e, *f;

    //Teste noia
    int *coisa[50];

	iniciaAlocador();

    for (int j = 0; j < 5; ++j){
        //coisa = (int**) alocaMem(50*sizeof(int*));
        for (int i = 0; i < 50; i++){
            coisa[i] = (int*) alocaMem(i*sizeof(int));   
            printf("aqui tem %i \n" ,i);
            fflush(stdout);  
            imprimeMapa();
        }

        for (int i = 0; i < 50; i+= 2){
            liberaMem(coisa[i]);   
            printf("aqui liberamos %i \n" ,i);
            fflush(stdout);  
            imprimeMapa();
        }

        for (int i = 1; i < 50; i+= 2){
            liberaMem(coisa[i]);   
            printf("aqui liberamos %i \n" ,i);
            fflush(stdout);  
            imprimeMapa();
        }
    }
}