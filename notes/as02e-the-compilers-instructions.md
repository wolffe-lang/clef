# Compiler integer instruction envelope

Footprint: module

## Prediction

`bea1305` records the prediction before implementation. Linux clef at
`0ef3d84a` should reproduce the Mac's 238 accepted / 402 refused forms without
a per-form difference. The missing families should use the existing ModRM,
SIB, REX, immediate and branch-relaxation machinery, with separate IMUL arities
and separate source/destination widths for extending moves. Every census form
is expected to be accepted by GNU as. The original corpus must not regress.

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
- `0eb5c8b`, `21e7930`: descriptor witnesses, machine-logic assertions and
  the declarative census index: 517 descriptors, 354 spellings, 886 descriptor
  by mode witnesses. The original source census is retained unchanged.
- `62a762c`: linked integer-code execution, without a C runtime.
- `f4e2802`, `6b51c39`: encoding documentation and README counts.
- `c83deb8`: CMOV architecture-feature metadata, independently of host CPUID.

### Specification provenance

Intel SDM 325383-086US (December 2024), combined volume 2, official PDF SHA256
`55b64951731ef661f8a7922b665e649715e3b3a7db06e4ff15158b875ccd1dce`.
Each descriptor carries volume, section, printed page and opcode row. GNU as
manual 9.16.4.1 supplies AT&T naming; 9.16.3.1 supplies operand order. No
assembler/disassembler implementation source or opcode database was read.

| Family | SDM entry and opcode table | Linux baseline refused | Green differential |
|---|---|---:|---|
| Jcc | 2A 3.3, 3-558..3-561; 70+cc / 0F 80+cc | 19 | Pending |
| SETcc | 2B 4.3, 4-619..4-621; 0F 90+cc | 87 | Pending |
| CMOVcc | 2A 3.3, 3-175..3-177; 0F 40+cc /r | 180 | Pending |
| MUL, one-operand IMUL, DIV, IDIV | 2B 4.3 MUL 4-148; 2A 3.3 IMUL 3-511, DIV 3-331, IDIV 3-508; F6/F7 /4..7 | 28 | Pending |
| Two/three-operand IMUL | 2A 3.3, 3-511..3-512; 0F AF, 6B, 69 | 14 | Pending |
| Extending moves | 2B 4.3 MOVSX/MOVSXD 4-128, MOVZX 4-138; 0F BE/BF/B6/B7, 63 | 16 | Pending |
| Shifts | 2B 4.3 SAL/SAR/SHL/SHR, 4-600..4-601; D0/D1, D2/D3, C0/C1, /4,/5,/7 | 48 | Pending |
| TEST word | 2B 4.3 TEST 4-713; 85, A9, F7 /0 | 4 | Pending |
| Accumulator sign extension | 2A 3.3 CBW/CWDE/CDQE 3-156 and CWD/CDQ/CQO 3-324; 98, 99 | 6 | Pending |

## Evidence

- [x] Linux baseline at `0ef3d84a`: 238 accepted / 402 refused. Every form's
  status, normalized diagnostic and object-presence result matches the Mac
  probe. No differences. `notes/as02e/linux-baseline.json` retains every form's
  disposition and the Linux executable SHA256
  `8a8232dbce25882cc81cfe5b7d4fcafdc73c3eb0da7a1f9e88581d88db1c8958`.
- [x] Mac acceptance only at `21e7930`: pinned wolf 0.2.36 builds with warnings
  denied, the expanded machine-logic program exits 0, and 640/640 probes are
  accepted. This is not Linux or GNU-as qualification. Executable SHA256
  `9ec8428f0fbdc6a4d1a89b48578b177053eff296c0b35654c22f3754fbd496ab`.
- [x] Generator SHA256:
  `d43b34de409cd074e0b321e396a1b80d61236dba0e1f3ab4d217c03e31cd4376`.
- [ ] Linux per-family GNU-as red record and green differential.
- [ ] All 640 forms, combined source and additional boundary/refusal controls.
- [ ] Every existing gate; the original 43 sources, muzzle and PAX's 29 valid
  sources; repeated output for determinism.
- [ ] Final-head gauntlet record and every END line.
- [ ] One local condition-nibble plant, red by name.
- [ ] Open PR and one local audit.

## Departures

No Linux differential claim is made from the Mac probes. The Linux baseline
completed before implementation qualification; its refusals are retained by
form ID, not counted as skips. Qualification and final-head evidence are still
pending. Flag-condition branches use the existing relaxation policy; extending
moves and conditional moves do not introduce byte forms the SDM lacks.

## Hand-off

Work in progress until the unchecked rows above are completed. Do not move a
consumer pin on this evidence alone. After the qualified PR merges, fenrir's
clef pin can move through its pin tool. No label, merge, tag or issue closure is
part of this change.
