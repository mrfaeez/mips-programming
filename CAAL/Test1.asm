#FAEEZ ZIMAM BINF FEIZAL
#1819541
#TEST1 CAAL SEM1 2020/2021


.data
	welcome: .asciiz "Welcome to the letter game\n"
	prompt: .asciiz "Please enter a 5 letter word (uppercase) : "
	word: .space 6										#The space is set to 6, as mips need 6 spaces to store 5 letters
	wordchanged: .space 6
	promptChanged: .asciiz "\nThe changed letter is "
	

.text
	#Prompt welcome
	la $a0,welcome
 	jal printSome
 	syscall
 	
 	#Ask for input
	la $a0,prompt
 	jal printSome
 	syscall
 	
 	#Store input
 	li	$v0,8
	la	$a0,word
	li	$a1,6
	syscall
	
	li	$s1,0
	li	$t1,6
	li	$t2,6
	
	
#Change the word to small-letters
change:

	lb	$s0,word($s1)
	beq	$s0,$t2,printChange
	addi	$s0,$s0,32
	sb	$s0,wordchanged($s1)
	addi	$s1,$s1,1
	bne	$s1,$t1,change
 
#Print the changed word
printChange:

	la	$a0,promptChanged
	jal	printSome
	syscall

	la	$a0,wordchanged
	jal	printSome
	syscall

	li	$v0,10
	syscall
	
#Procedure for print	
printSome:
 
	li $v0, 4
	jr $ra
