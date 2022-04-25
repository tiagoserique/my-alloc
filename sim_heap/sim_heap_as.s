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
    # 

    subq $32, %rsp  # aloca espaco para 4 variaveis
                    # -8(%rbp): bloco_aux
                    # -16(%rbp): ini_heap
                    # -24(%rbp): topo_heap
                    # -32(%rbp): aux
    # movq 16(%rbp),

    popq %rbp
    ret



