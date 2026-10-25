#!/usr/bin/env python3
"""Record .deb identities from a prepared oracle container, never package source."""
import glob,hashlib,json,pathlib,shlex,subprocess
rows=[]
for file in sorted(glob.glob('/var/cache/apt/archives/*.deb')):
    p=pathlib.Path(file)
    package,version=subprocess.check_output(['dpkg-deb','-f',file,'Package','Version'],text=True).splitlines()
    package=package.removeprefix('Package: ');version=version.removeprefix('Version: ')
    output=subprocess.check_output(['apt-get','--print-uris','download',package+'='+version],text=True)
    uri=next(shlex.split(line)[0] for line in output.splitlines() if line.startswith("'"))
    rows.append({'name':package,'version':version,'filename':p.name,'url':uri.replace('http:','https:'),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
print(json.dumps({'base':'docker.io/library/ubuntu:24.04@sha256:a2d43bffc46670d7108bb3c0468c67c5557c4c92e83e1e34cbff1322ad1b94dc','packages':rows},indent=2))
