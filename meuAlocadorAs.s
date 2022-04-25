.section .data
    topo_inicial_heap:  .quad 0
    busca_anterior:     .quad 0

    .globl topo_inicial_heap
    .globl busca_anterior
    
    new_line:           .byte 10
    bloco_gerenciador:  .byte 35
    bloco_ocupado:      .byte 43
    bloco_livre:        .byte 45

.section .text


.globl _iniciaAlocador
_iniciaAlocador:
    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax  # %rax = 12 para chamar sbrk()
    movq $0, %rdi   # parametro para chamada de sbrk(0)
    syscall         # %rax = sbrk(0)
    movq %rax, topo_inicial_heap # topo_inicial_heap = sbrk(0);
    movq %rax, busca_anterior    # busca_anterior = topo_inicial_heap;
    
    popq %rbp
    ret


.globl _finalizaAlocador
_finalizaAlocador:
    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax  # %rax = 12 para chamar sbrk()
    movq topo_inicial_heap, %rdi 
    syscall         # brk(topo_inicial_heap)

    popq %rbp
    ret


.globl _liberaMem
_liberaMem:
    pushq %rbp
    movq %rsp, %rbp
    # 

    subq $32, %rsp  # aloca espaco para 4 variaveis
                    # -8(%rbp): bloco_aux
                    # -16(%rbp): ini_heap
                    # -24(%rbp): topo_heap
                    # -32(%rbp): aux
    # movq 16(%rbp),

    popq %rbp
    ret


.globl _imprimeMapa
_imprimeMapa:
    pushq %rbp          # empilha %rbp
    movq %rsp, %rbp     # %rbp = %rsp

    subq $24, %rsp      # aloca espaco para 3 variaveis
                        # -8(%rbp): long int *heap
                        # -16(%rbp): void *topo_heap
                        # -24(%rbp): char bloco
    
    
    # long int *heap = topo_inicial_heap;
    movq topo_inicial_heap, %r10    
    movq %r10, -8(%rbp)             # -8(%rbp) [long int *heap] = topo_inicial_heap


    # void *topo_heap = sbrk(0);
    movq $12, %rax                  # %rax = 12 para chamar sbrk()
    movq $0, %rdi                   # %rdi = 0  parametro para chamada de sbrk(0)
    syscall                         # %rax = sbrk(0)
    movq %rax, -16(%rbp)            # -16(%rbp) [void *topo_heap] = sbrk(0);


	# while ( heap != topo_heap ){
    while:
    movq -8(%rbp), %r10        # %r10 = -8(%rbp) [long int *heap] [&heap[0]]
    movq -16(%rbp), %r11       # %r11 = -16(%rbp) [void *topo_heap]
    cmp %r11, %r10
    je fim_while

        # 	for (int i = 0; i < 16; i++)
        movq $0, %r12           # %r12 = 0
        for_1:
        cmp $16, %r12
        jge fim_for1
            
            # putchar('#');
            movq bloco_gerenciador, %rdi
            call putchar

            addq $1, %r12        # %r12 = i + 1
            
            jmp for_1
        fim_for1:

    
        # 	if ( heap[0] == 1 )
        movq -8(%rbp), %r12     # %r12 = -8(%rbp) [long int *heap] [&heap[0]]
        movq (%r12), %r12       # %r12 = heap[0] 
        cmp $1, %r12
        jne else

            #   bloco = '+';
            movq bloco_ocupado, %r13   # %r13 = '+'
            
            jmp fim_if
        # 	else
        else:

            #   bloco = '-';
            movq bloco_livre, %r13     # %r13 = '-'
        fim_if:
            

        # 	for (int i = 0; i < heap[1]; i++)
        movq $0, %r12           # %r12 = 0
        movq -8(%rbp), %r14     # %r14 = -8(%rbp) [long int *heap] [&heap[0]]
        addq $8, %r14            # %r14 = -8(%rbp) [long int *heap] [&heap[0]] + 8 
        movq (%r14), %r14       # %r14 = heap[1]
        for_2:
        cmp %r14, %r12
        jge fim_for2
            
            # putchar(bloco);
            movq %r13, %rdi
            call putchar

            addq $1, %r12        # %r12 = i + 1

            jmp for_2
        fim_for2:


        # 	heap = (void *)heap + heap[1] + 16; 
        movq -8(%rbp), %r12     # %r12 = -8(%rbp) [long int *heap] [&heap[0]]
        movq %r12, %r13         # %r13 = %r12
        addq $8, %r13            # %r13 = -8(%rbp) [long int *heap] [&heap[0]] + 8
        movq (%r13), %r13       # %r13 = heap[1]
        addq $16, %r13          # %r13 = heap[1] + 16
        addq %r13, %r12         # %r12 = -8(%rbp) [long int *heap] [&heap[0]] + heap[1] + 16
        movq %r12, -8(%rbp)     # -8(%rbp) [long int *heap] = &heap[0] + heap[1] + 16

        jmp while
    fim_while:

	# printf("\n\n");
    movq new_line, %rdi
    call putchar
    movq new_line, %rdi
    call putchar

    addq $24, %rsp      # aloca espaco para 3 variaveis
    popq %rbp
    ret
