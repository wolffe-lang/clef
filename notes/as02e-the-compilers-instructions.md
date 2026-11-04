# Compiler integer instruction envelope

Footprint: module

## Prediction

`bea1305` records the prediction before implementation. Linux clef at
`0ef3d84a` should reproduce the Mac's 238 accepted / 402 refused forms without
a per-form difference. The missing families should use the existing ModRM,
SIB, REX, immediate and branch-relaxation machinery, with separate IMUL arities
and separate source/destination widths for extending moves. Every census form
is expected to be accepted by GNU as. The original corpus must not regress.

The baseline prediction was correct, and all 640 census forms match GNU as.
One extra symbolic-immediate boundary row exposed an existing ELF relocation
limit, retained as the explicitly checked deviation below.

## What was done

- `d7b8e52`: pin fenrir's instruction census generator, all 640 individual
  sources, a combined source, and the differential before the implementation.
- `18d8c59`: all 30 flag-condition spellings and aliases for Jcc, SETcc and
  word/long/quad CMOVcc.
- `3d8529b`: all widths of MUL, one-operand IMUL, DIV and IDIV; two-operand
  word/long/quad IMUL; the existing immediate IMUL descriptors remain in use.
- `ea7d76b`: sign- and zero-extending move widths.
- `5bb3241`: arithmetic right shifts, byte/word SHL and SHR, and TEST word.
- `cffd8ac`: all six AT&T accumulator sign-extension spellings.
- `0eb5c8b`, `21e7930`, `1a410a3`: descriptor witnesses, machine assertions and
  the declarative census index: 517 descriptors, 354 aliases, 886 descriptor by
  mode witnesses. The original source census is retained unchanged.
- `62a762c`: linked integer-code execution, without a C runtime.
- `f4e2802`, `6b51c39`: encoding documentation and README counts.
- `c83deb8`: CMOV architecture-feature metadata, independently of host CPUID.
- `4082b9b`: cache descriptors once in the machine-test program. Reconstructing
  all 517 descriptors per instruction exhausted the checked machine's step
  budget after adding the condition witnesses. Caching fixes the helper's
  cost; the budget and encoder are unchanged. The pinned checked machine then
  reaches run with verdict `exit(0)` and no warnings, on both Mac and Linux.
- `e2455e8`: enforce the exact narrow-relocation deviation, including GNU-as
  acceptance, clef's status and complete reason, and an untouched output file.

### Specification provenance

Intel SDM 325383-086US (December 2024), combined volume 2, official PDF SHA256
`55b64951731ef661f8a7922b665e649715e3b3a7db06e4ff15158b875ccd1dce`.
Each descriptor carries volume, section, printed page and opcode row. GNU as
manual 9.16.4.1 supplies AT&T naming; 9.16.3.1 supplies operand order. No
assembler/disassembler implementation source or opcode database was read.

The red record is Linux `0ef3d84a`, per form ID in
`notes/as02e/linux-baseline.json`. The family green measurements below are from
Linux `4082b9b`, against the unchanged, package-version-checked GNU as 2.42
container. They include additional addressing and boundary controls beyond the
640-form census; the full final-head merge record is supplied with the PR.

| Family | SDM entry and opcode table | Baseline refused | Green family rows |
|---|---|---:|---:|
| Jcc | 2A 3.3, 3-558..3-561; 70+cc / 0F 80+cc | 19 | 480/480 |
| SETcc | 2B 4.3, 4-619..4-621; 0F 90+cc | 87 | 810/810 |
| CMOVcc | 2A 3.3, 3-175..3-177; 0F 40+cc /r | 180 | 540/540 |
| MUL, one-operand IMUL, DIV, IDIV | 2B 4.3 MUL 4-148; 2A 3.3 IMUL 3-511, DIV 3-331, IDIV 3-508; F6/F7 /4..7 | 28 | 96/96 |
| Two/three-operand IMUL | 2A 3.3, 3-511..3-512; 0F AF, 6B, 69 | 14 | 72/72 |
| Extending moves | 2B 4.3 MOVSX/MOVSXD 4-128, MOVZX 4-138; 0F BE/BF/B6/B7, 63 | 16 | 72/72 |
| Shifts | 2B 4.3 SAL/SAR/SHL/SHR, 4-600..4-601; D0/D1, D2/D3, C0/C1, /4,/5,/7 | 48 | 252/252 |
| TEST | 2B 4.3 TEST 4-713; 85, A9, F7 /0 | 4 | 16/16 encodings; one extra deviation |
| Accumulator sign extension | 2A 3.3 CBW/CWDE/CDQE 3-156 and CWD/CDQ/CQO 3-324; 98, 99 | 6 | 6/6 |

## Evidence

- [x] Linux baseline at `0ef3d84a`: 238 accepted / 402 refused. Every form's
  status, normalized diagnostic and object-presence result matches the Mac
  probe. No differences. `notes/as02e/linux-baseline.json` retains every form's
  disposition and the Linux executable SHA256
  `8a8232dbce25882cc81cfe5b7d4fcafdc73c3eb0da7a1f9e88581d88db1c8958`.
- [x] Mac checks at `4082b9b`, pinned wolf 0.2.36: warning-denied builds,
  native machine witnesses, six unit tests, checked-machine `exit(0)` and
  640/640 accepted probes. Mac acceptance is not GNU-as qualification.
- [x] Generator SHA256:
  `d43b34de409cd074e0b321e396a1b80d61236dba0e1f3ab4d217c03e31cd4376`.
- [x] Linux `4082b9b`: all 640 census forms and their combined source match
  GNU as in sections, relocation tuples and structural symbols, and every
  successful object is deterministic. No census form needs a deviation.
- [x] The 2741-row compiler differential has 2520 exact deterministic object
  comparisons, 220 shared named refusals, and the single named deviation below.
  Its linked integer executable exits 0 with both assemblers' objects.
- [x] Linux `4082b9b`: 886/886 descriptor-by-mode rows, 517/517 descriptors;
  the original 43 sources and 189 forms; 943/943 padding/LOCK/PAX controls,
  including 29 exact valid PAX objects and one shared deliberate refusal.
- [x] The first qualification record stopped at `END assembler exit=1` only
  because the old expectation demanded an object for the narrow-relocation
  row. It is a red record, not a successful merge gauntlet. Steps through
  table/layout, including checked and lupin machine tests, were exit 0.

### Merge records and plant

The PR supplies the final-head green record, every literal END line, and a
separate plant record. The wrapper stops on the first failing step and retains
its exit status; output counts alone are not a pass.

The plant witness is `cmovl-condition-nibble`: encoding long CMOVL with CMOVG's
condition nibble must fail `tools/compiler-forms-test --plant-only` by that name.
Its branch is based on the final green head, changes one file in one hunk, and
is pushed without a PR. No planted change enters the implementation branch.

## Departures

### R-as02e-1 — retain the named narrow-relocation limit

**Recommendation, implemented:** retain the existing refusal rather than add
16-bit symbolic relocations to this assembler and its downstream linker in an
instruction-encoding change.

`testw $external,external(%rip)` is accepted by GNU as. Its object contains
`R_X86_64_PC32` at offset 3 with addend -6 and `R_X86_64_16` (type 12) at offset
7 with addend 0. Clef refuses with the complete reason
`unsupported_narrow_relocation: x86-64 psABI §4.4`.

The compiler does not emit a symbolic 16-bit immediate. The extra boundary row
therefore records a named, intentional acceptance asymmetry, not a shared
refusal and not a skipped test. It passes only when GNU as succeeds, clef exits
1 with that exact reason, and the sentinel output remains untouched. Accidental
acceptance, a different refusal, or an oracle refusal fails the row. The entire
640-form census was checked for this diagnostic: **none** has it. No encoding
or relocation implementation was changed for this ruling.

Flag-condition branches otherwise retain the existing relaxation policy;
extending moves and conditional moves do not introduce byte forms the SDM lacks.

## Hand-off

Merge requires the exact-head green gauntlet and named plant red record supplied
with the PR, followed by the local audit. Do not move a consumer pin on a partial
record. After the qualified PR merges, fenrir's clef pin can move through its pin
tool. No label, merge, tag or issue closure is part of this change.
