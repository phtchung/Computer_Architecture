.eqv MONITOR_SCREEN 0x10010000   #Dia chi bat dau cua bo nho man hinh
.eqv RED            0x00FF0000   #Cac gia tri mau thuong su dung
.eqv GREEN          0x0000FF00
.eqv BLUE           0x000000FF
.eqv WHITE          0x00FFFFFF
.eqv YELLOW         0x00FFFF00
.text
 	li $k0, MONITOR_SCREEN 		#Nap dia chi bat dau cua man hinh
main: 	addi $s1, $zero, 8		#Size
	jal display_col
	nop
	jal display_row
	nop	
	j	exit 
display_col:
	addi $t0, $0, 0		#i =0 c?t
col_i: beq $t0, 0, red_col
	beq $t0, 1, red_col
	j white_col
	nop
red_col:
	mul $t2, $t0, 4
	add $t2, $t2, $k0
	li $t1, 0		#j = 0 hàng 
col_display_red:	
	mul $t3, $t1, 32
	add $t3, $t3, $t2
	li $a0, RED
	sw $a0, 0($t3)
	addi $t1, $t1, 1
	slt $t4, $t1, $s1
	bne $t4, 0, col_display_red
	j check_col_i
	nop
white_col:
	mul $t2, $t0, 4
	add $t2, $t2, $k0
	li  $t1, 0		#j
col_display_white:	
	mul $t3, $t1, 32
	add $t3, $t3, $t2
	li $a0, WHITE
	sw $a0, 0($t3)
	addi $t1, $t1, 1
	slt $t4, $t1, $s1
	bne $t4, 0, col_display_white
	j check_col_i
	nop
check_col_i:addi $t0, $t0,1		
	slt $t4, $t0, $s1		# $s1 =size = 8 
	bne $t4, 0, col_i
	jr $ra
display_row:
	addi $t0, $0, 0		#i
row_i: 	beq $t0, 0, red_row
	beq $t0, 1, red_row
	beq $t0, 7, red_row
	beq $t0, 6, red_row
	j check_row_i
	nop
red_row:
	mul $t2, $t0, 32
	add $t2, $t2, $k0
	li $t1, 0		#j
row_display_red:	
	mul $t3, $t1, 4
	add $t3, $t3, $t2
	li $a0, RED
	sw $a0, 0($t3)
	addi $t1, $t1, 1
	slt $t4, $t1, $s1
	bne $t4, 0, row_display_red
	j check_row_i
	nop
check_row_i:
	addi $t0, $t0, 1
	slt $t4, $t0, $s1
	bne $t4, 0, row_i
	jr $ra
exit:
	li $v0, 10
	syscall