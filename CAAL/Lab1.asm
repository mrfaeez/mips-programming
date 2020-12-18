#LAB 1

#1. Get an input from user to enter his/her name
#2. Print out a message string with a hello message and the user's name (e.g. "Hello Adam")
#3. Manipulate the user's name to output an encrypted user name (i.e. A=C, d=f, a=c, m=o)
#4. Print out the encrypted user name with a short message ("Hi Adam, you encrypted user name is Cfao")
#5. End the code

.data
	prompt: .asciiz "Enter your name : "
 	namePrompt: .asciiz "Hello "
 	name: .space 10
 	encryptPrompt: .asciiz ", your encrypted user name is "
 	hiPrompt: .asciiz "Hi "

.text
main:
 	
 	#Print ask for name
	la $a0,prompt
 	jal printSome
 	syscall
 	
 	#Store name in variable name with length 10
 	la $a0,name
 	la $a1,10  		
 	li $v0,8
 	syscall
 	la $t0,($a0) 	
 	li $t1,0 		
 
	#Print Hello prompt
 	jal printSome
	la $a0, namePrompt
	syscall	
	
	#Print name
	jal printSome
	la $a0, name
	syscall
	
	#Print Hi prompt
 	jal printSome
	la $a0, hiPrompt
	syscall	
	
	#Print name
	jal printSome
	la $a0, name
	syscall
	
	#Print prompt
	jal printSome
	la $a0, encryptPrompt
	syscall
	
 	#Encryption starts
 	li $s2, 2 		#Shift 2 places encryption (based on question)
 	jal encrypt
 
 	jal exit
 	

#PROCEDURE AREA

#Print something
printSome:
	li $v0, 4
	jr $ra
	

#Encrypt is divided into function to use the beq
encrypt:
	lb $t4, 0($t0)  	 	
	beqz $t4,exit			
	jal checkSmall
encrypt2:
	beq $v0,1, encryptSmall  		# branchifequal jump to ecnrypt small letter when $v0=1 (refer checkSmall)
	beq $v0,0, encryptCapital  		# branchifequal jump to ecnrypt capital letter when $v0=0 (refer checkSmall3)
	move $a0, $t4   
			

#Print encrypted character recursively for each character (calling encrypt back)
print:
	li $v0,11 			
	syscall
	add $t0,$t0,1 			
 	add $t1,$t1,1 			
 	jal encrypt


#Exit procedure
exit:
 	li $v0,10
 	syscall
 	

#Check small letter is divided to several procedure to use the bgt and blt 
checkSmall:
 	bgt $t4,122, checkSmall2	 	# check branchgreatherthan 122 (z in ASCII code)
 	blt $t4,97, checkSmall3			# check branchlowerthan 97 (a in ASCII CODE)
 	li $v0,1   				# $v0=1 if the character is a lower case character
 	jr $ra    	
checkSmall2:
 	li $v0,2   				# $v0=2 if neither
 	jal encrypt2  	
checkSmall3:
 	blt $t4,65, checkSmall2			# check branchlowerthan 65 (A in ASCII CODE)
 	li $v0,0   				# $v0=0 if true	
 	jal encrypt2


#Encrypt small letter
encryptSmall: 		
 	li $t5,26   				# $t5=26 (26 char in alphabet)
 	sub $t4,$t4,97				# minus the char with 97 (a in ascii code)
 	add $t4, $t4, $s2			# encrypt the letter by adding $s2=2 to the char ascii code
 	div $t4,$t5				# divide to get the percentage (location)
 	mfhi $a0				# move from hi is used because of the division used
 	addi $a0,$a0,97				# adds immediate value with 97 (since it is small letter)
 	jal print				# print encrypted letter

#Ecnrypt capital letter
encryptCapital:
 	li $t5,26   				# $t5=26 (26 char in alphabet)
 	sub $t4,$t4,65				# minus the char with 65 (A in ascii code)
 	add $t4, $t4, $s2			# encrypt the letter by adding $s2=2 to the char ascii code
 	div $t4,$t5				# divide to get the percentage (location)
 	mfhi $a0				# move from hi is used because of the division used
 	addi $a0,$a0,65				# adds immediate value with 65 (since it is capital letter)
 	jal print				# print encrypted letter


