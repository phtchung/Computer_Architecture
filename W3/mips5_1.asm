.data
A: .space  16 # Khai bao mang A có 4 phan tu 

.text
	li 	$s1,-1 	# gan i=-1
	li 	$s5,0	#SUM=0
	li      $s4,1    #step =1 
	
loop:	add 	$s1,$s1,$s4	#i=i+step
	add	$t1,$s1,$s1	#t1=2*s1
	add	$t1,$t1,$t1	#t1=4*s1	
	add	$t1,$t1,$s2	#t1 store the address of A[i]
	lw	$t0,0($t1)	#load value of A[i] in$t0
	add	$s5,$s5,$t0	#sum=sum+A[i]	
	seq	$t8,$t0,$zero     # if A[i] ==0
	bne	$t8,$zero,loop	#if i != n, goto loop