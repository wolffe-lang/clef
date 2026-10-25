# Reviewable source expansion

```sh
clef --expand input.S
```

The command writes fully macro-expanded source to stdout. Each statement has a
preceding `# clef FILE:LINE CHAIN` comment, so the output remains assembly text.
The primary origin is the original physical statement or macro-definition line;
the chain records `.irp` iterations and macro invocation sites in order.

Expansion supports positional `.macro` parameters, explicit comma-separated
`.irp` lists, parameter substitution within labels/immediates/directives/register
families, and `\()` token boundaries. List order is preserved. Definitions and
terminators disappear; no conditional-preprocessor or C-preprocessor language
is implied.

The command runs layout too. Each `.set` is printed with its resolved absolute
value, section-plus-offset or external-symbol addend. The definition remains in
the output so symbol visibility and symbol-table entries are not discarded.
Forward references, redefinitions and definition-site `.` values use the same
engine as object assembly. Numeric local labels remain readable in the output;
the assembler's internal unique names do not leak into it.

All 43 census files have been expanded, assembled again by pinned GNU as and
compared with their original gas objects. The PAX ISR file expands to **485
statements**, or **970 lines** including origin comments. This is a corpus
property, not a promise that resolving an early forward `.set` can never change
another assembler's later instruction-selection policy on arbitrary input.

## Errors and bounds

Unknown directives, mnemonics and operand forms are refused by name. Defaults,
keyword/variadic macro arguments and unsupported expansion modes are not
silently accepted. Limits are 32 expansion levels and 100,000 emitted statements;
cyclic `.set` definitions and nonconvergent layout are errors.

`--expand` does not create an object and cannot be combined with `-o` or
`--provenance`. Source/expansion/layout errors exit 1; invalid option combinations
exit 2. The provenance note is a separate object-output feature documented in
[FORMATS](FORMATS.md).

The source vocabulary is the measured GNU-as AT&T x86-64 dialect. General
assembler compatibility, Intel syntax, `.include`, C preprocessing and a lossless
disassembler are outside this command's current boundary.
