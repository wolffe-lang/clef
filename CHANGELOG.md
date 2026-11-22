# Changelog

## Unreleased

### Changed

- The version is 0.1.0. The package manifest names it, `clef --version` prints
  it from one constant, and a row (`tools/check-version`, in the gate) fails if
  the two differ.

### Fixed

- Assembly memory no longer grows with expressions times symbols, nor by the
  whole alias table per instruction (clef#25). Layout evaluated every operand
  and directive expression against a fresh copy of the symbol table, and chose
  every instruction's encoding through `x86table.alias`, which built all 670
  alias rows to find one; nothing either made was freed before the assembly
  ended, and both ran again in every layout pass. A compiler's 270 KB source
  (fenrir's numeric matrix, 12,977 instructions) aborted after 6 GiB, and
  clef#25's 3,000 labels between byte directives aborted under 2 GiB.
  Expressions now read the versioned `.set` names they use as overrides beside
  the table (`eval.evaluate_over`), and layout looks spellings up in an index
  built once per assembly (`x86table.alias_index`, `machine.choose_in`). Both
  sources now assemble well under 2 GiB, and output bytes are unchanged.
- Layout converges when direct jumps' short and long forms depend on each other
  (clef#21). Every same-section `jmp` and `jcc` starts short and grows only
  when its rel8 displacement no longer fits; a grown jump never shrinks.
  Forward targets are estimated as the pinned GNU as estimates them, which was
  read from its output on generated cases. fenrir's nested-loop file, which
  trunk refused with `layout_nonconvergent`, now matches GNU as byte for byte.
  Two adjacent jumps that span each other, which trunk left long, are now
  short as in GNU as.
- The layout pass cap is now 64 plus one per relaxable jump, because growth
  alone ends relaxation. A cascade of 200 jumps that grow one per pass
  assembles.

### Added

- The SSE2 scalar-double forms a compiler's floating-point code needs, from the
  Intel SDM: MOVSD, ADDSD, SUBSD, MULSD, DIVSD, SQRTSD, UCOMISD, CVTSI2SD,
  CVTTSD2SI and XORPD, and MOVQ between XMM and 64-bit general registers, with
  register, memory and `%rip`-relative operands, in both directions of the
  table: the assembler matches GNU as and the disassembler reads them in
  objdump's spelling. `census/fenrir-float-forms/` (fenrir's planned float
  forms and the anticipated MOVQ forms) and `tools/float-forms-test` check them
  against GNU as and objdump. Five kinds of input GNU as accepts are refused by
  name; `docs/FORMATS.md` lists them, among them `cvtsi2sd` from memory with
  no suffix in 64-bit code.

- `tools/memory-test`, the `memory` gate: generated sources under a 2 GiB
  address-space cap, each compared with GNU as, with a bound on the
  assembler's own peak RSS, and a linear-growth row for each instruction
  family.

- `clef --disassemble FILE`, a disassembler over the encoder's own table
  (`src/decode/`): every `SHF_EXECINSTR` section in the pinned objdump 2.42's
  AT&T spelling, `--raw --address=N` for flat byte streams, `--code32`,
  `--expand` for prefixes, REX, opcode, ModRM, SIB, displacement and immediate
  with the row's SDM volume, section and page, and `--roundtrip` for GNU as
  source (pseudo prefixes `{disp32}`, `{disp8}`, `{load}`, `{store}`,
  `{noimm8s}`, prefix words, `rex.W`, `%riz`) that clef assembles back to the
  same bytes. Bytes that select no row are one named `(bad)` with the SDM
  reason; the SSE, x87, VEX and EVEX classes are named apart at their full
  instruction length and round-trip as `.byte`.
- 324 general-purpose and system rows and 306 spellings transcribed from the
  SDM for the decoder's coverage (string forms, CET, MPX, TSX, SMX, the
  control and debug register moves, the segment and descriptor instructions);
  the assembler takes GNU as's pseudo prefixes, prefix words, segment
  overrides and `%riz`/`%eiz`.
- `tools/disasm-test` (the `disasm-table` gate: every row's witness read back
  and round-tripped), `tools/disasm-corpus` and `tools/law` (the `disasm-corpus`
  and `law` gates over the digest-checked corpus of `notes/as03/corpus.json`,
  skipping loudly where the corpus is not staged; `law --twice` checks
  determinism).

- `tools/relaxation-test`, the `relaxation` gate: 1,330 rows byte-identical to
  GNU as, the measured rule's model checked against GNU as's choices, and a pass
  bound on the largest case.
