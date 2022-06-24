.data
Message: .asciiz "Nhap xau(khong qua 20 ki tu) :"
string: .space 20
.text 
li $v0,4
la $a0,Message
li $t0,20      #Maximum length 
syscall 
la $s0,string   # s0 = address of string
li $s1,0	#s1=i=0
read_str:
li $v0,12
syscall
check_char:
bge $s1,$t0,print_reverse     # branch if s1 >=t0 <=> i >=20
beq $v0,10,print_reverse	#branch if input is enter
add $s2,$s0,$s1        #s2 =s0 + s1 = a[0] +i  = add of s[i]
sb  $v0,0($s2)         #store input char to s[i]
add $s1,$s1,1		#i = i+1
j   read_str
print_reverse:
blt $s1,$zero,exit     #exit if end of string
add $s2,$s0,$s1         #s2 = add of s[i]
lb  $t2,0($s2) 		#t2 = char s[i]
li  $v0,11   		#print char
add $a0,$t2,$zero      
syscall 
addi $s1,$s1,-1
j    print_reverse
exit: