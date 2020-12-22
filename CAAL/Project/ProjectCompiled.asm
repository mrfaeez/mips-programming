.data
	#AUTHENTICATION VARIABLES
	pass_welcome: .asciiz "\nWelcome to Smart Register System!\n"
    	pass_strToCompare: .asciiz "password\n"
    	pass_msg1: .asciiz "Please enter password: "
    	pass_msg4: .asciiz "Password is Incorrect!\n"
    	pass_msg3: .asciiz "Password is correct! Authnetication successful\n"
    	pass_string1: .space 100
    
    	#BUTTON SENSOR VARIABLES
    	btn_Prompt: .asciiz "\nDetecting button state......... (0 or 1)\n"
    	btn_lightoffPrompt: .asciiz "Door is closed! Light turned off"
    	btn_lightonPrompt: .asciiz "Door is opened! Light turned on"
    	btn_doorAlert: .asciiz "Door is opened for more than 1 minute!"
    	btn_State: .space 2
    	lightState: .space 2
    	
    	#IR SENSOR VARIABLES
    	ir_string: .space 20 		
	ir_welcomemsg: .asciiz "\n\nInventory Update by IR Sensor\n"
	ir_choose: .asciiz "Choose option: "
	ir_option: .asciiz "\n(1)Item list\n(2)Update\n(3)Exit\n"
	ir_minusmsg: .asciiz "\nPut negative (-) to decrese value ."
	
	iv_nugget: .asciiz "\n1) rice   "
	iv_noodle: .asciiz "\n2) noodle   "
	iv_chicken: .asciiz "\n3) chicken   "
	iv_fish: .asciiz "\n4) fish   "
	iv_meat: .asciiz "\n5) meat   "
	
	ir_inventory: .word iv_nugget, iv_noodle, iv_chicken, iv_fish, iv_meat, #inventory
	ir_quantity: .word 15, 14, 5, 21, 8,  #quantity		
	
	ir_initial: .word 0	
	ir_total:	 .word 4
    
.text
	li $v0, 4    							#load welcome message
        la $a0, pass_welcome
        syscall
        
        #START AUTHENTICATION
	PassMain:
        
        	li $v0, 4    						#load message for "Enter Password"
        	la $a0, pass_msg1
        	syscall
        
        	li $v0, 8    						#Input password from user
    		la $a0, pass_string1
        	li $a1, 99
        	syscall

        	la $t1, pass_string1       				#load address for string1
        	la $t2, pass_strToCompare  				#load address for strToCompare
        	j PassLoop
        	
	#END AUTHENTICATION
	
	#START BUTTON SENSOR
	BtnMain:
		
		li	$s0, 0						#s0 is used to compare the button state
	
		la	$a0, btn_Prompt
		jal	BtnPrintText
		syscall
	
		li	$v0,5
		syscall
		move 	$s2, $v0
		sb	$s2, btn_State
	
		beq	$s0, $s2, BtnDoorOpened
		bne	$s0, $s2, BtnDoorClosed
	
		j exit
	
	#END BUTTON SENSOR
	
	#START IR SENSOR
	IrMain:
    
        	la $s0, ir_inventory
        	la $s1, ir_quantity
        	lw $s2, ir_initial
        	lw $s3, ir_total
        
		li $v0, 4       	
        	la $a0, ir_welcomemsg  
        	syscall 

        	li $v0, 4		
        	la $a0, ir_option
        	syscall

        	li $v0, 4		
        	la $a0, ir_choose
        	syscall
        
        	addi $s4, $zero, 1
        	addi $s5, $zero, 2
        	addi $t9, $zero, 3
        	li $v0, 5		
        	syscall
        
		move $t6, $v0		
        	beq $s4, $t6, IrDisplayInventory
 		beq $s5, $t6, IrChangeItem
 		beq $t9, $t6, exit
	
	#END IR SENSOR


    	#PROCEDURE FOR AUTHENTICATION   
    
    	PassLoop:
    
        	lb $t3, 0($t1)        					#load each bits 
        	lb $t4, 0($t2)
        
        	sub $t6, $t3, $t4     					
        
        	beq $t6, $zero, PassContinueEqual 			#if t6 = 0, continue
        	j PassEndLoop                    			#if not equal, stop loop
        
    	PassContinueEqual:						# compare and continue by incrementing both address by one  
    
        	beq $t3, $t5, PassEndLoop  
        	addi $t1, $t1, 1
        	addi $t2, $t2, 1
        	j PassLoop

    	PassEndLoop:

        	beq $t6, $zero, PassCorrect

    	PassIncorrect:							#display message "Password is Incorrect"
        	
        	li $v0, 4   
        	la $a0, pass_msg4
        	syscall
		j PassMain
        
    	PassCorrect:							#display message "Password is correct"
        	
        	li $v0, 4    
        	la $a0, pass_msg3
        	syscall
        	j BtnMain
        	

    
    	#END PROCEDURE FOR AUTHENTICATION
    
    	#PROCEDURE FOR BUTTON
    
    	BtnDoorClosed:
	
		la	$a0, btn_lightoffPrompt
		jal	BtnPrintText
		syscall
	
		j exit
	
	BtnDoorOpened:
	
		la	$a0, btn_lightonPrompt
		jal	BtnPrintText
		syscall
	
		j IrMain
	
	BtnPrintText:

		li	$v0, 4
		jr	$ra
		
	#END PROCEDURE FOR BUTTON
	
	#PROCEDURE FOR IR 
	
	
	IrDisplayInventory: 		#print elements in inventory array  
 
        	#for() loop 
		bgt $s2, $s3, IrMain
		sll $t7, $s2, 2		#t4= 4xi
		addu $t7, $t7, $s0 	#memory location of inventory array ----> 1000+4 = 1004
		sll $t8,  $s2, 2	#loop for quantity
		addu $t8, $t8, $s1
	
		li $v0, 4		#print index element in array
		lw $a0, 0($t7)
        	syscall
        
        	li $v0, 1		#print index element in array
		lw $a0, 0($t8)
        	syscall
        
        	addi $s2, $s2, 1      
        	j IrDisplayInventory	#loop array to other index element until bgt instruction complete

	IrChangeItem:
		li $v0,4
		la $a0, ir_minusmsg
		syscall
	
		la $s0, ir_inventory
		la $s1, ir_quantity
	
		li $v0, 4		 #input +value for add,-value for sub
		lw $a0, 0($s0)
        	syscall        
        	li $v0,5
        	syscall
        	lw $a1, 0($s1)
        	add $a1, $a1, $v0
        	sb $a1, 0($s1)
    
		li $v0, 4		
		lw $a0, 4($s0)
        	syscall
        	li $v0,5
        	syscall
        	lw $a1, 4($s1)
        	add $a1, $a1, $v0
        	sb $a1, 4($s1)

		li $v0, 4		
		lw $a0, 8($s0)
        	syscall
        	li $v0,5
        	syscall
        	lw $a1, 8($s1)
        	add $a1, $a1, $v0
        	sb $a1, 8($s1)
        
        	li $v0, 4		
		lw $a0, 12($s0)
        	syscall
        	li $v0,5
        	syscall
        	lw $a1, 12($s1)
        	add $a1, $a1, $v0
        	sb $a1, 12($s1)
        
        	li $v0, 4		
		lw $a0, 16($s0)
        	syscall
        	li $v0,5
        	syscall
        	lw $a1, 16($s1)
        	add $a1, $a1, $v0
        	sb $a1, 16($s1)	
		jal IrMain
	
	#END PROCEDURE FOR IR
	
     	exit:
     
    		li $v0, 10
    		syscall
