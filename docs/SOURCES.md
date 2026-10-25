# Specifications and binary inputs

Clef is written from specifications and black-box measurements. No assembler,
disassembler, opcode database, or linker implementation supplied encoding data.
The copied assembly programs are the input language, not implementation references.
Their original licences are retained in `census/licenses/`.

## Instruction encodings

Intel **64 and IA-32 Architectures Software Developer's Manual**, combined Volume 2,
order **325383-086US, December 2024**:
[official PDF](https://cdrdv2-public.intel.com/843829/325383-sdm-vol-2abcd-dec-24.pdf).
SHA256: `55b64951731ef661f8a7922b665e649715e3b3a7db06e4ff15158b875ccd1dce`.

* Volume 2A §2.1: instruction fields and legacy prefixes; Tables 2-2 and 2-3:
  ModRM and SIB layouts. §2.2 and Table 2-4: 64-bit extensions and REX fields.
* Volume 2A §3.1.1: interpretation of opcode and operand-encoding columns.
* Volume 2A §3.3: CALL p.3-139, CMP p.3-179, HLT p.3-499,
  JMP p.3-563, LEA p.3-605, each instruction's opcode table.
* Volume 2B §4.3: MOV p.4-35, POP p.4-396, PUSH p.4-520,
  RET p.4-566, SYSCALL p.4-695, each instruction's opcode table.

`src/x86table/rows.lu` attaches the volume, section, page, and individual opcode
row to all 312 encoding descriptors; the earlier worked proof remains under
`src/table/`. Decimal opcode fields in the data are byte values, not a
second instruction database. The PDF itself is not vendored or modified.

## Objects and assembly dialect

* [ELF gABI](https://gabi.xinuos.com/elf/index.html): ELF header, section headers,
  string tables, symbol tables and relocation entries. The original chapter-4
  clauses correspond to the site's ELF Header, Sections, String Table,
  Symbol Table, and Relocation chapters.
* [x86-64 psABI](https://gitlab.com/x86-psABIs/x86-64-ABI): §4.1 ELF header,
  §4.2 sections and §4.4 relocations; Table 4.9 relocation types.
* [GNU as manual](https://sourceware.org/binutils/docs/as/): Syntax, Symbols,
  Expressions, Pseudo Ops, and i386-Dependent Features. The census requires
  the AT&T dialect, `.code32`/`.code64`, macros and `.irp`; see `FORMATS.md`.

## Pinned binaries

| Tool | Pin | Integrity record |
|---|---|---|
| Ubuntu | 24.04, manifest `a2d43bffc46670d7108bb3c0468c67c5557c4c92e83e1e34cbff1322ad1b94dc` | `ci/oracle-lock.json` |
| GNU as / objdump / readelf / nm / ar | Ubuntu binutils 2.42 | exact versions, binary package URLs and SHA256 in that lock |
| clang integrated assembler | Ubuntu clang 18.1.3 (1ubuntu1) | same lock |
| wolf | 0.2.35, Linux x86-64 archive | `wolf-toolchain.toml`, SHA256 `4cc4045bbbb605c07835bc4f32685953c784eeef4cd3139a48b457dfc90dad1a` |
| lupin | 0.1.56, Linux x86-64 archive | same file, SHA256 `ad703550ac4787e8e4bb26989d591a731410274d7332f2b4e8b9a64c878822cc` |

All 120 installed binary packages, including dependencies, are pinned. The container
is rebuilt with networking disabled after each package is checked against its hash.
A package disappearing from its recorded URL is a hard fetch failure, not permission
to upgrade. Both compiler archives are hashed twice before extraction. The wolf
archive's bundled standard library and runtime archives stay paired with its binary.

`tools/oracle FILE.S` records both command lines and statuses, `readelf -SrsW`,
`objdump -d -r --no-show-raw-insn`, and `objdump -s`. `--freestanding` adds clang's
`--target=x86_64-unknown-none-elf`. No C preprocessor feature is required by the
copied sources. The AArch64 Mach-O fixture is retained in the census but excluded
by name from both x86-64 oracle commands.

## System semantics supplement

Intel SDM Volume 3, **325384-093US, September 2026**, downloaded from
[the official Volume 3 endpoint](https://cdrdv2.intel.com/v1/dl/getContent/671447).
SHA256: `77919be320f35da2782771ef2cb65a868cf68e62c8f8279f2ca61199cb70d1f8`.
Read clauses: 3A §§2.3–2.6 (IF/IOPL, descriptor/control registers and XCR0),
§§2.8.1–2.8.11 (system instructions), §6.8.8 (SYSCALL/SYSRET), and
§§7.14.2–7.14.3 (64-bit interrupt frames and IRET). This supplies semantic
context, not replacement encoding data: opcode rows remain at Volume 2 edition
086. No newer instruction family is imported by this supplement.

## Kernel integration binaries

`ci/integration-lock.json` extends the unchanged oracle image with 46 additional
SHA256-pinned binary packages, including QEMU 8.2.2, firmware and Ubuntu lld
18.1.3. `tools/integration-image` checks each archive twice and builds offline.
The kernel linker executable SHA256 is
`7ad9a0e8fe6d0e79b71172d731e33872c0274e49fceb7b516d774876d5a58ade`.
The ISO's static lld 17.0.6 (`1217ca75f9df70439294844b2aba14895adc557e2514c6cdc76c4c6676a3757b`)
retains its user-toolchain role and is not substituted for the kernel linker.

Specification excerpts and downloaded manuals are kept outside the repository;
`notes/as01/table/source-index.json` records their identities and clauses.
