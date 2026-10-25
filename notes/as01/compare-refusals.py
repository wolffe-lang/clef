#!/usr/bin/env python3
"""Run inside the pinned container: old/new refusal and accepted-object controls."""
import hashlib,json,pathlib,subprocess
root=pathlib.Path('/lane/clef');stage=pathlib.Path('/lane/integration/unicode-control');stage.mkdir(exist_ok=True)
before=pathlib.Path('/lane/integration/pre-unicode-clef');after=root/'target/clef'
rows=[];old_manifest=[];new_manifest=[]
for entry in json.loads((root/'census/org-asm.json').read_text())['files']:
    if entry['architecture']!='x86_64':continue
    source=root/'census/sources'/entry['path'];old=stage/'before'/entry['path'];new=stage/'after'/entry['path']
    old.parent.mkdir(parents=True,exist_ok=True);new.parent.mkdir(parents=True,exist_ok=True)
    for binary,dest in [(before,old),(after,new)]:subprocess.run([str(binary),str(source),'-o',str(dest)],check=True)
    a=hashlib.sha256(old.read_bytes()).hexdigest();b=hashlib.sha256(new.read_bytes()).hexdigest();assert old.read_bytes()==new.read_bytes(),entry['path']
    old_manifest.append({'file':entry['path'],'sha256':a,'size':old.stat().st_size});new_manifest.append({'file':entry['path'],'sha256':b,'size':new.stat().st_size})
for name,text in [('expression','.quad é\n'),('operator','.quad 1+é\n'),('character',".byte 'é\n"),('macro','.macro M\n.ascii "\\€"\n.endm\nM\n')]:
    src=stage/(name+'.S');src.write_text(text);record={'name':name,'source':text}
    for tag,binary in [('before',before),('after',after)]:
        dest=stage/(name+'-'+tag+'.o');dest.write_bytes(b'unchanged')
        p=subprocess.run([str(binary),str(src),'-o',str(dest)],capture_output=True,text=True)
        record[tag]={'status':p.returncode,'stderr':p.stderr,'destination_unchanged':dest.read_bytes()==b'unchanged'}
        if tag=='after':assert p.returncode==1 and dest.read_bytes()==b'unchanged',(name,p.returncode,p.stderr)
    rows.append(record)
def digest(rows):return hashlib.sha256(json.dumps(rows,sort_keys=True,separators=(',',':')).encode()).hexdigest()
result={'before_revision':'da8afadaed0c8017475e22acca852df128356a63','after_revision':'62dc2a035939b29ba951766534a052cb310158c0','manifest_definition':'SHA256 of compact sorted-key JSON array of file/sha256/size records in pinned census order','before_manifest_sha256':digest(old_manifest),'after_manifest_sha256':digest(new_manifest),'accepted_objects':new_manifest,'refusal_controls':rows}
(stage/'results.json').write_text(json.dumps(result,indent=2)+'\n')
print('accepted source objects',len(new_manifest),'before',digest(old_manifest),'after',digest(new_manifest))
for row in rows:print(row['name'],'before',row['before']['status'],'after',row['after']['status'])
