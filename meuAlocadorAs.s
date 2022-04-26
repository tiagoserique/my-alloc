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
                    # %rdi: bloco
    subq $32, %rsp  # aloca espaco para 4 variaveis
                    # -8(%rbp): bloco_aux
                    # -16(%rbp): ini_heap
                    # -24(%rbp): topo_heap
                    # -32(%rbp): aux

    movq %rdi, %rax # %rax =  bloco
    movq %rax, -8(%rbp) # bloco_aux = %rax

    movq $0, -16(%rax)   # bloco_aux[-2] = 0
    movq $0, %rax        # bloco_aux = NULL

    movq topo_inicial_heap, %rax
    movq %rax, -16(%rbp) # ini_heap = topo_inicial_heap

    movq $12, %rax  # %rax = 12 para chamar sbrk()
    movq $0, %rdi   # parametro para chamada de sbrk(0)
    syscall         # %rax = sbrk(0)
    movq %rax, -24(%rbp) # topo_heap = sbrk(0)

loop_exterior:
    movq -16(%rbp), %rax # %rax = ini_heap
    movq -24(%rbp), %rbx # %rbx = topo_heap

    cmp %rax, %rbx # while (ini_heap != topo_heap)
    je fim_loop_exterior

    movq 0(%rax), %rcx
    cmp $0, %rcx # if ini_heap[0] == 0
    jne fim_if

    movq -16(%rbp), %rdx # %rdx = ini_heap
    addq 8(%rdx), %rdx   # %rdx += ini_heap[1]
    addq $16, %rdx       # %rdx += 16
    movq %rdx, -32(%rbp) # aux = ini_heap + ini_heap[1] + 16

loop_interior:
    movq -32(%rbp), %rax # %rax = aux
    movq 0(%rax), %rbx
    movq $0, %r10
    cmp %rbx, %r10     # while (aux[0] == 0)
    jne fim_loop_interior
    movq -24(%rbp), %rbx # %rbx = topo_heap
    cmp %rax, %rbx      # while (aux != topo_heap)
    je fim_loop_interior

    movq -16(%rbp), %rax # %rax = ini_heap
    movq 8(%rax), %rax   # %rax = ini_heap[1]
    movq -32(%rbp), %rbx # %rbx = aux
    addq 8(%rbx), %rax   # %rax += aux[1]
    addq $16, %rax       # %rax += 16
    movq -16(%rbp), %rcx # %rcx = ini_heap
    movq %rax, 8(%rcx)   # ini_heap[1] = %rax

                         # %rbx = aux
    addq 8(%rbx), %rbx   # %rbx += aux[1]
    addq $16, %rbx       # %rbx += 16
    movq %rbx, -32(%rbp) # aux = %rbx

    jmp loop_interior
fim_loop_interior:
fim_if:

    movq -16(%rbp), %rax # %rax = ini_heap
    addq 8(%rax), %rax   # %rax += ini_heap[1]
    addq $16, %rax       # %rax += 16
    movq %rax, -16(%rbp) # ini_heap = %rax
    
    jmp loop_exterior
fim_loop_exterior:

    addq $32, %rsp  # desaloca espaco para 4 variaveis
    
    movq $1, %rax   # return 1
    popq %rbp
    ret

.globl _alocaMem
_alocaMem:
    pushq %rbp      # empilha %rbp
    movq %rsp, %rbp # %rbp = %rsp

                    # %rdi = num_bytes
    subq $64, %rsp  # aloca espaco para 8 variaveis
                    #  -8(%rbp): inicio_busca
                    # -16(%rbp): topo_heap
                    # -24(%rbp): busca_atual
                    # -32(%rbp): volta
                    # -40(%rbp): bloco_atual_tam
                    # -48(%rbp): novo_bloco
                    # -56(%rbp): gerenciador
                    # -64(%rbp): endereco

    movq busca_anterior, %rbx
    movq %rbx, -8(%rbp)  # inicio_busca = busca_anterior

    movq $12, %rax  # %rax = 12 para chamar sbrk()
    movq $0, %rdi   # parametro para chamada de sbrk(0)
    syscall         # %rax = sbrk(0)
    movq %rax, -16(%rbp) # topo_heap = sbrk(0)

    movq %rbx, -24(%rbp) # busca_atual = busca_anterior

    movq $0, -32(%rbp)   # volta = 0

    # TODO: while



    movq -64(%rbp), %rax # return endereco
    addq $64, %rsp  # desaloca espaco para 7 variaveis
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
            
            jmp fim_if2
        # 	else
        else:

            #   bloco = '-';
            movq bloco_livre, %r13     # %r13 = '-'
        fim_if2:
            

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
