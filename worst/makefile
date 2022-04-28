
FLAGS = -no-pie -static


all: worst


worst: avalia.c meuAlocadorWorstFit.s meuAlocador.h
	gcc -c avalia.c -g
	as meuAlocadorWorstFit.s -o meuAlocadorWorstFit.o -g
	gcc $(FLAGS) avalia.o meuAlocadorWorstFit.o -o worst -g


clean:
	rm -rf *.o


purge: clean
	rm -rf worst	
