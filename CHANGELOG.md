# Changelog

## Unreleased

### Fixed

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
