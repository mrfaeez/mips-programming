.data
msg: .byte 10,11,12,13,14

.text
	slt	$t1,$t2,$t3	#check if $t2<$t3
	lui	$s0,0x1001 	#to load the address of msg into $s0
	lb	$s1,0($s0)	#read first byte in msg
loop:	xori	$s1,$s1,10	
	andi	$s2,$t2,11
	xor	$s1,$t2,$t3
	bne	$s1,$s2,loop
	slti	$s1,$t2,30
	sw	$s1,8($s0)
	lw	$s1,4($s0)
