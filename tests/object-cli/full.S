.text
.globl entry
.hidden entry
.type entry,@function
entry:
.quad external+8
.long external-.
call external
.long external
.quad datum+1
.long weakref
.size entry,.-entry
.weak weakref
.data
.p2align 3
.type datum,@object
datum: .quad 0x1122334455667788
.size datum,8
.bss
.p2align 4
.type buffer,@object
buffer: .zero 33
.size buffer,33
.set constant,-9
.section .note.Xen,"a",@note
.p2align 2
.long 4,4,18
.asciz "Xen"
.long 1
.section .note.GNU-stack,"",@progbits
