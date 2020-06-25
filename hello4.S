        .cpu cortex-a53
        .fpu neon-fp-armv8
        .syntax unified


        .text
        .global main
main: 
        ldr     r0, =fmt2
        ldr     r1, =alpha
        ldrb    r1, [r1]        @ x = 61 
        mov     r2, r1          @lowest address byte in =alpha c = a

        bl printf
        bl exit 





        .data
        .align 2

alpha: 
        .string "abcdefghijklmnopqrstuvwxyz"
alpha2: 
        .string "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
numstr: 
        .string "12345678901234567890"
fmt1:   .string "%x \n"
fmt2:   .string "%x \n %c \n"
fmt3:   .string "%s \n %s \n %s \n"

/*

this prints: 
61
 a


earlier:
printed from fmt1
ldr     r1, =alpha
ldr     r1, [r1] 
32 bit piece of =alpha
64 63 62 61 in hex, dcba 

64636261


 */


