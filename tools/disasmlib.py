"""Shared pieces for the disassembler rows: objdump as the black-box oracle,
clef's own disassembly, line normalization, the digest-checked corpus, and the
round-trip law (clef on both sides). No disassembler source is consulted."""
import hashlib,json,os,pathlib,re,subprocess
from elf import ELF
ROOT=pathlib.Path(__file__).resolve().parents[1]
CLEF=ROOT/'target/clef'
LINE=re.compile(r'^\s*([0-9a-f]+):\t(.*)$')
SECTION=re.compile(r'^Disassembly of section (\S+):$')
CHUNK=2000  # lines per reassembled chunk: clef holds about 0.85 MB per line, so 2,000 fits a 2.5 GiB cap

def sha256(path):
    h=hashlib.sha256()
    with open(path,'rb') as f:
        for block in iter(lambda:f.read(1<<20),b''):h.update(block)
    return h.hexdigest()

def normalize(text):
    """Only symbolic decoration and blank runs are free; everything else is compared. A
    symbolized address (`401000 <main+0x10>`, `# 4020 <x>`) is the number objdump prints as
    `0x401000` where no symbol applies, so it reads as that number."""
    text=re.sub(r'\b([0-9a-f]+) <[^>]*>',r'0x\1',text)
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

def memory_cap():
    """A hard address-space cap for every clef process, CLEF_MEM_GB gibibytes (default 4); None where unsupported."""
    try:
        import resource
    except ImportError:return None
    limit=int(float(os.environ.get('CLEF_MEM_GB','4'))*2**30)
    def cap():
        for name in ('RLIMIT_AS','RLIMIT_DATA'):
            try:resource.setrlimit(getattr(resource,name),(limit,limit));return
            except (ValueError,OSError):continue  # macOS refuses RLIMIT_AS; the cap is a Linux guarantee
    return cap

def clef_disassemble(path,*extra,mode=64):
    flags=['--code32'] if mode==32 else []
    p=subprocess.run([str(CLEF),'--disassemble',*flags,*extra,str(path)],capture_output=True,text=True,errors='replace',preexec_fn=memory_cap())
    return p.returncode,p.stdout,p.stderr

def classify_line(text):
    """The decoder names its own residual in a trailing comment: '# out_of_scope:sse'."""
    m=re.search(r'#\s*(out_of_scope:\w+|invalid_\w+|reserved_modrm|lock_without_memory|rex_misplaced|length_over_15)',text)
    if m:return m[1]
    return 'decoded'

def sections(path):
    """ELF64-LE section headers (ELF gABI ch.4) without the comparator's table checks: an
    executable's dynamic tables may point anywhere; only names, flags, addresses and bytes matter here."""
    import struct
    data=pathlib.Path(path).read_bytes()
    if data[:7]!=b'\x7fELF\x02\x01\x01' or struct.unpack_from('<H',data,18)[0]!=62:raise ValueError('not an ELF64 x86-64 file')
    shoff,shentsize,shnum,shstrndx=struct.unpack_from('<Q',data,40)[0],*struct.unpack_from('<HHH',data,58)
    if shentsize!=64 or not shnum or shstrndx>=shnum:raise ValueError('invalid section table')
    raw=[struct.unpack_from('<IIQQQQIIQQ',data,shoff+i*64) for i in range(shnum)]
    names=raw[shstrndx];table=data[names[4]:names[4]+names[5]]
    out=[]
    for s in raw:
        end=table.find(b'\0',s[0]);name=table[s[0]:end].decode('utf-8','surrogateescape') if end>=0 else ''
        out.append((name,s))
    return data,out

def executable_sections(path):
    data,secs=sections(path)
    for name,s in secs:
        if s[2]&4 and s[1]!=8 and s[5]>0:yield name,s[3],data[s[4]:s[4]+s[5]]

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
        p=subprocess.run([str(CLEF),'--64',str(src),'-o',str(obj)],capture_output=True,text=True,preexec_fn=memory_cap())
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
