#!/usr/bin/env python3
"""as02c evidence: every .S/.s under a directory (inside the clef root), clef against the pinned GNU as.
    tools/in-container python3 notes/as02c/sweep.py target/pax-eb6592de
Section contents, relocations and structural symbols (tools/elf.py differences); not a gate."""
import json, pathlib, subprocess, sys
ROOT = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from elf import ELF, differences  # noqa: E402
base = ROOT / sys.argv[1]
work = ROOT / 'target/as02c-sweep'
work.mkdir(parents=True, exist_ok=True)
rows = []
for src in sorted(p for p in base.rglob('*') if p.suffix in ('.S', '.s')):
    rel = src.relative_to(base)
    stem = work / str(rel).replace('/', '__')
    gas_o, clef_o = stem.with_suffix('.gas.o'), stem.with_suffix('.clef.o')
    gas = subprocess.run(['as', '--64', str(src), '-o', str(gas_o)], capture_output=True, text=True)
    ours = subprocess.run([str(ROOT / 'target/clef'), '--64', str(src), '-o', str(clef_o)], capture_output=True, text=True)
    row = {'file': str(rel), 'gas': gas.returncode, 'clef': ours.returncode, 'clef_stderr': ours.stderr.strip()}
    if gas.returncode == 0 and ours.returncode == 0:
        row['differences'] = differences(ELF(gas_o), ELF(clef_o))
    row['equal'] = gas.returncode == 0 and ours.returncode == 0 and not row.get('differences')
    rows.append(row)
    print('PASS' if row['equal'] else 'FAIL', rel, '' if row['equal'] else json.dumps(row)[:400], flush=True)
print(f"sweep {sys.argv[1]}: {sum(r['equal'] for r in rows)}/{len(rows)} byte-identical to GNU as", flush=True)
(ROOT / 'notes/as02c' / ('sweep-' + base.name + '.json')).write_text(json.dumps(rows, indent=1) + '\n')
