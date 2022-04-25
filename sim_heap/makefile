
all: exec


clean: 
	rm *.o 
	rm sim


exec: sim_heap.c sim_heap_as.s
	as sim_heap_as.s -o sim_heap_as.o -g
	gcc -c sim_heap.c -g
	gcc -no-pie sim_heap.o sim_heap_as.o -o sim -g
