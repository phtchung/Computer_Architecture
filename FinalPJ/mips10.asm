.data
zero:  .byte 0x3f
one:   .byte 0x6
two:   .byte 0x5b
three: .byte 0x4f
four:  .byte 0x66
five:  .byte 0x6d
six:   .byte 0x7d
seven: .byte 0x7
eight: .byte 0x7f
nine:  .byte 0x6f

mess1: .asciiz "Khong the div cho so 0 \n"

.eqv IN_ADDRESS_HEXA_KEYBOARD 	0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD 	0xFFFF0014
.eqv SEVENSEG_LEFT 0xFFFF0011		 # Dia chi cua den led 7 doan trai.
.eqv SEVENSEG_RIGHT 0xFFFF0010 		 # Dia chi cua den led 7 doan phai
.text
main:
start:
	li $s1,SEVENSEG_LEFT     	 
        li $s2,SEVENSEG_RIGHT     	 
        li $s0,0      			 # bien kiem tra loai phim duoc nhan, 0: so, 1 :toan tu, 2: terminate key
        li $s3,0     			 # bien kiem tra loai toan tu, 1:add, 2:sub, 3:nhan, 4:div
        li $s4,0      			 # so thu nhat
        li $s5,0   			 # so thu hai
        li $s6,0     			 # ket qua 2 so, add ,sub, nhan, div 
        li $t9,0 			 # gia tri tam thoi luu so vua nhap
	
	li $t1, IN_ADDRESS_HEXA_KEYBOARD  	
	li $t2, OUT_ADDRESS_HEXA_KEYBOARD 	
	li $t3, 0x80			  	#enable keyboard interrupt
	sb $t3, 0($t1)
	li $t4,0			  # gia tri led ,zero->nine
	li $t5,0       			  # gia tri cua so duoc nhap
storefirstvalue:
	lb $t4,zero 			  # led trai dau tien can hien thi :0
	addi $sp,$sp,4  		  # day vao stack
        sb $t4,0($sp)
loop:	#loop de doi nhap phim tu digital lab sim
	beq $s0,2,endloop 		  #neu phim terminate(phim e) duoc bam ,thoat loop
	nop
	nop
	nop
	nop
	j loop
endloop:
end_main:
	li $v0,10
	syscall
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Xu ly khi xay ra interupt
# Hien thi so vua bam len den led 7 doan
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.ktext 0x80000180
process:
	jal checkrow1			#check hang 1 xem co phim nao duoc nhap ko
	bnez $t3,convert_row1		#t3 != 0 --> co phim duoc nhap, convert phim do thanh bit hien ra led
	nop
	jal checkrow2			#check hang 2 xem co phim nao duoc nhap ko
	bnez $t3,convert_row2
	nop
	jal checkrow3			#check hang 3 xem co phim nao duoc nhap ko
	bnez $t3,convert_row3
	nop
	jal checkrow4			#check hang 4 xem co phim nao duoc nhap ko
	bnez $t3,convert_row4
checkrow1:
	addi $sp,$sp,4
        sw $ra,0($sp) 		# luu ra lai vi ve sau co the doi 
        li $t3,0x81     	# Kich hoat interrupt, cho phep bam phim o hang 1
        sb $t3,0($t1)
        jal getvalue		# get vi tri ( hang va cot ) cua phim duoc nhap neu co
        lw $ra,0($sp)
        addi $sp,$sp,-4
        jr $ra
checkrow2:
	addi $sp,$sp,4
        sw $ra,0($sp) 
	li $t3,0x82     	# Kich hoat interrupt, cho phep bam phim o hang 2
        sb $t3,0($t1)
        jal getvalue
        lw $ra,0($sp)
        addi $sp,$sp,-4
        jr $ra
checkrow3:
	addi $sp,$sp,4
        sw $ra,0($sp) 
	li $t3,0x84     	# Kich hoat interrupt, cho phep bam phim o hang 3
        sb $t3,0($t1)
        jal getvalue
        lw $ra,0($sp)
        addi $sp,$sp,-4
        jr $ra
checkrow4:
	addi $sp,$sp,4
        sw $ra,0($sp) 
	li $t3,0x88     	# Kich hoat interrupt, cho phep bam phim o hang 4
        sb $t3,0($t1)
        jal getvalue
        lw $ra,0($sp)
        addi $sp,$sp,-4
        jr $ra
getvalue:
	addi $sp,$sp,4
        sw $ra,0($sp) 
        li $t2,OUT_ADDRESS_HEXA_KEYBOARD  #dia chi chua vi tri phim duoc nhap
        lb $t3,0($t2)			  #load vi tri phim duoc nhap
        lw $ra,0($sp)
        addi $sp,$sp,-4
        jr $ra
convert_row1:			# convert tu vi tri sang bit de chuyen den led
	beq $t3,0x11,case_zero			# 0x11 -->phim o hang 1 cot 1--> 0
	beq $t3,0x21,case_one			
	beq $t3,0x41,case_two
	beq $t3,0xffffff81,case_three
case_zero:
	lb $t4,zero		#t4=zero (tuc = 0x3f, tong cac bit thanh ghi de tao thanh so 0 tren led)
	li $t5,0		#t7= 0
	j updatetmp
case_one:
	lb $t4,one
	li $t5,1
	j updatetmp
case_two:
	lb $t4,two
	li $t5,2
	j updatetmp
case_three:
	lb $t4,three
	li $t5,3
	j updatetmp
	
convert_row2:
	beq $t3,0x12,case_four
	beq $t3,0x22,case_five
	beq $t3,0x42,case_six
	beq $t3,0xffffff82,case_seven
case_four:
	lb $t4,four
	li $t5,4
	j updatetmp
case_five:
	lb $t4,five
	li $t5,5
	j updatetmp
case_six:
	lb $t4,six
	li $t5,6
	j updatetmp
case_seven:
	lb $t4,seven
	li $t5,7
	j updatetmp
	
convert_row3:
	beq $t3,0x14,case_eight
	beq $t3,0x24,case_nine
	beq $t3 0x44,case_a
	beq $t3 0xffffff84,case_b
case_eight:
	lb $t4,eight
	li $t5,8
	j updatetmp
case_nine:
	lb $t4,nine
	li $t5,9
	j updatetmp
case_a:	#subong hop phim add
	addi $s0,$0,1          #bien check phim nhap vao chuyen thanh 1(chung to nhap vao 1 toan tu)
	addi $s3,$0,1	#bien check loai toan tu chuyen thanh 1(tuc phep add)
	
	j setfirstnumber        #chuyen den ham chuyen 2 byte dang hien tren 2 led thanh so de tinh toan 
case_b: #subong hop phim sub
	addi $s0,$0,1
	addi $s3,$0,2
	j setfirstnumber
	
convert_row4:
	beq $t3,0x18,case_c
	beq $t3,0x28,case_d
	beq $t3,0x48,case_e
	beq $t3 0xffffff88,case_f
case_c: #subong hop phim nhan
	addi $s0,$0,1
	addi $s3,$0,3
	j setfirstnumber	
case_d: #subong hop phim div
	addi $s0,$0,1
	addi $s3,$0,4
	j setfirstnumber

case_e:  #subong hop terminate key
	addi $s0,$0,2
	j finish
	
setfirstnumber:       		# luu so thu nhat 
	addi $s4, $t9, 0
	li $t9, 0
	j done
case_f:  #subong hop bam =
setsecondnumber:	addi $s5, $t9, 0	#luu so thu hai 
			li $t9, 0 
			j get_result
updatetmp:			
	 mul $t9, $t9, 10
	 add $t9, $t9, $t5
done:				#s0 = 0> so hang
	beq $s0,1,resetled   # s0=1-->toan tu-->chuyen den ham reset led
	nop
load_to_left_led:   # ham hien thi bit len led trai
	lb $t6,0($sp)       #load bit hien thi led tu stack
	add $sp,$sp,-4    
	sb $t6,0($s1)       # hien thi len led trai
load_to_right_led:	# ham hien thi bit len led phai
	sb $t4,0($s2)       # hien thi bit len led phai
	add $sp,$sp,4
	sb $t4,0($sp)       #day bit nay vao stack
	j finish 

get_result:
	beq $s3,1,add         # s3=1--> add
	beq $s3,2,sub
	beq $s3,3,nhan
	beq $s3,4,div
add:
	add $s6,$s5,$s4
	li $s3,0
	j print_add
	nop     		# s6=s5+s4
	
print_add:
	li $v0, 1
	add $a0, $0, $s4
	syscall
	li $s4, 0
	
	
	li $v0, 11
	li $a0, '+'
	syscall
	
	li $v0, 1
	add $a0, $0, $s5
	syscall
	li $s5, 0		#reset $s5
	
	li $v0, 11
	li $a0, '='
	syscall
	
	li $v0, 1
	add $a0, $0, $s6
	syscall
	nop
	
	li $v0, 11
	li $a0, '\n'
	syscall
	li $s7,100
	div $s6,$s7
	mfhi $s6	    # chi lay 2 chu so cuoi cua ket qua de in ra led
	j show_result_in_led       # chuyen den ham div ket qua thanh 2 chu so de hien thi len tung led
	nop
	
sub:
	sub $s6,$s4,$s5    # s6=s4-s5
	li $s3,0
	j print_sub
	nop
print_sub:
	li $v0, 1
	add $a0, $0, $s4
	syscall
	
	li $v0, 11
	li $a0, '-'
	syscall
	
	li $v0, 1
	add $a0, $0, $s5
	syscall
	
	li $v0, 11
	li $a0, '='
	syscall
	
	li $v0, 1
	add $a0, $0, $s6
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	j show_result_in_led       # chuyen den ham div ket qua thanh 2 chu so de hien thi len tung led
	nop
nhan:
	mul $s6,$s4,$s5     # s6=s4*s5
	li $s3,0
	j print_mul
	nop
print_mul:
	li $v0, 1
	add $a0, $0, $s4
	syscall
	
	li $v0, 11
	li $a0, '*'
	syscall
	
	li $v0, 1
	add $a0, $0, $s5
	syscall
	
	li $v0, 11
	li $a0, '='
	syscall
	
	li $v0, 1
	add $a0, $0, $s6
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	li $s7,100
	div $s6,$s7
	mfhi $s6	    # chi lay 2 chu so sau c?ng cua ket qua in ra
	j show_result_in_led       # chuyen den ham div ket qua thanh 2 chu so de hien thi len tung led
	nop
div:
	beq $s5,0,div0
	li $s3,0
	div $s4,$s5   	    # s6=s4/s5
	mflo $s6
	mfhi $s7
	j print_div
	nop
print_div:
	li $v0, 1
	add $a0, $0, $s4
	syscall
	
	li $v0, 11
	li $a0, '/'
	syscall
	
	li $v0, 1
	add $a0, $0, $s5
	syscall
	
	li $v0, 11
	li $a0, '='
	syscall
	
	li $v0, 1
	add $a0, $0, $s6
	syscall
	
	li $v0, 11
	li $a0, ' '
	syscall
	
	li $v0, 11
	li $a0, 'r'
	syscall
	
	li $v0, 11
	li $a0, '='
	syscall
	
	li $v0, 1
	add $a0, $0, $s7
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	j show_result_in_led       # chuyen den ham div ket qua thanh 2 chu so de hien thi len tung led
	nop
div0: 
	li $v0, 55
	la $a0, mess1
	li $a1, 0
	syscall
	j resetled

show_result_in_led:	#ham div ket qua thanh 2 chu so de hien thi len tung led
	li $t8,10
	div $s6,$t8    #s6/10
	#---------
	mflo $t5       #t5 = result
	jal convert    #chuyen den ham chuyen t7 thanh bit hien thi len led
        sb $t4,0($s1)  # hien thi len led trai
	#----------
	mfhi $t5       #t5= remainder
	jal convert    #convert t5 thanh bit hien thi len led
        sb $t4,0($s2)  #hien thi len led phai 
        j resetled     # ham reset lai led
convert:
	addi $sp,$sp,4
        sw $ra,0($sp)
        beq $t5,0,case_0	# t5=0 -->ham chuyen 0 thanh bit zero hien thi len led
        beq $t5,1,case_1
        beq $t5,2,case_2
        beq $t5,3,case_3
        beq $t5,4,case_4
        beq $t5,5,case_5
        beq $t5,6,case_6
        beq $t5,7,case_7
        beq $t5,8,case_8
        beq $t5,9,case_9
case_0:	#ham chuyen 0 thanh bit zero hien thi len led
	lb $t4,zero    #t4=zero
	j finishconvert #ket thuc
case_1:
	lb $t4,one
	j finishconvert
case_2:
	lb $t4,two
	j finishconvert
case_3:
	lb $t4,three
	j finishconvert
case_4:
	lb $t4,four
	j finishconvert
case_5:
	lb $t4,five
	j finishconvert
case_6:
	lb $t4,six
	j finishconvert
case_7:
	lb $t4,seven
	j finishconvert
case_8:
	lb $t4,eight
	j finishconvert
case_9:
	lb $t4,nine
	j finishconvert

finishconvert:
	lw $ra,0($sp)
	addi $sp,$sp,-4
	jr $ra
           
resetled:
	li $s0,0           #s0=0--> doi nhap so tiep theo trong 2 so
        lb $t4,zero        # day bit zero vao stack
	addi $sp,$sp,4
        sb $t4,0($sp)
finish:
	j end_exception
	nop
end_exception:
	# return to start of the loop instead of where the interrupt occur, since the loop doesn't do meaningful thing
	la $a3, loop
	mtc0 $a3, $14
	eret