.text
# form-0000 scalar-move
movsd %xmm1, %xmm0
.Ltarget_form_0000:
# form-0001 scalar-move
movsd -16(%rbp), %xmm0
.Ltarget_form_0001:
# form-0002 scalar-move
movsd %xmm0, -16(%rbp)
.Ltarget_form_0002:
# form-0003 scalar-move
movsd .Ltarget_form_0003(%rip), %xmm0
.Ltarget_form_0003:
# form-0004 scalar-move
movsd %xmm0, .Ltarget_form_0004(%rip)
.Ltarget_form_0004:
# form-0005 scalar-arithmetic
addsd %xmm1, %xmm0
.Ltarget_form_0005:
# form-0006 scalar-arithmetic
addsd -16(%rbp), %xmm0
.Ltarget_form_0006:
# form-0007 scalar-arithmetic
addsd .Ltarget_form_0007(%rip), %xmm0
.Ltarget_form_0007:
# form-0008 scalar-arithmetic
subsd %xmm1, %xmm0
.Ltarget_form_0008:
# form-0009 scalar-arithmetic
subsd -16(%rbp), %xmm0
.Ltarget_form_0009:
# form-0010 scalar-arithmetic
subsd .Ltarget_form_0010(%rip), %xmm0
.Ltarget_form_0010:
# form-0011 scalar-arithmetic
mulsd %xmm1, %xmm0
.Ltarget_form_0011:
# form-0012 scalar-arithmetic
mulsd -16(%rbp), %xmm0
.Ltarget_form_0012:
# form-0013 scalar-arithmetic
mulsd .Ltarget_form_0013(%rip), %xmm0
.Ltarget_form_0013:
# form-0014 scalar-arithmetic
divsd %xmm1, %xmm0
.Ltarget_form_0014:
# form-0015 scalar-arithmetic
divsd -16(%rbp), %xmm0
.Ltarget_form_0015:
# form-0016 scalar-arithmetic
divsd .Ltarget_form_0016(%rip), %xmm0
.Ltarget_form_0016:
# form-0017 scalar-arithmetic
sqrtsd %xmm1, %xmm0
.Ltarget_form_0017:
# form-0018 scalar-arithmetic
sqrtsd -16(%rbp), %xmm0
.Ltarget_form_0018:
# form-0019 scalar-arithmetic
sqrtsd .Ltarget_form_0019(%rip), %xmm0
.Ltarget_form_0019:
# form-0020 scalar-compare
ucomisd %xmm1, %xmm0
.Ltarget_form_0020:
# form-0021 scalar-compare
ucomisd -16(%rbp), %xmm0
.Ltarget_form_0021:
# form-0022 scalar-compare
ucomisd .Ltarget_form_0022(%rip), %xmm0
.Ltarget_form_0022:
# form-0023 sign-mask
xorpd %xmm1, %xmm0
.Ltarget_form_0023:
# form-0024 sign-mask
xorpd -16(%rbp), %xmm0
.Ltarget_form_0024:
# form-0025 sign-mask
xorpd .Ltarget_form_0025(%rip), %xmm0
.Ltarget_form_0025:
# form-0026 int-to-double
cvtsi2sd %rax, %xmm0
.Ltarget_form_0026:
# form-0027 int-to-double
cvtsi2sd %eax, %xmm0
.Ltarget_form_0027:
# form-0028 int-to-double
cvtsi2sdq %rax, %xmm0
.Ltarget_form_0028:
# form-0029 int-to-double
cvtsi2sdl %eax, %xmm0
.Ltarget_form_0029:
# form-0030 int-to-double
cvtsi2sdq -16(%rbp), %xmm0
.Ltarget_form_0030:
# form-0031 int-to-double
cvtsi2sdl -16(%rbp), %xmm0
.Ltarget_form_0031:
# form-0032 double-to-int
cvttsd2si %xmm0, %rax
.Ltarget_form_0032:
# form-0033 double-to-int
cvttsd2si %xmm0, %eax
.Ltarget_form_0033:
# form-0034 double-to-int
cvttsd2si -16(%rbp), %rax
.Ltarget_form_0034:
# form-0035 double-to-int
cvttsd2si -16(%rbp), %eax
.Ltarget_form_0035:
# form-0036 double-to-int
cvttsd2si .Ltarget_form_0036(%rip), %rax
.Ltarget_form_0036:
# form-0037 extended-registers
addsd %xmm15, %xmm8
.Ltarget_form_0037:
# form-0038 extended-registers
movsd -16(%r13), %xmm9
.Ltarget_form_0038:
# form-0039 extended-registers
movsd %xmm10, (%r12)
.Ltarget_form_0039:
# form-0040 extended-registers
ucomisd %xmm8, %xmm15
.Ltarget_form_0040:
# form-0041 extended-registers
cvtsi2sd %r9, %xmm12
.Ltarget_form_0041:
# form-0042 extended-registers
cvttsd2si %xmm14, %r10
.Ltarget_form_0042:
# form-0043 extended-registers
xorpd %xmm11, %xmm11
.Ltarget_form_0043:
# form-0044 extended-registers
sqrtsd %xmm13, %xmm2
.Ltarget_form_0044:
# form-0045 anticipated-bits
movq %xmm0, %rax
.Ltarget_form_0045:
# form-0046 anticipated-bits
movq %rax, %xmm0
.Ltarget_form_0046:
# form-0047 anticipated-bits
movq %xmm15, %r8
.Ltarget_form_0047:
# form-0048 anticipated-bits
movq %r15, %xmm8
.Ltarget_form_0048:
