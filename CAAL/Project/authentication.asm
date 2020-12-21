.data
    strToCompare: .asciiz "fak\n"
    msg1: .asciiz "Enter password: "
    msg4: .asciiz "Password is Incorrect!\n"
    msg3: .asciiz "Password is correct!\n"
    endline: .asciiz "\n"
    string1: .space 100
    
.text
    main:
        
        li $v0, 4    #load message for "Enter Password"
        la $a0, msg1
        syscall
        
        li $v0, 8    #Input password from user
    	la $a0, string1
        li $a1, 99
        syscall

        la $t1, string1       #load address for string1
        la $t2, strToCompare  #load address for strToCompare
        
    loop:
        lb $t3, 0($t1)        #load each bits 
        lb $t4, 0($t2)
        
        sub $t6, $t3, $t4     # t6 = t3 - t4
        
        beq $t6, $zero, continueEqual #if t6 = 0, continue
        j end_loop                    #if not equal, stop loop
        
    continueEqual:
    
        beq $t3, $t5, end_loop
    # continue again, by incrementing both address by one    
        addi $t1, $t1, 1
        addi $t2, $t2, 1
        j loop

    end_loop:

        beq $t6, $zero, correct

    incorrect:
        li $v0, 4   #display message "Password is Incorrect"
        la $a0, msg4
        syscall

        j main
        
    correct:
        li $v0, 4    #display message "Password is correct"
        la $a0, msg3
        syscall

    

exit:
    li $v0, 10
    syscall
