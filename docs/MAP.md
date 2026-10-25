# Assembly source map

The census contains **44 unique tracked files**: 26 from PAX, five from muzzle,
and 13 from wolf-lang. It excludes duplicate worktrees and generated copies.
One file is AArch64 Mach-O; the x86-64 specification is the other **43** files.
The x86 sources have **112 mnemonic spellings** and **189 source-level operand forms**.
Suffixes remain distinct. Mode, prefix, actual operands and each source location
are retained in `org-asm.json`; pattern counts are not claims of encoder coverage.

## Input revisions

| Repository | Commit | Assembly files |
|---|---|---|
| pax | `105d0d1fe74bce11107a363a73751e35c9ac0987` | 26 |
| muzzle | `eff9eb5ba1ff37cc2e69cc5e68550408ba464533` | 5 |
| wolf-lang | `fc9064082cbda51b2faf3af8e2f21e376ba3a1e3` | 13 |

`census/sources/` holds the exact inputs, `repositories.json` the inventory,
and `org-asm.json` every parsed statement with file/line, labels, operand shape,
prefixes, code mode, expression text/operators, macros and comment styles.
This is a source census, not macro-expanded instruction coverage. Macro calls
are classified separately, and `%xmm\n` is an XMM-register parameter, not an
ordinary symbol. The source snapshots and binary inputs can be regenerated
without reading any third-party assembler implementation.

## Language observations

* Three files use `.macro` or `.irp`: PAX boot ISR, PAX user hello, and the wolf-lang interrupt ISR fixture.
* Only the wolf-lang interrupt boot fixture switches `.code32` to `.code64`.
  The PAX boot stub currently stays in 64-bit mode.
* Kernel state instructions include FXSAVE64/FXRSTOR64, XSAVE64/XRSTOR64,
  XGETBV/XSETBV, RDTSC and RDRAND. The XMM MOVDQU family occurs in user hello,
  not PAX boot. No AVX arithmetic appears in the census.
* Symbol visibility uses `.globl`; there are no `.weak`, `.hidden`, `.protected`
  or `.local` directives. `.type` names functions and objects, including
  macro-generated ISR labels. `.size` is a constant or a current-location
  difference from a symbol. Numeric forward/backward labels are significant.
* AT&T syntax uses `$` immediates, `%` registers, `*` indirect branches,
  base/index/scale/displacement memory and RIP-relative addresses. The snapshot
  retains literal spelling and signed/unsigned ranges rather than reducing all
  immediates to a single exemplar. Explicit segment operands are not used.
* Comments use block comments and hash comments. The AArch64 `#7` is an immediate,
  not a comment. No C-preprocessor feature is needed by the input set.

## Files and assembler dispositions

| Source | Architecture | Macro definitions | Code modes |
|---|---|---|---|
| `muzzle/notes/lc01-probes/q2/crt0.S` | x86_64 | none | 64 |
| `muzzle/notes/lc01-probes/q2/sys.S` | x86_64 | none | 64 |
| `muzzle/notes/lc01-probes/q9/cell.S` | x86_64 | none | 64 |
| `muzzle/src/crt0.S` | x86_64 | none | 64 |
| `muzzle/src/sys.S` | x86_64 | none | 64 |
| `pax/boot/console.S` | x86_64 | none | 64 |
| `pax/boot/cpu.S` | x86_64 | none | 64 |
| `pax/boot/event.S` | x86_64 | none | 64 |
| `pax/boot/font.S` | x86_64 | none | 64 |
| `pax/boot/fpu.S` | x86_64 | none | 64 |
| `pax/boot/io.S` | x86_64 | none | 64 |
| `pax/boot/isr.S` | x86_64 | ISR_ERR, ISR_NOERR | 64 |
| `pax/boot/net.S` | x86_64 | none | 64 |
| `pax/boot/sched.S` | x86_64 | none | 64 |
| `pax/boot/screen.S` | x86_64 | none | 64 |
| `pax/boot/sound.S` | x86_64 | none | 64 |
| `pax/boot/speaker.S` | x86_64 | none | 64 |
| `pax/boot/start.S` | x86_64 | none | 64 |
| `pax/boot/stub/pax-stub.s` | x86_64 | none | 64 |
| `pax/boot/tree.S` | x86_64 | none | 64 |
| `pax/boot/unix.S` | x86_64 | none | 64 |
| `pax/boot/user.S` | x86_64 | none | 64 |
| `pax/tests/mkw.d/boot/io.S` | x86_64 | none | 64 |
| `pax/user/elf/ask.S` | x86_64 | none | 64 |
| `pax/user/elf/hello.S` | x86_64 | none | 64 |
| `pax/user/elf/hold.S` | x86_64 | none | 64 |
| `pax/user/elf/reboot.S` | x86_64 | none | 64 |
| `pax/user/elf/seven.S` | x86_64 | none | 64 |
| `pax/user/play/kd.S` | x86_64 | none | 64 |
| `pax/user/programs.S` | x86_64 | none | 64 |
| `pax/user/termwolf/tio.S` | x86_64 | none | 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/asm/seven_aarch64_macos.S` | aarch64 | none | 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/asm/seven_x86_64.S` | x86_64 | none | 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/freestanding/rt_stub.S` | x86_64 | none | 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/freestanding/start.S` | x86_64 | none | 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/freestanding_alloc/heap.S` | x86_64 | none | 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/freestanding_device/dev_window.S` | x86_64 | none | 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/freestanding_interrupt/boot.S` | x86_64 | none | 32, 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/freestanding_interrupt/isr.S` | x86_64 | ISR_ERR, ISR_NOERR | 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/freestanding_static/table.S` | x86_64 | none | 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/freestanding_threads/threads.S` | x86_64 | none | 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/pkg/ffi/kernel/kern/io.S` | x86_64 | none | 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/shr_range/rd.S` | x86_64 | none | 64 |
| `wolf-lang/crates/wolf_driver/tests/fixtures/stale_global/kernel/stale.S` | x86_64 | none | 64 |

## Mnemonics and operand forms

Forms encode register classes and widths, indirect operands and memory base/index
classes. `disp` can be zero, a literal, a symbol or an expression; each occurrence
in the JSON retains the actual expression. Memory scale and RIP-relative bases
are explicit. The example column is illustrative; as01 must read every site.

| Form | Source occurrences | First example |
|---|---:|---|
| `add gpr64,gpr64` | 1 | `add     %rcx, %rax` |
| `add immediate,gpr32` | 1 | `add     $48, %edi` |
| `add immediate,gpr64` | 3 | `add     $8, %rsp` |
| `addb immediate,gpr8` | 5 | `addb    $'0', %dl` |
| `addl immediate,gpr32` | 3 | `addl    $('a' - 10 - '0'), %edi` |
| `addq gpr64,gpr64` | 4 | `addq    %rcx, %rbx` |
| `addq immediate,gpr64` | 13 | `addq    $16, %rsp` |
| `and immediate,gpr64` | 3 | `and	$-16, %rsp` |
| `andb immediate,gpr8` | 1 | `andb    $0x0c, %al` |
| `andl immediate,gpr32` | 5 | `andl    $15, %eax` |
| `andl immediate,mem[,rip64,,1,disp]` | 2 | `andl    $~ECHO, work+12(%rip)` |
| `andq immediate,gpr64` | 8 | `andq    $-16, %rsp` |
| `btl immediate,gpr32` | 1 | `btl     $20, %edx` |
| `call expression` | 170 | `call	main` |
| `callq *gpr64` | 1 | `callq   *%r12` |
| `callq expression` | 1 | `callq   pax_thread_exit` |
| `clac ` | 1 | `clac` |
| `cld ` | 2 | `cld` |
| `cli ` | 14 | `cli` |
| `cmpb immediate,mem[,gpr64,,1,disp]` | 5 | `cmpb    $'t', 0(%rsi)` |
| `cmpb immediate,mem[,gpr64,gpr64,1,disp]` | 2 | `cmpb    $10, -1(%rax,%r12)` |
| `cmpb immediate,mem[,rip64,,1,disp]` | 1 | `cmpb    $'q', inbuf(%rip)` |
| `cmpb mem[,gpr64,,1,disp],gpr8` | 1 | `cmpb    (%rsi), %al` |
| `cmpl immediate,gpr32` | 8 | `cmpl    $0x80000001, %eax` |
| `cmpl immediate,mem[,rip64,,1,disp]` | 1 | `cmpl    $0x1f80, mxcsr_at_entry(%rip)` |
| `cmpq gpr64,gpr64` | 5 | `cmpq    %rbx, %r12` |
| `cmpq gpr64,mem[,gpr64,,1,disp]` | 5 | `cmpq    %rcx, 136(%rsp)` |
| `cmpq gpr64,mem[,rip64,,1,disp]` | 6 | `cmpq    %rbx, av_phnum(%rip)` |
| `cmpq immediate,gpr64` | 31 | `cmpq    $1, %r8` |
| `cmpq immediate,mem[,gpr64,,1,disp]` | 6 | `cmpq    $0x100, 120(%rsp)` |
| `cmpq immediate,mem[,rip64,,1,disp]` | 5 | `cmpq    $0, base_revision+16(%rip)` |
| `cmpw immediate,mem[,rip64,,1,disp]` | 1 | `cmpw    $0x037f, fcw_at_entry(%rip)` |
| `cpuid ` | 5 | `cpuid` |
| `decl gpr32` | 2 | `decl    %ecx` |
| `decq gpr64` | 8 | `decq    %rdi` |
| `divl gpr32` | 1 | `divl    %r9d` |
| `divq gpr64` | 5 | `divq    %rcx` |
| `fnstcw mem[,rip64,,1,disp]` | 1 | `fnstcw  fcw_at_entry(%rip)` |
| `fxrstor64 mem[,gpr64,,1,disp]` | 1 | `fxrstor64 (%rdi)` |
| `fxsave64 mem[,gpr64,,1,disp]` | 1 | `fxsave64 (%rdi)` |
| `hlt ` | 17 | `hlt` |
| `imulq immediate,gpr64,gpr64` | 1 | `imulq   $1000000, %rdx, %rdx` |
| `imulq immediate,mem[,gpr64,,1,disp],gpr64` | 1 | `imulq   $1000, (%rsp), %rcx` |
| `inb gpr16,gpr8` | 3 | `inb     %dx, %al` |
| `inb immediate,gpr8` | 1 | `inb     $0x61, %al` |
| `incl gpr32` | 14 | `incl    %ebx` |
| `incq gpr64` | 16 | `incq    %rsi` |
| `incq mem[,rip64,,1,disp]` | 2 | `incq    magic(%rip)` |
| `inl gpr16,gpr32` | 1 | `inl     %dx, %eax` |
| `int3 ` | 2 | `int3` |
| `invlpg mem[,gpr64,,1,disp]` | 1 | `invlpg  (%rdi)` |
| `iretq ` | 3 | `iretq` |
| `ja expression` | 1 | `ja      .Lchecks` |
| `jae expression` | 5 | `jae     .Lpax_iret` |
| `jb expression` | 6 | `jb      1f` |
| `jc expression` | 1 | `jc      2f` |
| `je expression` | 23 | `je      1f` |
| `jle expression` | 3 | `jle     3f` |
| `jmp *gpr64` | 1 | `jmp     *%rdi` |
| `jmp expression` | 43 | `jmp     1b` |
| `jne expression` | 36 | `jne     .Lpax_iret` |
| `jns expression` | 4 | `jns     dec` |
| `jnz expression` | 16 | `jnz     1b` |
| `js expression` | 6 | `js      .Lfail` |
| `jz expression` | 14 | `jz      1f` |
| `lea mem[,gpr64,,1,disp],gpr64` | 2 | `lea	8(%rsp), %rsi` |
| `lea mem[,gpr64,gpr64,8,disp],gpr64` | 2 | `lea	8(%rsi,%rdi,8), %rdx` |
| `lea mem[,rip64,,1,disp],gpr64` | 2 | `lea     kw_stacks(%rip), %rax` |
| `leal mem[,gpr64,,1,disp],gpr32` | 2 | `leal    0x30(%r12), %eax` |
| `leaq mem[,gpr64,,1,disp],gpr64` | 4 | `leaq    8(%rsp), %rax` |
| `leaq mem[,gpr64,gpr64,8,disp],gpr64` | 2 | `leaq    16(%r15,%rbx,8), %rbx` |
| `leaq mem[,rip64,,1,disp],gpr64` | 108 | `leaq    msg_banner(%rip), %rsi` |
| `lgdt expression` | 1 | `lgdt    kw_gdt_ptr` |
| `lgdt mem[,gpr64,,1,disp]` | 1 | `lgdt    (%rdi)` |
| `lidt mem[,gpr64,,1,disp]` | 2 | `lidt    (%rdi)` |
| `ljmp immediate,immediate` | 1 | `ljmp    $0x08, $kw_long` |
| `lretq ` | 1 | `lretq` |
| `ltr gpr16` | 1 | `ltr     %di` |
| `mov gpr32,gpr32` | 4 | `mov	%eax, %edi` |
| `mov gpr64,gpr64` | 21 | `mov	%rdi, %rax` |
| `mov gpr64,mem[,gpr64,,1,disp]` | 3 | `mov     %rsp, (%rdi)` |
| `mov gpr64,mem[,rip64,,1,disp]` | 1 | `mov     %rdi, s214_cell(%rip)` |
| `mov gpr8,mem[,gpr64,,1,disp]` | 2 | `mov     %dil, 5(%rsp)` |
| `mov immediate,gpr32` | 14 | `mov     $7, %eax` |
| `mov mem[,gpr64,,1,disp],gpr64` | 3 | `mov	(%rsp), %rdi` |
| `movabs immediate,gpr64` | 1 | `movabs  $0x7fffffffffffffff, %rax` |
| `movabsq immediate,gpr64` | 12 | `movabsq $0x7fffffffffffffff, %rax` |
| `movb gpr8,gpr8` | 3 | `movb    %cl, %al` |
| `movb gpr8,mem[,gpr64,,1,disp]` | 6 | `movb    %dl, (%rdi)` |
| `movb gpr8,mem[,gpr64,gpr64,1,disp]` | 4 | `movb    %cl, (%rdx,%rax)` |
| `movb immediate,gpr8` | 14 | `movb    $EXIT_RETURNED, %al` |
| `movb immediate,mem[,gpr64,,1,disp]` | 11 | `movb    $0, (%rdi)` |
| `movb immediate,mem[,gpr64,gpr64,1,disp]` | 1 | `movb    $10, (%rsi,%rdx)` |
| `movb immediate,mem[,rip64,,1,disp]` | 1 | `movb    $1, work+17+VMIN(%rip)` |
| `movb mem[,gpr64,,1,disp],gpr8` | 2 | `movb    (%rdi), %cl` |
| `movdqu mem[,gpr64,,1,disp],xmm128` | 1 | `movdqu  (%rsp), %xmm\n` |
| `movdqu xmm128,mem[,gpr64,,1,disp]` | 1 | `movdqu  %xmm\n, (%rsp)` |
| `movl cr64,gpr32` | 2 | `movl    %cr4, %eax` |
| `movl gpr32,cr64` | 3 | `movl    %eax, %cr3` |
| `movl gpr32,expression` | 2 | `movl    %eax, kw_pml4` |
| `movl gpr32,gpr32` | 47 | `movl    %eax, %eax` |
| `movl gpr32,mem[,,gpr32,8,disp]` | 1 | `movl    %eax, kw_pd(,%ecx,8)` |
| `movl gpr32,mem[,gpr64,,1,disp]` | 1 | `movl    %esi, (%rsp)` |
| `movl gpr32,mem[,gpr64,gpr64,1,disp]` | 1 | `movl    %esi, (%rax,%rdi)` |
| `movl gpr32,seg16` | 1 | `movl    %eax, %ds` |
| `movl immediate,gpr32` | 173 | `movl    $0xc0000080, %ecx` |
| `movl immediate,mem[,,gpr32,8,disp]` | 1 | `movl    $0, kw_pd+4(,%ecx,8)` |
| `movl mem[,gpr64,gpr64,1,disp],gpr32` | 1 | `movl    (%rax,%rdi), %eax` |
| `movl mem[,rip64,,1,disp],gpr32` | 5 | `movl    saved+0(%rip), %edi` |
| `movq cr64,gpr64` | 4 | `movq    %cr0, %rax` |
| `movq expression,gpr64` | 1 | `movq    0x0, %rax` |
| `movq gpr64,cr64` | 3 | `movq    %rdi, %cr3` |
| `movq gpr64,gpr64` | 61 | `movq    %rdi, %rax` |
| `movq gpr64,mem[,gpr64,,1,disp]` | 6 | `movq    %rdx, (%rcx)` |
| `movq gpr64,mem[,rip64,,1,disp]` | 18 | `movq    %rsp, pax_syscall_state+8(%rip)` |
| `movq immediate,gpr64` | 3 | `movq    $0x1000, %rsp` |
| `movq immediate,mem[,gpr64,,1,disp]` | 7 | `movq    $1, (%rbx)` |
| `movq immediate,mem[,rip64,,1,disp]` | 5 | `movq    $0, outlen(%rip)` |
| `movq mem[,gpr64,,1,disp],gpr64` | 15 | `movq    16(%rsp), %rcx` |
| `movq mem[,gpr64,gpr64,8,disp],gpr64` | 2 | `movq    8(%r15,%r12,8), %rsi` |
| `movq mem[,rip64,,1,disp],gpr64` | 16 | `movq    firmware_type_response(%rip), %rax` |
| `movsb ` | 3 | `rep movsb` |
| `movslq mem[,gpr64,,1,disp],gpr64` | 1 | `movslq  (%rsp), %rax` |
| `movsq ` | 2 | `rep movsq` |
| `movw gpr16,mem[,gpr64,gpr64,1,disp]` | 3 | `movw    %di, (%rcx,%rax)` |
| `movw gpr16,seg16` | 10 | `movw    %ax, %ds` |
| `movw immediate,gpr16` | 7 | `movw    $0x10, %ax` |
| `movw seg16,gpr16` | 1 | `movw    %cs, %ax` |
| `movzbl mem[,gpr64,,1,disp],gpr32` | 7 | `movzbl  (%rsi), %ecx` |
| `movzbl mem[,gpr64,gpr64,1,disp],gpr32` | 3 | `movzbl  (%rax,%rbx), %edi` |
| `movzbl mem[,rip64,,1,disp],gpr32` | 2 | `movzbl  saved+16(%rip), %edi` |
| `movzwl mem[,gpr64,,1,disp],gpr32` | 1 | `movzwl  56(%rcx), %ebx` |
| `movzwl mem[,gpr64,gpr64,1,disp],gpr32` | 1 | `movzwl  (%rax,%rdi), %eax` |
| `movzwl mem[,rip64,,1,disp],gpr32` | 3 | `movzwl  winsz+0(%rip), %edi` |
| `negq gpr64` | 2 | `negq    %rdi` |
| `nop ` | 1 | `nop` |
| `orl immediate,gpr32` | 6 | `orl     $3, %eax` |
| `orq gpr64,gpr64` | 5 | `orq     %rdx, %rax` |
| `orq immediate,gpr64` | 4 | `orq     $0xa5, %rax` |
| `orq mem[,gpr64,,1,disp],gpr64` | 2 | `orq     8(%rcx), %rax` |
| `outb gpr8,gpr16` | 13 | `outb    %al, %dx` |
| `outb gpr8,immediate` | 10 | `outb    %al, $0x61` |
| `outl gpr32,gpr16` | 1 | `outl    %eax, %dx` |
| `pause ` | 2 | `pause` |
| `pop gpr64` | 6 | `pop     %r15` |
| `popq gpr64` | 66 | `popq    %rbx` |
| `push gpr64` | 6 | `push    %rbp` |
| `pushfq ` | 2 | `pushfq` |
| `pushq gpr64` | 54 | `pushq   %rbx` |
| `pushq immediate` | 18 | `pushq   $0` |
| `pushq mem[,rip64,,1,disp]` | 1 | `pushq   pax_syscall_state+8(%rip)` |
| `rdmsr ` | 4 | `rdmsr` |
| `rdrand gpr64` | 1 | `rdrand  %rax` |
| `rdtsc ` | 1 | `rdtsc` |
| `ret ` | 108 | `ret` |
| `setc gpr8` | 1 | `setc    %r8b` |
| `shl immediate,gpr64` | 1 | `shl     $16, %rcx` |
| `shll immediate,gpr32` | 1 | `shll    $21, %eax` |
| `shlq immediate,gpr64` | 7 | `shlq    $32, %rdx` |
| `shrl gpr8,gpr32` | 2 | `shrl    %cl, %eax` |
| `shrl immediate,gpr32` | 1 | `shrl    $4, %edi` |
| `shrq immediate,gpr64` | 6 | `shrq    $32, %rdx` |
| `stac ` | 1 | `stac` |
| `sti ` | 2 | `sti` |
| `stmxcsr mem[,rip64,,1,disp]` | 1 | `stmxcsr mxcsr_at_entry(%rip)` |
| `stosb ` | 1 | `rep stosb` |
| `stosq ` | 2 | `rep stosq` |
| `sub immediate,gpr64` | 5 | `sub     $16, %rsp` |
| `subl immediate,gpr32` | 3 | `subl    $4, %ecx` |
| `subq gpr64,gpr64` | 2 | `subq    %rsi, %rdx` |
| `subq immediate,gpr64` | 8 | `subq    $32, %rsp` |
| `syscall ` | 57 | `syscall` |
| `sysretq ` | 1 | `sysretq` |
| `test gpr64,gpr64` | 1 | `test    %r13, %r13` |
| `testb gpr8,gpr8` | 4 | `testb   %cl, %cl` |
| `testb immediate,gpr8` | 2 | `testb   $LSR_THR_EMPTY, %al` |
| `testl gpr32,gpr32` | 7 | `testl   %eax, %eax` |
| `testl immediate,gpr32` | 1 | `testl   $0x200, %edi` |
| `testq gpr64,gpr64` | 19 | `testq   %rax, %rax` |
| `testq immediate,gpr64` | 1 | `testq   $15, %r15` |
| `ud2 ` | 15 | `ud2` |
| `wrmsr ` | 3 | `wrmsr` |
| `xgetbv ` | 1 | `xgetbv` |
| `xor gpr32,gpr32` | 2 | `xor	%ebp, %ebp` |
| `xor gpr64,gpr64` | 1 | `xor	%rbp, %rbp` |
| `xorl gpr32,gpr32` | 67 | `xorl    %r8d, %r8d` |
| `xrstor64 mem[,gpr64,,1,disp]` | 1 | `xrstor64 (%rdi)` |
| `xsave64 mem[,gpr64,,1,disp]` | 1 | `xsave64 (%rdi)` |
| `xsetbv ` | 1 | `xsetbv` |

## Directives and arguments

| Directive | Occurrences | Distinct argument texts | Example |
|---|---:|---:|---|
| `.ascii` | 29 | 29 | `.ascii "ask> "` |
| `.asciz` | 39 | 38 | `.asciz "PAX\n"` |
| `.balign` | 5 | 2 | `.balign	16` |
| `.bss` | 7 | 1 | `.bss` |
| `.byte` | 256 | 190 | `.byte 0x00, 0x00, 0x7c, 0xc6, 0x06, 0x0c, 0x18, 0x30, 0x30, 0x00, 0x30, 0x30, 0x00, 0x00, 0x00, 0x00` |
| `.code32` | 1 | 1 | `.code32` |
| `.code64` | 1 | 1 | `.code64` |
| `.data` | 2 | 1 | `.data` |
| `.endm` | 4 | 1 | `.endm` |
| `.endr` | 4 | 1 | `.endr` |
| `.globl` | 185 | 169 | `.globl	_start` |
| `.irp` | 4 | 2 | `.irp v, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47` |
| `.long` | 4 | 4 | `.long 4` |
| `.macro` | 4 | 2 | `.macro ISR_NOERR v` |
| `.p2align` | 61 | 5 | `.p2align 6` |
| `.quad` | 45 | 31 | `.quad pax_isr\v` |
| `.section` | 68 | 10 | `.section .note.GNU-stack,"",@progbits` |
| `.set` | 71 | 59 | `.set EXIT_PORT,     0xf4` |
| `.size` | 101 | 98 | `.size	q_syscall3, .-q_syscall3` |
| `.text` | 33 | 1 | `.text` |
| `.type` | 100 | 97 | `.type	q_syscall3,@function` |
| `.word` | 1 | 1 | `.word kw_gdt_end - kw_gdt - 1` |
| `.zero` | 89 | 35 | `.zero	16` |

### Expression operators

The following are token observations, not an evaluator. Unary versus binary
operators and symbol arithmetic must be parsed using the GNU as grammar.

| Operator | Expression-bearing operands containing it |
|---|---:|
| `+` | 20 |
| `-` | 200 |
| `*` | 13 |
| `/` | 1 |
| `<<` | 2 |
| `>>` | 0 |
| `&` | 0 |
| `\|` | 1 |
| `^` | 0 |
| `~` | 2 |

## GNU as and clang

All 43 x86 sources assemble with both pinned binaries. Every source differs
structurally: clang gives `.text` alignment 4 versus GNU as alignment 1, and
clang may omit empty default `.data`/`.bss` sections. That is not an encoding
mismatch. The full section/symbol/relocation data is in `oracle-results.json`.
`.note.GNU-stack` is preserved where explicitly requested; no special stack-note
exception is needed. Symbol ordering is recorded separately and is free.

| Source | Content differences | Other differences |
|---|---|---|
| `pax/boot/io.S` | .text | relocations, symbols |
| `pax/boot/isr.S` | .text | relocations, symbols |
| `pax/boot/sched.S` | .text | relocations, symbols |
| `pax/user/play/kd.S` | .text | relocations, symbols |
| `pax/user/programs.S` | .rodata.pax_user | relocations, symbols |
| `wolf-lang/crates/wolf_driver/tests/fixtures/freestanding_interrupt/boot.S` | none | relocations |
| `wolf-lang/crates/wolf_driver/tests/fixtures/freestanding_interrupt/isr.S` | .text | relocations, symbols |

* `pax/boot/io.S`, `sched.S`, `isr.S`, `pax/user/play/kd.S`, and the wolf-lang
  interrupt ISR fixture: GNU as resolves/relaxes same-section global branches;
  clang retains near branches with PLT32 relocations. Subsequent symbol values,
  function sizes and relocation offsets/addends move with the instruction sizes.
* `pax/user/programs.S`: gas keeps the imm32 accumulator CMP for a forward-label
  difference; clang selects imm8. The first user blob is 159 versus 157 bytes;
  later alignment makes both complete `.rodata.pax_user` sections 707 bytes.
* The mixed-mode interrupt boot fixture has matching section bytes but gas
  chooses PC32 versus clang PLT32 for a cross-section jump, and 32 versus clang
  32S for two `.code32` indexed-memory relocations.

The GNU as choices remain the baseline in all cases. `FORMATS.md` states the
forward-expression selection rule and the relocation policy; no clang exception
is hidden in the comparator.

## Emitted sections

The table below lists every section kind/flag/alignment combination seen from gas.
Per-file order, symbol values/sizes and relocation tuples are in the JSON.

| Name | ELF type | Flags (numeric) | Alignment |
|---|---:|---:|---:|
| `NULL` | 0 | 0 | 0 |
| `.bss` | 8 | 3 | 1 |
| `.bss` | 8 | 3 | 8 |
| `.bss` | 8 | 3 | 16 |
| `.bss` | 8 | 3 | 64 |
| `.bss` | 8 | 3 | 4096 |
| `.data` | 1 | 3 | 1 |
| `.data` | 1 | 3 | 8 |
| `.data.limine` | 1 | 3 | 8 |
| `.kwdev` | 8 | 3 | 4096 |
| `.note.GNU-stack` | 1 | 0 | 1 |
| `.note.Xen` | 7 | 2 | 4 |
| `.rela.note.Xen` | 4 | 64 | 8 |
| `.rela.rodata` | 4 | 64 | 8 |
| `.rela.text` | 4 | 64 | 8 |
| `.rela.text.boot` | 4 | 64 | 8 |
| `.rodata` | 1 | 2 | 1 |
| `.rodata` | 1 | 2 | 8 |
| `.rodata` | 1 | 2 | 16 |
| `.rodata.pax_user` | 1 | 2 | 16 |
| `.shstrtab` | 3 | 0 | 1 |
| `.strtab` | 3 | 0 | 1 |
| `.symtab` | 2 | 0 | 8 |
| `.text` | 1 | 6 | 1 |
| `.text.boot` | 1 | 6 | 1 |

| Relocation | Count |
|---|---:|
| R_X86_64_64 | 70 |
| R_X86_64_PC32 | 176 |
| R_X86_64_PLT32 | 15 |
| R_X86_64_32 | 11 |

## Coverage boundary

Clef currently encodes ten selected forms from ten mnemonic families. It does
not yet assemble any whole PAX or muzzle source. The oracle census is the
specification for that next step, not evidence that it is implemented.
`tools/proof-test` produces 24 exact object comparisons including the empty
writer, plus explicit refusals and determinism checks. `tools/differ-test`
proves that changes to text, BSS size, relocation offset/type/addend and symbol
value/size are observable, while symbol ordering is not.

The binary round-trip measurement and its exclusions are recorded separately
in `census/roundtrip.json`; it measures objdump, not a clef disassembler.
