        .cpu cortex-a53
        .fpu neon-fp-armv8
        .syntax unified


        .text
        .global main
main: 
        ldr     r0, =fmt2
        ldr     r1, =alpha
        ldrb     r1, [r1]
        mov     r2, r1
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


