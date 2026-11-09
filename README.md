# clef

An assembler written in [wolf](https://github.com/wolffe-lang/wolf-lang),
for GNU-as AT&T x86-64 source and ELF relocatable objects.

| Machine | Verified scope |
|---|---|
| Linux x86-64 | Native assembler, complete source corpus and pinned GNU as differential |
| Wolf checked machine and lupin | Parser, expressions, macros, encoder, layout and ELF logic tests |
| PAX under QEMU, BIOS and UEFI | Native/release kernels built with clef's assembly objects; muzzle CRT program |
| Other hosts and AArch64 | Not qualified by this implementation |

All **43 x86-64 sources** in the pinned PAX, muzzle and wolf-lang census match
GNU as in section contents, relocation tuples and structural symbols. This
covers **112 mnemonic spellings and 189 observed operand forms**, including
mixed `.code32`/`.code64` input, macros, numeric local labels and symbolic
expressions. Five more spellings (`in`, `inw`, `out`, `outw`, `xorq`) carry
PAX's 16-bit port access: PAX `boot/io.S` at pax `eb6592de` matches GNU as too.
The padded directives and SDM LOCK families also cover all **29 valid assembly
sources** at pax `3e28a8bc`; its deliberate invalid assembly fixture is checked
as a shared refusal, not an object. Unsupported syntax or encodings are refused rather than guessed.

The native and release PAX kernel images built through clef are byte-identical
to the GNU-as baseline and pass the four BIOS/UEFI test legs. The original
clang-assembled kernels are measured separately; clang and GNU as make different
encoding and relocation choices. Kernel links use pinned lld 18.1.3.

## Build and test

Development requires Linux x86-64, Python 3.11+, curl, and Docker or rootless
Podman. Compiler archives and oracle binary packages are SHA256-pinned. Nothing
is installed globally, and no external assembler implementation is built or read.

```sh
CLEF_ENGINE=docker tools/in-container tools/gate
# CLEF_ENGINE=podman is the default.
```

The **35 gates** check formatting, warning-denied builds, six compiled native
logic programs, checked/lupin execution, all source statements, expression and
macro differentials, the ELF writer, instruction-table rows, layout/refusals,
mutually dependent jump relaxation, the complete assembler corpus, padding/LOCK
differentials, word-port rows and fenrir's compiler instruction envelope. Results are written to
`target/evidence/`; the executable is `target/clef`.

```sh
printf 'movq $4096, %%rsp\nret\n' > example.S
CLEF_ENGINE=docker tools/in-container target/clef --64 example.S -o example.o
CLEF_ENGINE=docker tools/in-container target/clef --expand example.S
```

## Commands

```text
clef [--64] [-o OUTPUT] SOURCE.S
clef -c SOURCE.S -o OUTPUT [--target=x86_64-unknown-none-elf]
clef --expand SOURCE.S
clef --provenance SOURCE.S -o OUTPUT
clef --version
```

Inputs must end in `.S` or `.s`; uppercase does not invoke a C preprocessor.
The default output is `a.out`. C sources, foreign targets and unknown options
are refused, never passed through to another tool. Source errors exit 1 without
replacing the destination; usage errors exit 2. `--expand` writes annotated,
expanded source to stdout and cannot be combined with `-o` or `--provenance`.
The optional `.note.clef.src` provenance note is **off by default**.

See [EXPAND](docs/EXPAND.md) for the expansion contract and
[FORMATS](docs/FORMATS.md) for encoding, expression, ELF and note formats.

## Measurements and boundaries

* 886 generated row-by-mode byte comparisons cover all 517 SDM-provenanced
  encoding descriptors. Some descriptors describe alternatives or widths beyond
  the accepted census spellings; they are not a promise of full ISA support.
* Fenrir's pinned 640-form integer census covers flag-condition jumps, SETcc,
  CMOVcc, multiply/divide, extending moves, shifts, TEST and accumulator sign
  extension. Its differential also checks addressing, illegal operands,
  determinism and a linked integer executable. One extra symbolic 16-bit
  immediate is an explicitly checked GNU-as/clef deviation: clef retains its
  named narrow-relocation refusal. No census form needs that deviation.
  See `census/fenrir-forms/` and [FORMATS](docs/FORMATS.md).
* All 43 original and expanded sources match pinned GNU as. Every source is
  assembled twice to check determinism. No x86 census source is waived.
* 191 layout/boundary controls, ten named source refusals, five additional CLI
  refusals, and complete byte-range coverage for the ISR provenance witness.
* 1,330 relaxation rows for mutually dependent direct jumps match GNU as byte for
  byte: fenrir's nested-loop file from clef#21, chains, rings, nested loops at the
  127/128-byte boundary, alignment between jumps, cross-section and external
  jumps, and 500 random programs. Each generated case also checks the documented
  rule against GNU as's own short and long choices. The largest case, 202 jumps
  that grow one per pass, finishes in 204 passes, within its bound of 206. See
  [FORMATS](docs/FORMATS.md).
* 128 word-port encoding rows (IN/OUT word forms and GNU as's implicit port
  spellings in both modes, `xorq` in 64-bit mode) match GNU as byte for byte.
  111 refusals are named; 34 of them are spellings GNU as accepts that clef
  refuses on purpose: a 32/64-bit port register, or bare `in`/`out`
  without a sizing operand. See [FORMATS](docs/FORMATS.md).
* 943 padding, LOCK, canonical exchange, refusal and PAX controls compare
  raw sections, relocations, structural symbols and `objdump -dr`, and check
  determinism. The fixture roster contains 29 exact objects and one shared
  deliberate refusal, pinned to pax `3e28a8bc` by file hashes.
* `.skip`/`.space` and x86 ELF `.align`/`.balign`/`.p2align` support byte fills,
  omitted alignment operands and max-skip; `.global` aliases `.globl`.
  LOCK is accepted only on the SDM's writable-memory forms, with a named
  `invalid_lock_prefix` refusal on other supported forms.
* Symbol/string tables need structural equality, not identical serialization.
  [MAP](docs/MAP.md) records the measured raw-table distances.
* `clef --disassemble` reads x86-64 ELF objects and raw byte streams back
  from the same encoding rows, in the pinned objdump 2.42's AT&T spelling, with
  `--expand` for the encoding fields and their SDM provenance and `--roundtrip`
  for GNU as source that clef assembles back to the same bytes. Every table
  row's witness reads back (886 rows in both modes), and the round-trip law
  `assemble(disassemble(bytes)) == bytes` holds over every x86-64 binary the
  org builds; the legacy SSE, x87, VEX and EVEX classes are named `(bad)`
  refusals of their full length and round-trip as `.byte`, measured per class in
  [FORMATS](docs/FORMATS.md#the-decoder). The earlier retained instrument's
  result is in [ROUNDTRIP](docs/ROUNDTRIP.md).

The disassembler decodes the general-purpose and system instructions; the
vector classes are decoded by later changes. There is no Intel-syntax dialect,
C preprocessor, sealed-dialect policy, AArch64 encoder or compiler
inline-assembly protocol yet. The ELF writer
rejects unsupported section/relocation features such as COMDAT and TLS.

## Source layout

| Path | Purpose |
|---|---|
| `src/front/`, `src/clef.lu` | CLI and output-file boundary |
| `src/lex/`, `src/dialect/` | Source origins and typed AT&T syntax |
| `src/eval/`, `src/expand/` | Checked expressions and bounded macro expansion |
| `src/x86table/`, `src/machine/` | Provenanced data and generic encoder/fixups |
| `src/assembly/`, `src/object/` | Layout, symbol policy, provenance and ELF serialization |
| `src/parse/`, `src/expr/`, `src/table/`, `src/encode/`, `src/elf/` | Retained small proof and its independent regression witnesses |
| `census/` | Exact source snapshots, repository pins and oracle records |
| `tools/`, `tests/` | Differential, native, interpreter and refusal gates |
| `notes/as01/` | Measured evidence and lane-local kernel integration controls |
| `notes/as02c/` | The word-port spelling measurement and the PAX source sweep |

Unlabelled PRs run one cheap job. The `ci` or `full-matrix` label runs the full
set: every assembler gate and the independent exhaustive oracle-corpus job.
Trunk pushes run it only on cross-cutting paths; nightly and default dispatch
still run the full set. Kernel/QEMU evidence is retained separately
under `notes/as01/kernel/`; it is not silently claimed as a GitHub CI job.

## Licence

GPL-3.0-only with the wolf Training Data Permission; see `LICENSE` and
`LICENSE-TRAINING-DATA`. Census inputs retain their original licences under
`census/licenses/`. [SOURCES](docs/SOURCES.md) identifies specifications and pins.
