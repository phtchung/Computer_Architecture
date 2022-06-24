.text
	li	$s0,4493       # test value
	li	$s1,1
	li	$s2,2 
	slt 	$s3,$s2,$s1
	beq	$s3,$zero,L
	j	EXIT	
L :
	li   	$s0,0	
EXIT : 		
