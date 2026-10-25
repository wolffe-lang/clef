#!/usr/bin/env python3
"""Recompute the prediction's syntax/table-size and external-field census metrics."""
import json,pathlib,re,sys
root=pathlib.Path(sys.argv[1]).resolve()
census=json.loads((root/'census/org-asm.json').read_text())
coverage=json.loads((root/'src/x86table/census-map.json').read_text())
rows=[line.split('|') for line in re.findall(r'"([^"\n]+\|[^"\n]+)"',(root/'src/x86table/rows.lu').read_text())]
sites={(f['path'],s['line']):s for f in census['files'] for s in f['statements'] if s.get('kind')=='instruction'}
forms={}
for form in coverage['forms']:
    features=set()
    for site in census['forms'][form['observed_form']]:
        statement=sites[(site['file'],site['line'])]
        if site['mode']==32:features.add('code32')
        if site['prefixes']:features.add('explicit prefix')
        for operand in statement['operands']:
            if operand['kind']=='memory':features.add('memory addressing')
            names=[operand.get(key,'') for key in ['register','base','index']]
            for name in names:
                if re.fullmatch(r'%(?:r(?:8|9|1[0-5])(?:b|w|d)?|xmm(?:8|9|1[0-5])|spl|bpl|sil|dil)',name):features.add('REX extension or low-byte')
                if name.startswith('%xmm\\'):features.add('expanded extended XMM family')
        for candidate in form['candidates']:
            if candidate['mode']!=site['mode']:continue
            matching=[r for r in rows if r[4]==candidate['family'] and r[5]==candidate['role'] and int(r[6])==candidate['bits'] and str(site['mode']) in r[7].split(',')]
            for row in matching:
                if int(row[10]):features.add('table-selected legacy prefix')
                if int(row[11]):features.add('table-selected REX.W')
                rm=int(row[14])
                if rm>=0 and rm<len(statement['operands']) and statement['operands'][rm]['kind']=='expression':features.add('absolute memory addressing')
                if row[21]=='address':features.add('moffs addressing')
    if features:forms[form['observed_form']]=sorted(features)
paths=['src/lex/lex.lu','src/dialect/dialect.lu','src/x86table/rows.lu']
counts={p:len((root/p).read_text().splitlines()) for p in paths}
result={'special_field_forms':len(forms),'total_forms':len(coverage['forms']),'criterion':'Any recorded site or admissible row needs a legacy/explicit prefix, REX.W or register extension, memory addressing or code32 routing; row-selected prefix bytes are included. This is not code outside the shared table.','forms':forms,'line_counts':counts,'table_module_lines':sum(len(p.read_text().splitlines()) for p in (root/'src/x86table').glob('*.lu')),'parser_lines':counts[paths[0]]+counts[paths[1]]}
print(json.dumps(result,indent=2))
