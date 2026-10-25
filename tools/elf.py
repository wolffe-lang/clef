"""Small independent ELF64-LE reader for the oracle comparator.
Layout: ELF gABI ch.4, x86-64 psABI 4.4. No assembler implementation used.
"""
import collections
import pathlib
import struct

class ELF:
    def __init__(self, path):
        self.data=pathlib.Path(path).read_bytes()
        def unpack(fmt,off):
            n=struct.calcsize(fmt)
            if off<0 or off+n>len(self.data): raise ValueError('truncated ELF structure')
            return struct.unpack_from(fmt,self.data,off)
        self.unpack=unpack
        h=unpack('<16sHHIQQQIHHHHHH',0)
        if h[0][:7]!=b'\x7fELF\x02\x01\x01' or h[2]!=62 or h[3]!=1 or h[8]!=64:
            raise ValueError('only ELF64 little-endian x86-64 version 1 is supported')
        self.header=h; shoff,shsize,n,strings=h[6],h[11],h[12],h[13]
        if shsize!=64 or not n or strings>=n: raise ValueError('invalid or extended section table')
        raw=[unpack('<IIQQQQIIQQ',shoff+i*64) for i in range(n)]
        def contents(s):
            if s[1]==8: return b''
            start,size=s[4],s[5]
            if start+size>len(self.data): raise ValueError('section outside file')
            return self.data[start:start+size]
        self.contents=contents
        names=contents(raw[strings])
        self.sections=[]
        for s in raw:
            self.sections.append((self.string(names,s[0]),s))
        self.symbol_tables={}
        for i,(name,s) in enumerate(self.sections):
            if s[1] not in (2,11): continue
            if s[6]>=n or s[9]!=24 or s[5]%24: raise ValueError('invalid symbol table')
            strings_data=contents(raw[s[6]])
            syms=[]
            for j in range(s[5]//24):
                no,info,other,shndx,value,size=unpack('<IBBHQQ',s[4]+24*j)
                if shndx<n: sec=self.sections[shndx][0] if shndx else 'UND'
                elif shndx>=0xff00: sec=str(shndx)
                else: raise ValueError('bad symbol section index')
                sym=self.string(strings_data,no)
                if not sym and info&15==3: sym=sec
                syms.append((sym,info>>4,info&15,sec,value,size,other))
            self.symbol_tables[i]=syms
        self.relocations=[]
        for name,s in self.sections:
            if s[1]==9: raise ValueError('SHT_REL is not the x86-64 RELA posture')
            if s[1]!=4: continue
            if s[6] not in self.symbol_tables or s[7]>=n or s[9]!=24 or s[5]%24: raise ValueError('invalid RELA table')
            for j in range(s[5]//24):
                off,info,add=unpack('<QQq',s[4]+24*j)
                syms=self.symbol_tables[s[6]]
                if info>>32>=len(syms): raise ValueError('bad relocation symbol index')
                self.relocations.append((self.sections[s[7]][0],off,info&0xffffffff,syms[info>>32][0],add))
    @staticmethod
    def string(data,off):
        if off>=len(data): raise ValueError('string offset outside string table')
        end=data.find(b'\0',off)
        if end<0: raise ValueError('unterminated ELF string')
        return data[off:end].decode('utf-8','surrogateescape')
    def normalized(self):
        sections=[]
        for name,s in self.sections:
            # Tables have their semantic comparisons below; string order is free.
            if s[1] in (0,2,3,4,11): continue
            sections.append((name,s[1],s[2],s[5],s[8],''))
        return {'sections':sorted(sections),'relocations':sorted(self.relocations),
                'symbols':sorted(sym for syms in self.symbol_tables.values() for sym in syms),
                'header':(self.header[1],self.header[2],self.header[7])}

def differences(a,b):
    aa,bb=a.normalized(),b.normalized()
    return {k:{'left':aa[k],'right':bb[k]} for k in aa if aa[k]!=bb[k]}
