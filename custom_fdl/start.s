@ -*- tab-width: 8 -*-
	.arch armv5te
	.syntax unified

.macro CODE16_FN name
	.section .text.\name, "ax", %progbits
	.p2align 1
	.code 16
	.type \name, %function
	.global \name
	.thumb_func
\name:
.endm

.macro CODE32_FN name
	.section .text.\name, "ax", %progbits
	.p2align 2
	.code 32
	.type \name, %function
	.global \name
\name:
.endm

//  0 : MMU enable
//  2 : Level 1 Data Cache enable
// 12 : Instruction Cache enable

CODE32_FN _start
	ldr	r4, 3f
4:	cmp	r4, pc
	bne	4b

	mrc	p15, #0, r0, c1, c0, #0 // Read Control Register
	bic	r0, #5
.if 1
	bic	r0, #0x1000
.else // faster
	orr	r0, #0x1000
.endif
	mcr	p15, #0, r0, c1, c0, #0 // Write Control Register
	mov	r2, #0xd3
	msr	cpsr_c, r2
	ldr	sp, 1f
	ldr	r4, 2f
	add	r4, pc
	bx	r4
2:	.long	entry_main - .
1:	.long	__stack_bottom
3:	.long	__image_start + 12

CODE32_FN __gnu_thumb1_case_uqi
	bic	r12, lr, #1
	ldrb	r12, [r12, r0]
	add	lr, lr, r12, lsl #1
	bx	lr

