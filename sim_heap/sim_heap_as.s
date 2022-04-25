.section .data
topo_inicial_heap: .quad 0
busca_anterior: .quad 0


.section .text
.globl _iniciaAlocador, _finalizaAlocador, _liberaMem, _alocaMem, _imprimeMapa
.globl topo_inicial_heap
.globl busca_anterior

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

_finalizaAlocador:
    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax  # %rax = 12 para chamar sbrk()
    movq topo_inicial_heap, %rdi 
    syscall         # brk(topo_inicial_heap)

    popq %rbp
    ret

_liberaMem:
    pushq %rbp
    movq %rsp, %rbp
                    # 16(%rbp): bloco
    subq $32, %rsp  # aloca espaco para 4 variaveis
                    # -8(%rbp): bloco_aux
                    # -16(%rbp): ini_heap
                    # -24(%rbp): topo_heap
                    # -32(%rbp): aux

    movq 16(%rbp), %rax # %rax =  bloco
    movq %rax, -8(%rbp) # bloco_aux = %rax

    movq $0, -16(%rax)   # bloco_aux[-2] = 0
    movq $0, %rax        # bloco_aux = NULL

    movq topo_inicial_heap, %rax
    movq %rax, -16(%rbp) # ini_heap = topo_inicial_heap

    movq $12, %rax  # %rax = 12 para chamar sbrk()
    movq $0, %rdi   # parametro para chamada de sbrk(0)
    syscall         # %rax = sbrk(0)
    movq %rax, -24(%rbp) # topo_heap = sbrk(0)

    movq -16(%rbp), %rax # %rax = ini_heap
    movq -24(%rbp), %rbx # %rbx = topo_heap

loop_exterior:
    cmpq %rax, %rbx # while (ini_heap != topo_heap)
    je fim_loop_exterior

    movq 0(%rax), %rcx
    cmpq $0, %rcx # if ini_heap[0] == 0
    jne fim_if

    movq -32(%rbp), %rdx # %rdx = aux
    addq %rax, %rdx      # %rdx += ini_heap
    addq 8(%rax), %rdx   # %rdx += ini_heap[1]
    addq $16, %rdx       # %rdx += 16

loop_interior:

    jmp loop_interior
fim_loop_interior:



fim_if:

    # TODO
    # ini_heap = (void *)ini_heap + 16 + ini_heap[1];

    jmp loop_exterior
fim_loop_exterior:

    popq %rbp
    ret



