"""Direct-jump relaxation: the rule read from GNU as's bytes, and the generated family.

Black-box only. The rule below was read from the pinned GNU as's objects on generated
cases (notes/as02f/prediction.txt); no assembler implementation was consulted. A case is
a list of items:

  ('fill', n)                  n fixed bytes (.zero, or instructions of known size)
  ('label', name)
  ('jmp', name) / ('jcc', name, cc)   a direct branch to a label in the same section
  ('align', p2, maxskip)       .p2align p2[,,maxskip] in the code section
  ('xjmp', kind)               jmp to another section ('xsec') or an undefined symbol ('ext')
"""
import random

SHORT = 2
LONG = {'jmp': 5, 'jcc': 6}
CONDITIONS = ['e', 'ne', 'l', 'ge', 'le', 'g', 'b', 'ae', 'be', 'a', 'o', 'no', 's', 'ns', 'p', 'np']


def is_jump(item):
    return item[0] in ('jmp', 'jcc')


def size_of(item, addr, longs, index):
    kind = item[0]
    if kind == 'fill':
        return item[1]
    if kind == 'label':
        return 0
    if kind == 'xjmp':
        return 5
    if is_jump(item):
        return LONG[kind] if index in longs else SHORT
    if kind == 'align':
        alignment = 1 << item[1]
        count = (alignment - addr % alignment) % alignment
        if item[2] is not None and item[2] > 0 and count > item[2]:
            count = 0
        return count
    raise ValueError(kind)


def layout(items, longs):
    addrs, labels, addr = [], {}, 0
    for i, item in enumerate(items):
        addrs.append(addr)
        if item[0] == 'label':
            labels[item[1]] = addr
        addr += size_of(item, addr, longs, i)
    return addrs, labels, addr


def fits(displacement):
    return -128 <= displacement <= 127


def relax(items, limit=100000):
    """The measured rule; returns (long jump indices, relaxation passes)."""
    where = {item[1]: i for i, item in enumerate(items) if item[0] == 'label'}
    longs = set()
    old_addrs, old_labels, _ = layout(items, longs)
    for passes in range(1, limit):
        grown = False
        addr, labels = 0, {}
        for i, item in enumerate(items):
            if item[0] == 'label':
                labels[item[1]] = addr
            if is_jump(item) and i not in longs:
                t = where[item[1]]
                if t <= i:
                    target = labels[item[1]]
                elif any(items[j][0] == 'align' and items[j][1] > 0 for j in range(i + 1, t)):
                    target = old_labels[item[1]]
                else:
                    target = old_labels[item[1]] + (addr - old_addrs[i])
                if not fits(target - (addr + SHORT)):
                    longs.add(i)
                    grown = True
            addr += size_of(item, addr, longs, i)
        old_addrs, old_labels, _ = layout(items, longs)
        if not grown:
            return longs, passes
    raise RuntimeError('relaxation limit')


# ---- rendering and reading back ----------------------------------------------------------

def fill_lines(n, style, mode):
    if n == 0:
        return []
    if style == 'zero':
        return [f'.zero {n}']
    out = []
    if mode == 64:
        while n >= 10:
            out.append('movabsq $0, %rax')
            n -= 10
    while n >= 5:
        out.append('movl $0, %eax')
        n -= 5
    return out + ['nop'] * n


def render(case):
    items, style, mode = case['items'], case['style'], case['mode']
    rng = random.Random(case['name'])
    lines = ['.text'] + (['.code32'] if mode == 32 else [])
    for item in items:
        kind = item[0]
        if kind == 'fill':
            lines += fill_lines(item[1], rng.choice(['zero', 'insn']) if style == 'mixed' else style, mode)
        elif kind == 'label':
            lines.append(f'{item[1]}:')
        elif kind == 'jmp':
            lines.append(f'jmp {item[1]}')
        elif kind == 'jcc':
            lines.append(f'j{item[2]} {item[1]}')
        elif kind == 'align':
            lines.append(f'.p2align {item[1]}' if item[2] is None else f'.p2align {item[1]},,{item[2]}')
        elif kind == 'xjmp':
            lines.append('jmp .Lother' if item[1] == 'xsec' else 'jmp external')
    lines.append('ret')
    if any(item[0] == 'xjmp' and item[1] == 'xsec' for item in items):
        lines += ['.data', '.Lother:', '.byte 0']
    return '\n'.join(lines) + '\n'


def read_longs(items, text):
    """Walk an object's .text with the known item sizes; return its long jumps."""
    addr, longs = 0, set()
    for i, item in enumerate(items):
        kind = item[0]
        if kind in ('fill', 'label', 'align', 'xjmp'):
            addr += size_of(item, addr, longs, i)
        elif kind == 'jmp':
            if text[addr] == 0xEB:
                addr += 2
            elif text[addr] == 0xE9:
                longs.add(i)
                addr += 5
            else:
                raise ValueError(f'item {i}: no jmp at {addr}')
        else:
            if 0x70 <= text[addr] <= 0x7F:
                addr += 2
            elif text[addr] == 0x0F and 0x80 <= text[addr + 1] <= 0x8F:
                longs.add(i)
                addr += 6
            else:
                raise ValueError(f'item {i}: no jcc at {addr}')
    if addr + 1 != len(text) or text[addr] != 0xC3:
        raise ValueError(f'walk ended at {addr} of {len(text)}')
    return longs


# ---- the family ----------------------------------------------------------------------------

def jump(kind, target, k):
    return ('jmp', target) if kind == 'jmp' else ('jcc', target, CONDITIONS[k % len(CONDITIONS)])


def chain_forward(n, fill, last, kinds):
    """Jump k targets the label just past jump k+1: each grows only once the next has."""
    items = []
    for k in range(n):
        items.append(jump(kinds[k % len(kinds)], f'.Lc{k + 1}', k))
        if k:
            items.append(('label', f'.Lc{k}'))
        items.append(('fill', fill if k < n - 1 else last))
    items.append(('label', f'.Lc{n}'))
    return items


def chain_backward(n, fill, first, kinds):
    """Jump k targets the label just before jump k-1."""
    items = [('label', '.Lb0'), ('fill', first)]
    for k in range(n):
        items.append(('label', f'.Lb{k + 1}'))
        items.append(jump(kinds[k % len(kinds)], f'.Lb{k}', k))
        items.append(('fill', fill))
    return items


def ring(n, fill, kinds):
    """Forward jumps each spanning the next; the last spans back over the first."""
    items = [('label', '.Lr0')]
    for k in range(n):
        target = f'.Lr{k + 2}' if k < n - 1 else '.Lr0'
        items.append(jump(kinds[k % len(kinds)], target, k))
        items.append(('label', f'.Lr{k + 1}'))
        items.append(('fill', fill))
    items.append(('label', f'.Lr{n + 1}'))
    return items


def nested(depth, body, step):
    """Loops: a forward exit test and a backward edge per level, bodies around the boundary."""
    def level(d):
        if d == depth:
            return [('fill', body)]
        inner = level(d + 1)
        return ([('label', f'.Lh{d}'), ('fill', step), ('jcc', f'.Le{d}', CONDITIONS[d]), ('fill', step)]
                + inner + [('fill', step), ('jmp', f'.Lh{d}'), ('label', f'.Le{d}')])
    return level(0)


def pair(gap):
    """The issue's kernel: two adjacent forward jumps, each `gap`+2 bytes from its target."""
    return [('jmp', '.Lp1'), ('jmp', '.Lp2'), ('fill', gap), ('label', '.Lp1'), ('fill', 2), ('label', '.Lp2')]


def with_align(items, at, p2, maxskip=None):
    out = list(items)
    out.insert(min(at, len(out)), ('align', p2, maxskip))
    return out


def random_small(rng):
    njumps = rng.randint(2, 9)
    nlabels = rng.randint(2, njumps + 2)
    kinds = ['jump'] * njumps + ['label'] * nlabels + ['align'] * rng.randint(0, 3)
    rng.shuffle(kinds)
    per = max(1, rng.choice([40, 60, 90, 128, 130, 160, 250]) // len(kinds))
    names = [f'.L{k}' for k in range(nlabels)]
    items, li = [], 0
    for k in kinds:
        items.append(('fill', rng.randint(0, 2 * per)))
        if k == 'label':
            items.append(('label', names[li]))
            li += 1
        elif k == 'jump':
            items.append(jump(rng.choice(['jmp', 'jcc']), rng.choice(names), rng.randrange(16)))
        else:
            p2 = rng.choice([2, 3, 4, 4, 5, 6])
            items.append(('align', p2, None if rng.random() < 0.7 else rng.randint(1, (1 << p2) - 1)))
    items.append(('fill', rng.randint(0, per)))
    return items


def random_big(rng):
    njumps = rng.randint(4, 24)
    nlabels = rng.randint(2, njumps)
    kinds = (['jump'] * njumps + ['label'] * nlabels + ['align'] * rng.randint(1, 5)
             + ['far'] * rng.randint(0, 3) + ['xjmp'] * rng.randint(0, 2) + ['align0'] * rng.randint(0, 1))
    rng.shuffle(kinds)
    per = max(1, rng.choice([60, 128, 160, 200, 300, 500]) // max(1, len(kinds) // 3))
    names = [f'.L{k}' for k in range(nlabels)]
    items, li, far = [], 0, False
    for k in kinds:
        items.append(('fill', rng.randint(0, per)))
        if k == 'label':
            items.append(('label', names[li]))
            li += 1
        elif k == 'jump':
            items.append(jump(rng.choice(['jmp', 'jcc']), rng.choice(names), rng.randrange(16)))
        elif k == 'far':
            items.append(jump(rng.choice(['jmp', 'jcc']), '.Lfar', rng.randrange(16)))
            far = True
        elif k == 'xjmp':
            items.append(('xjmp', rng.choice(['xsec', 'ext'])))
        elif k == 'align0':
            items.append(('align', 0, None))
        else:
            p2 = rng.choice([1, 2, 2, 3, 3, 4, 4, 5, 6])
            items.append(('align', p2, None if rng.random() < 0.7 else rng.randint(1, max(1, (1 << p2) - 1))))
    items.append(('fill', rng.randint(0, per)))
    if far:
        items += [('fill', 300), ('label', '.Lfar')]
    return items


def family():
    cases = []

    def add(name, group, items, style='zero', mode=64):
        cases.append({'name': name, 'group': group, 'items': items, 'style': style, 'mode': mode})

    for gap in (121, 122, 123, 124, 125, 126):
        add(f'pair-{gap}', 'pair', pair(gap))
        add(f'pair-{gap}-insn', 'pair', pair(gap), 'insn')
    for n in (2, 3, 8, 24):
        for fill in (120, 121, 122, 123, 124, 125, 126):
            for last in (fill, 200):
                for kinds in (['jmp'], ['jcc'], ['jmp', 'jcc']):
                    tag = '-'.join(kinds)
                    add(f'chain-forward-{n}-{fill}-{last}-{tag}', 'chain', chain_forward(n, fill, last, kinds))
                    if n == 3:
                        add(f'chain-backward-{n}-{fill}-{last}-{tag}', 'chain',
                            chain_backward(n, fill, last, kinds))
    for n in (2, 3, 5):
        for fill in range(118, 128):
            for kinds in (['jmp'], ['jcc'], ['jmp', 'jcc']):
                add(f'ring-{n}-{fill}-{"-".join(kinds)}', 'ring', ring(n, fill, kinds))
    for depth in (2, 3, 4):
        for body in range(100, 132, 2):
            for step in (0, 3, 7):
                add(f'nested-{depth}-{body}-{step}', 'nested', nested(depth, body, step))
                add(f'nested-{depth}-{body}-{step}-mixed', 'nested', nested(depth, body, step), 'mixed')
    for base_name, base in (('pair-124', pair(124)), ('ring-3-121', ring(3, 121, ['jmp', 'jcc'])),
                            ('nested-3-110-3', nested(3, 110, 3)),
                            ('chain-forward-3-123-200', chain_forward(3, 123, 200, ['jmp']))):
        for at in range(len(base) + 1):
            for p2, maxskip in ((2, None), (4, None), (5, None), (4, 7)):
                add(f'align-{base_name}-at{at}-p{p2}' + (f'-max{maxskip}' if maxskip else ''), 'align',
                    with_align(base, at, p2, maxskip))
    # The separating probes: each tells one discarded rule from the measured one.
    sep = {
        'two-fixed-points': [('label', 'Y'), ('fill', 63), ('jmp', 'X'), ('fill', 60), ('jmp', 'Y'),
                             ('fill', 64), ('label', 'X')],
        'growth-before-alignment': [('jmp', 'TA'), ('fill', 12), ('jmp', 'X'), ('fill', 120), ('align', 4, None),
                                    ('label', 'X'), ('fill', 200), ('label', 'TA')],
        'grown-never-shrinks': [('jmp', 'TU'), ('fill', 12), ('jmp', 'X'), ('fill', 113), ('label', 'TU'),
                                ('fill', 7), ('align', 4, None), ('label', 'X')],
        'alignment-hides-the-move': [('jmp', 'TC'), ('fill', 60), ('jmp', 'FAR'), ('fill', 64), ('label', 'TC'),
                                     ('fill', 10), ('jmp', 'X'), ('fill', 115), ('align', 4, None), ('label', 'X'),
                                     ('fill', 200), ('label', 'FAR')],
        'first-misfit-is-not-enough': [('jmp', 'TU'), ('fill', 60), ('jmp', 'FAR'), ('fill', 64), ('label', 'TU'),
                                       ('fill', 10), ('jmp', 'X'), ('fill', 120), ('align', 4, None),
                                       ('label', 'X'), ('fill', 200), ('label', 'FAR')],
    }
    for name, items in sep.items():
        for kind in ('zero', 'insn'):
            add(f'{name}-{kind}', 'separating', items, kind)
            add(f'{name}-{kind}-code32', 'separating', items, kind, 32)
    rng = random.Random(21)
    for k in range(250):
        add(f'random-small-{k:03d}', 'random', random_small(rng), rng.choice(['zero', 'insn', 'mixed']))
    for k in range(250):
        add(f'random-big-{k:03d}', 'random', random_big(rng), rng.choice(['zero', 'insn', 'mixed']))
    return cases


def bound_case(n=200):
    """The largest case: the issue's oscillating pair, then a cascade of n jumps that grow one per pass."""
    items = pair(124)
    for item in chain_forward(n, 124, 200, ['jmp']):
        items.append(item if item[0] != 'label' else ('label', item[1] + 'b'))
    items = [(it[0], it[1] + 'b') if is_jump(it) and it[1].startswith('.Lc') else it for it in items]
    return {'name': f'bound-cascade-{n}', 'group': 'bound', 'items': items, 'style': 'zero', 'mode': 64}
