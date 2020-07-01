/*
gcc -S sideeffects2.c 
gcc generated arm assembly for sideeffects2.c
annotated with my coments @
-> ascii stack diagram, notes at the end

-> simple demo of gcc's use of fp, sp in stack frame
-> on a simple func with 2 args 
(no need to preserve any other regsisters)
*/





/* 
sideeffects2.c 
#include <stdio.h>

int xandy(int x, int y)
{
	return y = x++;
}
int main(void)
{
	int a = 5;
	int b = 8;
	int c = xandy( a, b);
	return 0;
}

*/


	.arch armv6
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"sideeffects2.c"
	.text
	.align	2
	.global	xandy
	.arch armv6
	.syntax unified
	.arm
	.fpu vfp
	.type	xandy, %function
xandy:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]! @ store addr in fp at sp -4, sp = sp -4
	add	fp, sp, #0     @ fp = sp
	sub	sp, sp, #12    @ sp = sp - 12

	str	r0, [fp, #-8]  @ store local x val
	str	r1, [fp, #-12] @ store local y val
 
	ldr	r3, [fp, #-8]  @ load x val into r3
	add	r2, r3, #1	@ r2 = r3 +1

	str	r2, [fp, #-8]	@ r2 into x
	str	r3, [fp, #-12]	@ r3 into y

	ldr	r3, [fp, #-12]  @ y into r3
	mov	r0, r3		@ r3 to r0 
	add	sp, fp, #0 	@ sp = fp moving sp to fp
	@ sp needed
	ldr	fp, [sp], #4	@  post index, fp = thing in sp, sp = sp +4
	bx	lr
	.size	xandy, .-xandy
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu vfp
	.type	main, %function

main:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	mov	r3, #5
	str	r3, [fp, #-8]
	mov	r3, #8
	str	r3, [fp, #-12]
	ldr	r1, [fp, #-12]
	ldr	r0, [fp, #-8]
	bl	xandy
	str	r0, [fp, #-16]
	mov	r3, #0
	mov	r0, r3
	sub	sp, fp, #4
	@ sp needed
	pop	{fp, pc}
	.size	main, .-main
	.ident	"GCC: (Raspbian 8.3.0-6+rpi1) 8.3.0"
	.section	.note.GNU-stack,"",%progbits


/*
				last full<--		
	- 0[   |   |   | lr]   <-fp
	- 4[   |   |   | fp] <-sp -4
	- 8[   |   |   | 5 ] -4   -8
	-12[   |   |   | 8 ] -8   -12 					
	-16[   |   |   |   ] -12 	
	-20[   |   |   |   ] -16 <newsp main





				last full<--		
	- 0[   |   |   | lr]   <-fp      	<fp leaving func
	- 4[   |   |   | fp] <-sp -4 <-sp  {pop fp, pc} return from main
	- 8[   |   |   | 5 ] -4   -8
	-12[   |   |   | 8 ] -8   -12 					
	-16[   |   |   |y,r] -12 	
	-20[   |   |   |   ] -16 <newsp main 		<-post increment sp
	-24[   |   |   |mfp] <-sp, fp        <-sp end of f, thing here = fp ^^     
	-28[   |   |   |   ]  	-4		
	-32[   |   |   |  x]  -8
	-36[   |   |   |  y] -12 <new sp
	-40[   |   |   |   ]  
	-44[   |   |   |   ] 
	-48[   |   |   |   ] 
	-52[   |   |   |   ] 
	-56[   |   |   |   ]


*/

/* blank ascii stack diagram 
	- 0[   |   |   |   ]  
	- 4[   |   |   |   ]  
	- 8[   |   |   |   ] 
	-12[   |   |   |   ]  					
	-16[   |   |   |   ]    	
	-20[   |   |   |   ] 
	-24[   |   |   |   ]             
	-28[   |   |   |   ]  			
	-32[   |   |   |   ]  
	-36[   |   |   |   ] 
	-40[   |   |   |   ]  
	-44[   |   |   |   ] 
	-48[   |   |   |   ] 
	-52[   |   |   |   ] 
	-56[   |   |   |   ]


*/
/*
notes
[ ] is indirection, see below, indexing/incrementing syntax
** load store change contents, add sub move sp, fp on stack
ops that do 2 things, move + increment sp, fp, rn
[rn] post, increment if offest after
[rn offset]! pre incr rn, use that val addr
[rn offset] doesn't incement rn

push lowest registers stored at lowest stack addre

r11 fp
r12 ip
r13 sp
r14 lr
r15 pc

order that push and pop push and pop: lowest reg into lowest address 
push and pop and stm ldm incr sp

*/
