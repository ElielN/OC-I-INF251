#0)percorrer um vetor m(2)...m(100), verifique se m(0) está no vetor, gravar 1 em m(1)

lw $t0, 0($gp)

addi $t1, $gp, 8

LOOP:	
	beq $t2, 99, ENDLOOP
	lw $t3, 0($t1)
	IF:
		bne $t0, $t3, ENDIF
		addi $t4, $zero, 1
		j ENDLOOP
	ENDIF:
	addi $t1, $t1, 4
	addi $t2, $t2, 1
	j LOOP
ENDLOOP:

sw $t4, 4($gp)
