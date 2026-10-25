# Encoding and relocatable-object formats

## Encoding rows

`src/table/format.lu` is the executable worked format. `source()` returns ten
pipe-separated rows; `load()` refuses invalid sizes, missing provenance and
prefix/mode combinations not implemented by this proof. The numeric fields are
decimal. There is one row per selected mnemonic/operand form, not one row claiming
all encodings of a mnemonic.

| Columns | Meaning |
|---|---|
| mnemonic, operands | normalized mnemonic and explicit operand shape |
| opcode, second, opcode_len | one or two opcode bytes; opcode-plus-register uses the low three register bits |
| rex_w, extension, immediate | REX.W; ModRM /digit; trailing immediate/relative displacement width in bytes |
| volume, section, page, citation | SDM identity of the encoding; edition is pinned in SOURCES.md |
| legacy_prefixes | ordered 66/67/F2/F3 bytes, or `none`; this proof accepts only `none` |
| operand_bits, address_bits | zero denotes no explicit operands; proof modes are 64-bit |
| modrm_rule, sib_rule, displacement_rule | operand roles, SIB construction and displacement selection |
| preference | measured GNU as choice when more than one encoding is possible |

The format deliberately separates a valid encoding from a preference. Future
rows must add mode/feature predicates and explicit operand-direction fields,
not infer them from mnemonic spelling. Legacy prefix order is recorded before
REX, REX.R/X/B extend the appropriate register fields, and REX.W selects 64-bit
operands only when the instruction requires it. PUSH/POP in long mode do not
need REX.W. The existing descriptor is a version-one worked subset: it is not
a complete x86 instruction schema or a decoder yet.

### Worked rows

| Mnemonic | Worked form | Encoding |
|---|---|---|
| mov | signed imm32 to r64 | REX.W C7 /0 id |
| push | r64 | REX.B if needed, 50+rd |
| pop | r64 | REX.B if needed, 58+rd |
| call | resolved current-location rel32 | E8 cd |
| ret | near, no adjustment | C3 |
| jmp | resolved current-location rel8 | EB cb |
| lea | disp(base[,index,scale]) to r64 | REX.W 8D /r, optional SIB and disp8/disp32 |
| syscall | no operands | 0F 05 |
| hlt | no operands | F4 |
| cmp | known signed imm8 to r64 | REX.W 83 /7 ib |

`tools/proof-test` generates operand variants, runs clef and GNU as separately,
and invokes `tools/differ` for every object. It checks extended registers,
base-low-bits 4 and 5, an extended SIB index, signed displacement boundaries,
negative immediates and the two rel8 endpoints. These are ten worked forms,
not the complete census's MOV/CMP/LEA families. General labels, symbolic
relocations, 8/16/32-bit operands and the rest of those families remain refused.
No output file is opened until the whole source has passed the proof encoder.

### Encoding choice is not simply “shortest”

The baseline is the pinned GNU as decision, including when it is not the
shortest legal encoding. Numeric `cmpq $1,%rax` chooses 83 /7 ib; a wider
known immediate to the accumulator chooses 3D id rather than 81 /7 id.
A register-register MOV chooses the 89 direction. PUSH/POP choose the
opcode-plus-register form, not FF /6 or 8F /0. `movq $0,%rax` uses C7 id,
never an XOR substitution; explicit `movabsq` retains B8 iq.

**An expression containing a not-yet-known symbol keeps the imm32 form.**
In `pax/user/programs.S`, `cmpq $(.Lhello_msg_end-.Lhello_msg),%rax` is
`48 3d 17 00 00 00` under GNU as, versus clang's `48 83 f8 17`.
The same difference evaluated before the instruction permits the short form.
The assembler must retain whether an expression was known at the encoding
choice, not merely its eventual numeric value. These are oracle-only probes
in the proof harness; they are not falsely accepted by the current encoder.

GNU as also resolves and shortens same-section jumps to globally visible
symbols where clang retains PLT32 relocations. Branch relaxation must therefore
iterate layout to stability, while preserving GNU as's policy on symbol binding
and forward immediate expressions. No clang exception is applied.

## Expression and macro design

The complete source-level statements, operands and expression tokens are in
`census/org-asm.json`. A1 needs a real tokenizer: block comments, hash comments,
strings with escapes, character immediates, semicolon statement separators,
local numeric labels (`1f`/`1b`), named labels and macro backslash parameters.
Source file and line travel through every expansion.

Use a precedence parser matching GNU as's Expressions chapter, not C's
precedence by assumption. Represent values as `Absolute(integer)`,
`SectionOffset(section, addend)` or `Undefined(symbol, addend)`. Same-section
subtraction becomes absolute; cross-section subtraction is a named refusal
unless the output relocation expresses it. Unary and binary operations on
relocatable values must follow the documented gas algebra. Arithmetic overflow,
division by zero, undefined constants and cyclic `.set` dependencies are errors,
not wrapping guesses. Keep the *known at selection* bit described above.

The observed `.macro` definitions take one positional `v` parameter and produce
ISR labels, immediates and `.type`/`.size` expressions through `\\v` substitution.
`.irp` iterates explicit comma-separated integer lists, with a `v` or `n`
parameter, ending at `.endr`; `%xmm\\n` and label suffixes require token-boundary
aware textual substitution. `.endm` and `.endr` are separate terminators. The
census does not exercise defaults, variadic macros, recursion or conditional
assembly; refuse these until they have their own specification and tests.

`.code32` changes instruction/address defaults but does not change ELFCLASS64
or EM_X86_64. Its current consumer is the freestanding interrupt fixture's boot
source. In that file GNU as uses R_X86_64_32 for 32-bit indexed memory operands
where clang chooses R_X86_64_32S; a cross-section jump is PC32 under GNU as and
PLT32 under clang. Preserve the GNU as side of each choice, not a generalized
“all branch relocations are PLT32” shortcut.

## ELF64 writer

The object representation is independent of ligature's reader. All scalar
fields are explicitly little-endian; the file carries no timestamp. The
minimal writer in `src/elf/writer.lu` emits a 64-byte ELF header, `.text` bytes,
section names, zero padding to an eight-byte boundary, and five 64-byte section
headers. Header fields are ET_REL=1, EM_X86_64=62, EV_CURRENT=1, no entry point,
no program headers, `e_shentsize=64`, `e_shnum=5`, `e_shstrndx=4`.

GNU as's empty object has no symbol table or relocation table. Its section
order is NULL, `.text` (PROGBITS, AX, align 1), `.data` (PROGBITS, WA, align 1),
`.bss` (NOBITS, WA, align 1), `.shstrtab` (STRTAB, align 1). The proof writer
matches that structure; `tools/proof-test` compares every section header field
apart from offsets and string indices, as well as the semantic differ.

For nonempty census sources, `census/oracle-results.json` records every emitted
section in order, flags, type, size, alignment, link, info and entry size, plus
all symbols and RELA tuples. This measured per-file layout is the writer's
specification. The extension plan is:

1. Keep the default `.text`, `.data`, `.bss` even when empty. Create named input
   sections in declaration order; preserve flags and section kind. `.zero` in
   NOBITS advances size without file bytes. `.note.Xen` is SHT_NOTE, not PROGBITS.
2. Track each section's location counter and maximum alignment. `.p2align n`
   aligns to 2^n; `.balign n` aligns to n. Preserve the observed fill bytes,
   including data-vs-code alignment, and recompute after branch relaxation.
3. Place each `.rela<name>` next to its relocated section in the section-header
   order observed from GNU as. ELF64 RELA entries are (u64 offset, u64 info,
   i64 addend), 24 bytes. `sh_link` names `.symtab`; `sh_info` names the target
   section; alignment is 8, flags include SHF_INFO_LINK (64).
4. Append `.symtab`, `.strtab`, `.shstrtab` after ordinary sections, where
   symbols exist. Emit STN_UNDEF, section symbols where needed, locals before
   globals, then globals/undefined references. `sh_info` is the first nonlocal
   symbol. Ordering within each class is not part of the comparison contract.
5. `.globl` supplies binding, `.type` supplies STT_FUNC/STT_OBJECT, `.size`
   supplies explicit constants or current-location differences. `.set` absolute
   names have SHN_ABS. Section-relative relocations use section symbols plus
   addends when GNU as does; preserve externally named references otherwise.
6. `.note.GNU-stack` is an explicit zero-sized, non-alloc PROGBITS section in
   these sources. Do not silently synthesize it for sources that omit it.

The gas census uses relocation numbers 1 (64), 2 (PC32), 4 (PLT32), and 10 (32).
For PC-relative relocations, include instruction-end bias in the addend:
usually -4 for a four-byte field, but -5/-6/-8 when an immediate follows the
RIP displacement. The actual per-site tuples in the census, not that usual
case, are authoritative.

## Differential normalization

`tools/differ A.o B.o` exits 0 on agreement, 1 on a semantic mismatch, and 2
on malformed/unsupported input. It compares ordinary section contents, names,
kind, flags, size and alignment; relocations as sorted tuples of target section,
offset, type, symbol name and addend; symbols as sorted tuples of name, binding,
type, section, value, size and visibility. Symbol/string-table layout and file
offsets are free. Duplicates retain multiplicity. The null symbol is retained.
A `.bss` size difference is observable even though it has no file bytes.

The comparator rejects truncated structures, unsupported ELF class/endianness/
machine, malformed strings, bad symbol indices and SHT_REL. Extended section
numbering and COMDAT are outside this census and currently refused or unmodeled;
A1 must not claim general ELF support from the empty-object proof.
