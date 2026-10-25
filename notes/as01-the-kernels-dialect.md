# as01 — the kernels dialect (clef#8, merged at `996a3ccd`)

This note is the PR body of clef#8, materialised at the merge by the orchestrator (the lane's wrapper could not write Markdown). The lane's evidence files are under `notes/as01/` where it kept them.

Footprint: cross-cutting

Closes #3.

## Prediction

`e34dbe2` recorded the prediction before implementation. The first complete census run passed; the first table differences were redundant REX.W on segment-register aliases, not forward CMP. Alignment padding did expose a gas policy difference. No final STOP rows. The first successful clef relink was byte-identical, contrary to the predicted mismatch.

Measured: 132/189 forms need prefix/REX/address/mode handling under the explicit criterion in `notes/as01/measurements.json` (predicted 65); encoding rows 318 lines, complete table module 1,501, lexer/parser 514 (predicted about 450/700); ISR expansion 485 statements and 970 origin-annotated lines (predicted about 1,200 statements).

## What was done

- `ef30b27`: source lexer, origins, labels, directives and typed AT&T operands.
- `ba07c53`: checked expression algebra, forward definitions and ordered bounded macro/irp expansion.
- `c16dc4a`: independent complete ELF64 section/symbol/RELA writer.
- `2d1bb5b`: 312 SDM-provenanced descriptors, 112 aliases, generic ModRM/SIB/REX encoder and generated differential.
- `9917b7e`: versioned .set resolution, convergent layout, exact-gas policy, full CLI, --expand and opt-in provenance.
- `29d6091`, `da8afad`, `7048d27`: pinned kernel-linker controls, lane-local compiler shims, identical kernels and muzzle CRT boot proof.
- `17b018f`: require the new regression gates in PR CI.
- `62dc2a0`: named refusals for malformed non-ASCII expression/character/macro inputs.
- `11adf90`, `6d2e4a3`: refreshed README, formats/map/expansion docs and the as02 draft.
- `996a3cc`: retained final strict gate evidence.

### Verified inputs

The source roster and revisions are fixed by `census/repositories.json`; wolf 0.2.35 and lupin 0.1.56 archives were verified twice and kept with their bundled inputs. `ci/oracle-lock.json`, `ci/integration-lock.json`, and `notes/as01/table/source-index.json` identify the binary packages and SDM editions.

### Forbidden inputs

No assembler/disassembler implementation or opcode database was read. Encoding rows come from the pinned Intel SDM, with manual/gABI/psABI semantics and black-box oracles. PAX, muzzle and wolf-lang source pins are unchanged. No Mac build/test, host package installation or cross-repository source edit was performed.

## Evidence

### Evidence index

`notes/as01/final/` holds the final 33-gate record; `complete-census/`, `table-differential/`, `layout/`, `object/` and `item2-core/` hold the individual measurements. `kernel/` contains the full boot log, hash, shim commands and object identities; `refusal-fix/` contains the old/new controls.

- [x] 33/33 strict gates at `6d2e4a3`; the final commit adds only the saved evidence. `notes/as01/final/gate.log` and `gates.json`.
- [x] Six separately compiled native logic programs; checked-machine and lupin logic tests, zero unsupported rows.
- [x] 530/530 generated row×mode byte comparisons, all 312 descriptors witnessed.
- [x] 43/43 census sources exact in section contents and relocation tuples, structurally equal symbols, deterministic reruns and CLI/library identity. Measured coverage 189/189 forms; no x86 STOP rows. AArch64 deferred by name.
- [x] 43/43 --expand outputs reassemble with exact gas semantics; ISR 485 statements / 970 lines.
- [x] 191 layout/boundary controls, ten source-refusal controls, five additional argv refusals; 47 malformed-writer controls.
- [x] --provenance absent by default; ISR note covers each emitted byte once in 271 ranges.
- [x] 34 real assembly substitutions, 17 objects per native/release tier; unchanged compiler objects/archives. Complete kernel ELF hashes equal the gas baseline: native `54656851650d2da54f31b5304907ab1943998039ccc019a1c08bd4b943145962`, release `efb815659784e0759dbc1e114d4bfdf863dd72a02add4adff00900ad5909836a`.
- [x] All four mpx5-wolf BIOS/UEFI × native/release legs: eight exact root/pax transcripts, W2 pass, W3 clean halt. Fresh clef-assembled muzzle crt0/sys witness prints its expected output and exits 7 on all four legs. Kernel log SHA256 `146eba5d520d58033b33accd3e162832adb55e6c2308f2b75a0724ef6709f0f7`.
- [x] GitHub PR tier at final head: run `40173207051`, completed success; `tier pr: 2 of 3 job(s) chosen`, read by the required audit.
- [ ] Full-matrix label and full-tier verification by the orchestrator, not this lane.

Raw table distances: .symtab 35/43 byte-identical, 707 unequal positions; .strtab 39/43, 1,159; .shstrtab 0/43, 2,576. Structural equality is the ruled boundary.

### Plants

All three draft plants were inspected and closed unmerged by the orchestrator; `notes/as01/plants.json` records the heads and named rows.

- #5, run [40170658668](https://github.com/wolffe-lang/clef/actions/runs/40170658668): HLT row 274 red in modes 32/64; table, assembler and proof gates fail.
- #6, run [40170680340](https://github.com/wolffe-lang/clef/actions/runs/40170680340): layout red; wrong relocation addends in crt0.S/isr.S/sched.S, including the missing -4 tuples.
- #7, run [40170704106](https://github.com/wolffe-lang/clef/actions/runs/40170704106): expansion unit/native/checked and --expand gates red; assembler row names pax/boot/isr.S and its reversed .rodata relocation order.

### Malformed-Unicode refusal guards

A final input review found two bounds paths: expression token slicing and macro-boundary lookahead. The old executable exited 134 on the malformed controls; the guarded executable exits 1 by name without replacing output. The post-edit gate is 33/33. All 43 accepted object files are byte-identical before/after: both canonical file/hash/size manifest SHA256s are `1f1ad4ad251bd11e63430eeb15197edbf01b549dc15c651b0d5ce618a83cafac`. Exact revisions, every object hash and four controls are in `notes/as01/refusal-fix/census-identity.json`.

## Departures

The original stock-clang kernel is not the byte baseline: the census already records clang/gas encoding and relocation differences. It remains separately measured (first file difference 96 in both tiers), while clef is held to the gas baseline. R-as01-6 was concurred.

Changing only the kernel linker showed ISO lld17.0.6 red and pinned distro lld18.1.3 green; lld17 --no-relax was a diagnostic control only. Both real baselines use lld18 without new flags, matching PAX CI (R-as01-7; pax#172, ligature#4, wolf-lang#938). No PAX patch. Volume-3 system semantics were separately read/pinned at edition093; encoding bytes remain at Volume-2 edition086.

Pinned gas's measured comparison precedence and unary ! are explicit controls where the manual is incomplete (R-as01-5). R-as01-1..4 recommendations A are implemented as contracted. Existing toolchain gaps are preserved as probes and cited: wolf-interp#302 (imported error-set marks) and wolf-lang#939 (native copy of a lookup error row). Neither is a skipped clef test.

The executable is the measured census dialect, not a complete ISA/GNU-as replacement. There is no disassembler, Intel syntax, C preprocessor, AArch64 encoder or inline-assembly protocol. The muzzle fixture supplies test main/exit around the real pinned CRT/syscall bridge; it is not a whole-libc claim. Kernel/QEMU evidence is local container evidence, not a claimed GitHub job.

## Hand-off

`notes/as01/as02-contract.txt` splits the package path into wolf-lang's --assembler/WOLF_AS lane and a PAX image/seam lane. wolf-lang#937 and clef#4 remain follow-ons; clef#3 closes at merge. No further new issue is requested. README read and refreshed.

### Done-when

Implementation and local measurements are complete. The first immediate direct CI lookup was not yet indexed. The required audit observed run `40173207051`; its second pass, after adding the required report subheadings, saw completed-success PR CI. Audit exit 1, exact last line: `AUDIT FAIL (footprint: cross-cutting)`. Every other audit check passes; only the orchestrator-owned full-matrix label and green full tier remain missing. Audit log: `/Users/mfwolffe/lanes/as01/audit.log`. No CI wait or label operation was performed. Do not merge without the required green PR/full tiers. The lane reads CI once, does not wait, and never labels.

Prune after review: lane-local build/evidence caches, old integration controls and plant worktrees under the explicit as01 paths; retain the tracked source/evidence and pinned oracle/integration images until review completes. as00's inputs were copied and hash-compared, so its retained lane can be pruned. The hasu lane occupies 3.4 GB, below its 10 GB cap.

