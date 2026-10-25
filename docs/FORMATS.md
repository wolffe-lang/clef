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

`src/x86table/rows.lu` contains 312 declarative descriptors, each transcribed from
an individual Intel SDM opcode row. `aliases.lu` explicitly maps the 112 census
spellings to canonical families and width hints. `format.lu` validates rows and
provides cached lookup by family, role, operand width and code mode.

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
admitted mode: **530/530 byte comparisons**, covering **312/312 rows**. The full
assembler gate independently measures **189/189 census forms** through all
recorded sites in 43 exact source comparisons. A structural candidate in
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
The writer also handles 11 (`32S`) for signed address/immediate forms. Local
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
