# as02c — the word ports: `inw`, `outw` and `xorq`

Footprint: module

PAX's `boot/io.S` at px76's head (pax `eb6592de`) gained `pax_inw`/`pax_outw` for the 16-bit ACPI PM1 control
registers, and clef `996a3ccd` refused it: `unknown_mnemonic inw` at `../boot/io.S` line 86 (pax run 40832410617,
`kernel-as` K5). This pass adds the word forms of IN and OUT, GNU as's implicit port spellings, and `xorq`, each
byte-identical to the pinned GNU as 2.42, and a differential row for that `io.S`.

## Prediction

`1b24087` recorded the prediction before the first change (`notes/as02c/prediction.txt`). Measured on the pinned
oracle (`notes/as02c/spellings.json`, 268 probes):

- **Right:** `inw (%dx),%ax`, `outw %ax,(%dx)` and the suffixed one-operand forms (`inw %dx`, `inw $0x60`, `outw %dx`,
  `outw $0x60`) are accepted with the two-operand bytes; `inw %ax` is refused; bare `in %dx,%ax`/`out %ax,%dx` are
  accepted, sized by the register. All seven predicted `xorq` encodings matched, including `$256,%rax` taking the
  accumulator form `48 35`. `inw %dx,%eax`, `inw $256,%ax`, `inw %cx,%ax` and `xorq %eax,%rax` are refused.
- **Missed:** GNU as also takes a 32- or 64-bit register as the port (`inw %edx,%ax` is `66 ed`; `%rdx` in 64-bit
  mode) for every width, and spaces inside `( %dx )`. A bare one-operand `in %dx` is accepted with a warning and the
  long default (GNU as manual 9.16.4.1).
- **Alias rows:** predicted one per new mnemonic (3), plus 2 if the bare spellings were taken; they were, so **5**
  (112 to 117). No new `rows.lu` descriptor: the 16-bit IN/OUT rows (lines 267–270) and the REX.W XOR rows
  (114–118) were already there and witnessed by row index. The spelling layer took more than names: 62 lines in
  `dialect` (the `(%dx)` port, the implied accumulator, two named refusals) and 9 in `select`.
- **io.S:** byte-identical with nothing else changed, as predicted.
- **Plant:** red where predicted. The row is `rows.lu` line 267, which `tools/table-test` numbers 262.

## What was done

- `1b24087`: the prediction.
- `d06e107`: `tests/ports/pax/boot/io.S`, byte for byte from pax `eb6592de` (blob `71d28946`, sha256 `84d2de10…`),
  with its provenance in `tests/ports/sources.json`.
- `9654280`: the spelling measurement on the pinned GNU as (`notes/as02c/measure-spellings.py`, black box only).
- `dc2bcba`: `tools/ports-test`. It holds 126 encoding rows (42 port spellings in `.code64` and `.code32`, 32 `xorq`
  forms in `.code64`, RIP-relative and symbolic relocations included), each against both live gas and the measured
  bytes. It holds 113 named refusals, with the oracle's verdict on each checked. It assembles the fixture (sha256,
  byte-identical, twice the same) and checks the census map.
- `47786e9`: the gate runs `ports` (34 gates).
- `c14998c`, `e768a32`: `machine_test` and `dialect_test` rows for the new encodings, the normalization and the
  refusals.
- `dd59ae8`: `dialect` accepts `in inw out outw xorq`. For IN/OUT only, `(%dx)` names DX, and a suffixed one-operand
  form gets its accumulator. `port_register` and `implicit_operand_size` are refused by name (R-as02c-1).
- `f9e0706`: five aliases with SDM provenance: IN vol.2A 3.3 p.3-515, OUT vol.2B 4.3 p.4-178, XOR vol.2D 6.1
  p.6-40, the 66H override vol.2A 2.1.1 p.2-1 and REX.W vol.2A 2.2.1 p.2-8, with GNU as 9.16.4.1 for each suffix.
- `1481d1c`: a bare `in`/`out` is sized by its accumulator, not by the DX port.
- `5698d74`: `census-map.json` gains `inw gpr16,gpr16` and `outw gpr16,gpr16` with `origin`, and two counts the
  gate checks: `aliases` 117 and `forms_outside_census` 2.
- `5aee752`: FORMATS documents the port operands and the word ports.
- `7a48580`: README-only commit: 34 gates, the five spellings, the word-port measurement line and `notes/as02c/`.
- `4f2b9e8`, `91dd1d2`: evidence. This covers the sweep of every pax `eb6592de` assembly source, the red gate before
  the implementation and the plant's local red.

### Verified inputs

wolf 0.2.35 (`4cc4045b…`) and lupin 0.1.56 (`ad703550…`) archives were copied from as01's hasu clone, and
`tools/fetch-toolchain` verified each digest twice. The oracle image is `localhost/clef-oracle:bce39162bc0b1e5e` (the
`ci/oracle-lock.json` digest, unchanged). It carries GNU assembler 2.42 (`GNU Binutils for Ubuntu`). The SDM is
325383-086US, copied from as01's lane with sha256 `55b64951…`, the digest `notes/as01/table/source-index.json`
pins. The GNU as manual pages read were i386-Mnemonics, -Variations, -Memory, -Regs, -Prefixes, -Bugs and -Syntax
on sourceware.org.

### Forbidden inputs

No assembler or disassembler source and no opcode database were read; the pinned GNU as was run as a black box. pax
was read at `eb6592de` only (`git show`, `git archive`); it was not edited.

## Evidence

### Evidence index

`notes/as02c/`: `prediction.txt`, `spellings.json`/`.log` (the oracle measurement), `gate-red.log` (the gate at
`e768a32`, tests in, implementation out), `plant-red.log`, `sweep.py` and `sweep-pax-eb6592de.json`/`.log`, and
`gate-green.log` (the final gauntlet), `ports-rows.json` (every ports row, bytes and messages). Host: hasu block A under `flock /home/mfwolffe/lanes/hasu-block-A.lock`,
`taskset -c 0-5` inside the container, lane clone `/home/mfwolffe/lanes/as02c/clef`. A gauntlet takes about 90 s.

- [x] Baseline: trunk with the prediction, 33/33 gates (`~/lanes/as02c/baseline.log` on hasu).
- [x] Seen red before green at `e768a32`: `ports` reads `0/126 encoding rows`, and the fixture refuses
  `unknown_mnemonic inw` at line 86. `unit`, `native-logic`, `checked-`/`lupin-dialect` and
  `checked-`/`lupin-machine` are red too.
- [x] Green at `5698d74` and at `7e661f7` (the note; the final commit adds only this log and `ports-rows.json`): 34/34 gates. `ports: 126/126 encoding rows byte-identical to
  pinned GNU as; 113/113 refusals named (36 that GNU as accepts); 1/1 fixtures byte-identical; census map 2/2 new
  forms`. `table` is still 530/530 with 312/312 rows, and `assembler` is still 43/43 with 189/189 forms.
- [x] `io.S` differential: `pax@eb6592de:boot/io.S` is byte-identical to GNU as in every section, relocation and
  structural symbol, and deterministic. Its `.text` is 86 bytes, with `66 ed` at `pax_inw` and `66 ef` at
  `pax_outw`.
- [x] Sweep (evidence, not a gate): clef at `5698d74` against GNU as over all 29 assembly sources of pax `eb6592de`
  gives 26/29 byte-identical, including every `boot/*.S` and `user/programs.S` (the kernel-as K4/K5 set). The other
  three: `tests/mpx5-clef.d/unknown.S`, which both assemblers refuse (it is a refusal fixture); `user/fsck/open.S:7`,
  where clef refuses `.skip`; and `user/install/raw.S:80`, where clef refuses `.align`. The last two are directives
  outside the dialect, not this pass's gap, and are listed under Hand-off.
- [x] `wolf fmt --check src tests` clean; the README read and refreshed.
- [ ] `tier pr` at the final head: the orchestrator's (read once below).

### Plants

- clef#9 (`as02c-plant-inw-no-66`, `6a449b9`, draft): row `ED IN accumulator16,port` without its `66`. Locally
  red by name (`notes/as02c/plant-red.log`). `table` row 262 fails in modes 32 and 64 (gas `66ed`, clef `ed`;
  528/530). `ports` fails 16 encoding rows (`inw %dx,%ax`, `inw (%dx),%ax`, `inw %dx`, `in %dx,%ax`, …: measured
  `66ed`, clef `ed`). The fixture `pax@eb6592de:boot/io.S` fails with its first `.text` difference at byte 26
  (`pax_inw`), 86 bytes against 85, and every later symbol one byte early. `src/machine_test.lu` 90:9 traps on
  `assert` in `unit`, `native-logic`, `checked-machine` and `lupin-machine`.

### R-as02c-1 — which implicit port spellings clef takes

(A) Take what keeps the SDM's operands. `(%dx)` is DX. The suffix implies the accumulator. A bare `in`/`out` is sized
by its accumulator. Two spellings are refused by name: a 32/64-bit register as the port (`port_register`), and a bare
one-operand form with nothing to size it (`implicit_operand_size`). (B) Also take those two, byte-identical to gas.
(C) Take the four SDM forms only and name every implicit spelling. **Recommendation (A), implemented.** The SDM's
port operand is DX or imm8, and the GNU as manual documents neither `%edx` as a port nor the bare form beyond "using
default" with a warning. No org source uses either. Each refused spelling is a `ports` row that records gas's bytes,
so moving to (B) would be a two-line change with its rows already written.

### R-as02c-2 — where the `io.S` differential lives

(A) A fixture outside the census (`tests/ports/`, with its pax commit and sha256), checked by `ports`; the pinned
census and its 43-source gate stay as measured at their heads. (B) Re-pin the census's pax head to `eb6592de`.
**Recommendation (A), implemented.** Re-pinning would move `census/org-asm.json`, the scanner, dialect and corpus
gates and the 43-source count for one file. The fixture's new forms still reach `census-map.json`, checked.

## Departures

- `lock` is outside clef's dialect for every family: `emit` takes only `rep`. So `lock xorq %rax,(%rcx)` (gas
  `f0 48 31 01`) is a named refusal here, not this pass's gap. The rows' `lock-memory-destination` metadata is
  unused.
- The byte and long IN/OUT spellings gain the same `(%dx)` and implied-accumulator forms, because `select` and
  `dialect` act per family. They are rows in `ports` too, byte-identical.
- `xorq` was named in the contract although px76 already rewrote `io.S` to `xorl`. The fixture therefore has no
  `xorq`, and its 32 `xorq` rows are standalone.

## Hand-off

- pax's `user/clef.pin` should move to clef's merge commit of this PR, whose code equals `5698d74`. The orchestrator
  moves it in px76's rebase, and K5 should then go green: every `boot/*.S` and `user/programs.S` at `eb6592de`
  matches gas.
- Issues to file (clef): `.skip` (pax `user/fsck/open.S:7`) and `.align` (pax `user/install/raw.S:80`) refused at
  pax `eb6592de`, both outside the kernel-as seam today; and the `lock` prefix, for when an org source needs it.
- clef#9 is closed unmerged after it is read red.
- Prune after review: hasu `~/lanes/as02c/` (the clone, `pax-eb6592de/`, `specs/`, run logs; 783 MB with
  `target/`); the Mac worktree `~/lanes/as02c/clef`.

### Done-when

`Footprint: module` (ruling #104). The local gauntlet is green at the head and cited above: 34/34 at `7e661f7`,
whose code equals the head's. No label was added. The PR's `tier pr` run is read once at the head and not waited
on (R4). The plant ran locally as well as in its draft PR's own run. The lane hands back with the audit's last line;
the orchestrator merges on a green `tier pr`.
