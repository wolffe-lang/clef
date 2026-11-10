# as03 — the disassembler

Footprint: module

clef reads x86-64 machine code back. `clef --disassemble FILE` prints every
executable section in the pinned objdump 2.42's AT&T spelling from the same
encoding rows the assembler emits from, `--expand` shows each instruction's
fields with the row's SDM provenance, and `--roundtrip` prints GNU as source
that clef assembles back to the same bytes. The law
`assemble(disassemble(bytes)) == bytes` is measured over every x86-64 binary
the org builds, per binary, per section and per instruction class, and every
difference from objdump is named and counted. The general-purpose and system
instructions are decoded here; the legacy SSE, x87, VEX and EVEX classes are
named `(bad)` refusals of their full length that round-trip as `.byte`, each
measured, for the two changes that follow (as03b, as03c).

## Prediction

`3c6291a` recorded the prediction before any decoder code
(`notes/as03/prediction.md`, `notes/as03/corpus.json`), and `6ae378c` made the
rows red by name on hasu (`red-6ae378ced55e`: `END disasm-table exit=1`,
`END disasm-corpus exit=1`, `END law exit=1`, 888 FAIL lines).

- **Right: the corpus.** The newest dev ISO by digest holds 139 distinct ELF64
  x86-64 binaries (133 org-built, 6 from the external toolchain) and
  48,654,657 objdump lines; the org-built share is 38,227,415 lines, 92.22 %
  general-purpose, 0.44 % system, 5.64 % legacy SSE, 1.65 % AVX/AVX2/AVX-512,
  0.03 % BMI, 0.02 % x87. The kernel `boot/pax` (408,943 lines) is
  general-purpose and system only. The survey's numbers were reproduced by the
  measurement.
- **Right: the missing rows.** The table lacked 324 general-purpose and system
  rows (predicted ~330) and 306 spellings; the string forms, CET, MPX, TSX,
  SMX, the control and debug register moves and the descriptor instructions
  among them. All were transcribed from the SDM, each row with its volume,
  section, page and opcode citation, and every row's witness reads back.
- **Right: the forcing devices.** GNU as's own pseudo prefixes and prefix words
  cover every general-purpose difference the compilers produce except one
  (Departures: `accumulator-form`).
- **Partly right: the law rows.** Predicted: the kernel, `poweroff`/`reboot`
  (one digest), clef's own binary and the gate's two corpus programs green with
  everything decoded, every user program red by a named residual. Outcome: the
  law holds on all 139 members (the named residual round-trips as `.byte`, so
  no per-binary row is red; the class counts carry the residual instead), and
  exactly the predicted members decode completely: `pax`, `poweroff`, and the
  three `crt*.o`. Not taken: clef's own `target/clef` and the gate's two corpus
  programs are not members of the ISO, the corpus of record (R-as03-3), and
  the per-class rows `law-class:<class>` became the counts in `law.json`
  rather than green/red rows: `decoded` is 100 % of the general-purpose and
  system lines (no unforced escape remains), which is what those rows were
  to show.
- **Missed: three spellings.** The first full `disasm-table` on hasu
  (`full-98c4d2f73e58`) was red on 13 row×mode witnesses: `monitor` and
  `mwait` printed one operand (the `fixed:%ecx` pattern rendered nothing),
  `xlat` printed its table twice, and `arpl`'s register printed at 8 bits where
  objdump prints it at the operand size (`arpl %ecx,(%eax)`). The Mac-side
  oracle cache predated those rows, so the Mac checks could not see them;
  `788f9f8` fixed all three.

## What was done

- `src/decode/decode.lu`: an index over the rows by opcode bytes; one
  instruction decoded by SDM vol.2A chapter 2 (prefixes in order, REX, escapes,
  ModRM, SIB, displacement, immediate); the row chosen from its candidates by
  mode, ModRM extension, r/m form and the prefixes it consumes; refusals one
  byte, named (`invalid_opcode`, `invalid_in_64bit`, `reserved_modrm`,
  `rex_misplaced`, `length_over_15`); out-of-scope classes consumed at their SDM
  length (`out_of_scope:x87|sse|vex|evex`).
- `src/decode/render.lu`: objdump's spelling (suffix rule, mode spellings,
  prefix words, RIP comments, sign-extended immediates), `--expand`, and the
  round-trip source: `{disp32}`, `{disp8}`, `{load}`, `{store}`, `{noimm8s}`,
  `rex…`, prefix words, `%riz`, `.+N` targets; every line verified through
  `machine.choose`/`machine.emit`, with a named `.byte` where no device forces
  the encoding.
- `src/decode/elf.lu`: the executable sections of an ELF64 file.
- The assembler learned the same dialect (`src/dialect`, `src/machine`,
  `src/assembly`): pseudo prefixes, prefix words, segment overrides,
  `%riz`/`%eiz`, `%cr0`–`%cr8`, `%db0`–`%db7`, composite mandatory prefixes,
  the emission order implied 67, implied 66/F2/F3, explicit words, LOCK/REP,
  operand segment, REX, opcode.
- `src/x86table/rows.lu` +324 rows, `aliases.lu` +306 spellings,
  `decode-alias` marks on rows that are assembler spellings only.
- `tools/disasm-test`, `tools/disasm-corpus`, `tools/law` (+`disasmlib.py`,
  `rowwitness.py`); gates `disasm-table`, `disasm-corpus`, `law`,
  `checked-decode`, `lupin-decode`; `src/decode_test.lu`.
- Docs: `docs/FORMATS.md` "The decoder", README, CHANGELOG.

## Evidence

Record `full-06c0effd2407` on hasu (head `06c0eff`, the source of the final
head; the later commits change only `tools/law`'s scheduling, the probe's
removal and these notes), every END line:

```
END fetch-toolchain exit=0 secs=2.226
END build exit=0 secs=2.060
END disasm-table exit=0 secs=21.098
END disasm-corpus exit=0 secs=314.771
END law exit=0 secs=8102.050
RECORD-END worst=0 steps=5 end=2026-11-10T01:02:26Z
```

- `disasm-table`: 1,422/1,422 row×mode witnesses agree with objdump and
  round-trip; 5 witnesses GNU as refuses are listed, not counted.
- `disasm-corpus`: 139/139 binaries agree outside the named out-of-scope
  classes; 45,696,887 of 48,654,657 objdump lines are identical text (93.92 %),
  the other 2,957,770 are `(bad)` lines of a named class: sse 2,300,198, vex
  466,687, evex 183,533, x87 7,352. No `spelling:` or `length` difference
  remains.
- `law --twice`: 139/139 binaries round-trip byte for byte, every executable
  section, and the two disassemblies are identical. Classes over the org-built
  133: decoded 35,539,712 (92.97 %), sse 2,041,195, vex 460,547, evex 180,506,
  x87 5,978; over the 6 external: decoded 10,157,714. Escapes: 1,303
  `accumulator-form` (all in the kernel), 2,957,770 out-of-scope `.byte`
  lines, 0 unforced. `notes/as03/law.json` is the report.
- Plants and the gate's green record at the final head: see the PR.

## Departures

- **`accumulator-form`.** The compilers encode `add $imm32,%rax` as `81 /0 id`
  on the accumulator; GNU as picks the shorter `05 id` and has no device that
  refuses it. The round-trip source prints those lines as `.byte` with the
  reason; the law holds, and the count is named (1,303 in the kernel, 0.32 %).
- **R-as03-5, refined.** The named out-of-scope classes consume the whole
  instruction length instead of one byte, so the two streams stay in step and
  the law preserves the bytes; invalid bytes stay one byte. Ruled A as refined.
- **R-as03-7, refined.** objdump prints a symbolized address as bare hex before
  the symbol (`je 40103e <main+0x1e>`, `# 402000 <x>`) and the same number as
  `0x40103e` where no symbol applies. The normalization reads the symbolized
  form as that number: the `<…>` and the bare-hex spelling are one decoration
  from the symbol table, not from the bytes. Nothing else was added to it.
- **R-as03-6, refined.** The chunk is 2,000 instructions, not 50,000: clef's
  assembler holds about 0.85 MB per source line (a 50,000-line chunk peaked at
  15.6 GiB and a 10,000-line one at 7.8 GiB, measured with `time -l` on the
  Mac), so 50,000-line chunks died under the 2.5 GiB per-process cap on hasu
  (`full-9262708e6646`: every `.text` "reassembly refused" with "memory
  allocation failed"). The chunk size is the law's, not the assembler's; the
  memory per line is a clef finding handed off below.
- **FWAIT.** `9B` appeared six times in the corpus (`as`, `limine`) and was a
  reserved cell in the table; the SDM row (vol.2D 6.1 WAIT/FWAIT) was added
  with the `fwait`/`wait` spellings.
- **The operand-order plant was green on its first take.** `plant-9e3d4874d68a`
  (head `33eb108`) came back `END disasm-table exit=0`: swapping the IMUL
  r32,r/m32 row's operands also swaps the witness `tools/rowwitness.py`
  derives from the row (`imull %ecx,(%rax)`), GNU as refuses that, and
  `disasm-test` listed refused witnesses without counting them. A table row
  whose witness GNU as refuses is a hole in the gate, so `11bc8fd` pins the
  five refusals the gate had (`tools/disasm-refusals.json`: the r64 far-pointer
  loads and `bound`'s operand order, "operand size mismatch") and makes any
  other refusal, or a stale pin, a red row by name. Under lupin against the
  cached witnesses the same plant had read 2 rows red, which is how the hole
  stayed hidden until hasu. Both plants were retaken on `11bc8fd`.
- **One lock slip.** Early in the lane one `wolf build` ran on the Mac without
  the build lock (about a second, while another lane held it). Every later
  build went through the lock.
- **The Mac ran out of memory.** A full-corpus law run on the Mac with eight
  workers exhausted the compressor at 20:50Z on 11-09 and the session restarted.
  The corpus tools now cap every clef process (`--mem`, `CLEF_MEM_GB`) and the
  full-corpus runs live on hasu; the Mac does single-binary checks at
  `--jobs=2`.

## Hand-off

- **as03b**: the legacy SSE..SSE4.2 rows and the x87 escapes (146 + 39 corpus
  mnemonics, about 2.4 M lines); the decoder, the renderer's patterns
  (`xmm128`, `xmmrm128` already exist) and the law's class counts are in place.
- **as03c**: VEX/EVEX (95 mnemonics in the linked runtime); the prefix lengths
  are already decoded for stream sync, the operand forms are not.
- Intel syntax (`objdump -M intel`) is a later row.
- **clef's assembler memory.** About 0.85 MB of peak RSS per source line
  (1,000 lines 0.8 GiB; 2,000 lines 1.6 GiB; 5,000 lines 3.9 GiB; 50,000 lines
  15.6 GiB), linear in the line count, measured on the kernel's round-trip
  source. A compiler's 100,000-line unit would need 80 GiB. Worth its own
  change; the law works around it with 2,000-line chunks.
