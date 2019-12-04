lw $t0, 0($gp)
lw $t1, 4($gp)

LOOP:
	sub $t1, $t1, $t0
	slt $t2, $t1, $zero
	beq $t2, 1, ENDLOOP
	addi $t3, $t3, 1
	j LOOP
ENDLOOP:

add $t1, $t1, $t0

sw $t3, 8($gp)
sw $t1, 12($gp)
