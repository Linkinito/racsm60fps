	.file	1 "C:\\Users\\linki\\Documents\\PPSSPP\\Overcompensated-Reprise-2026-09-14\\development-v0.6.1\\menu-audit\\abi-probe.c"
	.section .mdebug.eabi32
	.previous
	.section .gcc_compiled_long32
	.previous
	.nan	legacy
	.module	singlefloat
	.module	nooddspreg
	.module	arch=allegrex
	.text
	.align	2
	.globl	check_native_call_convention
	.set	nomips16
	.set	nomicromips
	.ent	check_native_call_convention
	.type	check_native_call_convention, @function
check_native_call_convention:
	.frame	$sp,16,$31		# vars= 0, regs= 1/0, args= 8, gp= 0
	.mask	0x80000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	li	$2,9			# 0x9
	li	$11,8			# 0x8
	sw	$2,0($sp)
	li	$10,7			# 0x7
	li	$9,6			# 0x6
	li	$8,5			# 0x5
	li	$7,4			# 0x4
	li	$6,3			# 0x3
	li	$5,2			# 0x2
	sw	$31,12($sp)
	jal	menu_add_probe
	li	$4,1			# 0x1

	lw	$31,12($sp)
	jr	$31
	addiu	$sp,$sp,16

	.set	macro
	.set	reorder
	.end	check_native_call_convention
	.size	check_native_call_convention, .-check_native_call_convention
	.ident	"GCC: (GNU) 15.2.0"
