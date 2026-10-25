# Objdump round-trip baseline

This measures the text produced by the pinned GNU objdump, not a clef
disassembler. No disassembler is implemented yet.

## Corpus

The read-only `pax-dev.iso` copy has SHA256
`02f979bedf5520661f8a5e5623f1f9a7f5cb18b2b1d8c936b3d51f8c0336d4d9`.
Its initramfs supplies `/usr/bin` and `/bin` programs, including boreutils,
pelt, wolf and other wolf tools. The kernel, two newly built wolf corpus
programs, and the clef proof binary complete the set. Every file's digest and
path appears in `census/roundtrip.json`. Shell wrappers, the runtime archive
and a symlink alias are named exclusions, not silently counted as binaries.

| Set | Binaries | Decoded instruction lines | Lines with an error | Lines with no located diagnostic |
|---|---:|---:|---:|---:|
| Org programs and corpus outputs | 77 | 22,861,456 | 210,362 | 22,651,022 (99.0795%) |
| External toolchain tail: cc and lld | 2 | 9,863,901 | 1,962,502 | 7,901,399 (80.1042%) |
| Total | 79 | 32,725,357 | 2,172,864 | 30,552,421 (93.3601%) |

**Zero of the 79 binaries has every batch assemble. Zero successful whole-body
byte round trips were obtained.** The no-diagnostic percentage is not a
reassembly success rate: undeclared symbols and numeric references can fail
later, and warnings can change the meaning. There are another 13,237 assembler
errors without source-line numbers, of which 1,347 belong to the org-program
set. There are 399,643 lines with warnings; warning and error sets overlap.

## Method and limits

`tools/roundtrip` runs `objdump -d --no-show-raw-insn --wide`. It removes only
headings and address columns; the instruction text, symbol annotations,
immediates, prefixes and comments remain unchanged. It puts `.text` before
the extracted body, and runs GNU as `--64` in **100,000-line batches**, every
batch, without sampling. Errors and warnings are counted by distinct source
line within each batch. Errors reported only at end of assembly are counted
separately, not assigned a fabricated line number.

A full-body assembly and comparison are attempted only if all batches parse.
That condition is false for every corpus binary; the whole-body fields are
`null` where the test was not attempted, not a false claim of measured byte
inequality. The synthetic integration tests exercise the successful path,
including a 100,001-instruction object spanning two batches. A successful
whole-body comparison requires all executable-section bytes in order to match
and no unresolved relocations in the reconstructed object.

The initial single-body lld attempt timed out after 180 seconds. The next
instrument version refused its previously unhandled end-of-assembly diagnostics.
Both failed attempts are retained in the result. Batching completed the entire
corpus within the bounded job; no timeout was called a skip or a success.

`objdump -d` decodes executable sections, including padding and any embedded
data it mistakes for instructions. Conversely, code intentionally stored in a
non-executable section (such as PAX's `.rodata.pax_user`) is outside `-d`'s
coverage. The 32.7 million figure counts decoded lines, not executed or
semantically verified instructions. The later round-trip law must cover all
intended code regions and explicitly represent undecodable/data bytes.

## Spellings a byte-preserving disassembler must avoid

| Observed problem | Required output policy |
|---|---|
| `address <symbol+offset>` | Emit valid assembler labels or numeric expressions; never angle-bracket annotations as operands. |
| Bare hex-looking branch targets | Add an unambiguous numeric radix or resolve generated labels; `32f` is a gas local-label reference, not necessarily hex 0x32f. |
| Duplicate prefix spellings such as repeated operand-size prefixes | Preserve original bytes with an explicit byte escape when canonical syntax would reject or discard them. |
| Prefixes that gas warns it is skipping | Do not call warning-only assembly byte-preserving. |
| `(bad)` | Use exact byte directives, not the diagnostic word as a mnemonic. |
| Width ambiguities and implicit defaults | Emit explicit sizes; test the resulting bytes rather than treating parse success as correctness. |
| Data in text and instruction padding | Preserve byte identity even when a canonical instruction spelling chooses a different encoding. |

The principal diagnostics are junk after expressions, accidental forward/backward
numeric-label references, invalid expression arithmetic involving undefined
symbols, duplicate prefixes, and operand-size mismatches. The JSON retains
counts and a concrete example per diagnostic class for every binary.
