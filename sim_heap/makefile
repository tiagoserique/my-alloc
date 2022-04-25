
all: exec

clean: 
	rm *.o 
	rm sim

exec: sim_heap.c
	gcc sim_heap_as.s -c -o sim_heap_as.o
	gcc sim_heap.c -g -c
	gcc -no-pie sim_heap.o sim_heap_as.o -g -o sim

