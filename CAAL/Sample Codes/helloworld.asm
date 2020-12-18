        	.data
msg:   .asciiz "Hello Class CSC3402"

        .text
        .globl main
main:   add $s1,$s2,$s3
	li $v0, 4       # syscall 4 (print_str)
        la $a0, msg     	# argument: string
        syscall         	# print the string
        #j main
        
        lui	$t1,0x7900
        ori	$t1,$t1,0x1122
        lui	$t2,0x8C00
        ori	$t2,$t2,0x1122
        subu	$t3,$t1,$t2
        lui 	$s2,0xAC51
	ori	$s2,$s2,0x65D9
	addi 	$s1, $s2, 0xff11
        lui 	$s3,0x55A3
	ori	$s3,$s3,0x0098
	add	$s1,$s2,$s3
	#load and store
	la	$s0,msg
	lw	$s1,8($s0)
	sw	$s1,msg
	#load and store
	#lw	$s1, 8($s0)	# $s1 = A[2] 
	#addiu	$s2, $s1, 5	# $s2 = A[2] + 5
	#sw	$s2, 4($s0)	# A[1] = $s2
	
	#load byte, load half
	la	$s1,msg
	lb	$s2,4($s1)
	lh	$s3,4($s1)
	lw	$s4,4($s1)
	lb	$s5,0($s1)
	#to test jump	
	addi	$a1, $zero, 50
 	addi	$a2,	$zero, 100
loop: 	jal	addNumbers

  	li 	$v0, 1
 	addi 	$a0, $v1, 0
 	syscall
 	
 	#branch
 	slt	$t4,$t1,$t2
 	beq	$t4,$t5,loop 

 	# Tell the system that the program is done
 	li	$v0, 10
 	syscall
 
 addNumbers:
 	add	$v1, $a1, $a2	
 	jr	$ra

