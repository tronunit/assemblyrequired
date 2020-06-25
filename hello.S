    @ 2020 hi
    
        .cpu cortex-a53
        .fpu neon-fp-armv8
        .syntax unified


        .text
        .global main

main: 
        ldr r0, =hello
        bl printf
        bl exit





        .data
hello: .string "Hello, World\n"



