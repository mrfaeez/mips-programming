.data 

#humidifier regulates the smart refrigerator's temperature
#temperature of smart refridgerator 
#safe temperature to store food according to FDA is 4 degrees celsius and below
   base_temp: .float 2.0
   freeze_temp: .float -18.0
   min_temp: .float -20.0   
   max_temp: .float 4.0
   msgt_prompt: .asciiz "\nSet new temperature? (yes(1) or no(0): "
   msgt_new: .asciiz "\nEnter preferred refrigerator temperature(4 to -20): "
   msgt_success: .asciiz "\nThe temperature has been regulated"
   msgt_change: .asciiz "\nThe temperature has been changed  to"  
   msgt_initial: .asciiz "\nThe initial temperature is 4 degress celcisus and -18 degrees celcisus(for the freezer)"
   msgt_invalid: .asciiz "\nInvalid refridgerator temperature. Range is from 4 to -20"
   msgt_no : .asciiz "Temperature remains at base temperature 4 degrees celsius"
   getyesno: .space 8
   NewTemp: .space 8
   
   .text

  

 
setNewTemp:
 	li $v0, 4
 	la $a0, msgt_prompt
 	syscall

 	la $v0, getyesno 
	li $v0, 5
 	syscall
 
 	add $t1, $v0,$zero
 	lwc1 $f0, base_temp  
	beq $t1, 0, tnochange
	syscall
	j tYes
 
 
tYes:
       li $v0, 4
       la $a0, msgt_new
       syscall  
       
       j getNewTemp
       
        
       
      
getNewTemp:

	la $t0, NewTemp
        li $v0, 6
        syscall
        
         
       
       lwc1 $f2, min_temp
       lwc1 $f4, max_temp
       
       c.le.d $f0, $f4
       bc1f tInvalid
       c.le.d $f0,$f2
       bc1f tInvalid
       
       li $v0, 4
       la $a0, msgt_success
       syscall
      
       



	


printTemp:

	li $v0,4
	la $a0 , msgt_change
	syscall
	
	
	li $v0, 2
	lwc1 $f12, NewTemp
	syscall
	
	
tnochange:
	li $v0, 4 
	la $a0, msgt_no	
	syscall
	
	j exit
	
	
tInvalid:
	li $v0, 4
	la $a0, msgt_invalid
	syscall
	
	j getNewTemp
	
exit:

li $v0, 10
syscall
	


