.data
A: .word  -5,-4,4493,15       #    Khai bao mang A có 4 phan tu 

.text
	li 	$s1,-1  # gan i=-1
	la 	$s2 ,A # $2 = &A
	li 	$s3,4 	# n =4
	li 	$s4,1  	#step =1
	li	$s5 ,0 # max = 0
	
loop:	
	add 	$s1,$s1,$s4	#i=i+step
	add	$t1,$s1,$s1	#t1=2*s1
	add	$t1,$t1,$t1	#t1=4*s1	
	add	$t1,$t1,$s2	#t1 store the address of A[i]
	lw	$t0,0($t1)	#load value of A[i] in$t0
	abs	$t8,$t0	
	sgt	$t7,$t8,$s5	# if max > A[i] 
	bne 	$t7,$zero,else  #l?p l?i 
	j       endif
	
else :   add  	$s5,$zero,$t8

endif : bne	$s1,$s3,loop    

	