#!/usr/bin/env python3
"""Independent writer fixture, raw-header, refusal, and complete census replay gate.
Run only inside the pinned Linux oracle container, after building target/object-cli.
The generator receives structured values, never assembler implementation input.
"""
import json
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from elf import ELF

OUT = ROOT / 'target/object-tests'
OUT.mkdir(parents=True, exist_ok=True)
CLI = ROOT / 'target/object-cli'


def run(*args):
    return subprocess.run([str(x) for x in args], check=True, capture_output=True, text=True).stdout


def structure(obj):
    """Check fields deliberately normalized away by tools/differ."""
    h = obj.header
    assert h[0] == b'\x7fELF\x02\x01\x01' + b'\0' * 9
    assert (h[1], h[2], h[3], h[4], h[5], h[7], h[8], h[9], h[10], h[11]) == (1, 62, 1, 0, 0, 0, 64, 0, 0, 64)
    assert h[6] % 8 == 0
    assert h[6] + 64 * h[12] == len(obj.data)
    assert obj.sections[0] == ('', (0,) * 10)
    assert obj.sections[h[13]][0] == '.shstrtab'
    strings = obj.contents(obj.sections[h[13]][1])
    assert strings[0] == strings[-1] == 0
    file_ranges = [(0, 64), (h[6], len(obj.data))]
    for index, (name, section) in enumerate(obj.sections[1:], 1):
        _, kind, flags, addr, off, size, link, info, align, entsize = section
        assert addr == 0 and (align == 0 or align & (align - 1) == 0)
        assert align < 2 or off % align == 0
        if kind != 8 and size:
            file_ranges.append((off, off + size))
        if kind == 4:
            assert name == '.rela' + obj.sections[index - 1][0]
            assert info == index - 1 and obj.sections[link][0] == '.symtab'
            assert flags == 64 and align == 8 and entsize == 24
        elif kind == 2:
            assert obj.sections[link][0] == '.strtab'
            syms = obj.symbol_tables[index]
            assert syms[0] == ('', 0, 0, 'UND', 0, 0, 0)
            assert all(s[1] == 0 for s in syms[:info])
            assert all(s[1] != 0 for s in syms[info:])
            assert flags == 0 and align == 8 and entsize == 24
            for i, s in enumerate(syms):
                if s[2] == 3:
                    assert obj.unpack('<I', off + i * 24)[0] == 0
            strdata = obj.contents(obj.sections[link][1])
            assert strdata[0] == strdata[-1] == 0
        else:
            assert link == info == entsize == 0
    file_ranges.sort()
    assert all(a[1] <= b[0] for a, b in zip(file_ranges, file_ranges[1:]))


def compare_headers(obj, reference):
    # String-table compaction and physical placement are not semantic contracts.
    assert len(obj.sections) == len(reference.sections)
    for (name, a), (refname, b) in zip(obj.sections, reference.sections):
        assert name == refname
        assert [a[i] for i in (1, 2, 3, 6, 7, 8, 9)] == [b[i] for i in (1, 2, 3, 6, 7, 8, 9)], name
        if a[1] != 3:
            assert a[5] == b[5], name


print(run(CLI, 'invalid').strip())
for name in ('empty', 'full', 'signed'):
    ours = OUT / (name + '.o')
    again = OUT / (name + '-again.o')
    gas = OUT / (name + '-gas.o')
    run(CLI, name, ours)
    run(CLI, name, again)
    assert ours.read_bytes() == again.read_bytes(), name
    run('as', '--64', '-o', gas, ROOT / 'tests/object-cli' / (name + '.S'))
    result = run(ROOT / 'tools/differ', ours, gas)
    assert json.loads(result)['equal'], name
    obj = ELF(ours)
    structure(obj)
    compare_headers(obj, ELF(gas))
    for path in (ours, gas):
        p = subprocess.run(['readelf', '-hSsrW', str(path)], capture_output=True, text=True, check=True)
        assert not p.stderr, p.stderr
        path.with_suffix('.readelf').write_text(p.stdout)
    if name == 'empty':
        assert not obj.symbol_tables
        assert [n for n, _ in obj.sections] == ['', '.text', '.data', '.bss', '.shstrtab']
    print('gas differential and raw headers: ' + name)

# Feed all measured ordinary sections, symbols and final relocations back into
# the independent writer, then compare to the published census oracle record.
count = 0
for row in json.loads((ROOT / 'census/oracle-results.json').read_text())['rows']:
    expected = row.get('gas_object')
    if row.get('gas_status') != 0 or not expected:
        continue
    source = row['source']
    byname = {s[0]: s for s in expected['sections']}
    lines = []
    for header in row['gas_sections']:
        if header['type'] in (1, 7, 8):
            s = byname[header['name']]
            lines.append('|'.join(map(str, ('S', s[0], s[1], s[2], s[4], s[3], s[5]))))
    syms = expected['symbols']
    # Exercise remapping, not a hidden dependence on raw gas symbol ordering.
    for s in reversed(syms):
        if s == ['', 0, 0, 'UND', 0, 0, 0]:
            continue
        name, binding, kind, section, value, size, visibility = s
        if section == '65521':
            section = 'ABS'
            if value >= 1 << 63:
                value -= 1 << 64
        lines.append('|'.join(map(str, ('Y', name, binding, kind, section, value, size, visibility))))
    for r in expected['relocations']:
        lines.append('|'.join(map(str, ('R', *r))))
    fixture = OUT / ('census-' + str(count) + '.txt')
    ours = fixture.with_suffix('.o')
    fixture.write_text('\n'.join(lines) + '\n')
    run(CLI, 'replay', fixture, ours)
    obj = ELF(ours)
    structure(obj)
    actual = json.loads(json.dumps(obj.normalized()))
    assert actual == expected, source
    # Live gas remains the black-box oracle, not merely the saved JSON.
    gas = OUT / ('census-' + str(count) + '-gas.o')
    run('as', '--64', '-o', gas, ROOT / 'census/sources' / source)
    assert json.loads(run(ROOT / 'tools/differ', ours, gas))['equal'], source
    compare_headers(obj, ELF(gas))
    count += 1
assert count == 43, count
print(f'complete measured corpus: {count} independent serializations match live gas; symbol-order permutation and raw headers pass')
