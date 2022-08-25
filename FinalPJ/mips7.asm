.data
command:  	.space 100	# save code
opcode:   	.space 30	# save opcode
ident:    	.space 30	# label
token:    	.space 30	# register

input_msg:      .asciiz "Ban hay nhap vao 1 cau lenh :  "	
opcode_msg: 	.asciiz "Opcode: "
Operand_msg: 	.asciiz "Toan hang: "
valid_msg: 	.asciiz " - Hop le.\n"
error_msg: 	.asciiz "\n Khong hop le , Sai dinh dang cau lenh !\n"
cycle_msg: 	.asciiz "\n Chu ki cua lenh hop ngu : "
completed_msg:  .asciiz "\n Cau lenh vua nhap hop le !"
	
expect_register:.asciiz "\n Loi thanh ghi !\n"
expect_integer: .asciiz "\n Loi hang so !!\n"
expect_ident:	.asciiz "\n Loi dinh danh!!!!\n"
expect_imm:  	.asciiz "\n Missing Imm!!!!!!\n"	
# library structure: 
# opcode (7) - operation (3)

library:	.asciiz "add****111;sub****111;addi***112;addu***111;addiu**112;subu***111;mfc0***110;mult***110;multu**110;div****110;mfhi***100;and****111;or*****111;andi***112;ori****112;sll****112;srl****112;lw*****140;sw*****140;lbu****140;sb*****140;lb*****140;lui****120;beq****113;bne****113;slt****111;slti***112;sltiu**112;j******300;jal****300;jr*****100;nop****000"
cycle:		.asciiz "add**1;sub**1;addi*1;addu*1;addiu1;subu*1;mfc0*1;mult*1;multu1;div**1;mfhi*1;mflo*1;and**1;or***1;andi*1;ori**1;sll**1;srl**1;lw***1;sw***1;lbu**1;sb***1;lui**1;beq**2;bne**2;slt**1;slti*1;sltiu1;j****1;jal**1;jr***1;nop**1"

# value : 0-none ; 1 - register; 2 - integer constant ; 3 - (label); 4 - imm($rs).
charGroup: .asciiz "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"		
numberGroup: 	.asciiz "0123456789-"

tokenRegisters: .asciiz "$zero $at   $v0   $v1   $a0   $a1   $a2   $a3   $t0   $t1   $t2   $t3   $t4   $t5   $t6   $t7   $s0   $s1   $s2   $s3   $s4   $s5   $s6   $s7   $t8   $t9   $k0   $k1   $gp   $sp   $fp   $ra   $0    $1    $2    $3    $4    $5    $7    $8    $9    $10   $11   $12   $13   $14   $15   $16   $17   $18   $19   $20   $21   $22   $21   $22   $23   $24   $25   $26   $27   $28   $29   $30   $31   "
.text
main: 
main_input:
	jal  input		# Read input 
	nop
main_check:
	jal check		#check opcode , operands
	nop
end_main:
	li $v0, 10 		#exit
	syscall
# Input Mips code
#------------------------------------------
input:
	li $v0, 4
	la $a0, input_msg 	#display input msg
	syscall
	li $v0, 8
	la $a0, command 	#save string value, up to 100 characters
	li $a1, 100
	syscall
	jr $ra
#check code format
check:
					# save $ra to use later on (return to main)
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	
	addi $s7, $zero, 0		#  $s7 for saving index in command , check ðen kí tu bao nhiêu trong câu lenh nhap vào 
	jal check_opcode		# CHECK OPCODE
	nop
	# CHECK toan hang 1
	li  $s3, 7			# operand 1 index in Library
	jal check_operand
	nop
	
	# CHECK toán hang  2		# if not ',' inbetween operand 1 va operand 2 => FALSE
	li  $s3, 8			# operand 2 index in Library
	add $t0, $s5, $s3
	lb  $t0, 0($t0)
	beq $t0, 48, check_none		# if operand = 0 -> end; 48 is '0' in ASCII
	
	la   $a0, command
	add  $t0, $a0, $s7 		# point to next index of command, di chuyen den dia chi cua so hang tiep theo
	lb   $t1, 0($t0)        
	bne  $t1, 44, error		# if ',' not found -> not found;
	add  $s7, $s7, 1		# increase index of pointer in command by 1
	jal check_operand
	nop
	
	# CHECK OPERAND 3		# if not ',' inbetween operand 2 va operand 3 => FALSE
	li  $s3, 9			# operand 3 index in Library
	add $t0, $s5, $s3
	lb  $t0, 0($t0)
	beq $t0, 48, check_none		# if operand = 0 -> end; '0' in ASCII
	
	la   $a0, command
	add  $t0, $a0, $s7 		# point to next index of command
	lb   $t1, 0($t0)        
	bne  $t1, 44, error		# ',' not found
	add  $s7, $s7, 1
	
	jal check_operand
	nop
	j check_none			# check xem con ki tu nao thua sau cau lenh hay khong
	# return $ra in order to return to main
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra
# check_opcode: check the command
check_opcode:
	la  $a0, command				# address of command
	la  $a1, opcode					# address of opcode
	li  $t0, 0					# current index , i =0 
remove_space:
	add $t1, $a0, $t0				# t1 = address command , a0 = address of command 
	lb  $t2, 0($t1)					# t2 = value of first byte in t1
	bne $t2, 32, end_remove_space			# if not equal ' ' -> go to check character in opcode 
	addi $t0, $t0, 1				# current index in command
	j remove_space
end_remove_space:	
	li  $t9, 0					# index in opcode
	li  $t7, 0					# number of character in current opcode = 0 
read_opcode:
	add $t1, $a0, $t0				# move bit of command
	add $t2, $a1, $t9				# move bit of opcode to read opcode 
	lb  $t3, 0($t1)					#t3 = value first in t1
	
	beq $t3, 32, read_opcode_checked 		# if ' ', done
	beq $t3, 10, read_opcode_checked		# if '\n',done
	beq $t3, 0,  read_opcode_checked		# end read opcode, end of command

	sb  $t3, 0($t2)					#save opcode of command  .  now t3 = first address of opcode(a1) 
	addi $t9, $t9, 1				#increase index of opcode space ,tính cá space bên trong câu lenh
	addi $t0, $t0, 1				#increase index of command's opcode space consist of space in first 
	j read_opcode
read_opcode_checked :
	addi $t7,$t9,0					# number of character in opcode 
	add $s7, $s7, $t0				# s7: index of command is updated to be after opcode, tính cá dau space o dau và trong opcode
	la $a2, library					# save address of lib in a2
	li $t0, -11
	
check_opcode_lib:					# check opcode in library
	addi $t0, $t0, 11
	li $t1, 0 						# i = 0
	li $t2, 0					## j = 0 =>so ki tu cua opcode trong cau lenh õ library
	add $t1, $t1, $t0				#i+=11 => di chuyen len 11 byte de den lenh tiep theo trong thý vien
	compare_opcode:
		add $t3, $a2, $t1			# t3 become first letter of each , then use to compare with opcode 
		lb  $t4,0($t3)				# t4 =t3
		beq $t4, 0, error			# t4 = 0 ? => jump error	
		beq $t4, 42, length_opcode		# if = `*` => check length of opcode 
		add $t5, $a1, $t2			# t5 =dia chi cua opcode vua duoc doc 
		lb  $t6, 0($t5)				# load opcode
		bne $t4, $t6, check_opcode_lib		# compare characters, if not equal then jump to next Instruction.
		addi $t1, $t1, 1			# i = i + 1
		addi $t2, $t2, 1			# j = j + 1
		j compare_opcode
	length_opcode:
		bne $t2, $t7, check_opcode_lib		#if opcode not equal with opcopde in lib -> idousuru to next opcode in lib	
end_check_opcode_lib:
	add $s5, $t0, $a2				# save index of opcode  in Library have value = opcode read 
	
#Print 
	li $v0, 4
	la $a0, opcode_msg				#display dialogue
	syscall
	
	la $a3, opcode					#start display opcode 
	li $t0, 0
	print_opcode:
		beq $t0, $t9, end_print_opcode
		add $t1, $a3, $t0
		lb  $t2, 0($t1)
		li $v0, 11
		add $a0, $t2, $zero
		syscall 
		addi $t0, $t0, 1
		j print_opcode
	end_print_opcode:
	
	li $v0, 4
	la $a0, valid_msg
	syscall	
	jr $ra
# check_operand: 
check_operand:
	# save $ra to return to check_operand later
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	
	add $t9,$s5,$s3				# point to operand in Library. s5 = vi trí cua opcode vua check ðc o lib . s3 =7.nhay ðen operand 1 
	lb  $t9, 0($t9)
	addi $t9, $t9, -48			# Char -> Number. load ra ascii-> -48 .t9 consist of value ( 0,1,2,3,4)
	
	la  $a0, command
	add $t0, $a0, $s7			#t0 point to index in command hold by s7.Nhay ðen so hang 1 trong command ngýoi dùng nhap 

	li $t1, 0				# i = 0
	space_remove:				# remove space
		add $t2, $t0, $t1
		lb  $t2, 0($t2)			
		bne $t2, 32, end_space_remove	# if not =  ' ' => end 
		addi $t1, $t1, 1		# i = i + 1	
		j space_remove
	end_space_remove:
	
	add $s7, $s7, $t1			# update index of command after remove space.vi tri cua so hang 1 sau khi loai bo space
	li $s2, 0				# deactive check number_register
	beq $t9,$zero, check_none			
	beq $t9,1, check_register		# register				
	beq $t9,2, check_number			# integer constant 
	beq $t9,3, check_label			# Label 		
	beq $t9,4, check_number_register		# Check number & register
end_check_operand:
	# write $ra, return to check_operand
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra
#   check functions
check_none:
	la $a0, command
	add $t0, $a0, $s7			#s7 la vi tri cua so hang sau khi da xoa het dau cach o ðau và sau opcode 
	lb $t1, 0($t0)
	beq $t1, 10, done			# if t1 = '\n'=> ket thúc 
	beq $t1, 0, done			# if t1 = '0' => end of string => done 
	j error	
done:
	li $v0, 4
	la $a0, completed_msg
	syscall
	
	li $v0, 4
	la $a0, cycle_msg
	syscall
# check cycle of opcode 	
check_opcode_cycle:
	la  $a0, command				# address of command
	la  $a1, opcode					# address of opcode
	li  $t0, 0					# current index , i =0 
remove_space_cycle:
	add $t1, $a0, $t0				# t1 = address command , a0 = address of command 
	lb  $t2, 0($t1)					# t2 = value of first byte in t1
	bne $t2, 32, end_remove_space_cycle			# if not equal ' ' -> go to check character in opcode 
	addi $t0, $t0, 1				# current index in command
	j remove_space_cycle
end_remove_space_cycle:	
	li  $t9, 0					# index in opcode
	li  $t7, 0					# number of character in current opcode = 0 
	
read_opcode_cycle:
	add $t1, $a0, $t0				# move bit of command
	add $t2, $a1, $t9				# move bit of opcode to read opcode 
	lb  $t3, 0($t1)					#t3 = value first in t1
	
	beq $t3, 32, read_cycle_checked 		# if ' ', done
	beq $t3, 10, read_cycle_checked		# if '\n',done
	beq $t3, 0,  read_cycle_checked		# end read opcode, end of command

	sb  $t3, 0($t2)					#save opcode of command  .  now t3 = first address of opcode(a1) 
	addi $t9, $t9, 1				#increase index of opcode space ,tính cá space bên trong câu lenh
	addi $t0, $t0, 1				#increase index of command's opcode space consist of space in first 
	j read_opcode_cycle
read_cycle_checked :
	addi $t7,$t9,0					# number of character in opcode 
	add $s7, $s7, $t0				# s7: index of command is updated to be after opcode, tính cá dau space o dau và trong opcode
	la $a2, cycle					# save address of lib in a2
	li $t0, -7					# so ki tu cua opcode
					
check_cycle_lib:					# check opcode in library
	addi $t0, $t0, 7
	li $t1, 0 						# i = 0
	li $t2, 0					## j = 0 =>so ki tu cua opcode trong cau lenh õ library
	add $t1, $t1, $t0				#i+=11 => di chuyen len 11 byte de den lenh tiep theo trong thý vien
	compare_cycle:
		add $t3, $a2, $t1			# t3 become first letter of each , then use to compare with opcode 
		lb  $t4,0($t3)				# t4 =t3
		beq $t4, 0, error			# t4 = 0 ? => jump error	
		beq $t4, 42, length_cycle		# if = `*` => check length of opcode 
		add $t5, $a1, $t2			# t5 =dia chi cua opcode vua duoc doc 
		lb  $t6, 0($t5)				# load opcode
		bne $t4, $t6, check_cycle_lib		# compare characters, if not equal then jump to next Instruction.
		addi $t1, $t1, 1			# i = i + 1
		addi $t2, $t2, 1			# j = j + 1
		j compare_cycle
	length_cycle:
		bne $t2, $t7, check_cycle_lib	
	end_cycle:
		add $s6, $t0, $a2
		addi $s6, $s6,5			# vi tri cua lenh trong cycle có opcode trung opcode cua cau lenh 
	print_cycle:
		lb  $k0,0($s6)
		beq $k0,42,update			# gap * thi bo qua
		li $v0,1
		addi $a0,$k0,-48			# char - > number 
		syscall
		jal end_main
		nop
	update: 
		addi $s6,$s6,1
		j print_cycle
		nop	  	
check_register:
	la $a0, command					#save add command into a0
	la $a1, token
	la $a2, tokenRegisters				# library of registers
	add $t0, $a0, $s7				# point to index of command 
	
	li $t1, 0					# i = 0
	li $t9, 0					# number of character in register
read_register_command:
	add $t2, $t0, $t1				# t1=i , t0 = vi trí cua so hang trong command 
	add $t3, $a1, $t1				# token , mang ðe lýu so hang nhý thanh ghi ..
	lb $t4, 0($t2)					# tmp t4 dia chi hien tai cua cau lenh 
	beq $t4, 41, end_read				# if =  ')' => end 
	beq $t4, 44, end_read				#  if =  ' , ' => end
	beq $t4, 10, end_read				#  if =  '\n' - > end 
	beq $t4, 0, end_read				#  if = '0 'end
	addi $t1, $t1, 1				# i += 1
	beq $t4, 32, read_register_command		# if meet ' ' -> continue 
		
	sb $t4, 0($t3)					# t3 := t4=> lýu tung giá tri ðoc ðc vào a1 
	addi $t9, $t9, 1				# j += 1. so ki tu cua thanh ghi nguoi dung nhap
	j read_register_command
end_read:
	add $s7, $s7, $t1				# update value of index in command ( s7 là tong kí tu ca dau cách tu ðau ðen thanh ghi vua ðoc ) 
	
	li $t0, -6					# i =6; 			
compare_register:	
	addi $t0, $t0,6
	li $t1, 0 					# i = 0
	li $t2, 0					# j = 0
	add $t1, $t1, $t0				
	compare_:
		add $t3, $a2, $t1			# t3 kí tu ðau tiên cua thanh ghi trong lib 
		lb  $t4, 0($t3)
		
		beq $t4, 0, error_reg
		beq $t4, 32, length_register		# if t4 = ` ` => check length
	
		add $t5, $a1, $t2			# Load token 
		lb  $t6, 0($t5)				# get value 
	
		bne $t4, $t6, compare_register		# compare characters, if not equal then jump to next Register in lib 
		addi $t1, $t1, 1			# i = i + 1
		addi $t2, $t2, 1			# j = j + 1, continue compare the next character
		j compare_
	length_register:
		bne $t2, $t9, compare_register		# if length not equal, jump to next register	
compare_register_done:
# PRINT TO SCREEN 
	beq $s2, 1, on_token_number_register
	
	li $v0, 4					#display operand 
	la $a0, Operand_msg
	syscall
	
	la $a3, token
	li $t0, 0
	print_register:
		beq $t0, $t9, end_print_register
		add $t1, $a3, $t0
		lb  $t2, 0($t1)
		li $v0, 11
		add $a0, $t2, $zero
		syscall 
		addi $t0, $t0, 1
		j print_register
	end_print_register:
	
	li $v0, 4
	la $a0, valid_msg
	syscall
	jal end_check_operand
	nop
on_token_number_register:
	la $a1, token
	li $t0, 0
	print_on_token_register:
		beq $t0, $t9, end_print_on_token_register
		add $t1, $a1, $t0
		lb  $t2, 0($t1)
		li $v0, 11
		add $a0, $t2, $zero
		syscall 
		addi $t0, $t0, 1
		j print_on_token_register
	end_print_on_token_register:
	
	li $v0, 11
	li $a0, 41
	syscall 
	li $v0, 4
	la $a0, valid_msg
	syscall
	jr $ra
check_number:
	la $a2, numberGroup				# save the numberGroup into s2 
	jal check_ident
	nop
	jal end_check_operand
	nop
check_ident:
	la $a0, command
	la $a1, ident
	add $t0, $a0, $s7			# point to index of instruction. di chuyen ðen vi trí cua so hang 1 sau khi xóa space 
	li $t1, 0				# i = 0 , bien chay doc ki tu
	li $t9, 0				# index of ident
read_ident:
	add $t2, $t0, $t1			# command
	lb $t4, 0($t2)			
	add $t3, $a1, $t1			# ident , 
		
	beq $t4, 40, end_read_ident		# if t4 =  '('
	beq $t4, 44, end_read_ident		# if t4 =  ' , '
	beq $t4, 10, end_read_ident		# if t4 =  '\n'
	beq $t4, 0, end_read_ident		# if t4 = 0 => end_read 
		
	addi $t1, $t1, 1
	beq $t4, 32, read_ident	 		# if meet ' ' then continue
		
	sb $t4, 0($t3)				# t3 :=t4 . load value after read in to t3 
	addi $t9, $t9, 1
	j read_ident	
end_read_ident:
	add $s7, $s7, $t1			# update value of index . check xong update vi trí ðe cbi check tiep 
	beq $t9, 0, error_ide
	li $t2, 0				# index for Ident	
compare_ident:					#compare 
	beq  $t2, $t9, end_compare_ident	# index = number of character = >end 
	li   $t1, 0				# index for charGroup
	add  $t3, $a1, $t2		
	lb   $t3, 0($t3)			# value of each char in Ident	
	loop:					# check each character in Ident is in group or not
		add $t4, $a2, $t1
		lb $t4, 0($t4)
		beq $t4, 0, error_ide		# ðen het chuoi numbergroup //
		beq $t4, $t3, end_loop		
		addi $t1, $t1, 1
		j loop	
	end_loop:
		addi $t2, $t2, 1		#index in so hang  
		j compare_ident
end_compare_ident:
	beq $s2, 1, on_number_register	
#PRINT INFO TO THE SCREEN
	li $v0, 4
	la $a0, Operand_msg
	syscall
	
	la $a3, ident
	li $t0, 0
	print_ident:
		beq $t0, $t9, printed_ident
		add $t1, $a3, $t0
		lb  $t2, 0($t1)
		li $v0, 11
		add $a0, $t2, $zero
		syscall 
		addi $t0, $t0, 1
		j print_ident
	printed_ident:
	
	li $v0, 4
	la $a0, valid_msg
	syscall
	jr $ra
on_number_register:
	li $v0, 4
	la $a0, Operand_msg
	syscall

	la $a3, ident
	li $t0, 0
	print_on_ident:
		beq $t0, $t9, end_print_on_ident
		add $t1, $a3, $t0
		lb  $t2, 0($t1)
		li $v0, 11
		add $a0, $t2, $zero
		syscall 
		addi $t0, $t0, 1
		j print_on_ident
	end_print_on_ident:
	
	li $v0, 11
	li $a0, 40
	syscall
	jr $ra
check_label:
	la $a2, charGroup
	jal check_ident
	nop
	jal end_check_operand
	nop
check_number_register:
	# save $ra to return
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	li $s2, 1				# active number_register
	
	la $a2, numberGroup			# Check number
	jal check_ident
	nop
	
	addi $s7, $s7, 1
	beq $t4, 0, error_imm			#ket thuc chuoi hay chua

	jal check_register			# Check register
	nop
	
	beq $t4, 0, error_imm			#ket thuc chuoi hay chua
	addi $s7, $s7, 1
	# use saved $ra to return
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra 
error:
	li $v0, 4
	la $a0, error_msg
	syscall
	j end_main
error_reg:
	li $v0, 4
	la $a0, expect_register
	syscall
	j end_main
error_ide:
	li $v0, 4
	la $a0, expect_ident
	syscall
	j end_main	
error_imm:
	li $v0, 4
	la $a0, expect_imm
	syscall
	j end_main	
	

	

	
