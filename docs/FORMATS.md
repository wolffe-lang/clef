# Encoding and relocatable-object formats

## Pipeline

`lex.source` preserves physical file/line origins while removing hash and block
comments and separating statements. `expand.source` expands positional `.macro`
and explicit-list `.irp` bodies in order, retaining the definition site and the
ordered invocation chain. `dialect.statement` parses directives, symbolic and
numeric labels, registers, immediates, indirect operands and memory references.

`assembly` resolves numeric locals internally, evaluates symbols and versioned
`.set` definitions, iterates layout to convergence, chooses encoding rows and
applies fixups. It hands ordinary sections, symbols and RELA records to the
independent `object.write` serializer. No assembler subprocess is used by clef.
The output file is not opened until the entire source and object have succeeded.

## Encoding data

`src/x86table/rows.lu` contains 517 declarative descriptors, each transcribed from
an individual Intel SDM opcode row. `aliases.lu` explicitly maps 354 spellings to
canonical families and width hints: the original census, word-port and LOCK
spellings, plus the compiler's integer instruction envelope. `format.lu`
validates rows and provides
cached lookup by family, role, operand width and code mode.

The pipe-separated columns are:

| Columns | Meaning |
|---|---|
| volume, section, page, citation | SDM identity and individual opcode row; printed pages, not PDF indices |
| family, role, bits, modes | Canonical instruction, explicit operand direction/form, logical width and admitted modes |
| opcode | One to three decimal byte values |
| extension | ModRM `/digit`, or -1 when unused |
| prefix, rex_w | Complete operand-size/mandatory legacy prefix, and explicit REX.W policy |
| immediate | Encoded byte count, not logical operand width |
| reg_operand, rm_operand, opcode_operand, immediate_operand | Zero-based AT&T operand indices; -1 means an unused field |
| guard, preference | Legality checks and separately identified encoding-selection policy |
| feature | Architectural feature requirement, not host CPU probing |
| operands, immediate_kind, allowed_prefixes | Typed operand pattern, field semantics and permitted explicit prefixes |

The generic encoder validates patterns before emission. REX.R/X/B derive from
the selected register roles, ModRM/SIB from the address, and RIP displacement
bias from the complete instruction length, including any trailing immediate.
REX precedes the opcode; high-byte registers cannot coexist with a REX prefix.
No `66` or REX.W prefix is inferred merely from the logical width: LTR, segment
moves, control-register moves and stack instructions have different rules.

`tools/table-test` generates a source witness for every descriptor in every
admitted mode: 886 row-by-mode comparisons cover the 517 descriptors. The full
assembler gate independently measures the original 189 census forms through all
recorded sites in 43 source comparisons. A structural candidate in
`census-map.json` is not, by itself, a passing differential.

The old ten-form proof remains in `src/table/` and `src/encode/` as a small,
independent regression boundary. It is not the production encoder.

## GNU as selection and layout

The baseline is pinned GNU as 2.42, not simply the shortest legal encoding:

* Register-register MOV uses the `89` direction. PUSH/POP registers use their
  opcode-plus-register forms. Explicit MOVABS retains its wide immediate.
* Known sign-extended imm8 forms are preferred where available. A wider
  accumulator immediate uses its accumulator opcode. Expressions not known at
  initial selection retain the wide form even if layout later makes them small.
  The forward and backward symbol-difference CMP controls test this distinction.
* Same-section jumps, including global targets, relax to rel8 where possible.
  Calls to global/undefined symbols retain their relocation semantics. Layout
  is iterated with section switching and alignment included.
* `.code32` changes instruction/address defaults inside ELF64; it does not
  change ELF class or machine. The mixed-mode fixture retains gas's `_32`
  indexed-address and `PC32` cross-section choices, not clang's alternatives.
* Gas omits redundant REX.W for register-only segment-register aliases. The two
  initially mismatching rows and corrected differential are retained in the
  table evidence; the SDM's zero-extension/low-selector semantics are cited.
* Code alignment uses gas's NOP policy, rather than zero fill. After raw-data
  fragments gas first emits a one-byte NOP. It then uses sequences up to eleven
  bytes, including redundant legacy prefixes, and jumps over runs of eight or
  more maximum-length NOPs. Data alignment uses zeros unless a fill is explicit.
  `notes/as01/layout/gas-padding.json` records 510 black-box controls. The SDM
  NOP table supplies the underlying instruction forms; gas supplies this policy.

## Compiler integer forms

`census/fenrir-forms/` pins the 640-form generator by SHA256 and retains one
source per form plus a combined source. `tools/compiler-forms-test`, called by
`tools/assembler-test`, checks that regeneration is unchanged, compares every
object's sections, relocations and structural symbols with GNU as, and repeats
clef for identical bytes. Extra rows exercise byte registers, addressing,
branch distances, illegal operands and a linked integer program.

The table uses Intel SDM 325383-086US opcode tables, not an opcode database:

| Family | Volume, entry and printed page | Opcode rows |
|---|---|---|
| Flag-condition jumps, all 30 condition spellings | 2A 3.3 Jcc, 3-558..3-561 | `70+cc` rel8, `0F 80+cc` rel32 |
| SETcc, all condition aliases | 2B 4.3 SETcc, 4-619..4-621 | `0F 90+cc`, ModRM.reg zero |
| CMOVcc word/long/quad, all condition aliases | 2A 3.3 CMOVcc, 3-175..3-177 | `0F 40+cc /r` |
| MUL, one-operand IMUL, DIV, IDIV | 2B 4.3 MUL 4-148; 2A 3.3 IMUL 3-511, DIV 3-331, IDIV 3-508 | `F6/F7 /4,/5,/6,/7` |
| Two-operand IMUL | 2A 3.3 IMUL, 3-511..3-512 | `0F AF /r`; immediate three-operand rows remain `6B/69` |
| MOVSX, MOVZX, MOVSXD | 2B 4.3 MOVSX/MOVSXD 4-128, MOVZX 4-138 | `0F BE/BF`, `0F B6/B7`, `63` |
| SHL, SHR, SAR, every width | 2B 4.3 SAL/SAR/SHL/SHR, 4-600..4-601 | `D0/D1`, `D2/D3`, `C0/C1`, extensions 4/5/7 |
| TEST word | 2B 4.3 TEST, 4-713 | `85`, `A9`, `F7 /0`, operand-size override |
| Accumulator sign extension | 2A 3.3 CBW/CWDE/CDQE 3-156, CWD/CDQ/CQO 3-324 | `98`, `99`, operand-size override or REX.W |

GNU as manual 9.16.4.1 supplies the AT&T `cbtw`, `cwtl`, `cltq`, `cwtd`,
`cltd`, `cqto` and extending-move names. Source width is independent of
destination width for extending moves. There is no byte CMOV or two-operand
byte IMUL, and unsigned long-to-quad widening uses MOV long, not `movzlq`.
SETcc accepts the REX-only byte registers and extended byte registers; the
shared encoder enforces the high-byte/REX exclusion. Flag-condition branches
use the existing same-section relaxation and cross-section relocation policy.

## Port operands and the word ports

IN and OUT take the accumulator (AL, AX or EAX) and a port, DX or an imm8
(SDM vol.2A 3.3 IN p.3-515, vol.2B 4.3 OUT p.4-178). A word access is the
doubleword opcode with the 66H operand-size override (vol.2A 2.1.1). `dialect`
normalizes the spellings the pinned GNU as also accepts, as measured in
`notes/as02c/spellings.json`:

* `(%dx)`, with spaces allowed inside the parentheses, names DX for IN and OUT
  only. Any other instruction still refuses it as a 16-bit base.
* A suffixed one-operand form implies the accumulator: `inw %dx` is
  `inw %dx,%ax`, and `outb $0x61` is `outb %al,$0x61`.
* A bare `in` or `out` takes its width from the accumulator, never from DX.

Two spellings GNU as accepts are refused by name. A 32- or 64-bit register as
the port is `port_register`; gas encodes `inw %edx,%ax` as `66 ed`, but the SDM's
operand is DX. A bare one-operand form, such as `in %dx`, has nothing to size it
and is `implicit_operand_size`; gas warns and takes long.

`xorq` selects the existing REX.W XOR rows (vol.2D 6.1 XOR p.6-40, REX.W from
vol.2A 2.2.1). They are 64-bit only, so `.code32` refuses it as `unknown_form`.

`tools/ports-test` holds 128 row-by-mode encodings, each byte-identical to the
pinned GNU as and to the measured bytes. It also holds 111 named refusals, 34 of
them spellings gas accepts, and PAX `boot/io.S` at pax `eb6592de` from
`tests/ports/`, with its sha256 pinned. Each form a fixture adds to the census
appears in `census-map.json` with its `origin`. The map's `aliases` and
`forms_outside_census` counts are checked against the table.

## Padding aliases and LOCK

On x86 ELF, `.align` and `.balign` specify a byte boundary; `.p2align` specifies
its base-two exponent. An omitted alignment operand is zero (no effective
alignment). `.skip` and `.space` emit the requested number of bytes. Fill takes
the low byte of an absolute expression; an omitted spacing fill is zero. An
omitted alignment fill chooses code NOPs or data zeros. Padding in NOBITS
sections changes only logical size; GNU as ignores a nonzero padding fill there,
and clef does too. Ordinary nonzero `.byte` data in NOBITS is still refused.

An optional third alignment operand limits padding: if a positive limit is
smaller than the required padding, alignment is not performed. GNU as 2.42
measures zero max-skip as unlimited, even though a literal reading of the
manual's limit wording suggests otherwise. Both cases are explicit rows.
Non-power-of-two byte alignments, negative counts and implementation-size limits
remain named refusals. `.global` is normalized to `.globl`, including the ELF
binding policy; it is needed by PAX's filesystem helper.

Intel SDM 325383-086US vol.2A LOCK p.3-621 lists ADC, ADD, AND, BTC, BTR, BTS,
CMPXCHG, CMPXCHG8B, CMPXCHG16B, DEC, INC, NEG, NOT, OR, SBB, SUB, XADD, XCHG
and XOR. All legal operand widths have rows. A LOCK prefix requires the row's
`lock-memory-destination` permission and a memory operand in its writable r/m
field. Register-only forms, memory-source arithmetic, unrelated instructions,
duplicate LOCK and REP/LOCK combinations are `invalid_lock_prefix`.

GNU as's canonical prefix order is address-size, operand-size, LOCK/REP, REX,
opcode. This is a serialization policy, not a claim that other architectural
prefix orders are invalid. Explicit LOCK is retained on XCHG's memory forms,
which already lock implicitly. Unlocked accumulator XCHG uses its short opcode;
EAX,EAX in long mode retains `87 c0` to preserve zero-extension, while RAX,RAX
is the single-byte `90` identity.

`tools/directives-test`, reached by `tools/assembler-test` on both CI tiers,
checks 943 controls, including every assembly path at pax `3e28a8bc`. Its 29
valid sources match GNU as in raw sections, relocations, structural symbols and
`objdump -dr`; every output is deterministic. The 30th path deliberately uses
`frobnicate`, and both assemblers must refuse it without replacing the output.
The fixture manifest pins each source hash. `--only-p2align` exposes the named
`p2align-off-by-one` raw-data witness for a local planted-break record.

## Expressions and symbol algebra

Values are absolute numbers, section offsets or undefined-symbol addends.
Absolute plus relocatable stays relocatable; same-section subtraction becomes
absolute. Unsupported cross-section algebra, cyclic definitions, division by
zero and overflow are named refusals. Signed magnitude supports negative signed
64-bit offsets and the full unsigned 64-bit literal range needed by `.quad`.
Bitwise operations use the 64-bit representation; right shift is logical, as
measured from gas. Decimal, hexadecimal, binary, octal and ASCII character
literals are supported. Strings may contain UTF-8 bytes; expression identifiers
and character literals are restricted to the accepted ASCII dialect.

Precedence, highest first, with left associativity within each binary tier:

1. Unary `+ - ~ !` and parentheses.
2. `* / % << >>`.
3. `| & ^ !` (binary `!` is OR-NOT).
4. `+ -`.
5. `== != <> < > <= >=`.
6. `&&`, then `||`.

Comparisons return -1/0; logical operators return 1/0. The manual's Infix
Operators page groups comparisons alongside addition/subtraction, but the pinned
binary gives `.quad 1==2+3` the value 0. Its Prefix Operators page lists `-` and
`~`, while the binary also accepts unary `!`. Both differences have explicit
witnesses in the 264-value expression differential.

`.set` binds a version of an expression: a later redefinition cannot retroactively
change an earlier definition's dependency. Forward references resolve to the
appropriate first definition. Each location counter is tied to its definition
site, and selection-time availability is distinct from the final numeric value.

Limits are explicit: 100,000 expanded statements, macro depth 32, expression
depth 128, `.set` dependency depth 256 and 64 layout passes. Serialized objects
are limited to 64 MiB; section counters are bounded by 2,147,483,647 bytes.
Unsupported macro defaults, keyword/variadic arguments and unsupported directives
are refused. These are implementation boundaries, not GNU as completeness claims.

## ELF64 representation

`src/object/writer.lu` independently serializes ELF64 little-endian ET_REL for
EM_X86_64. Its input records are:

```text
Section(name, kind, flags, align, size, data)
Symbol(name, binding, kind, section, value, size, visibility)
Relocation(section, offset, kind, symbol, addend)
```

The layout layer supplies ordinary sections in declaration order, including
empty `.text`, `.data` and `.bss`. The writer inserts adjacent `.rela.*` sections,
then symbol/string/section-name tables when needed. Empty objects have no symbol
table. NOBITS consumes logical size but no file data; NOTE and explicit
`.note.GNU-stack` sections preserve their type and flags.

The writer adds the null symbol and stable-partitions locals before nonlocals.
Section symbols have empty ELF names but use section names for internal lookup.
`sh_link`, `sh_info`, alignment and entry sizes are checked before emission.
Symbol/string ordering and string suffix sharing are not copied from gas.

The census uses relocation types 1 (`64`), 2 (`PC32`), 4 (`PLT32`) and 10 (`32`).
The writer also handles 11 (`32S`) for signed address/immediate forms. Symbolic
16-bit fields remain `unsupported_narrow_relocation: x86-64 psABI §4.4`;
`R_X86_64_16` (type 12) is not supported. The compiler differential names
`testw $external,external(%rip)` as a deliberate deviation: GNU as accepts it,
while clef must refuse for that exact reason without replacing output. No form
in the 640-form compiler census needs this deviation. Local
defined references use section symbols plus addends where gas does; global and
undefined references retain their names. PC-relative addends include all bytes
from the field to instruction end, not an unconditional -4.

COMDAT, TLS, extended section numbering and unrelated ELF features remain
unsupported. The writer gate rejects 47 malformed objects and reserializes all
43 oracle records with permuted symbol order, comparing against live gas.

## Optional source provenance note

`--provenance` adds `.note.clef.src` (SHT_NOTE=7, flags=0, alignment=4). It is
absent by default. ELF note fields are little-endian u32:

```text
namesz = 5
names  = "clef\0", padded to four bytes
type   = 1
descsz = UTF-8 JSON byte length
desc   = JSON below, padded to four bytes
```

The physical header order is `namesz, descsz, type`, followed by name and
descriptor. Version 1 has this shape:

```json
{"version":1,"ranges":[{"section":".text","offset":0,"size":2,"file":"example.S","line":3,"chain":"example.S:6 macro PUSH"}]}
```

Offsets are section-relative and ranges are half-open `[offset, offset+size)`.
Only emitted bytes are mapped; NOBITS reservations and the provenance note itself
are excluded. File/line identifies the source statement or macro definition;
`chain` records ordered invocation sites. The format is deterministic for the
same source and source-path spelling. The ISR witness maps every emitted byte
once in 271 ranges.

This is the source-side counterpart to ligature's `.note.wolf.link`: a future
consumer can connect linked ranges to assembly origins. No cross-repository
consumer or manifest change is included here.

## Differential normalization

`tools/differ A.o B.o` exits 0 for agreement, 1 for a semantic mismatch and 2
for malformed/unsupported input. It compares ordinary section contents and
metadata, relocation tuple multisets, and structural symbol records; duplicates
retain multiplicity. File offsets and symbol/string-table ordering are free.
Raw table distances are measured separately in MAP. The optional source note is
not silently ignored by the normal comparator.
