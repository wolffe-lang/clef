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
expressions. Unsupported syntax or encodings are refused rather than guessed.

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

The **33 gates** check formatting, warning-denied builds, six compiled native
logic programs, checked/lupin execution, all source statements, expression and
macro differentials, the ELF writer, instruction-table rows, layout/refusals,
and the complete assembler corpus. Results are written to `target/evidence/`;
the executable is `target/clef`.

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

* 530 generated row-by-mode byte comparisons cover all 312 SDM-provenanced
  encoding descriptors. Some descriptors describe alternatives or widths beyond
  the accepted census spellings; they are not a promise of full ISA support.
* All 43 original and expanded sources match pinned GNU as. Every source is
  assembled twice to check determinism. No x86 census source is waived.
* 191 layout/boundary controls, ten named source refusals, five additional CLI
  refusals, and complete byte-range coverage for the ISR provenance witness.
* Symbol/string tables need structural equality, not identical serialization.
  [MAP](docs/MAP.md) records the measured raw-table distances.
* The retained objdump round-trip instrument measured 79 binaries and
  32,725,357 decoded lines. It is not a clef disassembler: none of those complete
  inputs reassembled unchanged. [ROUNDTRIP](docs/ROUNDTRIP.md) explains the result.

There is no disassembler, Intel-syntax dialect, C preprocessor, sealed-dialect
policy, AArch64 encoder or compiler inline-assembly protocol yet. The ELF writer
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

CI runs every assembler gate in `tier pr`. `tier full` adds the independent
exhaustive oracle-corpus job and runs on trunk, nightly, dispatches and explicitly
labelled full-matrix pull requests. Kernel/QEMU evidence is retained separately
under `notes/as01/kernel/`; it is not silently claimed as a GitHub CI job.

## Licence

GPL-3.0-only with the wolf Training Data Permission; see `LICENSE` and
`LICENSE-TRAINING-DATA`. Census inputs retain their original licences under
`census/licenses/`. [SOURCES](docs/SOURCES.md) identifies specifications and pins.
