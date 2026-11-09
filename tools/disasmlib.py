"""Shared pieces for the disassembler rows: objdump as the black-box oracle,
clef's own disassembly, line normalization, the digest-checked corpus, and the
round-trip law (clef on both sides). No disassembler source is consulted."""
import hashlib,json,os,pathlib,re,subprocess
from elf import ELF
ROOT=pathlib.Path(__file__).resolve().parents[1]
CLEF=ROOT/'target/clef'
LINE=re.compile(r'^\s*([0-9a-f]+):\t(.*)$')
SECTION=re.compile(r'^Disassembly of section (\S+):$')
CHUNK=50000

def sha256(path):
    h=hashlib.sha256()
    with open(path,'rb') as f:
        for block in iter(lambda:f.read(1<<20),b''):h.update(block)
    return h.hexdigest()

def normalize(text):
    """Only symbolic decoration and blank runs are free; everything else is compared."""
    text=re.sub(r'\s*<[^>]*>','',text)
    return re.sub(r'\s+',' ',text).strip()

def parse(dump):
    """-> {section: [(address, normalized text)]} from objdump-shaped output."""
    out={};cur=None
    for line in dump.splitlines():
        m=SECTION.match(line)
        if m:cur=m[1];out.setdefault(cur,[]);continue
        m=LINE.match(line)
        if m and cur is not None:out[cur].append((int(m[1],16),normalize(m[2])))
    return out

def objdump(path,mode=64):
    flags=['-M','i386'] if mode==32 else []
    p=subprocess.run(['objdump','-d','--no-show-raw-insn','--wide',*flags,str(path)],capture_output=True,text=True,errors='replace')
    if p.returncode:raise RuntimeError('objdump failed: '+p.stderr[:300])
    return parse(p.stdout)

def clef_disassemble(path,*extra,mode=64):
    flags=['--code32'] if mode==32 else []
    p=subprocess.run([str(CLEF),'--disassemble',*flags,*extra,str(path)],capture_output=True,text=True,errors='replace')
    return p.returncode,p.stdout,p.stderr

def classify_line(text):
    """The decoder names its own residual in a trailing comment: '# out_of_scope:sse'."""
    m=re.search(r'#\s*(out_of_scope:\w+|invalid_\w+|reserved_modrm|lock_without_memory|rex_misplaced|length_over_15)',text)
    if m:return m[1]
    return 'decoded'

def executable_sections(path):
    e=ELF(path)
    for name,s in e.sections:
        if s[2]&4 and s[1]!=8 and s[5]>0:yield name,s[3],e.contents(s)

def corpus_members(manifest,root):
    """Digest-checked members of the staged corpus; a mismatch is a hard failure, never a skip."""
    m=json.loads(pathlib.Path(manifest).read_text())
    for b in m['binaries']:
        path=pathlib.Path(root)/b['paths'][0]
        if not path.exists():raise FileNotFoundError(str(path))
        digest=sha256(path)
        if digest!=b['sha256']:raise RuntimeError(f'corpus digest mismatch: {path} {digest} != {b["sha256"]}')
        yield b,path

def assemble_chunks(source_lines,workdir,tag,mode=64):
    """Assemble round-trip source in CHUNK-line pieces with clef; -> (bytes or None, diagnostics)."""
    out=bytearray();diag=[]
    for i in range(0,len(source_lines),CHUNK):
        src=workdir/f'{tag}-{i//CHUNK}.S';obj=src.with_suffix('.o')
        src.write_text(f'.text\n.code{mode}\n'+'\n'.join(source_lines[i:i+CHUNK])+'\n')
        p=subprocess.run([str(CLEF),'--64',str(src),'-o',str(obj)],capture_output=True,text=True)
        if p.returncode or not obj.exists():
            diag.append(p.stderr.strip()[:300]);return None,diag
        e=ELF(obj)
        text=next((e.contents(s) for name,s in e.sections if name=='.text'),b'')
        if e.relocations:diag.append('unresolved relocations in chunk %d'%(i//CHUNK));return None,diag
        out+=text;src.unlink();obj.unlink()
    return bytes(out),diag

def corpus_root():
    root=os.environ.get('CLEF_CORPUS')
    return pathlib.Path(root) if root else None
