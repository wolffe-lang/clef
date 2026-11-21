#!/usr/bin/env python3
"""Census of fenrir's planned scalar-double instruction forms (its float tranche), with the two
MOVQ forms between XMM and 64-bit general registers that tranche is anticipated to need.

Each form is one AT&T instruction placed after `.text` and before a local `.Ltarget:` label, the
shape of the integer census in census/fenrir-forms/. `anticipated` marks the forms that are not on
fenrir's stated list. References are the Intel 64 and IA-32 Architectures Software Developer's
Manual, volume 2, order 325383-086US: the named instruction entries and their opcode tables.

    python3 x86_float_forms.py --write DIR   writes form-NNNN.s, fenrir-float-forms.s, forms.json
"""
import argparse
import hashlib
import json
from pathlib import Path


def forms():
    rows = []

    def add(group, sample, sdm, anticipated=False):
        rows.append({'id': f'form-{len(rows):04d}', 'group': group, 'sample': sample, 'sdm': sdm,
                     'anticipated': anticipated})
    for ops in ['%xmm1, %xmm0', '-16(%rbp), %xmm0', '%xmm0, -16(%rbp)', '.Ltarget(%rip), %xmm0',
                '%xmm0, .Ltarget(%rip)']:
        add('scalar-move', f'movsd {ops}', '2B MOVSD: F2 0F 10 /r, F2 0F 11 /r')
    for op, sdm, group in [('addsd', '2A ADDSD: F2 0F 58 /r', 'scalar-arithmetic'),
                           ('subsd', '2B SUBSD: F2 0F 5C /r', 'scalar-arithmetic'),
                           ('mulsd', '2B MULSD: F2 0F 59 /r', 'scalar-arithmetic'),
                           ('divsd', '2A DIVSD: F2 0F 5E /r', 'scalar-arithmetic'),
                           ('sqrtsd', '2B SQRTSD: F2 0F 51 /r', 'scalar-arithmetic'),
                           ('ucomisd', '2B UCOMISD: 66 0F 2E /r', 'scalar-compare')]:
        for src in ['%xmm1', '-16(%rbp)', '.Ltarget(%rip)']:
            add(group, f'{op} {src}, %xmm0', sdm)
    for src in ['%xmm1', '-16(%rbp)', '.Ltarget(%rip)']:
        add('sign-mask', f'xorpd {src}, %xmm0', '2D XORPD: 66 0F 57 /r')
    for sample in ['cvtsi2sd %rax, %xmm0', 'cvtsi2sd %eax, %xmm0', 'cvtsi2sdq %rax, %xmm0',
                   'cvtsi2sdl %eax, %xmm0', 'cvtsi2sdq -16(%rbp), %xmm0', 'cvtsi2sdl -16(%rbp), %xmm0']:
        add('int-to-double', sample, '2A CVTSI2SD: F2 0F 2A /r, F2 REX.W 0F 2A /r')
    for ops in ['%xmm0, %rax', '%xmm0, %eax', '-16(%rbp), %rax', '-16(%rbp), %eax', '.Ltarget(%rip), %rax']:
        add('double-to-int', f'cvttsd2si {ops}', '2A CVTTSD2SI: F2 0F 2C /r, F2 REX.W 0F 2C /r')
    for sample, sdm in [('addsd %xmm15, %xmm8', '2A ADDSD: F2 0F 58 /r; 2A 2.2.1 REX'),
                        ('movsd -16(%r13), %xmm9', '2B MOVSD: F2 0F 10 /r; 2A 2.2.1 REX'),
                        ('movsd %xmm10, (%r12)', '2B MOVSD: F2 0F 11 /r; 2A 2.2.1 REX'),
                        ('ucomisd %xmm8, %xmm15', '2B UCOMISD: 66 0F 2E /r; 2A 2.2.1 REX'),
                        ('cvtsi2sd %r9, %xmm12', '2A CVTSI2SD: F2 REX.W 0F 2A /r'),
                        ('cvttsd2si %xmm14, %r10', '2A CVTTSD2SI: F2 REX.W 0F 2C /r'),
                        ('xorpd %xmm11, %xmm11', '2D XORPD: 66 0F 57 /r; 2A 2.2.1 REX'),
                        ('sqrtsd %xmm13, %xmm2', '2B SQRTSD: F2 0F 51 /r; 2A 2.2.1 REX')]:
        add('extended-registers', sample, sdm)
    for sample, sdm in [('movq %xmm0, %rax', '2B MOVD/MOVQ: 66 REX.W 0F 7E /r'),
                        ('movq %rax, %xmm0', '2B MOVD/MOVQ: 66 REX.W 0F 6E /r'),
                        ('movq %xmm15, %r8', '2B MOVD/MOVQ: 66 REX.W 0F 7E /r'),
                        ('movq %r15, %xmm8', '2B MOVD/MOVQ: 66 REX.W 0F 6E /r')]:
        add('anticipated-bits', sample, sdm, anticipated=True)
    return rows


def source(form):
    return '.text\n' + form['sample'] + '\n.Ltarget:\n'


def combined(rows):
    lines = ['.text']
    for form in rows:
        label = '.Ltarget_' + form['id'].replace('-', '_')
        lines += ['# ' + form['id'] + ' ' + form['group'], form['sample'].replace('.Ltarget', label), label + ':']
    return '\n'.join(lines) + '\n'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--write', type=Path, required=True)
    out = ap.parse_args().write
    rows = forms()
    for form in rows:
        (out / (form['id'] + '.s')).write_text(source(form))
    (out / 'fenrir-float-forms.s').write_text(combined(rows))
    digest = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    (out / 'forms.json').write_text(json.dumps({'generator_sha256': digest, 'forms': rows}, indent=1) + '\n')
    print(f'{len(rows)} forms, {sum(f["anticipated"] for f in rows)} anticipated')


if __name__ == '__main__':
    main()
