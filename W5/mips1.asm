.data
test: .asciiz "Hello World Pham Thanh Chung 20194493"
.text
li  $v0, 4
la  $a0, test
syscall 