.data 

#humidifier regulates the smart refrigerator's temperature
#temperature of smart refridgerator 
#safe temperature to store food according to FDA is 4 degrees celsius and below
#base_temp:  2
#freeze_temp: -18

   base_temp: .word 2
   min_temp: .word -20   
   max_temp: .word 4
   msgt_prompt: .asciiz "\nSet new temperature? (yes(1) or no(0): "
   msgt_new: .asciiz "\nEnter preferred refrigerator temperature(4 to -20): "
   msgt_success: .asciiz "\nThe temperature has been regulated"
   msgt_change: .asciiz "\nThe temperature has been changed  to = "  
   msgt_initial: .asciiz "\nThe initial temperature is 4 degress celcisus and -18 degrees celcisus(for the freezer)"
   msgt_invalid: .asciiz "\nInvalid refridgerator temperature. Range is from 4 to -20"
   msgt_no : .asciiz "Temperature remains at base temperature 4 degrees celsius"
   getyesno: .space 8
   NewTemp: .space 8
   
   .text

  

 
setNewTemp:
 	li $v0, 4		 	#ask user if they want to change temperature
 	la $a0, msgt_prompt
 	syscall

 	la $v0, getyesno 		#get user input either yes or no
	li $v0, 5
 	syscall
 
 	add $t1, $v0,$zero
 	la $a0, base_temp  		# set base temperature
	beq $t1, 0, tnochange		#if user does not want to change branch to tnochange
	syscall
	j tYes				#if user wants to change jump to yes
 
 
tYes:
       li $v0, 4			#prompt user to enter new temperature			
       la $a0, msgt_new
       syscall  
       
       j getNewTemp			#jumb to getNewTemp to handle user input
       
        
       
      
getNewTemp:

	
        li $v0, 5			#takes user input for the temperature
        syscall
        
       
         
       
       lw $t4, min_temp			#set min temperature
       lw $t6, max_temp			# set max temp
       
       slt $t1, $t4, $v0		#error handling for the range of temperature
       beq $t1,$zero, tInvalid
       slt $t1, $v0,$t6
       beq $t1,$zero, tInvalid
       
       
       move $t6,$v0			#move the temperature value to temporary register6
       
       li $v0, 4
       la $a0, msgt_success		#alert user of the temperature change
       syscall
      
       



	


printTemp:

	li $v0,4			#notify the user of the new temp value
	la $a0 , msgt_change
	syscall
	
	
	li $v0, 1			#print current changed value
	move $a0,$t6
	syscall
	
	j exit				
	
	
tnochange:
	li $v0, 4 			#notify user that there is no temperature change
	la $a0, msgt_no	
	syscall
	
	j exit
	
	
tInvalid:
	li $v0, 4			#notify the user that the user input was invalid(out of range)
	la $a0, msgt_invalid
	syscall
	
	j getNewTemp
	
exit:

li $v0, 10
syscall
	


