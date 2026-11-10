# as03 — the disassembler and the law: the prediction

Written 2026-11-09 before any change to clef, at trunk `bc5677bc`. Everything
below that reads as a measurement was measured with the pinned black-box
oracle (`objdump` 2.42, package `binutils 2.42-4ubuntu2.10`, binary SHA256
`325c4205a4c658a9d1e1ebc469ae55975a2b897a3d3c1e79d9b158612d37f745`, in the
`clef-oracle` container) on 2026-11-09, 18:02–18:13Z, as a light job on the Linux build host, on
block C's CPUs 16–17. Everything that reads as a claim about clef after the
change is a prediction, and the rows below are red until the change lands.

## 1. The corpus, by digest

`corpus.json` beside this file lists every member with its SHA256, its paths on
the ISO, its size, its executable sections and the number of lines `objdump -d
--no-show-raw-insn --wide` decodes for it.

**The corpus of record** is the newest PAX dev ISO the org has built,
`pax-dev-ca13ce2c.iso` (pax `ca13ce2c`, built 2026-11-08, SHA256
`b93ab87f78a43010d15c4b655e07a8f7b668d41805c8e9d79bd123d9f130e39f`): the
kernel `boot/pax` and every ELF64 x86-64 regular file in `boot/initramfs.cpio`.
It carries every x86-64 program the org builds and ships: the kernel, PAX's
user programs (`pax-install`, `paxext2`, `paxfat`, `paxgpt`, `login`, `passwd`,
`su`, `sudo`, `poweroff`, `reboot`, …), boreutils (103 utilities), pelt (`sh`),
scent, yew, lope, aspen, den, burrow (`ssh`, `burrow-keygen`), sniff, lobo,
pack, trail, cub, play, wolf, lupin and clef's `as`.

| set | distinct binaries | decoded lines |
|---|---:|---:|
| org-built | 133 | 38,227,415 |
| external toolchain tail (`cc`, `ld.lld`, `limine`, `crt1.o`, `crti.o`, `crtn.o`) | 6 | 10,427,242 |
| total | 139 | 48,654,657 |

Seven paths are aliases of another path's bytes (`boot/pax` is also
`initramfs/boot/pax`; `cub`, `pack` and `trail` are each installed twice;
`poweroff` and `reboot` share a digest), so 147 files are 139 binaries. The
external tail is shipped on the ISO but not built by the org; it is measured
and reported, never part of the law's 100 %. The two 79-instruction programs
`poweroff`/`reboot` and the kernel are the only members with no vector code.

**The baseline** `pax-dev.iso` of as00/as01 (SHA256 `02f979be…6d4d9`, 79
binaries, 32,510,475 lines) stays staged for comparability with
`census/roundtrip.json`. Its kernel is the only corpus member on which objdump
itself prints `(bad)`: 943 lines, all in `boot/pax` (data in `.text`). The
newest kernel has none.

`den` and `burrow` need no separate build: both are on the ISO
(`initramfs/bin/den`, `initramfs/bin/ssh`, `initramfs/bin/burrow-keygen`).
clef's own `target/clef` and the gate's two corpus programs are added to the
law's run from the gate's own build, as `census/roundtrip.json` did.

### The corpus by instruction class

Every decoded line was classed by its objdump mnemonic (the classifier and
its output are the lane's `survey/` evidence; the per-binary counts are in
`corpus.json`):

| class | org-built lines | share | external lines | distinct mnemonics (corpus) |
|---|---:|---:|---:|---:|
| gp: one-byte and `0F` map integer forms | 35,254,807 | 92.22 % | 10,140,248 | 217 |
| system: privileged, CET, TSX, XSAVE | 168,264 | 0.44 % | 1,773 | 28 |
| sse: legacy-prefix SSE..SSE4.2 | 2,156,931 | 5.64 % | 274,670 | 146 |
| x87: `D8`–`DF` | 6,360 | 0.02 % | 1,384 | 39 |
| bmi: VEX-encoded integer (BMI1/2) | 11,632 | 0.03 % | 656 | 7 |
| avx: VEX/EVEX vector and AVX-512 masks | 629,421 | 1.65 % | 8,511 | 95 |

The vector, x87 and BMI lines of the user programs are a linked runtime's, not
the compiler's: every one of the 103 boreutils programs carries exactly 4,639
AVX, 387 BMI and 35 x87 lines, and the larger programs 5,891/98/98. The
kernel has none of any of them: `boot/pax` is 408,877 gp and 66 system lines.

## 2. The table: what is missing for full coverage

clef's table at `bc5677bc` has 517 descriptors in 134 families, with 354
spellings in `aliases.lu`. Against the corpus's 522 distinct objdump spellings
(newest ISO), 176 are spelled by the alias table today, covering 43,365,661 of
51,372,012 decoded lines (84.4 %, duplicates included).

**Spellings only (no new row):** objdump drops the suffix when a register
sizes the operands, and the alias table has only the census's explicit
spellings. `cmp` (2,731,382 lines), `shr`, `sar`, `imul`, `div`, `mul`,
`idiv`, `bt`, `nopl`, `nopw`, `stos`, `movsl` and the twenty bare `cmovcc`
spellings are rows clef already has. These become aliases: 4.2 M of the 4.7 M
missing gp lines.

**Rows missing for the corpus's gp and system classes** (SDM vol. 2, edition
325383-086US; the entry pages are cited on each row when transcribed):

| family | SDM entry | opcodes | corpus lines |
|---|---|---|---|
| ROL/ROR/RCL/RCR | 2B 4.3 RCL/RCR/ROL/ROR | `C0/C1/D0–D3 /0–/3` | 18,382 |
| SHLD, SHRD | 2B 4.3 SHLD, SHRD | `0F A4/A5`, `0F AC/AD` | 11,604 |
| BSWAP | 2A 3.3 BSWAP | `0F C8+r` | 10,043 |
| BSF, BSR, TZCNT, LZCNT, POPCNT | 2A 3.3 BSF/BSR; 2B 4.3 TZCNT/LZCNT/POPCNT | `0F BC/BD`, `F3 0F BC/BD/B8` | 98,241 |
| BT r/m,r (register source) | 2A 3.3 BT | `0F A3 /r` | with `bt` |
| LEAVE, ENTER | 2A 3.3 LEAVE, ENTER | `C9`, `C8 iw ib` | 24,167 |
| CLC/STC/CMC/STD, LAHF/SAHF | 2A/2B/2D entries | `F8 F9 F5 FD 9F 9E` | 144 |
| PUSHF/POPF all widths | 2B 4.3 PUSHF, POPF | `9C/9D` with/without 66 | 8 |
| JrCXZ, LOOP/LOOPE/LOOPNE | 2A 3.3 Jcc, LOOP | `E3 cb`, `E0–E2 cb` | 270 |
| MOVS/STOS/LODS/SCAS/CMPS, every width; INS/OUTS | 2B/2A string entries | `A4–AF`, `6C–6F` | 3,454 |
| INT imm8, INT1, IRET/IRETD, RET imm16, far RET imm16 | 2A 3.3 INT n, IRET; 2B 4.3 RET | `CD ib`, `F1`, `CF`, `C2 iw`, `CA iw` | 0 (SDM completeness) |
| XLAT, CBW family 16-bit forms, CWD etc. | already partly present | | |
| MOV r/m, imm with 66; MOVABS moffs64 (`A0–A3` in 64-bit) | 2B 4.3 MOV | `A0–A3 io` | 0 |
| ENDBR64/ENDBR32, RDSSP, INCSSP, SAVEPREVSSP, RSTORSSP, SETSSBSY, CLRSSBSY, WRSS, WRUSS | 2A 3.3 ENDBR64 …; 2B 4.3 RDSSPD/Q …, 2D 6.1 WRSS | `F3 0F 1E FA/FB`, `F3 0F 1E /1`, `F3 0F AE /5`, `F3 0F 01 EA`, `F3 0F 01 29`, … | 143,123 |
| XBEGIN, XEND, XABORT, XTEST | 2D 6.1 XBEGIN …; 2D 6.1 XTEST | `C7 F8 cd`, `0F 01 D5`, `C6 F8 ib`, `0F 01 D6` | 3,361 |
| XSAVE/XSAVEC/XSAVEOPT/XSAVES/XRSTOR/XRSTORS (32-bit and 64 forms), FXSAVE/FXRSTOR 32 | 2D 6.1 XSAVE …; 2A 3.3 FXSAVE | `0F AE /4 /5`, `0F C7 /3 /4 /5 /6` | 945 |
| LDMXCSR, SFENCE/LFENCE/MFENCE, CLFLUSH/CLFLUSHOPT/CLWB, PREFETCHh, PREFETCHW | 2A/2B/2D entries | `0F AE /2`, `0F AE F8/E8/F0`, `0F AE /7`, `66 0F AE /7`, `0F 18 /0–/3`, `0F 0D /1` | 29,282 |
| SGDT/SIDT/STR/LLDT/SLDT/SMSW/LMSW/VERR/VERW/LAR/LSL/ARPL32 | 2B 4.3 SGDT …, 2A 3.3 LAR | `0F 00 /0–/5`, `0F 01 /0 /1 /4 /6`, `0F 02/03` | 0 |
| INVD/WBINVD/CLTS/RDPMC/RDTSCP/SYSENTER/SYSEXIT/RSM/UD0/UD1/MONITOR/MWAIT/RDSEED/RDPID/RDFSBASE…/INVPCID/SWAPGS/VMCALL family names | vol. 2 entries | `0F 08/09/06/33/34/35/AA`, `0F FF`, `0F B9`, `0F 01 C8/C9`, `0F C7 /7`, `F3 0F AE /0–/3`, `66 0F 38 82`, `0F 01 F8/F9` | 0 |
| MOV to/from debug registers; CR8 via REX.R | 2B 4.3 MOV debug registers | `0F 21/23` | 0 |
| PUSH/POP segment registers; far indirect CALL/JMP; LDS/LES/LFS/LGS/LSS | vol. 2 entries, 32-bit forms where legal | `06/07/0E/16/17/1E/1F`, `0F A0/A1/A8/A9`, `FF /3 /5`, `C4/C5` (32), `0F B2/B4/B5` | 0 |
| 32-bit-only forms: PUSHA/POPA, DAA/DAS/AAA/AAS/AAM/AAD, BOUND, INTO, far CALL/JMP imm, `40+r/48+r` INC/DEC | vol. 2 entries | `60/61`, `27/2F/37/3F/D4/D5`, `62`, `CE`, `9A/EA` | 0 |
| MOVBE, CRC32 | 2B 4.3 MOVBE; 2A 3.3 CRC32 | `0F 38 F0/F1`, `F2 0F 38 F0/F1` | 2,160 |
| MOVNTI, CMPXCHG16B widths, XADD widths | present or 2B 4.3 MOVNTI | `0F C3` | 0 |
| NOP forms objdump spells `nopw`/`nopl` with `cs`/`data16` repeats | 2B 4.3 NOP; 2A 2.1.1 prefix groups | `66…`, `2E`, `0F 1F /0` | 979,799 (with prefixes) |

Expected size: about 330 new descriptors for the gp and system classes, taking
the table from 517 to roughly 850, and about 260 new spellings. The two-byte
map's SSE entries (146 corpus mnemonics, ~2.4 M lines), the x87 escapes (39
mnemonics) and every VEX/EVEX form are **not** in this change (the split decided at the prediction).

## 3. The disassembler: shape and policy

One module, `src/decode/`, reads the same `x86table.Form` rows the encoder
emits from. At load it indexes the rows by (mandatory prefix, opcode bytes,
ModRM extension, REX.W, mode); decoding one instruction is:

1. **Legacy prefixes** (SDM 2A §2.1.1, one group each; repeats are kept, in
   order, since the bytes are the law's input): `F0 F2 F3`, `2E 36 3E 26 64 65`,
   `66`, `67`. Then **REX** (`40–4F` in 64-bit mode; a REX not immediately
   before the opcode is a legacy-prefix violation, refused by name).
2. **Opcode**: one byte, `0F xx`, `0F 38 xx`, `0F 3A xx`. The index gives the
   candidate rows; ModRM `/digit` and the `mod=11` register forms select.
3. **ModRM, SIB, displacement** (2A §2.1.5, Tables 2-2/2-3/2-5; §2.2.1.2 for
   REX.B/X; `mod=00 rm=101` is RIP-relative in 64-bit mode and `disp32` in
   32-bit); **immediate** by the row's `immediate` byte count and kind.
4. **Operand text** in AT&T, objdump's spelling: `%reg`, `$0x..`,
   `disp(base,index,scale)`, `0x..(%rip)` with the `# target` comment, branch
   targets as absolute `0x..` from the section's address. Widths are spelled as
   objdump spells them: a suffix only where no register sizes the operand.
5. **Refusal:** every byte that decodes to no row is one `(bad)` line of one
   byte, with a name and an SDM reason in a trailing comment: `invalid_opcode`
   (an undefined map cell, Table A-2/A-3), `invalid_in_64bit` (a cell marked
   i64, §2.2.1), `reserved_modrm` (a `/digit` the group table leaves blank,
   Table A-6), `lock_without_memory` (LOCK rules, 3-621), `rex_misplaced`,
   `length_over_15` (§2.3.11), `out_of_scope:<class>` (x87, sse, vex, evex:
   a known escape clef does not decode yet, named by class, counted apart from
   the invalid ones). objdump's `(bad)` is one byte long too, so the two
   streams stay in step.

**`--disassemble FILE`** reads an ELF64 object or executable and prints every
`SHF_EXECINSTR` section in objdump's layout (`Disassembly of section .text:`,
`address:\ttext`); `--disassemble --raw` reads bytes from a flat file at
address 0; `--disassemble --expand` prints, under each instruction, its fields
with their SDM provenance:

```text
  401000:	48 89 e5          	mov    %rsp,%rbp
          prefixes=none rex=48 (W=1 R=0 X=0 B=0; 2A 2.2.1 Table 2-4) opcode=89 (2B 4.3 MOV p.4-35 REX.W + 89 /r)
          modrm=e5 mod=11 reg=100 rm=101 (2A 2.1.5 Table 2-2) sib=none disp=none imm=none
```

**`--disassemble --roundtrip`** prints assembler source for the law: the same
instruction text, plus whatever the AT&T dialect needs to force the exact
encoding where GNU as (and clef) would otherwise choose another legal one.
Every device is the GNU as manual's (9.16.4.1 pseudo prefixes, 9.16.6
prefixes, 9.16.7 memory references): `{disp32}` and `{disp8}` for a
displacement or branch width, `{load}`/`{store}` for the direction of a
register-register MOV/ADD/…, `{rex}` for a redundant REX, `{noimm8s}` for an
imm32 that fits imm8, `%riz`/`%eiz` for a SIB with no index, and the prefix
words `data16`, `addr32`, `cs`/`ds`/…/`gs`, `lock`, `rep`/`repz`/`repnz`,
`rex`/`rex.W`/… for prefixes the bytes carry. Branch targets are `.+N`
expressions (the instruction's own address is `.`), so no label is needed and
no chunk boundary matters. `(bad)` and out-of-scope bytes are `.byte` lines.
The assembler learns these spellings in the same change: the dialect accepts
the pseudo prefixes and prefix words, and the layout honours them.

### Measuring agreement with objdump

`tools/disasm-test` compares clef's text with objdump's on every table row's
witness (the `table-test` sources, assembled by GNU as) and on every corpus
section. Lines are compared after one normalization, stated here so it cannot
widen later: the address column is kept; symbolic decoration is removed
(`<sym+off>` after a target, the `# 0x…` RIP comment is kept as a number); runs
of blanks become one. Any remaining difference is counted under a name, and the
report lists every name with its count and one example:

- `out_of_scope:<class>`: clef prints a named `(bad)` where objdump decodes an
  x87/SSE/VEX/EVEX instruction (this change's known residual).
- `spelling:<mnemonic>`: both decode the same bytes to the same instruction and
  differ in text (expected zero at the end; any survivor is ruled, not hidden).
- `length`: the two streams consume different byte counts (expected zero).

Intel syntax (`objdump -M intel`) is not compared (the output-syntax decision).

## 4. The law and its rows

`assemble(disassemble(bytes)) == bytes`, with clef on both sides. For each
corpus binary (digest-checked against `corpus.json` before use) and each
executable section: clef prints the section's round-trip source, the source is
assembled by clef in chunks of at most 50,000 instructions (clef's expanded
statement limit is 100,000; a chunk boundary falls on an instruction boundary
and the chunks' `.text` bytes are concatenated), and the result is compared
byte for byte with the section. The report (`target/evidence/law.json`,
checked into `notes/as03/law.json` at the final head) has three row kinds:

- **per binary**: `law:<name>` is green when every executable section round
  trips. Predicted at the end of this change: **green for `boot/pax`,
  `poweroff`/`reboot`, clef's own `target/clef` and the gate's two corpus
  programs, i.e. the kernel's whole dialect and every binary with no vector
  code**; red, by the named residual, for the 130 user programs that carry the
  linked runtime's SSE/AVX/x87 lines and for the external tail.
- **per text section**: `law:<name>:<section>` as above; `.init`, `.fini`,
  `.plt`, `.iplt` are tiny and integer-only and are predicted green everywhere.
- **per instruction class**: `law-class:gp` and `law-class:system` are
  predicted **100 %** of their lines over the whole org-built corpus
  (35,423,071 lines), with every difference named; `law-class:sse`, `:x87`,
  `:bmi`, `:avx` are reported as `.byte`-preserved (byte-identical by escape,
  not decoded) and counted as **not decoded**, never as decoded agreement.

Named differences expected inside gp/system, each with its forcing spelling
and its own count in the report: `direction` (compiler chose `8B` where gas
chooses `89`; `{load}`), `disp-width` (a `disp32` that fits `disp8`;
`{disp32}`), `branch-width` (`E9` where `EB` fits; `{disp32}`), `imm-width`
(`81` where `83` fits; `{noimm8s}`), `redundant-rex` (`{rex}`), `sib-no-index`
(`%riz`), `prefix-repeat` (padding NOPs: `data16 data16 cs nopw`). Expected
zero after the change: any gp/system line that cannot be forced.

**Determinism:** `disasm-determinism` runs the corpus twice and requires
byte-identical text and byte-identical `law.json`; no timestamps, no paths of
the lane host, in either.

## 5. Hosts, inputs and the gate

- Inputs staged by digest: the ISO (above), the baseline ISO, the SDM volume 2
  PDF (`55b64951…1dce`, the pinned edition), objdump (the oracle lock's
  package digests; the binary's digest above). Nothing is fetched from a
  release origin during a record.
- The corpus rows run where the ISO is staged (the Linux build host, under the lane's inputs directory,
  as a light job: objdump and clef are single-threaded). In CI they `SKIP`
  loudly with the reason `corpus not staged`, and the hand-back names them as
  hosted-skipped; the table-row disassembly witnesses and the unit rows run
  everywhere.
- Steps added to `tools/gate`: `decode-unit` (checked machine and lupin on
  `src/decode_test.lu`), `disasm-table` (every row × mode: GNU as's bytes →
  clef's text = objdump's text, and clef's text → clef's bytes = the input),
  `disasm-corpus` (objdump agreement over the corpus), `law` and
  `disasm-determinism`. The record is one gauntlet at the final head on the Linux build host.
- Two plants, each one hunk on its own `as03-plant-*` branch, red by name
  locally: `as03-plant-operand-order` swaps `reg_operand`/`rm_operand` on the
  `0F AF IMUL r32, r/m32` row (red: `disasm-table` row 0F AF, `law:boot/pax`);
  `as03-plant-prefix-dropped` makes the decoder skip the `66` operand-size
  prefix (red: `disasm-table` every 16-bit row, `law:boot/pax` through its
  2,485 `nopw` lines).

## 6. Rulings asked (recommendation first; implemented as recommended)

- **Output syntax.** (A) AT&T only, objdump's default spelling, Intel
  syntax a later row as R-AS-4 ruled; (B) both from the start. **(A).**
- **The split.** The contract allows one at the prediction. (A)
  Three changes in order: **as03** (this one) the decoder, the gp and system
  tables completed from the SDM, objdump agreement, the law with the kernel
  and the no-vector binaries green and every residual named by class;
  **as03b** the legacy SSE..SSE4.2 rows and the x87 escapes (146 + 39 corpus
  mnemonics, ~2.4 M lines; this makes every org binary's own code decode);
  **as03c** VEX/EVEX (BMI, AVX, AVX2, AVX-512 and its masks: the linked
  runtime's 95 mnemonics) to reach 100 % per binary over all 133. (B) one
  change for everything. (C) as03 plus the SSE rows now. **(A)**: the decoder
  and the law are one review; the vector maps are data over the same
  machinery and each is its own measured step.
- **The corpus of record.** (A) The newest dev ISO by digest, every
  ELF64 x86-64 file in it, the external toolchain tail measured but outside the
  100 %; the baseline ISO kept as a comparability row. (B) Only the retained
  79-binary baseline. (C) Build each repo at a pinned commit instead. **(A)**:
  it is what the org ships, it already contains den, burrow and sniff, and a
  later ISO replaces it by changing one digest.
- **The round-trip dialect.** (A) GNU as's own pseudo prefixes and
  prefix words, learned by clef's assembler, so the law's source is valid gas
  input too. (B) A clef-only encoding hint. (C) Emit `.byte` wherever the
  canonical choice differs. **(A)**.
- **`(bad)`.** (A) One byte per refusal, named, with the SDM reason,
  out-of-scope classes named apart from invalid bytes; `.byte` in round-trip
  source. (B) Consume the whole instruction length objdump would. **(A)**: the
  two streams stay in step and the law preserves bytes it does not decode.
- **Chunking.** (A) 50,000 instructions per assembled chunk, cut on
  an instruction boundary, concatenated. (B) Raise clef's statement limit.
  **(A)**: the limit is a stated boundary of the assembler, not of the law.
- **objdump text normalization.** (A) Only symbolic decoration and
  blank runs, as stated in §3; (B) also mnemonic suffixes. **(A)**.

## 7. What I expect to be wrong about

- The count of new descriptors (330) is an estimate from the map; the
  transcription decides.
- The forcing spellings may not cover every gp difference the compilers
  produce (an `8B` direction on a memory form has none; a `data16` run longer
  than gas accepts). Each survivor becomes a named row, not a waiver.
- Throughput: 48.7 M lines through clef twice plus 35 M through its assembler
  in 50,000-line chunks; if a chunk's layout is slow the chunk shrinks, and the
  record's `secs=` says so.
