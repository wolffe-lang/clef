#!/usr/bin/env python3
"""Run the repository's exact gate list, stop at first failure, print every END.
Also require checked JSON verdicts and the unit runner's full pass count.
"""
import ast
import json
import pathlib
import subprocess
import sys
import time
ROOT = pathlib.Path(__file__).resolve().parents[2]
W = ROOT / '.wolf-bin/wolf/wolf-0.2.36-x86_64-unknown-linux-gnu/wolf'
L = ROOT / '.wolf-bin/lupin/lupin-0.1.58-x86_64-unknown-linux-gnu/lupin'
OUT = ROOT / 'target/evidence'
OUT.mkdir(parents=True, exist_ok=True)
code = ast.parse((ROOT / 'tools/gate').read_text())
commands_node = next(node.value for node in code.body if isinstance(node, ast.Assign)
                     and any(isinstance(t, ast.Name) and t.id == 'commands' for t in node.targets))
commands = eval(compile(ast.Expression(commands_node), '<gate commands>', 'eval'),
                {'ROOT': ROOT, 'W': W, 'L': L})
commands.insert(0, ('fetch-toolchain', ['tools/fetch-toolchain']))
for name, argv in commands:
    print('START ' + name, flush=True)
    started = time.monotonic()
    p = subprocess.run(argv, cwd=ROOT, capture_output=True, text=True)
    (OUT / (name + '.log')).write_text(p.stdout + p.stderr)
    print(p.stdout + p.stderr, end='', flush=True)
    status = p.returncode
    if name.startswith('checked') and status == 0:
        try:
            record = json.loads(p.stdout)
            if (record.get('verdict') != 'exit(0)' or record.get('phase_reached') != 'run'
                    or record.get('warnings')):
                status = 1
        except ValueError:
            status = 1
    if name == 'unit' and '6 passed; 0 failed; 0 rejected; 0 unsupported' not in p.stdout:
        status = 1
    print(f'END {name} exit={status} secs={time.monotonic() - started:.3f}', flush=True)
    if status:
        sys.exit(status)
