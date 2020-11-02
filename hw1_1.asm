	.data 
prompt:   .asciiz "Please use the 'Keyboard and Display MMIO Simulator' in the 'Tools' menu for your input,then check the 'Connect to MIPS' button and the 'reset' button!\n"
cap_alph: .asciiz "Alpha ","Bravo ","China ","Delta ","Echo ","Foxtrot ","Golf ","Hotel ","India ","Juliet ","Kilo ","Lima ","Mary ","November ","Oscar ","Paper ","Quebec ","Research ","Sierra ","Tango ","Uniform ","Victor ","Whisky ","X-ray ","Yankee ","Zulu "
alph_offset: .word 0,7,14,21,28,34,43,49,56,63,71,77,83,89,99,106,113,121,131,139,146,155,163,171,178,186
number:   .asciiz "zero ", "First ", "Second ", "Third ", "Fourth ", "Fifth ", "Sixth ", "Seventh ","Eighth ","Ninth "
n_offset: .word 0,6,13,21,28,36,43,50,59,67 
low_alph: .asciiz "alpha ","bravo ","china ","delta ","echo ","foxtrot ","golf ","hotel ","india ","juliet ","kilo ","lima ","mary ","november ","oscar ","paper ","quebec ","research ","sierra ","tango ","uniform ","victor ","whisky ","x-ray ","yankee ","zulu "
	
	
	.text
main:
		la $a0, prompt
		li $v0,4
		syscall 
		
loop:		
		
		jal getchar
		#is '?' ?
		li $t1,63
      	beq $v0,$t1,exit
      	
      	addi $a0,$v0,0
      	#is number?
		li $t1,47
		li $t2,58
		sgt $t1,$a0,$t1
		slt $t2,$a0,$t2
       	and $t0,$t1,$t2
       	bnez $t0,change_num
       	#is cap_alph?
       	li $t1,64
		li $t2,91
		sgt $t1,$a0,$t1
		slt $t2,$a0,$t2
       	and $t0,$t1,$t2
       	bnez $t0,ch_cap_alph
		#is low_alph?
		li $t1,96
		li $t2,123
		sgt $t1,$a0,$t1
		slt $t2,$a0,$t2
       	and $t0,$t1,$t2
       	bnez $t0,ch_low_alph
		# other symbols?
		li $a0,42
		li $v0,11
       	syscall
		
getchar:	
		lui $a3,0xffff
		wait_for_key:
      	lw   $t0,($a3)  
      	andi $t0,$t0,0x0001 
      	beqz  $t0,wait_for_key
      	lw   $v0,4($a3)   
      	jr $ra

change_num:
		
		li $t1,48
		sub $t3,$a0,$t1
		mul $t3,$t3,4
		la $t4,n_offset
		la $a0,number
		add $t4,$t4,$t3
		lw $t4,($t4)
		add $a0,$a0,$t4
		li $v0,4
       	syscall
		j loop
		
ch_cap_alph:
		li $t1,65
		sub $t3,$a0,$t1
		mul $t3,$t3,4
		la $t4,alph_offset
		la $a0,cap_alph
		add $t4,$t4,$t3
		lw $t4,($t4)
		add $a0,$a0,$t4
		li $v0,4
       	syscall
		j loop

ch_low_alph:
		li $t1,97
		sub $t3,$a0,$t1
		mul $t3,$t3,4
		la $t4,alph_offset
		la $a0,low_alph
		add $t4,$t4,$t3
		lw $t4,($t4)
		add $a0,$a0,$t4
		li $v0,4
       	syscall
		j loop
 
		
exit:
		li $v0,10
		syscall
