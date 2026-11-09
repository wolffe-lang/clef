"""Shared generator: one AT&T source witness per encoding row and admitted mode.
Used by tools/table-test (encoder) and tools/disasm-test (decoder) so both
directions of the table are measured on the same sources."""
import pathlib,re
ROOT=pathlib.Path(__file__).resolve().parents[1]

def rows():
    found=re.findall(r'"([^"\n]+\|[^"\n]+)"',(ROOT/'src/x86table/rows.lu').read_text())
    assert found
    return found

def witnesses():
    """Yield (index, row_fields, mode, source_text) for every row and mode."""
    suffix={8:'b',16:'w',32:'l',64:'q'}
    for index,row in enumerate(rows()):
        f=row.split('|');family,role,bits=f[4],f[5],int(f[6]);pattern=f[20]
        for mode in map(int,f[7].split(',')):
            base='%rax' if mode==64 else '%eax'
            register={8:'%cl',16:'%cx',32:'%ecx',64:'%rcx',128:'%xmm1'}
            acc={8:'%al',16:'%ax',32:'%eax',64:'%rax'}
            mnemonic=family
            sized={'adc','sbb','btc','btr','bts','not','cmpxchg','xadd','xchg','add','and','or','sub','xor','cmp','test','mov','lea','inc','dec','neg','mul','div','idiv','imul','shl','shr','sar','bt','push','pop','in','out','nop',
                   'rol','ror','rcl','rcr','shld','shrd','bsf','bsr','tzcnt','lzcnt','popcnt','bswap','movbe','lar','lsl','rdseed','movnti','lss','lfs','lgs','lds','les','bound'}
            if (family.startswith('cmov') or family in sized) and bits and role!='string':
                mnemonic+=suffix[bits]
            if role=='string' and family in ('movs','cmps','ins','outs'):mnemonic+=suffix[bits]
            if family=='crc32':mnemonic='crc32'+('b' if role=='rm8_reg' else 'w' if role=='rm16_reg' else suffix[bits])
            if family=='movabs':mnemonic='movabsq' if role=='imm_reg' else 'movabs'
            if family in {'movsx','movzx'}:
                mnemonic=('movs' if family=='movsx' else 'movz')+('b' if role=='rm8_reg' else 'w')+suffix[bits]
            if family=='movsxd':mnemonic='movslq' if bits==64 else 'movsxd'
            if family=='setb':mnemonic='setb'
            operands=[]
            for p in ([] if pattern=='none' else pattern.split(',')):
                if p=='imm' and f[21]=='enter':
                    operands.append('$16' if not operands else '$0');continue
                if p=='imm':
                    value=3
                    if role in {'imm8','imm8_rm','imm8_rm_reg','shift1'}:value=1
                    elif role in {'imm_rm','imm_acc','imm_rm_reg','imm'} and bits>8:value=256
                    if family in {'mov','movabs'} and bits==64 and role=='imm_reg':value=0x123456789abcdef
                    if family in {'bt','btc','btr','bts'}:value=3
                    operands.append('$'+str(value))
                elif p=='relative':operands.append('.+2' if role=='relative8' else '.+4096')
                elif p=='cl':operands.append('%cl')
                elif p=='dx':operands.append('%dx')
                elif p=='control':operands.append('%cr3')
                elif p=='segment':operands.append('%'+role[4:] if role.startswith('seg_') else '%ds')
                elif p=='xsi':operands.append('%ds:(%rsi)' if mode==64 else '%ds:(%esi)')
                elif p=='ydi':operands.append('%es:(%rdi)' if mode==64 else '%es:(%edi)')
                elif p=='moffs':operands.append('0x1000')
                elif p=='debug':operands.append('%db0')
                elif p=='indirect-mem':operands.append('*('+base+')')
                elif p=='rmw16':operands.append('('+base+')')
                elif p in ('port8','selector16','offset32'):operands.append('$'+str({'port8':97,'selector16':8,'offset32':0x12345678}[p]))
                elif p=='moffs32':operands.append('4096')
                elif p=='xmm128':operands.append('%xmm1')
                elif p=='xmmrm128':operands.append('('+base+')')
                elif p.startswith('acc'):operands.append(acc[int(p[3:])])
                elif p.startswith('indirect-rm'):operands.append('*('+base+')')
                elif p=='mem' or p.startswith('rm'):operands.append('('+base+')')
                elif p.startswith('r'):operands.append(register[int(p[1:])])
                else:raise AssertionError(p)
            # RDRAND's /6 is register-only; its table pattern is already rN.
            text=mnemonic+(' '+','.join(operands) if operands else '')
            yield index,f,mode,text
