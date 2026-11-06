# as02f — the layout's fixed point (clef#21)

Footprint: module

fenrir, the second wolf compiler, lowered a program with two nested `while`
loops to a 260-line AT&T file. clef at `900bdf0a` refused it with
`layout_nonconvergent` (`src/assembly/layout.lu:712`), although every form in
it is one clef accepts elsewhere. This change relaxes direct jumps as the pinned
GNU as 2.42 does. Every same-section `jmp` and `jcc` starts short, and a jump
only grows. The forward-target estimate was read from GNU as's output. The
issue's file and 1,329 generated cases now match GNU as byte for byte.

## Prediction

`8cce41d` recorded the prediction before any code (`notes/as02f/prediction.txt`).

- **Right: why trunk oscillates.** Trunk decided every jump afresh in each
  pass. Forward targets came from the previous pass, with no allowance for
  growth earlier in the same pass, and jumps could shrink. In the issue's file,
  line 129 `jmp .Lf1_b7` and line 131 `jmp .Lf1_b8` are adjacent forward jumps,
  each 126 bytes from its target. They alternated (long, short), (short, long)
  from pass 2 until the 64-pass cap. GNU as keeps both short (`eb 7e`,
  `eb 7e`). Every other jump in the file matched trunk's last passes.
- **Right: the rule.** It was read from black-box output on 1,184 generated
  cases and 22 hand probes. Eleven candidate rules were simulated on the same
  cases, and only one reproduced them all. The generated family then checks the
  stated rule against GNU as on 1,329 more cases. It held on every one, with no
  case where GNU as departs from a pure monotone rule.
- **Right: the rows.** Each was red on trunk as predicted (Evidence below): the
  issue's file and the bound row with `layout_nonconvergent`, the two-fixed-point
  pair with different bytes. All are green after the fix.
- **Right: the pass bound.** The 202-jump bound case finishes in 204 passes.
  The bound is the number of relaxable jumps plus four.
- **Missed: the plant's shape.** I expected that letting a grown jump shrink
  again would bring back non-convergence. On the family it does not. A long
  jump reads its own forward target with its long size included, and that
  margin settles the layout, but on a fixed point GNU as never reaches: 11 rows
  go red on bytes, and none on convergence. The plant therefore breaks the
  pass budget instead (R-as02f-4).
- **Unchanged, as predicted:** the 43 census sources, the 2,741 compiler
  controls (the 640 census forms and their combined source among them), the 943
  padding/LOCK/PAX controls, the word ports and the corpus.

### The rule, as GNU as's bytes show it

1. Every direct `jmp` or `jcc` whose target is in the same section starts short.
   A jump to another section or to an undefined symbol is long from the first
   layout.
2. Passes run in source order. A jump that has grown never shrinks.
3. A short jump grows when its rel8 displacement, measured from the end of the
   short form, falls outside -128..127. The target address it uses:
   - **Backward:** its address in the current pass.
   - **Forward:** its previous-pass address, plus the distance the jump has
     moved since then.
   - **Forward, across a padding alignment** in the same section: its
     previous-pass address, unmoved. A padding alignment is a `.p2align`,
     `.balign` or `.align` of 2 bytes or more, max-skip and fill forms included.
     The address stays unmoved even where the padding cannot absorb the move.
     `.p2align 0` and alignment in another section do not count.
4. A pass that grows nothing ends the layout.

How the candidate rules scored on the three random sets, 1,086 cases:

| candidate (all grow-only, from an all-short start) | matches |
|---|---:|
| the rule above | 1086 |
| the rule above, with growth summed since the last alignment for the move | 1083 |
| the rule above, with the move across an alignment floored to its multiple | 1073 |
| previous-pass forward targets with no move (trunk's estimate) | 1067 |
| the floored rule, with max-skip alignments passing the move whole | 1049 |
| exact relayout of the rest of the section for each forward target | 957 |
| the rule above, with growth summed over the whole pass for the move | 945 |
| grow only the first misfit, then lay out again | 943 |
| the jump's move added across alignment too | 853 |
| decide every jump from the previous pass alone | 785 |
| grow only the last misfit, then lay out again | 751 |

One more set of 98 cases separates two readings. GNU as matched, 98 of 98, the
reading where cross-section and external jumps are long from the start and
`.p2align 0` is not an alignment. The other readings matched 60, 32 and 4.

## What was done

- `8cce41d`: the prediction.
- `30468ce`: `census/relaxation/issue-21.s`, the issue's file. Its 57-byte
  `.rodata` path string is replaced by a neutral string of the same length
  (R-as02f-1). `.text` and every relocation are unchanged.
- `ea3e7b6`: `tools/relaxation.py`, the rule as a model, the renderer, a reader
  that walks GNU as's `.text` to recover its short and long choices, and the
  generated family. The family has pairs, forward and backward chains, rings,
  nested loops at the 127/128-byte boundary, alignment inserted at every
  position of four base cases (`.p2align` 2, 4 and 5, and `4,,7`), the
  separating witnesses, `.code32` copies and 500 seeded random programs.
- `4dd84e6`, `9bb2769`: `tools/relaxation-test`. Each row compares sections,
  relocations and structural symbols with live GNU as and assembles twice for
  determinism. Each generated row also checks the model's long set against GNU
  as's. The bound row reads `assembly-cli`'s pass count. Failures print
  `FAIL <row> <reason>`.
- `c42f0b3`: the gate runs `relaxation` (35 gates).
- `1109a2e`: `src/assembly_test.lu` rows for the checked machine and lupin: the
  adjacent pair stays `eb 7e eb 7e`, and the spanning pair keeps both short.
- `04b85d4`: the fix in `src/assembly/layout.lu`. It adds a discovery pass, an
  all-short start, and growth-only passes with the forward estimate above. The
  per-section count of padding alignments before each statement decides the
  "across an alignment" case. The pass cap is 64 plus the number of relaxable
  jumps (R-as02f-3). Alignment, max-skip, fill, expression and relocation code
  is untouched.
- `24bdb8e`, `2e11b1b`: the plant-run rows, the never-shrinks witness and the
  bound included.
- `49a8a43`: `docs/FORMATS.md` states the rule and the new pass limit.
- `d2ef2e5`: README counts.
- `40098b0`: `CHANGELOG.md`, new (R-as02f-2).

## Evidence

- **Red, at `9bb2769`** (rows in, fix absent), in the pinned oracle container:
  `relaxation` exit 1 with 149 of 1,330 rows red.
  - 89 failed with `layout_nonconvergent`. Among them: `issue-21`,
    `pair-123`..`pair-125`, 37 forward chains, rings,
    `grown-never-shrinks-*` and `bound-cascade-200`.
  - 60 differed in bytes, among them `two-fixed-points-*`,
    `first-misfit-is-not-enough-*` and 18 nested loops. In 53 of them trunk
    left a jump long that GNU as keeps short. In 7 it was the reverse.
  - `checked-assembly` and `lupin-assembly` also exited 1.
  ```text
  END fetch-toolchain exit=0
  END build exit=0
  END assembly-build exit=0
  END relaxation exit=1
  END checked-assembly exit=1
  END lupin-assembly exit=1
  ```
- **Green, at the fix:** `relaxation` 1,330/1,330, by group: issue 1/1, pair
  12/12, chain 210/210, ring 90/90, nested 288/288, align 208/208, separating
  20/20, random 500/500 and bound 1/1, `bound-cascade-200 took 204 passes,
  bound 206`. The model matched GNU as on all 1,329 generated cases.
  `assembler` 43/43 sources, `directives` 943/943, `compiler-forms` 2741/2741,
  `ports` 128/128, `corpus` 44 dispositions, and every other gate exit 0.
- The final-head record, every literal END line and the plant record are in
  the PR.

## Departures

### R-as02f-1: the issue's path string

**Recommendation, implemented: (A).** The issue's `.rodata` holds the source
path of a local build, a private path.
- (A) Replace its 57 bytes with a neutral string of the same length. `.text`,
  the `.rodata` size and every relocation addend stay as they were.
- (B) Commit the file verbatim.

### R-as02f-2: the changelog

**Recommendation, implemented: (A).** clef had no CHANGELOG.
- (A) Start `CHANGELOG.md` with an Unreleased section. The CI planner already
  classes that path as prose.
- (B) Record the change in README alone.

### R-as02f-3: the pass cap

**Recommendation, implemented: (A).**
- (A) 64 plus one pass per relaxable jump. Every growth pass but the last grows
  a jump, so jumps alone always finish. The cap still guards the
  expression-driven layouts that may never settle, and those keep their
  `layout_nonconvergent` refusal.
- (B) No cap.
- (C) Keep 64. A 200-jump cascade, a plausible compiler output, would still be
  refused.

### R-as02f-4: the plant

**Recommendation, implemented: (A).**
- (A) Restore trunk's fixed 64-pass cap. The bound row is refused with
  `layout_nonconvergent`, red by name at a convergence row.
- (B) Let grown jumps shrink. Measured on the family, this is 11 byte-red rows
  and no convergence failure (Prediction, Missed). It is evidence that the
  grow-only guard matters for bytes, but it is not a convergence plant.

### R-as02f-5: the rule as a checked model

**Recommendation, implemented: (A).**
- (A) Every generated row also fails when the documented rule disagrees with
  GNU as's own choice. The written rule cannot drift from the bytes.
- (B) Bytes only.

## Hand-off

The merge needs the final-head green record, the plant red by name, and the
local audit. The issue closes by hand at the merge. After that, fenrir's clef
pin can move, and its fixed-size `leaq`/`jmp *%rax` workaround for block jumps
can go. No label, merge, tag or issue closure is part of this change.
