# clef

An assembler written in [wolf](https://github.com/wolffe-lang/wolf-lang).
Its target is GNU-as AT&T x86-64 source and ELF relocatable objects whose
section contents and relocations match GNU as byte for byte. With
[ligature](https://github.com/wolffe-lang/ligature), it is intended to remove
the C toolchain from PAX's assembly and linking paths.

**Current state: a measured source map and a ten-form encoding proof, not a
general-purpose assembler.** The proof emits real ELF objects independently
of GNU as. It does not yet assemble PAX's boot stubs or muzzle. There is no
disassembler, macro expander, general expression engine or symbolic-relocation
writer yet. Unsupported input is refused rather than guessed.

## Build and test

The supported development environment is Linux x86-64 with Python 3.11+, curl,
and Docker or rootless Podman. All compiler/oracle downloads are SHA256-pinned;
no external assembler implementation is built or read.

```sh
CLEF_ENGINE=docker tools/in-container tools/gate
# For rootless Podman, use CLEF_ENGINE=podman (the default).
```

The gate fetches wolf 0.2.35 and lupin 0.1.56, checks formatting, builds with
warnings denied, runs native/checked/lupin tests, verifies the source census,
checks the object comparator's planted corruptions, compares the encoding
proof against GNU as, tests the round-trip instrument, and checks both
oracles over all 43 x86 source files. It writes evidence under `target/evidence/`
and produces `target/clef`. Nothing is installed globally.

A small accepted example, after the gate has built the binary:

```sh
printf 'movq $4096, %%rsp\nret\n' > example.S
CLEF_ENGINE=docker tools/in-container target/clef --64 -c example.S -o example.o
```

`clef --version` identifies the proof. The front end accepts `--64`, `-c`,
`-o FILE` and one source path. It supports `.text`, hash comments and the ten
selected forms described in [FORMATS](docs/FORMATS.md). An unsupported source
exits 1 without replacing the output; malformed arguments exit 2.

## What is measured

* **44 unique assembly files**, pinned to three repository commits; one is an
  AArch64 Mach-O fixture outside this first x86 implementation.
* **112 x86 mnemonic spellings and 189 source-level operand forms**. This is
  the next implementation's specification, not a claim of current support.
* **24 exact object comparisons** for ten worked forms and the empty ELF
  writer, with deterministic reruns and 14 source/argv refusals.
* **79 binary inputs** for the objdump round-trip baseline. All decoded lines
  were measured in bounded batches, without sampling. No input passed every
  batch unchanged. See [ROUNDTRIP](docs/ROUNDTRIP.md) for the error/warning
  counts and the distinction between parsing and byte identity.

The primary oracle is GNU as from pinned Ubuntu binutils 2.42. clang 18.1.3 is
a second opinion, not an interchangeable baseline. `tools/differ A.o B.o`
compares ordinary section contents and metadata, relocation tuples, and symbol
values/bindings/types/sizes/visibility; symbol/string-table order is free.
Every observed gas/clang disagreement is named in the [source map](docs/MAP.md).

## Repository

| Path | Purpose |
|---|---|
| `src/clef.lu`, `src/front/` | command-line entry and refusal-first arguments |
| `src/lex/`, `src/parse/`, `src/expr/` | restricted proof syntax; full dialect design in FORMATS |
| `src/table/`, `src/encode/` | SDM-provenanced rows and proof encoder |
| `src/elf/` | deterministic minimal ELF64 relocatable writer |
| `src/oracle/` | comparison posture; no oracle invocation in clef |
| `census/` | source snapshots, repository revisions, syntax and binary measurements |
| `tools/oracle`, `tools/corpus`, `tools/differ` | black-box measurements and semantic comparison |
| `tools/roundtrip` | objdump-text reassembly instrument, not a disassembler |
| `tests/`, `src/proof_test.lu` | binary corpus sources and Wolf unit tests |
| `docs/` | [SOURCES](docs/SOURCES.md), [MAP](docs/MAP.md), [FORMATS](docs/FORMATS.md), [ROUNDTRIP](docs/ROUNDTRIP.md) |

CI uses `tier pr` for code pull requests and `tier full` for trunk, nightly,
dispatches and pull requests carrying `full-matrix`. The full tier adds an
independent exhaustive oracle-corpus run. The planner tests its own selection
and rejects a missing or skipped required gate. Red nightly runs open an issue.

## Licence

GPL-3.0-only with the wolf Training Data Permission; see `LICENSE` and
`LICENSE-TRAINING-DATA`. Copied census inputs retain their original licences
under `census/licenses/`.
