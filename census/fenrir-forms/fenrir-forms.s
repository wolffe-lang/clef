.text
# form-0000 move
movb %al, %cl
.Ltarget_form_0000:
# form-0001 move
movb -16(%rbp), %al
.Ltarget_form_0001:
# form-0002 move
movb %al, -16(%rbp)
.Ltarget_form_0002:
# form-0003 move
movb $7, %al
.Ltarget_form_0003:
# form-0004 move
movb $7, -16(%rbp)
.Ltarget_form_0004:
# form-0005 integer
addb %al, %cl
.Ltarget_form_0005:
# form-0006 integer
addb -16(%rbp), %al
.Ltarget_form_0006:
# form-0007 integer
addb %al, -16(%rbp)
.Ltarget_form_0007:
# form-0008 integer
addb $7, %al
.Ltarget_form_0008:
# form-0009 integer
addb $7, -16(%rbp)
.Ltarget_form_0009:
# form-0010 integer
subb %al, %cl
.Ltarget_form_0010:
# form-0011 integer
subb -16(%rbp), %al
.Ltarget_form_0011:
# form-0012 integer
subb %al, -16(%rbp)
.Ltarget_form_0012:
# form-0013 integer
subb $7, %al
.Ltarget_form_0013:
# form-0014 integer
subb $7, -16(%rbp)
.Ltarget_form_0014:
# form-0015 integer
andb %al, %cl
.Ltarget_form_0015:
# form-0016 integer
andb -16(%rbp), %al
.Ltarget_form_0016:
# form-0017 integer
andb %al, -16(%rbp)
.Ltarget_form_0017:
# form-0018 integer
andb $7, %al
.Ltarget_form_0018:
# form-0019 integer
andb $7, -16(%rbp)
.Ltarget_form_0019:
# form-0020 integer
orb %al, %cl
.Ltarget_form_0020:
# form-0021 integer
orb -16(%rbp), %al
.Ltarget_form_0021:
# form-0022 integer
orb %al, -16(%rbp)
.Ltarget_form_0022:
# form-0023 integer
orb $7, %al
.Ltarget_form_0023:
# form-0024 integer
orb $7, -16(%rbp)
.Ltarget_form_0024:
# form-0025 integer
xorb %al, %cl
.Ltarget_form_0025:
# form-0026 integer
xorb -16(%rbp), %al
.Ltarget_form_0026:
# form-0027 integer
xorb %al, -16(%rbp)
.Ltarget_form_0027:
# form-0028 integer
xorb $7, %al
.Ltarget_form_0028:
# form-0029 integer
xorb $7, -16(%rbp)
.Ltarget_form_0029:
# form-0030 integer
cmpb %al, %cl
.Ltarget_form_0030:
# form-0031 integer
cmpb -16(%rbp), %al
.Ltarget_form_0031:
# form-0032 integer
cmpb %al, -16(%rbp)
.Ltarget_form_0032:
# form-0033 integer
cmpb $7, %al
.Ltarget_form_0033:
# form-0034 integer
cmpb $7, -16(%rbp)
.Ltarget_form_0034:
# form-0035 test
testb %al, %cl
.Ltarget_form_0035:
# form-0036 test
testb %al, -16(%rbp)
.Ltarget_form_0036:
# form-0037 test
testb $7, %al
.Ltarget_form_0037:
# form-0038 test
testb $7, -16(%rbp)
.Ltarget_form_0038:
# form-0039 unary
negb %al
.Ltarget_form_0039:
# form-0040 unary
negb -16(%rbp)
.Ltarget_form_0040:
# form-0041 unary
notb %al
.Ltarget_form_0041:
# form-0042 unary
notb -16(%rbp)
.Ltarget_form_0042:
# form-0043 shift
shlb $1, %al
.Ltarget_form_0043:
# form-0044 shift
shlb $1, -16(%rbp)
.Ltarget_form_0044:
# form-0045 shift
shlb $7, %al
.Ltarget_form_0045:
# form-0046 shift
shlb $7, -16(%rbp)
.Ltarget_form_0046:
# form-0047 shift
shlb %cl, %al
.Ltarget_form_0047:
# form-0048 shift
shlb %cl, -16(%rbp)
.Ltarget_form_0048:
# form-0049 shift
sarb $1, %al
.Ltarget_form_0049:
# form-0050 shift
sarb $1, -16(%rbp)
.Ltarget_form_0050:
# form-0051 shift
sarb $7, %al
.Ltarget_form_0051:
# form-0052 shift
sarb $7, -16(%rbp)
.Ltarget_form_0052:
# form-0053 shift
sarb %cl, %al
.Ltarget_form_0053:
# form-0054 shift
sarb %cl, -16(%rbp)
.Ltarget_form_0054:
# form-0055 shift
shrb $1, %al
.Ltarget_form_0055:
# form-0056 shift
shrb $1, -16(%rbp)
.Ltarget_form_0056:
# form-0057 shift
shrb $7, %al
.Ltarget_form_0057:
# form-0058 shift
shrb $7, -16(%rbp)
.Ltarget_form_0058:
# form-0059 shift
shrb %cl, %al
.Ltarget_form_0059:
# form-0060 shift
shrb %cl, -16(%rbp)
.Ltarget_form_0060:
# form-0061 division
mulb %cl
.Ltarget_form_0061:
# form-0062 division
mulb -16(%rbp)
.Ltarget_form_0062:
# form-0063 division
imulb %cl
.Ltarget_form_0063:
# form-0064 division
imulb -16(%rbp)
.Ltarget_form_0064:
# form-0065 division
divb %cl
.Ltarget_form_0065:
# form-0066 division
divb -16(%rbp)
.Ltarget_form_0066:
# form-0067 division
idivb %cl
.Ltarget_form_0067:
# form-0068 division
idivb -16(%rbp)
.Ltarget_form_0068:
# form-0069 move
movw %ax, %cx
.Ltarget_form_0069:
# form-0070 move
movw -16(%rbp), %ax
.Ltarget_form_0070:
# form-0071 move
movw %ax, -16(%rbp)
.Ltarget_form_0071:
# form-0072 move
movw $7, %ax
.Ltarget_form_0072:
# form-0073 move
movw $7, -16(%rbp)
.Ltarget_form_0073:
# form-0074 integer
addw %ax, %cx
.Ltarget_form_0074:
# form-0075 integer
addw -16(%rbp), %ax
.Ltarget_form_0075:
# form-0076 integer
addw %ax, -16(%rbp)
.Ltarget_form_0076:
# form-0077 integer
addw $7, %ax
.Ltarget_form_0077:
# form-0078 integer
addw $7, -16(%rbp)
.Ltarget_form_0078:
# form-0079 integer
subw %ax, %cx
.Ltarget_form_0079:
# form-0080 integer
subw -16(%rbp), %ax
.Ltarget_form_0080:
# form-0081 integer
subw %ax, -16(%rbp)
.Ltarget_form_0081:
# form-0082 integer
subw $7, %ax
.Ltarget_form_0082:
# form-0083 integer
subw $7, -16(%rbp)
.Ltarget_form_0083:
# form-0084 integer
andw %ax, %cx
.Ltarget_form_0084:
# form-0085 integer
andw -16(%rbp), %ax
.Ltarget_form_0085:
# form-0086 integer
andw %ax, -16(%rbp)
.Ltarget_form_0086:
# form-0087 integer
andw $7, %ax
.Ltarget_form_0087:
# form-0088 integer
andw $7, -16(%rbp)
.Ltarget_form_0088:
# form-0089 integer
orw %ax, %cx
.Ltarget_form_0089:
# form-0090 integer
orw -16(%rbp), %ax
.Ltarget_form_0090:
# form-0091 integer
orw %ax, -16(%rbp)
.Ltarget_form_0091:
# form-0092 integer
orw $7, %ax
.Ltarget_form_0092:
# form-0093 integer
orw $7, -16(%rbp)
.Ltarget_form_0093:
# form-0094 integer
xorw %ax, %cx
.Ltarget_form_0094:
# form-0095 integer
xorw -16(%rbp), %ax
.Ltarget_form_0095:
# form-0096 integer
xorw %ax, -16(%rbp)
.Ltarget_form_0096:
# form-0097 integer
xorw $7, %ax
.Ltarget_form_0097:
# form-0098 integer
xorw $7, -16(%rbp)
.Ltarget_form_0098:
# form-0099 integer
cmpw %ax, %cx
.Ltarget_form_0099:
# form-0100 integer
cmpw -16(%rbp), %ax
.Ltarget_form_0100:
# form-0101 integer
cmpw %ax, -16(%rbp)
.Ltarget_form_0101:
# form-0102 integer
cmpw $7, %ax
.Ltarget_form_0102:
# form-0103 integer
cmpw $7, -16(%rbp)
.Ltarget_form_0103:
# form-0104 test
testw %ax, %cx
.Ltarget_form_0104:
# form-0105 test
testw %ax, -16(%rbp)
.Ltarget_form_0105:
# form-0106 test
testw $7, %ax
.Ltarget_form_0106:
# form-0107 test
testw $7, -16(%rbp)
.Ltarget_form_0107:
# form-0108 unary
negw %ax
.Ltarget_form_0108:
# form-0109 unary
negw -16(%rbp)
.Ltarget_form_0109:
# form-0110 unary
notw %ax
.Ltarget_form_0110:
# form-0111 unary
notw -16(%rbp)
.Ltarget_form_0111:
# form-0112 shift
shlw $1, %ax
.Ltarget_form_0112:
# form-0113 shift
shlw $1, -16(%rbp)
.Ltarget_form_0113:
# form-0114 shift
shlw $7, %ax
.Ltarget_form_0114:
# form-0115 shift
shlw $7, -16(%rbp)
.Ltarget_form_0115:
# form-0116 shift
shlw %cl, %ax
.Ltarget_form_0116:
# form-0117 shift
shlw %cl, -16(%rbp)
.Ltarget_form_0117:
# form-0118 shift
sarw $1, %ax
.Ltarget_form_0118:
# form-0119 shift
sarw $1, -16(%rbp)
.Ltarget_form_0119:
# form-0120 shift
sarw $7, %ax
.Ltarget_form_0120:
# form-0121 shift
sarw $7, -16(%rbp)
.Ltarget_form_0121:
# form-0122 shift
sarw %cl, %ax
.Ltarget_form_0122:
# form-0123 shift
sarw %cl, -16(%rbp)
.Ltarget_form_0123:
# form-0124 shift
shrw $1, %ax
.Ltarget_form_0124:
# form-0125 shift
shrw $1, -16(%rbp)
.Ltarget_form_0125:
# form-0126 shift
shrw $7, %ax
.Ltarget_form_0126:
# form-0127 shift
shrw $7, -16(%rbp)
.Ltarget_form_0127:
# form-0128 shift
shrw %cl, %ax
.Ltarget_form_0128:
# form-0129 shift
shrw %cl, -16(%rbp)
.Ltarget_form_0129:
# form-0130 division
mulw %cx
.Ltarget_form_0130:
# form-0131 division
mulw -16(%rbp)
.Ltarget_form_0131:
# form-0132 division
imulw %cx
.Ltarget_form_0132:
# form-0133 division
imulw -16(%rbp)
.Ltarget_form_0133:
# form-0134 division
divw %cx
.Ltarget_form_0134:
# form-0135 division
divw -16(%rbp)
.Ltarget_form_0135:
# form-0136 division
idivw %cx
.Ltarget_form_0136:
# form-0137 division
idivw -16(%rbp)
.Ltarget_form_0137:
# form-0138 multiply
imulw %cx, %ax
.Ltarget_form_0138:
# form-0139 multiply
imulw $7, %cx, %ax
.Ltarget_form_0139:
# form-0140 multiply
imulw $1000, %cx, %ax
.Ltarget_form_0140:
# form-0141 multiply
imulw -16(%rbp), %ax
.Ltarget_form_0141:
# form-0142 multiply
imulw $7, -16(%rbp), %ax
.Ltarget_form_0142:
# form-0143 multiply
imulw $1000, -16(%rbp), %ax
.Ltarget_form_0143:
# form-0144 move
movl %eax, %ecx
.Ltarget_form_0144:
# form-0145 move
movl -16(%rbp), %eax
.Ltarget_form_0145:
# form-0146 move
movl %eax, -16(%rbp)
.Ltarget_form_0146:
# form-0147 move
movl $7, %eax
.Ltarget_form_0147:
# form-0148 move
movl $7, -16(%rbp)
.Ltarget_form_0148:
# form-0149 integer
addl %eax, %ecx
.Ltarget_form_0149:
# form-0150 integer
addl -16(%rbp), %eax
.Ltarget_form_0150:
# form-0151 integer
addl %eax, -16(%rbp)
.Ltarget_form_0151:
# form-0152 integer
addl $7, %eax
.Ltarget_form_0152:
# form-0153 integer
addl $7, -16(%rbp)
.Ltarget_form_0153:
# form-0154 integer
subl %eax, %ecx
.Ltarget_form_0154:
# form-0155 integer
subl -16(%rbp), %eax
.Ltarget_form_0155:
# form-0156 integer
subl %eax, -16(%rbp)
.Ltarget_form_0156:
# form-0157 integer
subl $7, %eax
.Ltarget_form_0157:
# form-0158 integer
subl $7, -16(%rbp)
.Ltarget_form_0158:
# form-0159 integer
andl %eax, %ecx
.Ltarget_form_0159:
# form-0160 integer
andl -16(%rbp), %eax
.Ltarget_form_0160:
# form-0161 integer
andl %eax, -16(%rbp)
.Ltarget_form_0161:
# form-0162 integer
andl $7, %eax
.Ltarget_form_0162:
# form-0163 integer
andl $7, -16(%rbp)
.Ltarget_form_0163:
# form-0164 integer
orl %eax, %ecx
.Ltarget_form_0164:
# form-0165 integer
orl -16(%rbp), %eax
.Ltarget_form_0165:
# form-0166 integer
orl %eax, -16(%rbp)
.Ltarget_form_0166:
# form-0167 integer
orl $7, %eax
.Ltarget_form_0167:
# form-0168 integer
orl $7, -16(%rbp)
.Ltarget_form_0168:
# form-0169 integer
xorl %eax, %ecx
.Ltarget_form_0169:
# form-0170 integer
xorl -16(%rbp), %eax
.Ltarget_form_0170:
# form-0171 integer
xorl %eax, -16(%rbp)
.Ltarget_form_0171:
# form-0172 integer
xorl $7, %eax
.Ltarget_form_0172:
# form-0173 integer
xorl $7, -16(%rbp)
.Ltarget_form_0173:
# form-0174 integer
cmpl %eax, %ecx
.Ltarget_form_0174:
# form-0175 integer
cmpl -16(%rbp), %eax
.Ltarget_form_0175:
# form-0176 integer
cmpl %eax, -16(%rbp)
.Ltarget_form_0176:
# form-0177 integer
cmpl $7, %eax
.Ltarget_form_0177:
# form-0178 integer
cmpl $7, -16(%rbp)
.Ltarget_form_0178:
# form-0179 test
testl %eax, %ecx
.Ltarget_form_0179:
# form-0180 test
testl %eax, -16(%rbp)
.Ltarget_form_0180:
# form-0181 test
testl $7, %eax
.Ltarget_form_0181:
# form-0182 test
testl $7, -16(%rbp)
.Ltarget_form_0182:
# form-0183 unary
negl %eax
.Ltarget_form_0183:
# form-0184 unary
negl -16(%rbp)
.Ltarget_form_0184:
# form-0185 unary
notl %eax
.Ltarget_form_0185:
# form-0186 unary
notl -16(%rbp)
.Ltarget_form_0186:
# form-0187 shift
shll $1, %eax
.Ltarget_form_0187:
# form-0188 shift
shll $1, -16(%rbp)
.Ltarget_form_0188:
# form-0189 shift
shll $7, %eax
.Ltarget_form_0189:
# form-0190 shift
shll $7, -16(%rbp)
.Ltarget_form_0190:
# form-0191 shift
shll %cl, %eax
.Ltarget_form_0191:
# form-0192 shift
shll %cl, -16(%rbp)
.Ltarget_form_0192:
# form-0193 shift
sarl $1, %eax
.Ltarget_form_0193:
# form-0194 shift
sarl $1, -16(%rbp)
.Ltarget_form_0194:
# form-0195 shift
sarl $7, %eax
.Ltarget_form_0195:
# form-0196 shift
sarl $7, -16(%rbp)
.Ltarget_form_0196:
# form-0197 shift
sarl %cl, %eax
.Ltarget_form_0197:
# form-0198 shift
sarl %cl, -16(%rbp)
.Ltarget_form_0198:
# form-0199 shift
shrl $1, %eax
.Ltarget_form_0199:
# form-0200 shift
shrl $1, -16(%rbp)
.Ltarget_form_0200:
# form-0201 shift
shrl $7, %eax
.Ltarget_form_0201:
# form-0202 shift
shrl $7, -16(%rbp)
.Ltarget_form_0202:
# form-0203 shift
shrl %cl, %eax
.Ltarget_form_0203:
# form-0204 shift
shrl %cl, -16(%rbp)
.Ltarget_form_0204:
# form-0205 division
mull %ecx
.Ltarget_form_0205:
# form-0206 division
mull -16(%rbp)
.Ltarget_form_0206:
# form-0207 division
imull %ecx
.Ltarget_form_0207:
# form-0208 division
imull -16(%rbp)
.Ltarget_form_0208:
# form-0209 division
divl %ecx
.Ltarget_form_0209:
# form-0210 division
divl -16(%rbp)
.Ltarget_form_0210:
# form-0211 division
idivl %ecx
.Ltarget_form_0211:
# form-0212 division
idivl -16(%rbp)
.Ltarget_form_0212:
# form-0213 multiply
imull %ecx, %eax
.Ltarget_form_0213:
# form-0214 multiply
imull $7, %ecx, %eax
.Ltarget_form_0214:
# form-0215 multiply
imull $1000, %ecx, %eax
.Ltarget_form_0215:
# form-0216 multiply
imull -16(%rbp), %eax
.Ltarget_form_0216:
# form-0217 multiply
imull $7, -16(%rbp), %eax
.Ltarget_form_0217:
# form-0218 multiply
imull $1000, -16(%rbp), %eax
.Ltarget_form_0218:
# form-0219 move
movq %rax, %rcx
.Ltarget_form_0219:
# form-0220 move
movq -16(%rbp), %rax
.Ltarget_form_0220:
# form-0221 move
movq %rax, -16(%rbp)
.Ltarget_form_0221:
# form-0222 move
movq $7, %rax
.Ltarget_form_0222:
# form-0223 move
movq $7, -16(%rbp)
.Ltarget_form_0223:
# form-0224 integer
addq %rax, %rcx
.Ltarget_form_0224:
# form-0225 integer
addq -16(%rbp), %rax
.Ltarget_form_0225:
# form-0226 integer
addq %rax, -16(%rbp)
.Ltarget_form_0226:
# form-0227 integer
addq $7, %rax
.Ltarget_form_0227:
# form-0228 integer
addq $7, -16(%rbp)
.Ltarget_form_0228:
# form-0229 integer
subq %rax, %rcx
.Ltarget_form_0229:
# form-0230 integer
subq -16(%rbp), %rax
.Ltarget_form_0230:
# form-0231 integer
subq %rax, -16(%rbp)
.Ltarget_form_0231:
# form-0232 integer
subq $7, %rax
.Ltarget_form_0232:
# form-0233 integer
subq $7, -16(%rbp)
.Ltarget_form_0233:
# form-0234 integer
andq %rax, %rcx
.Ltarget_form_0234:
# form-0235 integer
andq -16(%rbp), %rax
.Ltarget_form_0235:
# form-0236 integer
andq %rax, -16(%rbp)
.Ltarget_form_0236:
# form-0237 integer
andq $7, %rax
.Ltarget_form_0237:
# form-0238 integer
andq $7, -16(%rbp)
.Ltarget_form_0238:
# form-0239 integer
orq %rax, %rcx
.Ltarget_form_0239:
# form-0240 integer
orq -16(%rbp), %rax
.Ltarget_form_0240:
# form-0241 integer
orq %rax, -16(%rbp)
.Ltarget_form_0241:
# form-0242 integer
orq $7, %rax
.Ltarget_form_0242:
# form-0243 integer
orq $7, -16(%rbp)
.Ltarget_form_0243:
# form-0244 integer
xorq %rax, %rcx
.Ltarget_form_0244:
# form-0245 integer
xorq -16(%rbp), %rax
.Ltarget_form_0245:
# form-0246 integer
xorq %rax, -16(%rbp)
.Ltarget_form_0246:
# form-0247 integer
xorq $7, %rax
.Ltarget_form_0247:
# form-0248 integer
xorq $7, -16(%rbp)
.Ltarget_form_0248:
# form-0249 integer
cmpq %rax, %rcx
.Ltarget_form_0249:
# form-0250 integer
cmpq -16(%rbp), %rax
.Ltarget_form_0250:
# form-0251 integer
cmpq %rax, -16(%rbp)
.Ltarget_form_0251:
# form-0252 integer
cmpq $7, %rax
.Ltarget_form_0252:
# form-0253 integer
cmpq $7, -16(%rbp)
.Ltarget_form_0253:
# form-0254 test
testq %rax, %rcx
.Ltarget_form_0254:
# form-0255 test
testq %rax, -16(%rbp)
.Ltarget_form_0255:
# form-0256 test
testq $7, %rax
.Ltarget_form_0256:
# form-0257 test
testq $7, -16(%rbp)
.Ltarget_form_0257:
# form-0258 unary
negq %rax
.Ltarget_form_0258:
# form-0259 unary
negq -16(%rbp)
.Ltarget_form_0259:
# form-0260 unary
notq %rax
.Ltarget_form_0260:
# form-0261 unary
notq -16(%rbp)
.Ltarget_form_0261:
# form-0262 shift
shlq $1, %rax
.Ltarget_form_0262:
# form-0263 shift
shlq $1, -16(%rbp)
.Ltarget_form_0263:
# form-0264 shift
shlq $7, %rax
.Ltarget_form_0264:
# form-0265 shift
shlq $7, -16(%rbp)
.Ltarget_form_0265:
# form-0266 shift
shlq %cl, %rax
.Ltarget_form_0266:
# form-0267 shift
shlq %cl, -16(%rbp)
.Ltarget_form_0267:
# form-0268 shift
sarq $1, %rax
.Ltarget_form_0268:
# form-0269 shift
sarq $1, -16(%rbp)
.Ltarget_form_0269:
# form-0270 shift
sarq $7, %rax
.Ltarget_form_0270:
# form-0271 shift
sarq $7, -16(%rbp)
.Ltarget_form_0271:
# form-0272 shift
sarq %cl, %rax
.Ltarget_form_0272:
# form-0273 shift
sarq %cl, -16(%rbp)
.Ltarget_form_0273:
# form-0274 shift
shrq $1, %rax
.Ltarget_form_0274:
# form-0275 shift
shrq $1, -16(%rbp)
.Ltarget_form_0275:
# form-0276 shift
shrq $7, %rax
.Ltarget_form_0276:
# form-0277 shift
shrq $7, -16(%rbp)
.Ltarget_form_0277:
# form-0278 shift
shrq %cl, %rax
.Ltarget_form_0278:
# form-0279 shift
shrq %cl, -16(%rbp)
.Ltarget_form_0279:
# form-0280 division
mulq %rcx
.Ltarget_form_0280:
# form-0281 division
mulq -16(%rbp)
.Ltarget_form_0281:
# form-0282 division
imulq %rcx
.Ltarget_form_0282:
# form-0283 division
imulq -16(%rbp)
.Ltarget_form_0283:
# form-0284 division
divq %rcx
.Ltarget_form_0284:
# form-0285 division
divq -16(%rbp)
.Ltarget_form_0285:
# form-0286 division
idivq %rcx
.Ltarget_form_0286:
# form-0287 division
idivq -16(%rbp)
.Ltarget_form_0287:
# form-0288 multiply
imulq %rcx, %rax
.Ltarget_form_0288:
# form-0289 multiply
imulq $7, %rcx, %rax
.Ltarget_form_0289:
# form-0290 multiply
imulq $1000, %rcx, %rax
.Ltarget_form_0290:
# form-0291 multiply
imulq -16(%rbp), %rax
.Ltarget_form_0291:
# form-0292 multiply
imulq $7, -16(%rbp), %rax
.Ltarget_form_0292:
# form-0293 multiply
imulq $1000, -16(%rbp), %rax
.Ltarget_form_0293:
# form-0294 branch
ja .Ltarget_form_0294
.Ltarget_form_0294:
# form-0295 set-condition
seta %al
.Ltarget_form_0295:
# form-0296 set-condition
seta %r8b
.Ltarget_form_0296:
# form-0297 set-condition
seta -16(%rbp)
.Ltarget_form_0297:
# form-0298 conditional-move
cmovaw %cx, %ax
.Ltarget_form_0298:
# form-0299 conditional-move
cmovaw -16(%rbp), %ax
.Ltarget_form_0299:
# form-0300 conditional-move
cmoval %ecx, %eax
.Ltarget_form_0300:
# form-0301 conditional-move
cmoval -16(%rbp), %eax
.Ltarget_form_0301:
# form-0302 conditional-move
cmovaq %rcx, %rax
.Ltarget_form_0302:
# form-0303 conditional-move
cmovaq -16(%rbp), %rax
.Ltarget_form_0303:
# form-0304 branch
jae .Ltarget_form_0304
.Ltarget_form_0304:
# form-0305 set-condition
setae %al
.Ltarget_form_0305:
# form-0306 set-condition
setae %r8b
.Ltarget_form_0306:
# form-0307 set-condition
setae -16(%rbp)
.Ltarget_form_0307:
# form-0308 conditional-move
cmovaew %cx, %ax
.Ltarget_form_0308:
# form-0309 conditional-move
cmovaew -16(%rbp), %ax
.Ltarget_form_0309:
# form-0310 conditional-move
cmovael %ecx, %eax
.Ltarget_form_0310:
# form-0311 conditional-move
cmovael -16(%rbp), %eax
.Ltarget_form_0311:
# form-0312 conditional-move
cmovaeq %rcx, %rax
.Ltarget_form_0312:
# form-0313 conditional-move
cmovaeq -16(%rbp), %rax
.Ltarget_form_0313:
# form-0314 branch
jb .Ltarget_form_0314
.Ltarget_form_0314:
# form-0315 set-condition
setb %al
.Ltarget_form_0315:
# form-0316 set-condition
setb %r8b
.Ltarget_form_0316:
# form-0317 set-condition
setb -16(%rbp)
.Ltarget_form_0317:
# form-0318 conditional-move
cmovbw %cx, %ax
.Ltarget_form_0318:
# form-0319 conditional-move
cmovbw -16(%rbp), %ax
.Ltarget_form_0319:
# form-0320 conditional-move
cmovbl %ecx, %eax
.Ltarget_form_0320:
# form-0321 conditional-move
cmovbl -16(%rbp), %eax
.Ltarget_form_0321:
# form-0322 conditional-move
cmovbq %rcx, %rax
.Ltarget_form_0322:
# form-0323 conditional-move
cmovbq -16(%rbp), %rax
.Ltarget_form_0323:
# form-0324 branch
jbe .Ltarget_form_0324
.Ltarget_form_0324:
# form-0325 set-condition
setbe %al
.Ltarget_form_0325:
# form-0326 set-condition
setbe %r8b
.Ltarget_form_0326:
# form-0327 set-condition
setbe -16(%rbp)
.Ltarget_form_0327:
# form-0328 conditional-move
cmovbew %cx, %ax
.Ltarget_form_0328:
# form-0329 conditional-move
cmovbew -16(%rbp), %ax
.Ltarget_form_0329:
# form-0330 conditional-move
cmovbel %ecx, %eax
.Ltarget_form_0330:
# form-0331 conditional-move
cmovbel -16(%rbp), %eax
.Ltarget_form_0331:
# form-0332 conditional-move
cmovbeq %rcx, %rax
.Ltarget_form_0332:
# form-0333 conditional-move
cmovbeq -16(%rbp), %rax
.Ltarget_form_0333:
# form-0334 branch
jc .Ltarget_form_0334
.Ltarget_form_0334:
# form-0335 set-condition
setc %al
.Ltarget_form_0335:
# form-0336 set-condition
setc %r8b
.Ltarget_form_0336:
# form-0337 set-condition
setc -16(%rbp)
.Ltarget_form_0337:
# form-0338 conditional-move
cmovcw %cx, %ax
.Ltarget_form_0338:
# form-0339 conditional-move
cmovcw -16(%rbp), %ax
.Ltarget_form_0339:
# form-0340 conditional-move
cmovcl %ecx, %eax
.Ltarget_form_0340:
# form-0341 conditional-move
cmovcl -16(%rbp), %eax
.Ltarget_form_0341:
# form-0342 conditional-move
cmovcq %rcx, %rax
.Ltarget_form_0342:
# form-0343 conditional-move
cmovcq -16(%rbp), %rax
.Ltarget_form_0343:
# form-0344 branch
je .Ltarget_form_0344
.Ltarget_form_0344:
# form-0345 set-condition
sete %al
.Ltarget_form_0345:
# form-0346 set-condition
sete %r8b
.Ltarget_form_0346:
# form-0347 set-condition
sete -16(%rbp)
.Ltarget_form_0347:
# form-0348 conditional-move
cmovew %cx, %ax
.Ltarget_form_0348:
# form-0349 conditional-move
cmovew -16(%rbp), %ax
.Ltarget_form_0349:
# form-0350 conditional-move
cmovel %ecx, %eax
.Ltarget_form_0350:
# form-0351 conditional-move
cmovel -16(%rbp), %eax
.Ltarget_form_0351:
# form-0352 conditional-move
cmoveq %rcx, %rax
.Ltarget_form_0352:
# form-0353 conditional-move
cmoveq -16(%rbp), %rax
.Ltarget_form_0353:
# form-0354 branch
jg .Ltarget_form_0354
.Ltarget_form_0354:
# form-0355 set-condition
setg %al
.Ltarget_form_0355:
# form-0356 set-condition
setg %r8b
.Ltarget_form_0356:
# form-0357 set-condition
setg -16(%rbp)
.Ltarget_form_0357:
# form-0358 conditional-move
cmovgw %cx, %ax
.Ltarget_form_0358:
# form-0359 conditional-move
cmovgw -16(%rbp), %ax
.Ltarget_form_0359:
# form-0360 conditional-move
cmovgl %ecx, %eax
.Ltarget_form_0360:
# form-0361 conditional-move
cmovgl -16(%rbp), %eax
.Ltarget_form_0361:
# form-0362 conditional-move
cmovgq %rcx, %rax
.Ltarget_form_0362:
# form-0363 conditional-move
cmovgq -16(%rbp), %rax
.Ltarget_form_0363:
# form-0364 branch
jge .Ltarget_form_0364
.Ltarget_form_0364:
# form-0365 set-condition
setge %al
.Ltarget_form_0365:
# form-0366 set-condition
setge %r8b
.Ltarget_form_0366:
# form-0367 set-condition
setge -16(%rbp)
.Ltarget_form_0367:
# form-0368 conditional-move
cmovgew %cx, %ax
.Ltarget_form_0368:
# form-0369 conditional-move
cmovgew -16(%rbp), %ax
.Ltarget_form_0369:
# form-0370 conditional-move
cmovgel %ecx, %eax
.Ltarget_form_0370:
# form-0371 conditional-move
cmovgel -16(%rbp), %eax
.Ltarget_form_0371:
# form-0372 conditional-move
cmovgeq %rcx, %rax
.Ltarget_form_0372:
# form-0373 conditional-move
cmovgeq -16(%rbp), %rax
.Ltarget_form_0373:
# form-0374 branch
jl .Ltarget_form_0374
.Ltarget_form_0374:
# form-0375 set-condition
setl %al
.Ltarget_form_0375:
# form-0376 set-condition
setl %r8b
.Ltarget_form_0376:
# form-0377 set-condition
setl -16(%rbp)
.Ltarget_form_0377:
# form-0378 conditional-move
cmovlw %cx, %ax
.Ltarget_form_0378:
# form-0379 conditional-move
cmovlw -16(%rbp), %ax
.Ltarget_form_0379:
# form-0380 conditional-move
cmovll %ecx, %eax
.Ltarget_form_0380:
# form-0381 conditional-move
cmovll -16(%rbp), %eax
.Ltarget_form_0381:
# form-0382 conditional-move
cmovlq %rcx, %rax
.Ltarget_form_0382:
# form-0383 conditional-move
cmovlq -16(%rbp), %rax
.Ltarget_form_0383:
# form-0384 branch
jle .Ltarget_form_0384
.Ltarget_form_0384:
# form-0385 set-condition
setle %al
.Ltarget_form_0385:
# form-0386 set-condition
setle %r8b
.Ltarget_form_0386:
# form-0387 set-condition
setle -16(%rbp)
.Ltarget_form_0387:
# form-0388 conditional-move
cmovlew %cx, %ax
.Ltarget_form_0388:
# form-0389 conditional-move
cmovlew -16(%rbp), %ax
.Ltarget_form_0389:
# form-0390 conditional-move
cmovlel %ecx, %eax
.Ltarget_form_0390:
# form-0391 conditional-move
cmovlel -16(%rbp), %eax
.Ltarget_form_0391:
# form-0392 conditional-move
cmovleq %rcx, %rax
.Ltarget_form_0392:
# form-0393 conditional-move
cmovleq -16(%rbp), %rax
.Ltarget_form_0393:
# form-0394 branch
jna .Ltarget_form_0394
.Ltarget_form_0394:
# form-0395 set-condition
setna %al
.Ltarget_form_0395:
# form-0396 set-condition
setna %r8b
.Ltarget_form_0396:
# form-0397 set-condition
setna -16(%rbp)
.Ltarget_form_0397:
# form-0398 conditional-move
cmovnaw %cx, %ax
.Ltarget_form_0398:
# form-0399 conditional-move
cmovnaw -16(%rbp), %ax
.Ltarget_form_0399:
# form-0400 conditional-move
cmovnal %ecx, %eax
.Ltarget_form_0400:
# form-0401 conditional-move
cmovnal -16(%rbp), %eax
.Ltarget_form_0401:
# form-0402 conditional-move
cmovnaq %rcx, %rax
.Ltarget_form_0402:
# form-0403 conditional-move
cmovnaq -16(%rbp), %rax
.Ltarget_form_0403:
# form-0404 branch
jnae .Ltarget_form_0404
.Ltarget_form_0404:
# form-0405 set-condition
setnae %al
.Ltarget_form_0405:
# form-0406 set-condition
setnae %r8b
.Ltarget_form_0406:
# form-0407 set-condition
setnae -16(%rbp)
.Ltarget_form_0407:
# form-0408 conditional-move
cmovnaew %cx, %ax
.Ltarget_form_0408:
# form-0409 conditional-move
cmovnaew -16(%rbp), %ax
.Ltarget_form_0409:
# form-0410 conditional-move
cmovnael %ecx, %eax
.Ltarget_form_0410:
# form-0411 conditional-move
cmovnael -16(%rbp), %eax
.Ltarget_form_0411:
# form-0412 conditional-move
cmovnaeq %rcx, %rax
.Ltarget_form_0412:
# form-0413 conditional-move
cmovnaeq -16(%rbp), %rax
.Ltarget_form_0413:
# form-0414 branch
jnb .Ltarget_form_0414
.Ltarget_form_0414:
# form-0415 set-condition
setnb %al
.Ltarget_form_0415:
# form-0416 set-condition
setnb %r8b
.Ltarget_form_0416:
# form-0417 set-condition
setnb -16(%rbp)
.Ltarget_form_0417:
# form-0418 conditional-move
cmovnbw %cx, %ax
.Ltarget_form_0418:
# form-0419 conditional-move
cmovnbw -16(%rbp), %ax
.Ltarget_form_0419:
# form-0420 conditional-move
cmovnbl %ecx, %eax
.Ltarget_form_0420:
# form-0421 conditional-move
cmovnbl -16(%rbp), %eax
.Ltarget_form_0421:
# form-0422 conditional-move
cmovnbq %rcx, %rax
.Ltarget_form_0422:
# form-0423 conditional-move
cmovnbq -16(%rbp), %rax
.Ltarget_form_0423:
# form-0424 branch
jnbe .Ltarget_form_0424
.Ltarget_form_0424:
# form-0425 set-condition
setnbe %al
.Ltarget_form_0425:
# form-0426 set-condition
setnbe %r8b
.Ltarget_form_0426:
# form-0427 set-condition
setnbe -16(%rbp)
.Ltarget_form_0427:
# form-0428 conditional-move
cmovnbew %cx, %ax
.Ltarget_form_0428:
# form-0429 conditional-move
cmovnbew -16(%rbp), %ax
.Ltarget_form_0429:
# form-0430 conditional-move
cmovnbel %ecx, %eax
.Ltarget_form_0430:
# form-0431 conditional-move
cmovnbel -16(%rbp), %eax
.Ltarget_form_0431:
# form-0432 conditional-move
cmovnbeq %rcx, %rax
.Ltarget_form_0432:
# form-0433 conditional-move
cmovnbeq -16(%rbp), %rax
.Ltarget_form_0433:
# form-0434 branch
jnc .Ltarget_form_0434
.Ltarget_form_0434:
# form-0435 set-condition
setnc %al
.Ltarget_form_0435:
# form-0436 set-condition
setnc %r8b
.Ltarget_form_0436:
# form-0437 set-condition
setnc -16(%rbp)
.Ltarget_form_0437:
# form-0438 conditional-move
cmovncw %cx, %ax
.Ltarget_form_0438:
# form-0439 conditional-move
cmovncw -16(%rbp), %ax
.Ltarget_form_0439:
# form-0440 conditional-move
cmovncl %ecx, %eax
.Ltarget_form_0440:
# form-0441 conditional-move
cmovncl -16(%rbp), %eax
.Ltarget_form_0441:
# form-0442 conditional-move
cmovncq %rcx, %rax
.Ltarget_form_0442:
# form-0443 conditional-move
cmovncq -16(%rbp), %rax
.Ltarget_form_0443:
# form-0444 branch
jne .Ltarget_form_0444
.Ltarget_form_0444:
# form-0445 set-condition
setne %al
.Ltarget_form_0445:
# form-0446 set-condition
setne %r8b
.Ltarget_form_0446:
# form-0447 set-condition
setne -16(%rbp)
.Ltarget_form_0447:
# form-0448 conditional-move
cmovnew %cx, %ax
.Ltarget_form_0448:
# form-0449 conditional-move
cmovnew -16(%rbp), %ax
.Ltarget_form_0449:
# form-0450 conditional-move
cmovnel %ecx, %eax
.Ltarget_form_0450:
# form-0451 conditional-move
cmovnel -16(%rbp), %eax
.Ltarget_form_0451:
# form-0452 conditional-move
cmovneq %rcx, %rax
.Ltarget_form_0452:
# form-0453 conditional-move
cmovneq -16(%rbp), %rax
.Ltarget_form_0453:
# form-0454 branch
jng .Ltarget_form_0454
.Ltarget_form_0454:
# form-0455 set-condition
setng %al
.Ltarget_form_0455:
# form-0456 set-condition
setng %r8b
.Ltarget_form_0456:
# form-0457 set-condition
setng -16(%rbp)
.Ltarget_form_0457:
# form-0458 conditional-move
cmovngw %cx, %ax
.Ltarget_form_0458:
# form-0459 conditional-move
cmovngw -16(%rbp), %ax
.Ltarget_form_0459:
# form-0460 conditional-move
cmovngl %ecx, %eax
.Ltarget_form_0460:
# form-0461 conditional-move
cmovngl -16(%rbp), %eax
.Ltarget_form_0461:
# form-0462 conditional-move
cmovngq %rcx, %rax
.Ltarget_form_0462:
# form-0463 conditional-move
cmovngq -16(%rbp), %rax
.Ltarget_form_0463:
# form-0464 branch
jnge .Ltarget_form_0464
.Ltarget_form_0464:
# form-0465 set-condition
setnge %al
.Ltarget_form_0465:
# form-0466 set-condition
setnge %r8b
.Ltarget_form_0466:
# form-0467 set-condition
setnge -16(%rbp)
.Ltarget_form_0467:
# form-0468 conditional-move
cmovngew %cx, %ax
.Ltarget_form_0468:
# form-0469 conditional-move
cmovngew -16(%rbp), %ax
.Ltarget_form_0469:
# form-0470 conditional-move
cmovngel %ecx, %eax
.Ltarget_form_0470:
# form-0471 conditional-move
cmovngel -16(%rbp), %eax
.Ltarget_form_0471:
# form-0472 conditional-move
cmovngeq %rcx, %rax
.Ltarget_form_0472:
# form-0473 conditional-move
cmovngeq -16(%rbp), %rax
.Ltarget_form_0473:
# form-0474 branch
jnl .Ltarget_form_0474
.Ltarget_form_0474:
# form-0475 set-condition
setnl %al
.Ltarget_form_0475:
# form-0476 set-condition
setnl %r8b
.Ltarget_form_0476:
# form-0477 set-condition
setnl -16(%rbp)
.Ltarget_form_0477:
# form-0478 conditional-move
cmovnlw %cx, %ax
.Ltarget_form_0478:
# form-0479 conditional-move
cmovnlw -16(%rbp), %ax
.Ltarget_form_0479:
# form-0480 conditional-move
cmovnll %ecx, %eax
.Ltarget_form_0480:
# form-0481 conditional-move
cmovnll -16(%rbp), %eax
.Ltarget_form_0481:
# form-0482 conditional-move
cmovnlq %rcx, %rax
.Ltarget_form_0482:
# form-0483 conditional-move
cmovnlq -16(%rbp), %rax
.Ltarget_form_0483:
# form-0484 branch
jnle .Ltarget_form_0484
.Ltarget_form_0484:
# form-0485 set-condition
setnle %al
.Ltarget_form_0485:
# form-0486 set-condition
setnle %r8b
.Ltarget_form_0486:
# form-0487 set-condition
setnle -16(%rbp)
.Ltarget_form_0487:
# form-0488 conditional-move
cmovnlew %cx, %ax
.Ltarget_form_0488:
# form-0489 conditional-move
cmovnlew -16(%rbp), %ax
.Ltarget_form_0489:
# form-0490 conditional-move
cmovnlel %ecx, %eax
.Ltarget_form_0490:
# form-0491 conditional-move
cmovnlel -16(%rbp), %eax
.Ltarget_form_0491:
# form-0492 conditional-move
cmovnleq %rcx, %rax
.Ltarget_form_0492:
# form-0493 conditional-move
cmovnleq -16(%rbp), %rax
.Ltarget_form_0493:
# form-0494 branch
jno .Ltarget_form_0494
.Ltarget_form_0494:
# form-0495 set-condition
setno %al
.Ltarget_form_0495:
# form-0496 set-condition
setno %r8b
.Ltarget_form_0496:
# form-0497 set-condition
setno -16(%rbp)
.Ltarget_form_0497:
# form-0498 conditional-move
cmovnow %cx, %ax
.Ltarget_form_0498:
# form-0499 conditional-move
cmovnow -16(%rbp), %ax
.Ltarget_form_0499:
# form-0500 conditional-move
cmovnol %ecx, %eax
.Ltarget_form_0500:
# form-0501 conditional-move
cmovnol -16(%rbp), %eax
.Ltarget_form_0501:
# form-0502 conditional-move
cmovnoq %rcx, %rax
.Ltarget_form_0502:
# form-0503 conditional-move
cmovnoq -16(%rbp), %rax
.Ltarget_form_0503:
# form-0504 branch
jnp .Ltarget_form_0504
.Ltarget_form_0504:
# form-0505 set-condition
setnp %al
.Ltarget_form_0505:
# form-0506 set-condition
setnp %r8b
.Ltarget_form_0506:
# form-0507 set-condition
setnp -16(%rbp)
.Ltarget_form_0507:
# form-0508 conditional-move
cmovnpw %cx, %ax
.Ltarget_form_0508:
# form-0509 conditional-move
cmovnpw -16(%rbp), %ax
.Ltarget_form_0509:
# form-0510 conditional-move
cmovnpl %ecx, %eax
.Ltarget_form_0510:
# form-0511 conditional-move
cmovnpl -16(%rbp), %eax
.Ltarget_form_0511:
# form-0512 conditional-move
cmovnpq %rcx, %rax
.Ltarget_form_0512:
# form-0513 conditional-move
cmovnpq -16(%rbp), %rax
.Ltarget_form_0513:
# form-0514 branch
jns .Ltarget_form_0514
.Ltarget_form_0514:
# form-0515 set-condition
setns %al
.Ltarget_form_0515:
# form-0516 set-condition
setns %r8b
.Ltarget_form_0516:
# form-0517 set-condition
setns -16(%rbp)
.Ltarget_form_0517:
# form-0518 conditional-move
cmovnsw %cx, %ax
.Ltarget_form_0518:
# form-0519 conditional-move
cmovnsw -16(%rbp), %ax
.Ltarget_form_0519:
# form-0520 conditional-move
cmovnsl %ecx, %eax
.Ltarget_form_0520:
# form-0521 conditional-move
cmovnsl -16(%rbp), %eax
.Ltarget_form_0521:
# form-0522 conditional-move
cmovnsq %rcx, %rax
.Ltarget_form_0522:
# form-0523 conditional-move
cmovnsq -16(%rbp), %rax
.Ltarget_form_0523:
# form-0524 branch
jnz .Ltarget_form_0524
.Ltarget_form_0524:
# form-0525 set-condition
setnz %al
.Ltarget_form_0525:
# form-0526 set-condition
setnz %r8b
.Ltarget_form_0526:
# form-0527 set-condition
setnz -16(%rbp)
.Ltarget_form_0527:
# form-0528 conditional-move
cmovnzw %cx, %ax
.Ltarget_form_0528:
# form-0529 conditional-move
cmovnzw -16(%rbp), %ax
.Ltarget_form_0529:
# form-0530 conditional-move
cmovnzl %ecx, %eax
.Ltarget_form_0530:
# form-0531 conditional-move
cmovnzl -16(%rbp), %eax
.Ltarget_form_0531:
# form-0532 conditional-move
cmovnzq %rcx, %rax
.Ltarget_form_0532:
# form-0533 conditional-move
cmovnzq -16(%rbp), %rax
.Ltarget_form_0533:
# form-0534 branch
jo .Ltarget_form_0534
.Ltarget_form_0534:
# form-0535 set-condition
seto %al
.Ltarget_form_0535:
# form-0536 set-condition
seto %r8b
.Ltarget_form_0536:
# form-0537 set-condition
seto -16(%rbp)
.Ltarget_form_0537:
# form-0538 conditional-move
cmovow %cx, %ax
.Ltarget_form_0538:
# form-0539 conditional-move
cmovow -16(%rbp), %ax
.Ltarget_form_0539:
# form-0540 conditional-move
cmovol %ecx, %eax
.Ltarget_form_0540:
# form-0541 conditional-move
cmovol -16(%rbp), %eax
.Ltarget_form_0541:
# form-0542 conditional-move
cmovoq %rcx, %rax
.Ltarget_form_0542:
# form-0543 conditional-move
cmovoq -16(%rbp), %rax
.Ltarget_form_0543:
# form-0544 branch
jp .Ltarget_form_0544
.Ltarget_form_0544:
# form-0545 set-condition
setp %al
.Ltarget_form_0545:
# form-0546 set-condition
setp %r8b
.Ltarget_form_0546:
# form-0547 set-condition
setp -16(%rbp)
.Ltarget_form_0547:
# form-0548 conditional-move
cmovpw %cx, %ax
.Ltarget_form_0548:
# form-0549 conditional-move
cmovpw -16(%rbp), %ax
.Ltarget_form_0549:
# form-0550 conditional-move
cmovpl %ecx, %eax
.Ltarget_form_0550:
# form-0551 conditional-move
cmovpl -16(%rbp), %eax
.Ltarget_form_0551:
# form-0552 conditional-move
cmovpq %rcx, %rax
.Ltarget_form_0552:
# form-0553 conditional-move
cmovpq -16(%rbp), %rax
.Ltarget_form_0553:
# form-0554 branch
jpe .Ltarget_form_0554
.Ltarget_form_0554:
# form-0555 set-condition
setpe %al
.Ltarget_form_0555:
# form-0556 set-condition
setpe %r8b
.Ltarget_form_0556:
# form-0557 set-condition
setpe -16(%rbp)
.Ltarget_form_0557:
# form-0558 conditional-move
cmovpew %cx, %ax
.Ltarget_form_0558:
# form-0559 conditional-move
cmovpew -16(%rbp), %ax
.Ltarget_form_0559:
# form-0560 conditional-move
cmovpel %ecx, %eax
.Ltarget_form_0560:
# form-0561 conditional-move
cmovpel -16(%rbp), %eax
.Ltarget_form_0561:
# form-0562 conditional-move
cmovpeq %rcx, %rax
.Ltarget_form_0562:
# form-0563 conditional-move
cmovpeq -16(%rbp), %rax
.Ltarget_form_0563:
# form-0564 branch
jpo .Ltarget_form_0564
.Ltarget_form_0564:
# form-0565 set-condition
setpo %al
.Ltarget_form_0565:
# form-0566 set-condition
setpo %r8b
.Ltarget_form_0566:
# form-0567 set-condition
setpo -16(%rbp)
.Ltarget_form_0567:
# form-0568 conditional-move
cmovpow %cx, %ax
.Ltarget_form_0568:
# form-0569 conditional-move
cmovpow -16(%rbp), %ax
.Ltarget_form_0569:
# form-0570 conditional-move
cmovpol %ecx, %eax
.Ltarget_form_0570:
# form-0571 conditional-move
cmovpol -16(%rbp), %eax
.Ltarget_form_0571:
# form-0572 conditional-move
cmovpoq %rcx, %rax
.Ltarget_form_0572:
# form-0573 conditional-move
cmovpoq -16(%rbp), %rax
.Ltarget_form_0573:
# form-0574 branch
js .Ltarget_form_0574
.Ltarget_form_0574:
# form-0575 set-condition
sets %al
.Ltarget_form_0575:
# form-0576 set-condition
sets %r8b
.Ltarget_form_0576:
# form-0577 set-condition
sets -16(%rbp)
.Ltarget_form_0577:
# form-0578 conditional-move
cmovsw %cx, %ax
.Ltarget_form_0578:
# form-0579 conditional-move
cmovsw -16(%rbp), %ax
.Ltarget_form_0579:
# form-0580 conditional-move
cmovsl %ecx, %eax
.Ltarget_form_0580:
# form-0581 conditional-move
cmovsl -16(%rbp), %eax
.Ltarget_form_0581:
# form-0582 conditional-move
cmovsq %rcx, %rax
.Ltarget_form_0582:
# form-0583 conditional-move
cmovsq -16(%rbp), %rax
.Ltarget_form_0583:
# form-0584 branch
jz .Ltarget_form_0584
.Ltarget_form_0584:
# form-0585 set-condition
setz %al
.Ltarget_form_0585:
# form-0586 set-condition
setz %r8b
.Ltarget_form_0586:
# form-0587 set-condition
setz -16(%rbp)
.Ltarget_form_0587:
# form-0588 conditional-move
cmovzw %cx, %ax
.Ltarget_form_0588:
# form-0589 conditional-move
cmovzw -16(%rbp), %ax
.Ltarget_form_0589:
# form-0590 conditional-move
cmovzl %ecx, %eax
.Ltarget_form_0590:
# form-0591 conditional-move
cmovzl -16(%rbp), %eax
.Ltarget_form_0591:
# form-0592 conditional-move
cmovzq %rcx, %rax
.Ltarget_form_0592:
# form-0593 conditional-move
cmovzq -16(%rbp), %rax
.Ltarget_form_0593:
# form-0594 extension
movsbw %cl, %ax
.Ltarget_form_0594:
# form-0595 extension
movsbw -16(%rbp), %ax
.Ltarget_form_0595:
# form-0596 extension
movsbl %cl, %eax
.Ltarget_form_0596:
# form-0597 extension
movsbl -16(%rbp), %eax
.Ltarget_form_0597:
# form-0598 extension
movsbq %cl, %rax
.Ltarget_form_0598:
# form-0599 extension
movsbq -16(%rbp), %rax
.Ltarget_form_0599:
# form-0600 extension
movswl %cx, %eax
.Ltarget_form_0600:
# form-0601 extension
movswl -16(%rbp), %eax
.Ltarget_form_0601:
# form-0602 extension
movswq %cx, %rax
.Ltarget_form_0602:
# form-0603 extension
movswq -16(%rbp), %rax
.Ltarget_form_0603:
# form-0604 extension
movslq %ecx, %rax
.Ltarget_form_0604:
# form-0605 extension
movslq -16(%rbp), %rax
.Ltarget_form_0605:
# form-0606 extension
movzbw %cl, %ax
.Ltarget_form_0606:
# form-0607 extension
movzbw -16(%rbp), %ax
.Ltarget_form_0607:
# form-0608 extension
movzbl %cl, %eax
.Ltarget_form_0608:
# form-0609 extension
movzbl -16(%rbp), %eax
.Ltarget_form_0609:
# form-0610 extension
movzbq %cl, %rax
.Ltarget_form_0610:
# form-0611 extension
movzbq -16(%rbp), %rax
.Ltarget_form_0611:
# form-0612 extension
movzwl %cx, %eax
.Ltarget_form_0612:
# form-0613 extension
movzwl -16(%rbp), %eax
.Ltarget_form_0613:
# form-0614 extension
movzwq %cx, %rax
.Ltarget_form_0614:
# form-0615 extension
movzwq -16(%rbp), %rax
.Ltarget_form_0615:
# form-0616 sign-extend-accumulator
cbtw
.Ltarget_form_0616:
# form-0617 sign-extend-accumulator
cwtl
.Ltarget_form_0617:
# form-0618 sign-extend-accumulator
cltq
.Ltarget_form_0618:
# form-0619 sign-extend-accumulator
cwtd
.Ltarget_form_0619:
# form-0620 sign-extend-accumulator
cltd
.Ltarget_form_0620:
# form-0621 sign-extend-accumulator
cqto
.Ltarget_form_0621:
# form-0622 control-address
movabsq $9223372036854775807, %rax
.Ltarget_form_0622:
# form-0623 control-address
movabsq $-9223372036854775808, %r10
.Ltarget_form_0623:
# form-0624 control-address
movq %r8, %r9
.Ltarget_form_0624:
# form-0625 control-address
movq 16(%rdi,%rsi,8), %rax
.Ltarget_form_0625:
# form-0626 control-address
movq %rax, 16(%rdi,%rsi,8)
.Ltarget_form_0626:
# form-0627 control-address
leaq .Ltarget_form_0627(%rip), %rsi
.Ltarget_form_0627:
# form-0628 control-address
leaq -16(%rbp), %rdi
.Ltarget_form_0628:
# form-0629 control-address
leaq 16(%rdi,%rsi,8), %rax
.Ltarget_form_0629:
# form-0630 control-address
pushq %rbp
.Ltarget_form_0630:
# form-0631 control-address
popq %rbp
.Ltarget_form_0631:
# form-0632 control-address
call external_function
.Ltarget_form_0632:
# form-0633 control-address
call *%rax
.Ltarget_form_0633:
# form-0634 control-address
call *-16(%rbp)
.Ltarget_form_0634:
# form-0635 control-address
jmp .Ltarget_form_0635
.Ltarget_form_0635:
# form-0636 control-address
jmp *%rax
.Ltarget_form_0636:
# form-0637 control-address
jmp *-16(%rbp)
.Ltarget_form_0637:
# form-0638 control-address
ret
.Ltarget_form_0638:
# form-0639 control-address
ud2
.Ltarget_form_0639:
