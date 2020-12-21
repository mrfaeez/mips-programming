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
	
		li	$v0,10
		syscall
	
	BtnDoorOpened:
	
		la	$a0, btn_lightonPrompt
		jal	BtnPrintText
		syscall
	
		li	$v0,10
		syscall
	
	BtnPrintText:

		li	$v0, 4
		jr	$ra
		
	#END PROCEDURE FOR BUTTON
	
     	exit:
     
    		li $v0, 10
    		syscall
