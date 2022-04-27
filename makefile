
FLAGS = -no-pie -static


all: main1 main2 main3 main4 base


# meuAlocador: meuAlocador.c meuAlocadorAs.s
# 	gcc -c meuAlocador.c -g
# 	as meuAlocadorAs.s -o meuAlocadorAs.o -g
# 	gcc $(FLAGS) meuAlocador.o meuAlocadorAs.o -o meuAlocador -g


main1: main_1.c meuAlocador.s meuAlocador.h
	gcc -c main_1.c -g
	as meuAlocador.s -o meuAlocador.o -g
	gcc $(FLAGS) main_1.o meuAlocador.o -o teste1 -g


main2: main_2.c meuAlocador.s meuAlocador.h
	gcc -c main_2.c -g
	as meuAlocador.s -o meuAlocador.o -g
	gcc $(FLAGS) main_2.o meuAlocador.o -o teste2 -g


main3: main_3.c meuAlocador.s meuAlocador.h
	gcc -c main_3.c -g
	as meuAlocador.s -o meuAlocador.o -g
	gcc $(FLAGS) main_3.o meuAlocador.o -o teste3 -g


main4: main_4.c meuAlocador.s meuAlocador.h
	gcc -c main_4.c -g
	as meuAlocador.s -o meuAlocador.o -g
	gcc $(FLAGS) main_4.o meuAlocador.o -o teste4 -g


base: main_4.c meuAlocador.c meuAlocador.h
	gcc -c main_4.c -g
	gcc -c meuAlocador.c -g
	gcc $(FLAGS) main_4.o meuAlocador.o -o base -g


clean:
	rm -rf *.o


purge: clean
	rm -rf teste*
	rm -rf base
	