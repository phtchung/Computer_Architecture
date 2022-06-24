#-------------------------------------------------------------
# Project 19:
# Write a program that : 
# -	Input some variable names. 
# -	Check if variable names consist only of English letters, digits and underscores. 
# -	Can't start with a digit.
#-------------------------------------------------------------
.data
	String:		.space 20		
	getvariableName_msg:	.asciiz "Enter the variableName:"
	getvariableName_invalid_msg:	.asciiz "Invalid variableName.\nPlease re-enter 0 < variableName <= 20 (charater)"
	msg_ : .asciiz "\n VariableName("
	msg_false : .asciiz ") = false \n"
	msg_true : .asciiz ") = true \n"
	msg_cf_continue : .asciiz " Do you want to continue input variable name ?"
#-------------------------------------------------------------
.text
main:	jal	getvariableName 		# get the variableName
	nop
	jal 	check1stcharacter		# check 1st character 
	nop
	bne    	$s1,10,check			#( if character is not end of string -> branch check ) 
	nop
	sb 	$0, String($t0)			# change the last character := \0
	j	print
	nop
print:
	li	$v0,4
	la	$a0,msg_			# display output 
	syscall
	li	$v0,4				# display output
	la	$a0,String
	syscall
	
	li	$v0,4				# display output
	la	$a0,msg_true
	syscall
	li	$v0,50
	la	$a0,msg_cf_continue			# confirm continue program  
	syscall
	beq	$a0,$zero,main				# if $a0 = 0 return main and begin again 
	nop						# else exit program 
	j 	exit
	nop
	
getvariableName_invalid:
	li 	$v0, 55					# input again ( 0< variable name < 21 ) 
	la 	$a0, getvariableName_invalid_msg
	li 	$a1, 0
	syscall
	
getvariableName:	
	li	$v0, 54					# input variable name
	la	$a0, getvariableName_msg
	la	$a1, String				#save the address of string in $a1
	la	$a2, 21					# 21 = MAX_NAME_LEN + 1
	syscall  
	
	beq	$a1,-2,exit				# if cancel choosen -> out 
	
	bnez 	$a1, getvariableName_invalid		# invalidname because 0< name < 21 character 
	nop
			
	la 	$s0,String			#s0 is the 1stcharacter's address 
	add 	$t0,$zero,$zero			# i = 0
	add	$t1,$s0,$t0			# $t1 is each of character's address 
	lb	$s1,0($t1)			# $s1 is the value of each character  
	jr	$ra
Next :
	add  	$t1,$s0,$t0			# update address 
	lb	$s1,0($t1)			# s1 is value of character[i]
	jr	$ra
check :
	li 	$t4,'A'				# $t4 = 'A'
	slt 	$t3,$s1,$t4			# if $s1 < $t4 then t3 = 1 else t3 =0 
	bne 	$t3,$zero,checknumber		# if t3 !=0 then jump checknumber 
	nop
	li 	$t4,'Z'				# $t4 = 'Z'
	sle	$t3,$s1,$t4			# if $s1 <= $t4 then t3 = 1 else t3 =0 
	bne 	$t3,$zero,checked		# if t3 !=zero jump checked 
	nop
	li 	$t4,'_'				
	beq	$s1,$t4,checked			# if s1 = '_' then jump checked 
	nop
	li 	$t4,'a'				# t4 = 'a'
	slt 	$t3,$s1,$t4			# if s1 < t4 th? t3 = 1
	bne 	$t3,$zero,error			# if t3 !=0 jump error 
	nop
	li 	$t4,'z'				# t4 = 'z'
	sle 	$t3,$s1,$t4			# if s1 <= t4 => t3 =1 
	bne 	$t3,$zero,checked		# t= !=0 then jump checked 
	nop	
check1stcharacter:
	
	li 	$t4,'A'				# $t4 = 'A'
	slt 	$t3,$s1,$t4			# s1 < t4 then t3 = 1
	bne 	$t3,$zero,error			# if t3!=0 them jump error 
	nop
	li 	$t4,'Z'				# $t4 = 'z'
	sle	$t3,$s1,$t4			# if $s1 <= $t4 then t3 = 1 else t3 =0 
	bne 	$t3,$zero,checked		# if t3 !=0 then t3 = 0
	nop
	li 	$t4,'_'				# t4 = '_'
	beq	$s1,$t4,checked			# if s1 = '_' then jump checked 
	nop
	li 	$t4,'a'				# t4 = 'a'
	slt 	$t3,$s1,$t4			# s1 < t4 then t3 = 1
	bne 	$t3,$zero,error			# if t3!=0 then jump error
	nop
	li 	$t4,'z'				# t4 = 'z'
	sle 	$t3,$s1,$t4			# if s1 <= t4 then t3 =1 
	bne 	$t3,$zero,checked		# if t3 !=0 then jump check 
	nop	
checknumber:
	li	$t4,'0'				# t4 ='0'
	slt 	$t3,$s1,$t4			#s1 <t4 th? t3 =1
	bne 	$t3,$zero,error			# if t3 !=0 then jump error 
	nop
	li 	$t4,'9'				# t4 ='9'
	sle	$t3,$s1,$t4			#s1 <t4 th? t3 =1
	bne	$t3,$zero,checked		# if t3 !=0 then jump checked 
	nop
	j	error
	nop

checked:
	addi	$t0,$t0,1			# update i= i+1 
	beq	$t0,20,print			# N?u t =20 ( t?c là có 20 kí t? h?p l? và 1 kí t? '\0' , lúc này chu?i s? in ra chu?i true luôn 
	j	Next
	nop
increase :
	addi	$t0,$t0,1			# i = i+1
	add  	$t1,$s0,$t0			# update address 
	lb	$s1,0($t1)			# s1 is value of character[i]
	j	error				# nv : n?u ph?n t? l?i , t?m t?i ph?n t? cu?i cùng c?a chu?i . Thay kí t? '\n' thành '\0'
	nop
error :
	bne    	$s1,10,increase			# find the last character of string 
	nop
	
	sb 	$0, String($t0)			# change the last character := \0 
	li	$v0,4				# display output
	la	$a0,msg_
	syscall
	li	$v0,4				# display output
	la	$a0,String
	syscall
	li	$v0,4				# display output
	la	$a0,msg_false
	syscall
	li	$v0,50				# display output
	la	$a0,msg_cf_continue
	syscall
	beq	$a0,$zero,main				# If a0 =0 (Yes ) => begin again 
	nop					# else if a0 = 1 ( No ) then out program
	j	exit
	nop
	
exit :						# out program
	li $v0,10
	syscall
	
