.data
m_max: .asciiz "Largest: "
m_min: .asciiz "\nSmallest: "
position: .asciiz ", position: "
.text
input: 	addi $s0, $0, 2
	addi $s1, $0, 0
	addi $s2, $0, 1
	addi $s3, $0, 9
	addi $s4, $0, 4
	addi $s5, $0, -4
	addi $s6, $0, 9
	addi $s7, $0, 3
main:	jal push
	nop
	jal max
	nop
print_max:
	li $v0, 4
	la $a0, m_max
	syscall
	li $v0, 1
	add $a0, $t1, $0
	syscall
	li $v0, 4
	la $a0, position
	syscall
	li $v0, 1
	addi $a0, $t3, -1
	syscall
	
	jal min
	nop
print_min:
	li $v0, 4
	la $a0, m_min
	syscall
	li $v0, 1
	add $a0, $t1, $0
	syscall
	li $v0, 4
	la $a0, position
	syscall
	li $v0, 1
	addi $a0, $t3, -1
	syscall
endofmain:
exit: 	li $v0, 10
	syscall
push:	add $fp, $sp, $0
	addi $sp, $sp, -32
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	jr $ra
max:	lw $t1, 0($sp)		#max = $s0
	add $t2, $0, $0		#i = 0
loop_max:	
	beq $sp, $fp, end
	lw $v1, 0($sp)		#$v1= arr[i]
	addi $sp, $sp, 4
	addi $t2, $t2, 1
	slt $t0, $v1, $t1	#if v1 < t1
	bne $t0, $0, loop_max	#then loop
	add $t1, $v1, $0	#else t1= v1
	add $t3, $t2, $0	#position = i
	j loop_max
min:	lw $t1, 0($sp)		#min = $s0
	add $t2, $0, $0	#i = 0
loop_min:	
	beq $sp, $fp, end
	lw $v1, 0($sp)		#$v1= arr[i]
	addi $sp, $sp, 4
	addi $t2, $t2, 1
	slt $t0, $t1, $v1	#if t1 < v1
	bne $t0, $0, loop_min	#then loop
	add $t1, $v1, $0	#else t1= v1
	add $t3, $t2, $0	#position = i
	j loop_min
end: 	addi $sp, $sp, -32
	jr $ra
