.text
	li	$s1,4493        # test value
	bltz 	$s1,Convert      # n?u s1 < 0 
	add 	$s0,$s1,0	# lýu resule vào $s0
	j	Exit
Convert :
	xori 	$s0,$s1,0xffffffff
	add	$s0,$s0,1
Exit : 
