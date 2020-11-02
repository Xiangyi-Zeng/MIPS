		.data

input:	.space 1000
prompt1:	.asciiz "Please enter a string without the '?' character:\n"
prompt2:    .asciiz "\nPlease enter a character to find out whether it's in the string or not:\n"
fail_prompt:.asciiz "\nFail!" 
suc_prompt: .asciiz "\nSuccess! Location:"
		.text

main:
		la $a0, prompt1
		li $v0,4
		syscall
		
		li $v0,8
		la $a0,input
		li $a1,1000
		syscall
loop:
		la $a0, prompt2
		li $v0,4
		syscall
		
		#get char
		li $v0,12
		syscall
		addi $a1,$v0,0
		#'?' then exit
		li $a2,63
		beq $a1,$a2,exit
		#is the char in the string?
		la $t0,input
fi_loct:		
		lb $t1,($t0)
		beq $t1,$zero,fail
		beq $t1,$a1,success
		addi $t0,$t0,1
		j fi_loct
		
fail:
		la $a0,fail_prompt
		li $v0,4
		syscall	
		j loop	
success:	
		la $a0,suc_prompt
		li $v0,4
		syscall
		la $a0,input
		sub $a0,$t0,$a0
		addi $a0,$a0,1
		li $v0,1
		syscall
		j loop
		
exit:
		li $v0,10
		syscall
