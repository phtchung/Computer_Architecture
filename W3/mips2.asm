.data
A: .space  16 # Khai bao mang A có 4 phan tu 

.text
	li 	$s1,-1  # gan i=-1
	la 	$s2 ,A # $2 = &A
	
	li 	$t8,2019
	sw	$t8,0($s2) # A[0] =2019
	li 	$t8,4493
	sw	$t8,4($s2) # A[1] =4493
	li 	$t8,3
	sw	$t8,8($s2) # A[2] =3
	li 	$t8,4
	sw	$t8,12($s2) # A[3] =4
	
	li 	$s3,4 	# n =4
	li 	$s4,1  	#step =1
	li	$s5 ,0 # sum=0
	
loop:	add 	$s1,$s1,$s4	#i=i+step
	add	$t1,$s1,$s1	#t1=2*s1
	add	$t1,$t1,$t1	#t1=4*s1	
	add	$t1,$t1,$s2	#t1 store the address of A[i]
	lw	$t0,0($t1)	#load value of A[i] in$t0
	add	$s5,$s5,$t0	#sum=sum+A[i]
	bne	$s1,$s3,loop	#if i != n, goto loop