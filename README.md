# assemblyrequired
 
## sideeffects2.s gcc generated assembly
* write a simple c program, such as sideeffects2.c, with a simple user defined function, 2 args
* gcc -S sideeffects2.c
* this will give you sideeffects2.s with just the gcc generated code, and none of the comments I put in my version
* This shows a simple gcc stack set up for main, with 2 locals
* calls the simple function
* note the stack set up/clean up
* note the use of fp and sp to navigate the stack
* you can also do gcc -g -o nameyouwant sideeffects2.c 
* and then use gdb to examine the output as it runs
***
* there are many ways that you as an assembly coder can set up and take down the stack frame for a function
* as long as you follow the conventions, you will be able to share your code/use others code
* This is what gcc does. 

### Here is a much better explanation of this from Robert Plantz (Introduction to Computer Organization: ARM Assembly Language Using the Raspberry Pi)
main/passing arguments

http://bob.cs.sonoma.edu/IntroCompOrg-RPi/chp-subroutine.html

writing your own functions

http://bob.cs.sonoma.edu/IntroCompOrg-RPi/chp-writfuncs.html




## don't hesitate to make stack diagrams. 
> "I strongly urge you to draw pictures like  when designing your stack frame. 
> It is the only way I am able to get all the numbers to be correct, and I have been 
> designing stack frames for over forty years." 

http://bob.cs.sonoma.edu/IntroCompOrg-RPi/sec-varstack.html

* I, personally have not been designing stack frames for 40 years, but I make diagrams of all sorts, and highly recommend it
* be careful of just reading code - make sure you know what each thing is doing
* write down in words what you think each step is doing
* write and generate code, then analize what is happening. See if you can get the stack to work out
* check out what it's actually doing with gdb if it doesn't add up
* then verify that each instruction is doing what you think it is. 


***
# subtract to add and add to subtract
### welcome to the stack frame
## the stack *grows* down and *shrinks* up
## negative offsets are going towards/adding to the "top" of the stack
## adding to an address goes toward the "bottom" of the stack

## free store/ heap memory addresses are the opposite. 
## same with things stored in .data

## indexing/incrementing in addressing
* armv7 has some complicated addressing syntax 

### pre index (increment or decrement)
* the output here uses a preindex
* line 59: str	fp, [sp, #-4]! 
* this stores the thing stored in fp at the address that is 4 bytes less than sp
* then makes sp = to sp - 4
* this both uses indirection to store at an address, and changes the address of sp

### no indexing
* here is one with no indexing/incrementing
* line 66: ldr	r3, [fp, #-8]
* this loads the thing at the address 8 bytes below fp (the framepointer) into r3. 
* fp does not change

### post index (increment or decrement)
* here is one with a post index
* line 76: ldr	fp, [sp], #4	
* This loads the thing stored at sp into fp
* then makes sp equal to sp + 4 bytes

### remember load and store are moving *things* around register to address, etc 
### except those load/stores that *also* change addresses, 
### such as pre/post incememnting, ldm/stm (sp) and push and pop (sp)
### add and subtract move sp and fp around (what they point to) moving where the address points, not what is stored there. 


see text/ascii stack diagram in the .s file (this one doesn't show up quite right)
you can copy it, then move around values/sp/fp on the stack
note that the individual bytes would go [ 3 | 2 | 1 | 0 ] in each 4 byte word
The offsets are on the left since it was easier to make the diagram that way
so that it could be annotated with what is happening. Those values would be the 
offsets of the rightmost byte in this diagram (little endian because linux.)


You can address a byte, but it's better to keep sp at 4 byte alignment
since the stack gets a lot if 4 byte size regsiters push/popping
(there are situation/machine specific rules about this)

...
blank ascii stack diagram 

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
 
 ...
