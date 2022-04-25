
FLAGS = -no-pie -static


all: meuAlocador


meuAlocador: meuAlocador.c meuAlocadorAs.s
	gcc -c meuAlocador.c -g
	as meuAlocadorAs.s -o meuAlocadorAs.o -g
	gcc $(FLAGS) meuAlocador.o meuAlocadorAs.o -o meuAlocador -g


# main: 
# 	gcc -c main.c -g
# 	as -c meuAlocador.s -g
# 	gcc $(FLAGS) meuAlocador.o -o meuAlocador -g


clean:
	rm -rf *.o


purge: clean
	rm -rf meuAlocador
	