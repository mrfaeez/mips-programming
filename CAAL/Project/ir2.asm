.data
	string: .space 20 		#The string  array size 20

	welcomemsg: .asciiz "\nSmart Refrigerator\n"
	choose: .asciiz "Choose option"
	option: .asciiz "\n(1)Item list\n(2)Update\n(3)Exit\n"
	minusmsg: .asciiz"\nPut negative (-) to decrese value ."
	#list of inventory
	nugget: .asciiz "\n1) rice   "
	noodle: .asciiz "\n2) noodle   "
	chicken: .asciiz "\n3) chicken   "
	fish: .asciiz "\n4) fish   "
	meat: .asciiz "\n5) meat   "
	#array
	inventory: .word nugget, noodle, chicken, fish, meat, #inventory
	quantity: .word 15, 14, 5, 21, 8,  #quantity		
	#size of array
	initial: .word 0	
	total:	 .word 4

.text
main:
 #size of inventory array       
        la $s0, inventory
        la $s1, quantity
        lw $s2, initial
        lw $s3, total
        
	li $v0, 4       	# print welcome msg
        la $a0, welcomemsg  
        syscall 

        li $v0, 4		# print option msg
        la $a0, option
        syscall

        li $v0, 4		# print insruction msg
        la $a0, choose
        syscall
        
        addi $s4, $zero, 1
        addi $s5, $zero, 2
        addi $t9, $zero, 3
        li $v0, 5		#get input option
        syscall
        
	move $t6, $v0		#store in t0
        beq $s4, $t6, displayInventory	#compare input element. if 1 go to display inventory list. else to to fetch
 	beq $s5, $t6, changeItem #changes to quantity of inventory
 	beq $t9, $t6, endProgram # when select 3, exit the program
 
displayInventory: 		#print elements in inventory array  
 
        #for() loop 
	bgt $s2, $s3, main
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
        j displayInventory	#loop array to other index element until bgt instruction complete

changeItem:
	li $v0,4
	la $a0, minusmsg
	syscall
	
	la $s0, inventory
	la $s1, quantity
	
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
	jal main
endProgram:
	li $v0, 10
	syscall


	
