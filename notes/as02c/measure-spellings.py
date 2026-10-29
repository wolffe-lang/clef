#!/usr/bin/env python3
"""as02c: what the pinned GNU as accepts for the word ports, black-box.

Each spelling is assembled alone (`.codeN` then the statement) by `as --64`
inside clef's oracle container; the status, the first diagnostic line and the
.text bytes are recorded. No assembler source is read. Run from the clef root:
    tools/in-container python3 notes/as02c/measure-spellings.py
"""
import json
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from elf import ELF  # noqa: E402

GROUPS = {
    'inw': [
        'inw %dx,%ax', 'inw (%dx),%ax', 'inw %dx', 'inw (%dx)',
        'inw $0x60,%ax', 'inw $0x60', 'inw $0,%ax', 'inw $255,%ax',
        'inw %ax', 'inw', 'inw $256,%ax', 'inw $-1,%ax', 'inw 0x60,%ax',
        'inw %dx,%eax', 'inw %dx,%bx', 'inw %dx,%al', 'inw %cx,%ax',
        'inw %edx,%ax', 'inw %ax,%dx', 'inw (%edx),%ax', 'inw (%rdx),%ax',
        'inw %dx,%ax,%ax',
    ],
    'outw': [
        'outw %ax,%dx', 'outw %ax,(%dx)', 'outw %dx', 'outw (%dx)',
        'outw %ax,$0x60', 'outw $0x60', 'outw %ax,$0', 'outw %ax,$255',
        'outw %ax', 'outw', 'outw %ax,$256', 'outw %ax,$-1', 'outw %ax,0x60',
        'outw %eax,%dx', 'outw %bx,%dx', 'outw %al,%dx', 'outw %ax,%cx',
        'outw %ax,%edx', 'outw %dx,%ax', 'outw %ax,(%edx)', 'outw $0x60,%ax',
    ],
    'bare in/out': [
        'in %dx,%ax', 'in (%dx),%ax', 'in $0x60,%ax', 'in %dx', 'in $0x60',
        'out %ax,%dx', 'out %ax,(%dx)', 'out %ax,$0x60', 'out %dx',
        'out $0x60',
        'in %dx,%al', 'in %dx,%eax', 'out %al,%dx', 'out %eax,%dx',
    ],
    'port register widths and spacing': [
        'inw %rdx,%ax', 'inw %edx', 'outw %edx', 'outw %ax,%rdx',
        'inb %edx,%al', 'inl %edx,%eax', 'outb %al,%edx', 'outl %eax,%edx',
        'inw %dl,%ax', 'inw ( %dx ),%ax', 'inw (%dx ),%ax',
        'outw %ax, ( %dx )', 'inw *%dx,%ax', 'inw 0(%dx),%ax',
    ],
    'bare in/out, more': [
        'in %dx,%bl', 'in (%dx)', 'out (%dx)', 'in %al', 'in $0x60,%al',
        'in $0x60,%eax', 'out %al,$0x60', 'out %eax,$0x60', 'in %edx,%ax',
        'out %ax,%edx', 'in %dx,%rax', 'out %rax,%dx',
    ],
    'b/l neighbours (implicit forms, for the record)': [
        'inb %dx', 'inb (%dx),%al', 'inb $0x60', 'inl %dx', 'inl (%dx),%eax',
        'inl $0x60', 'outb %dx', 'outb %al,(%dx)', 'outb $0x60', 'outl %dx',
        'outl %eax,(%dx)', 'outl $0x60',
    ],
    'xorq': [
        'xorq %rax,%rax', 'xorq %rcx,%rdx', 'xorq %r8,%r15', 'xorq %r12,%r13',
        'xorq %rcx,(%rax)', 'xorq (%rax),%rcx', 'xorq %rax,8(%rsp)',
        'xorq 8(%rsp),%rax', 'xorq %r9,-16(%rbp,%rcx,8)',
        'xorq -16(%rbp,%rcx,8),%r9', 'xorq %rax,(%r12)', 'xorq (%r13),%rax',
        'xorq $1,%rcx', 'xorq $-1,%rax', 'xorq $127,%rax', 'xorq $-128,%rax',
        'xorq $128,%rax', 'xorq $128,%rcx', 'xorq $256,%rax', 'xorq $256,%rcx',
        'xorq $0x7fffffff,%rdx', 'xorq $-0x80000000,%rdx',
        'xorq $0xffffffffffffffff,%rax', 'xorq $0x80000000,%rax',
        'xorq $0x100000000,%rcx', 'xorq $1,(%rax)', 'xorq $256,(%rax)',
        'xorq $1,8(%rsp)', 'xorq $256,%r11', 'lock xorq %rax,(%rcx)',
        'lock xorq $1,(%rcx)', 'lock xorq %rax,%rcx', 'xorq %eax,%rax',
        'xorq %rax,%eax', 'xorq %ax,%ax', 'xorq %rax', 'xorq',
        'xorq (%rax),(%rcx)', 'xorq %ah,%rax',
    ],
}


def measure(text, mode, work):
    src = work / 'probe.S'
    obj = work / 'probe.o'
    src.write_text(f'.code{mode}\n{text}\n')
    if obj.exists():
        obj.unlink()
    p = subprocess.run(['as', '--64', str(src), '-o', str(obj)],
                       capture_output=True, text=True)
    row = {'source': text, 'mode': mode, 'gas_status': p.returncode,
           'diagnostic': '', 'bytes': None, 'warning': ''}
    lines = [l.split(': ', 2)[-1] for l in p.stderr.splitlines() if l.strip()]
    if p.returncode == 0:
        row['bytes'] = next(s[-1] for s in ELF(obj).normalized()['sections']
                            if s[0] == '.text')
        row['warning'] = '; '.join(l for l in lines if 'Assembler messages' not in l)
    else:
        row['diagnostic'] = '; '.join(l for l in lines if 'Assembler messages' not in l)
    return row


def main():
    work = ROOT / 'target/as02c-spellings'
    work.mkdir(parents=True, exist_ok=True)
    version = subprocess.run(['as', '--version'], capture_output=True, text=True).stdout.splitlines()[0]
    out = {'oracle': version, 'groups': {}}
    for group, spellings in GROUPS.items():
        rows = []
        for text in spellings:
            for mode in (64, 32):
                rows.append(measure(text, mode, work))
        out['groups'][group] = rows
        print(f'## {group}')
        for r in rows:
            verdict = ('ok  ' + r['bytes']) if r['gas_status'] == 0 else 'REFUSED'
            extra = r['warning'] or r['diagnostic']
            print(f"  .code{r['mode']}  {r['source']:<34} {verdict:<28} {extra}")
    print(out['oracle'])
    dest = ROOT / 'notes/as02c/spellings.json'
    dest.write_text(json.dumps(out, indent=1) + '\n')


main()
