# Bubble sort 
.data
A: .word 20, 19, -5, 1, 4493 , 8, 2019
.text
main: 
    	la $a0, A 	#$a0 = Address(A[0])
    	li $a1, 7	# length of array A: n
   	 j sort 	#sort 
    	li $v0, 10 	#exit
    	syscall
end_main:
sort: 
	li $t0, 0	# i = 0 
loop_1:
	li  $t1, 0		# index i cua vong lap thu 2
	add $t0, $t0, 1		# i++
	sub $t2, $a1, $t0	# n - i
loop_2:
	add $t3, $t1, $t1 	#put t3 =2t1 
	add $t4, $t3, $t3 	#put t4=4t1
	add $t4, $t4, $a0
	lw  $a2, 0($t4)		# load A[i]
	lw  $a3, 4($t4)		# Load A[i+1]
if:
	slt $t7, $a2, $a3 	# If A[i] < A[i+1]
	bne $t7, $zero, end_if	
	# Swap
   	sw $a3, 0($t4) 
    	sw $a2, 4($t4) 
end_if:	
	add $t1, $t1, 1		# i = i+ 1
	slt $s1, $t1, $t2	# neu t1 < t2 return 1; else return 0
	beq $s1, $zero, end_loop_2
	j   loop_2
end_loop_2:	
	slt $s2, $t0, $a1  
	beq $s2, $zero, end_loop_1
	j   loop_1
end_loop_1:
