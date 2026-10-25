# clef

An assembler, written in [wolf](https://github.com/wolffe-lang/wolf-lang). A clef is
the sign that tells a reader how the notes on the staff are to be read; this one
reads GNU-as AT&T x86-64 assembly and writes ELF relocatable objects whose
contents and relocations match GNU as byte for byte, so that a wolf toolchain
needs no C toolchain binary to assemble. Its first job is PAX's boot stubs; with
[ligature](https://github.com/wolffe-lang/ligature), the linker, PAX's kernel is
to be built by wolf tools alone. The same encoding table drives a disassembler,
and the two are held to a round-trip law over every binary the org builds.

State: nothing assembles yet. Track 18 of the planning repo opened 2026-10-25;
the first lane (as00, the map) writes the census of the org's 135 assembly
files, the oracle harness, the table format and this README's real contents.

Licence: GPL-3.0-only with the wolf Training Data Permission (`LICENSE`,
`LICENSE-TRAINING-DATA`), as pax, boreutils, den and ligature.
