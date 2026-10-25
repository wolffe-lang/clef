# This test supplies main and exit; the entry and syscall bridge are the pinned muzzle sources.
.text
.globl main
.type main,@function
main:
    subq $8,%rsp
    movl $1,%edi
    movl $1,%esi
    leaq message(%rip),%rdx
    movl $message_length,%ecx
    xorl %r8d,%r8d
    xorl %r9d,%r9d
    movq $0,(%rsp)
    call __muzzle_syscall6
    addq $8,%rsp
    movl $7,%eax
    ret
.size main,.-main
.globl exit
.type exit,@function
exit:
    subq $8,%rsp
    movl %edi,%esi
    movl $231,%edi
    xorl %edx,%edx
    xorl %ecx,%ecx
    xorl %r8d,%r8d
    xorl %r9d,%r9d
    movq $0,(%rsp)
    call __muzzle_syscall6
    ud2
.size exit,.-exit
.section .rodata
message:
    .ascii "clef muzzle CRT: pass\n"
.set message_length,.-message
.section .note.GNU-stack,"",@progbits
