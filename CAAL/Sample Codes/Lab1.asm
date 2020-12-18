# Lab 1 exercise
#1. Get an input from user to enter his/her name
#2. Print out a message string with a hello message and the user's name (e.g. "Hello Adam")
#3. Manipulate the user's name to output an encrypted user name (i.e. A=C, d=f, a=c, m=o)
#4. Print out the encrypted user name with a short message ("Hi Adam, you encrypted user name is Cfao")
#5. End the code

.data 
name:.space 10
encrname: .space 10

hellomsg:.asciiz "Hello "
hellomsg2:.asciiz "Your encrypted user name is "


.text

#1. Get an input from user to enter his/her name
#syscall read string
li	$v0,8
la	$a0,name
li	$a1,10
syscall


#2. Print out a message string with a hello message and the user's name
#syscall print string

la	$a0,hellomsg
jal	printstring


la	$a0,name
jal	printstring

#3. Manipulate the user's name to output an encrypted user name (i.e. A=C, d=f, a=c, m=o)
li	$s1,0
li	$t1,10
li	$t2,0xa
manipulate:
lb	$s0,name($s1)
beq	$s0,$t2,printnext
addi	$s0,$s0,32
sb	$s0,encrname($s1)
addi	$s1,$s1,1
bne	$s1,$t1,manipulate

#4. Print out the encrypted user name with a short message ("Hi Adam, you encrypted user name is Cfco")
#syscall print string
printnext:

la	$a0,hellomsg2
jal	printstring



la	$a0,encrname
jal	printstring

#5. End the code
#syscall exit code
li	$v0,10
syscall


#procedure print string
#print string
printstring:
li	$v0,4
syscall
jr	$ra
