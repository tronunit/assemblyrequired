    @ 2020 hi
    
        .cpu cortex-a53
        .fpu neon-fp-armv8
        .syntax unified


        .text
        .global main
        @ .print " Hi did it do it" directive from gas manual 
        @ claims to print while assembling. Did not. 

main: 
        ldr r0, =hello
        bl printf
        bl exit





        .data
hello: .string "Hello, World\n"



