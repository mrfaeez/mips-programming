.data
	btnPrompt: .asciiz "Detecting button state......... (0 or 1)\n"
	lightoffPrompt: .asciiz "Door is closed! Light turned off"
	lightonPrompt: .asciiz "Door is opened! Light turned on"
	doorAlert: .asciiz "Door is opened for more than 1 minute!"
	
	btnState: .space 2
	lightState: .space 2
	
.text
	
	#s0 is used to compare the button state
	li	$s0, 0
	
	la	$a0, btnPrompt
	jal	printText
	syscall
	
	li	$v0,5
	syscall
	move 	$s2, $v0
	sb	$s2, btnState
	#la	$a0, btnState
	#li	$a1,6
	
	beq	$s0, $s2, doorOpened
	bne	$s0, $s2, doorClosed
	
	li	$v0,10
	syscall
	
doorClosed:
	
	la	$a0, lightoffPrompt
	jal	printText
	syscall
	
	la	$a0, btnState
	jal	printText
	syscall
	
	li	$v0,10
	syscall
	
doorOpened:
	
	la	$a0, lightonPrompt
	jal	printText
	syscall
	
	li	$v0,10
	syscall
	
printText:

	li	$v0, 4
	jr	$ra
