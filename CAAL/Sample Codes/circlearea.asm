.data
	pi:	.double	3.1415926
	height: .double 2.0
	msg:	.asciiz	"Circle Area = "
	radius:	.asciiz "What is the radius? "
.text
main:
	#beq	$t1,$t2,here
	#c.eq.s	$f8,$f0
	#j	here
	
	ldc1	$f4,height
	ldc1	$f2, pi	# $f2,3 = pi
	la	$a0, radius
	li	$v0, 4	# print string (msg)
	syscall
	li	$v0, 7	# read double (radius)
	syscall		# $f0,1 = radius
	mul.d	$f12, $f0, $f0	# $f12,13 = radius*radius
	mul.d	$f12, $f2, $f12	# $f12,13 = area
	mul.d	$f12,$f12,$f4
here:	la	$a0, msg
	li	$v0, 4	# print string (msg)
	syscall
	li	$v0, 3	# print double (area) 
	syscall		# print $f12,13
	li	$v0,10
	syscall
	
