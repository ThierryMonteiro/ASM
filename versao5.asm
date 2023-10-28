.data
        
        #Instruções
	#Tipo I
	str_addiu: .asciiz "addiu "
	str_sw:    .asciiz "sw "
	str_lw:    .asciiz "lw "
	str_bne:   .asciiz "bne "
	str_addi:  .asciiz "addi "
	str_lui:   .asciiz "lui "
	str_ori:   .asciiz "ori "
	#Tipo R
	str_add:   .asciiz "add "
	str_addu:  .asciiz "addu "
	str_jr:    .asciiz "jr "
	str_mul:   .asciiz "mul "
	#Tipo J
	str_jal:   .asciiz "jal "
	str_j:     .asciiz "j "
	#Procurar lugar certo
	str_la:    .asciiz "la "
	str_syscall: .asciiz "syscall"
	
		
	#Registradores
	r_zero: .asciiz "$zero"
	r_at:   .asciiz "$at"
	r_v0:   .asciiz "$v0"
	r_v1:   .asciiz "$v1"
	r_a0:   .asciiz "$a0"
	r_a1:   .asciiz "$a1"
	r_a2:   .asciiz "$a2"
	r_a3:   .asciiz "$a3"
	r_t0:   .asciiz "$t0"
	r_t1:   .asciiz "$t1"
	r_t2:   .asciiz "$t2"
	r_t3:   .asciiz "$t3"
	r_t4:   .asciiz "$t4"
	r_t5:   .asciiz "$t5"
	r_t6:   .asciiz "$t6"
	r_t7:   .asciiz "$t7"
	r_s0:   .asciiz "$s0"
	r_s1:   .asciiz "$s1"
	r_s2:   .asciiz "$s2"
	r_s3:   .asciiz "$s3"
	r_s4:   .asciiz "$s4"
	r_s5:   .asciiz "$s5"
	r_s6:   .asciiz "$s6"
	r_s7:   .asciiz "$s7"
	r_t8:   .asciiz "$t8"
	r_t9:   .asciiz "$t9"
	r_k0:   .asciiz "$k0"
	r_k1:   .asciiz "$k1"
	r_gp:   .asciiz "$gp"
	r_sp:   .asciiz "$sp"
	r_fp:   .asciiz "$fp"
	r_ra:   .asciiz "$ra"
	
	
	#Números
	zero: .asciiz "0"
	um: .asciiz "1"
	dois: .asciiz "2"
	tres: .asciiz "3"
	quatro: .asciiz "4"
	cinco: .asciiz "5"
	seis: .asciiz "6"
	sete: .asciiz "7"
	oito: .asciiz "8"
	nove: .asciiz "9"


	#Carateres especiais
	espaco: .asciiz " "
	enter: .asciiz "\n"
	virgula_espaco: .asciiz ", "
	abre_parenteses: .asciiz "("
	fecha_parenteses: .asciiz ")"
	instrucao_desconhecida: .asciiz "Instrucao desconhecida"
	
	#Variáveis
	cont_instrucao: .word -1
	endereco_instrucao : .word  0x003ffffc
	variavel_auxiliar: .word 0
        
	#string para selvar valores em hexadecimal
	hex_buffer: .asciiz "0x12345678"
	
	#variaveis do arquivo de leitura
	nome_arquivo_leitura: .ascii "C:/Users/Ana/Documents/Ciencia da Computacao/Semestre 2/Organizacao de Computadores/Trabalho 1/ex-000-012.bin"
	.align 2
	conteudo_arquivo: .space 1024000
	
.text

	#abrir arquivo em modo leitura
	li $v0, 13 
	la $a0, nome_arquivo_leitura
	li $a1, 0
	li $a2, 0
	syscall
	
	move $s0, $v0
	
	move $a0, $s0
	li $v0, 14
	la $a1, conteudo_arquivo
	li $a2, 1024000
	syscall
	
	#fechar o arquivo de leitura
	li $v0, 16
	move $a0, $s0
	syscall
	
	#abrir arquivo em modo escrita
	li $v0, 13
	la $a0, nome_arquivo_escrita
	li $a1, 1
	syscall

	move $s0, $v0 #descriptor do aqruivo de escrita em $s0
	
main_loop:

	#incrementa o contador
	la $s3, cont_instrucao
	lw $s4, 0($s3)
	addi $s4, $s4, 1
	sw $s4, 0($s3)
	
	#incrementa o endereço
	la $s3, endereco_instrucao
	lw $s4, 0($s3)
	addi $s4, $s4, 4
	sw $s4, 0($s3)
	
	#se a intrucao for nula, encerra o programa
	lw $s3, cont_instrucao
	la $s4, conteudo_arquivo
	mul $s3, $s3, 4
	add $s4, $s4, $s3
	lw $s5, 0($s4)
	beqz $s5, fim
	
	la $t6, endereco_instrucao #carrega o valor do endereço em $t6
	
	jal converte_hex_para_string #transforma o numero do endereco para string e escreve no arquivo
	
	jal escreve_espaco #escreve o carater espaço no arquivo txt
	
	jal encontra_num_instrucao #carrega o valor da instrução em $t6 e escreve no arquivo
	
	jal escreve_espaco #escreve o carater espaço no arquivo 
	
	jal acha_opcode
	
	beq $t2, 0, opecode_nulo
	beq $t2, 0x1c, opecode_nulo
	bne $t2, 0, opecode_nao_nulo
	
	j escreve_instrucao_desconhecida
		
	j fim
	
escreve_registrador:

	li $v0, 15
	move $a0, $s0
	li $a2, 3
	syscall
	
	jr $ra
	
escreve_$zero:

	li $v0, 15
	move $a0, $s0
	la $a1, r_zero
	li $a2, 5
	syscall
	
	jr $ra
	
escreve_$at:

	la $a1, r_at
	j escreve_registrador
	
escreve_$v0:

	la $a1, r_v0
	j escreve_registrador	
	
escreve_$v1:

	la $a1, r_v1
	j escreve_registrador	
	
escreve_$a0:

	la $a1, r_a0
	j escreve_registrador
	
escreve_$a1:

	la $a1, r_a1
	j escreve_registrador
	
escreve_$a2:

	la $a1, r_a2
	j escreve_registrador
	
escreve_$a3:

	la $a1, r_a3
	j escreve_registrador
	
escreve_$t0:

	la $a1, r_t0
	j escreve_registrador	
	
escreve_$t1:

	la $a1, r_t1
	j escreve_registrador	
	
escreve_$t2:

	la $a1, r_t2
	j escreve_registrador
	
escreve_$t3:

	la $a1, r_t3
	j escreve_registrador
	
escreve_$t4:

	la $a1, r_t4
	j escreve_registrador
	
escreve_$t5:

	la $a1, r_t5
	j escreve_registrador
	
escreve_$t6:

	la $a1, r_t6
	j escreve_registrador
	
escreve_$t7:

	la $a1, r_t7
	j escreve_registrador	
	
escreve_$s0:

	la $a1, r_s0
	j escreve_registrador
	
escreve_$s1:

	la $a1, r_s1
	j escreve_registrador
	
escreve_$s2:

	la $a1, r_s2
	j escreve_registrador
							
escreve_$s3:

	la $a1, r_s3
	j escreve_registrador
	
escreve_$s4:

	la $a1, r_s4
	j escreve_registrador
	
escreve_$s5:

	la $a1, r_s5
	j escreve_registrador
	
escreve_$s6:

	la $a1, r_s6
	j escreve_registrador
	
escreve_$s7:

	la $a1, r_s7
	j escreve_registrador
	
escreve_$t8:

	la $a1, r_t8
	j escreve_registrador
	
escreve_$t9:

	la $a1, r_t9
	j escreve_registrador
	
escreve_$k0:

	la $a1, r_k0
	j escreve_registrador
	
escreve_$k1:

	la $a1, r_k1
	j escreve_registrador
	
escreve_$gp:

	la $a1, r_gp
	j escreve_registrador
	
escreve_$sp:

	la $a1, r_sp
	j escreve_registrador
	
escreve_$fp:

	la $a1, r_fp
	j escreve_registrador
	
escreve_$ra:

	la $a1, r_ra
	j escreve_registrador
	
acha_registrador:

	beq $t2, 0, escreve_$zero
    	beq $t2, 1, escreve_$at
    	beq $t2, 2, escreve_$v0
    	beq $t2, 3, escreve_$v1
    	beq $t2, 4, escreve_$a0
    	beq $t2, 5, escreve_$a1
    	beq $t2, 6, escreve_$a2
    	beq $t2, 7, escreve_$a3
    	beq $t2, 8, escreve_$t0
    	beq $t2, 9, escreve_$t1
    	beq $t2, 10, escreve_$t2
    	beq $t2, 11, escreve_$t3
    	beq $t2, 12, escreve_$t4
    	beq $t2, 13, escreve_$t5
    	beq $t2, 14, escreve_$t6
    	beq $t2, 15, escreve_$t7
    	beq $t2, 16, escreve_$s0
    	beq $t2, 17, escreve_$s1
    	beq $t2, 18, escreve_$s2
    	beq $t2, 19, escreve_$s3
    	beq $t2, 20, escreve_$s4
    	beq $t2, 21, escreve_$s5
    	beq $t2, 22, escreve_$s6
    	beq $t2, 23, escreve_$s7
    	beq $t2, 24, escreve_$t8
    	beq $t2, 25, escreve_$t9
    	beq $t2, 26, escreve_$k0
    	beq $t2, 27, escreve_$k1
    	beq $t2, 28, escreve_$gp
    	beq $t2, 29, escreve_$sp
    	beq $t2, 30, escreve_$fp
    	beq $t2, 31, escreve_$ra
    	
escreve_rt:

	#achar o campo rt
	#carrega o valor da intrução em $t2
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#separa os 5 bits do campo rt
	sll $t2, $t2, 11
	srl $t2, $t2, 27
	
	j acha_registrador
    	
escreve_rs:

	#achar o campo rs
	#carrega o valor da intrução em $t2
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#separa os 5 bits do campo rs
	sll $t2, $t2, 6
	srl $t2, $t2, 27
	
	j acha_registrador
	
escreve_rd:

	#achar o campo rd
	#carrega o valor da intrução em $t2
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#separa os 5 bits do campo rd
	sll $t2, $t2, 16
	srl $t2, $t2, 27
	
	jal acha_registrador
	
	jal escreve_virgula_espaco
	
	jal escreve_rs
	
	jal escreve_virgula_espaco
	
	jal escreve_rt
	
	j escreve_enter
	
escreve_add:

	li $v0, 15
	move $a0, $s0
	la $a1, str_add
	li $a2, 4
	syscall
	
	j escreve_rd
	
escreve_addu:

	li $v0, 15
	move $a0, $s0
	la $a1, str_addu
	li $a2, 5
	syscall
	
	j escreve_rd
	
escreve_jr:

	li $v0, 15
	move $a0, $s0
	la $a1, str_jr
	li $a2, 3
	syscall
	
	#escreve  o registrador ra
	li $v0, 15
	move $a0, $s0
	la $a1, r_ra
	li $a2, 3
	syscall
	
	jal escreve_enter
	
	
escreve_mul:

	li $v0, 15
	move $a0, $s0
	la $a1, str_mul
	li $a2, 4
	syscall
	
	j escreve_rd
	
escreve_syscall:

	li $v0, 15
	move $a0, $s0
	la $a1, str_syscall
	li $a2, 7
	syscall
	
	j escreve_enter
	
escreve_addi:

	li $v0, 15
	move $a0, $s0
	la $a1, str_addi
	li $a2, 5
	syscall
	
	jal escreve_rt
	
	jal escreve_virgula_espaco
	
	jal escreve_rs
	
	jal escreve_virgula_espaco
	
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#acha o imm
	sll $t2, $t2, 16
	srl $t2, $t2, 16
	
	#coloca em $t6
	la $t6, variavel_auxiliar
	sw $t2, 0($t6)
	
	#escreve o imm
	jal converte_hex_para_string
	
	j escreve_enter
	
escreve_addiu:

	li $v0, 15
	move $a0, $s0
	la $a1, str_addiu
	li $a2, 6
	syscall
	
	jal escreve_rt
	
	jal escreve_virgula_espaco
	
	jal escreve_rs
	
	jal escreve_virgula_espaco
	
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#acha o imm
	sll $t2, $t2, 16
	srl $t2, $t2, 16
	
	#coloca em $t6
	la $t6, variavel_auxiliar
	sw $t2, 0($t6)
	
	#escreve o imm
	jal converte_hex_para_string
	
	j escreve_enter
	
escreve_bne:

	li $v0, 15
	move $a0, $s0
	la $a1, str_bne
	li $a2, 4
	syscall
	
	jal escreve_rs
	
	jal escreve_virgula_espaco
	
	jal escreve_rt
	
	jal escreve_virgula_espaco
	
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#acha o imm
	sll $t2, $t2, 16
	srl $t2, $t2, 16
	mul $t2, $t2, 4
	lw $t7, endereco_instrucao
	addi $t7, $t7, 4
	add $t2, $t2, $t7
	
	#coloca em $t6
	la $t6, variavel_auxiliar
	sw $t2, 0($t6)
	
	jal converte_hex_para_string
	
	j escreve_enter
	
escreve_sw:

	li $v0, 15
	move $a0, $s0
	la $a1, str_sw
	li $a2, 3
	syscall
	
	jal escreve_rt
	
	jal escreve_virgula_espaco
	
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#acha o imm
	sll $t2, $t2, 16
	srl $t2, $t2, 16
	
	jal escreve_num
	
	jal escreve_abre_parenteses
	
	jal escreve_rs
	
	jal escreve_fecha_parenteses
	
	j escreve_enter
	
escreve_lw:

	li $v0, 15
	move $a0, $s0
	la $a1, str_lw
	li $a2, 3
	syscall
	
	jal escreve_rt
	
	jal escreve_virgula_espaco
	
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#acha o imm
	sll $t2, $t2, 16
	srl $t2, $t2, 16
	
	jal escreve_num
	
	jal escreve_abre_parenteses
	
	jal escreve_rs
	
	jal escreve_fecha_parenteses
	
	j escreve_enter
	
escreve_lui:

	li $v0, 15
	move $a0, $s0
	la $a1, str_lui
	li $a2, 4
	syscall
	
	jal escreve_rt
	
	jal escreve_virgula_espaco
	
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#acha o imm
	sll $t2, $t2, 11
	srl $t2, $t2, 27
	
	#carrega o valor em $t6
	la $t6, variavel_auxiliar
	sw $t2, 0($t6)
	
	jal converte_hex_para_string
	
	jal escreve_enter
	
escreve_ori:

	li $v0, 15
	move $a0, $s0
	la $a1, str_ori
	li $a2, 4
	syscall
	
	jal escreve_rt
	
	jal escreve_virgula_espaco
	
	jal escreve_rs
	
	jal escreve_virgula_espaco
	
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#acha o imm
	sll $t2, $t2, 16
	srl $t2, $t2, 16
	
	#carrega o valor em $t6
	la $t6, variavel_auxiliar
	sw $t2, 0($t6)
	
	jal converte_hex_para_string
	
	jal escreve_enter
	
escreve_j:

	li $v0, 15
	move $a0, $s0
	la $a1, str_j
	li $a2, 2
	syscall
	
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#acha o imm
	sll $t2, $t2, 6
	srl $t2, $t2, 4
	la $t6, variavel_auxiliar
	sw $t2, 0($t6)
	
	jal converte_hex_para_string
	
	j escreve_enter 
	
escreve_jal:

	li $v0, 15
	move $a0, $s0
	la $a1, str_jal
	li $a2, 4
	syscall
	
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#acha o imm
	sll $t2, $t2, 6
	srl $t2, $t2, 4
	la $t6, variavel_auxiliar
	sw $t2, 0($t6)
	
	jal converte_hex_para_string
	
	j escreve_enter 	
	
escreve_num:

	beq $t2, 0, escreve_0
	beq $t2, 1, escreve_1	
	beq $t2, 2, escreve_2
	beq $t2, 3, escreve_3
	beq $t2, 4, escreve_4
	beq $t2, 5, escreve_5
	beq $t2, 6, escreve_6
	beq $t2, 7, escreve_7
	beq $t2, 8, escreve_8
	beq $t2, 9, escreve_9
	
escreve_num_arquivo:
	
	li $v0, 15
	move $a0, $s0
	li $a2, 1
	syscall
	
	jr $ra
	
	
escreve_0:

	la, $a1, zero
	j escreve_num_arquivo
	
escreve_1:

	la, $a1, um
	j escreve_num_arquivo
	
escreve_2:

	la, $a1, dois
	j escreve_num_arquivo
	
escreve_3:

	la, $a1, tres
	j escreve_num_arquivo
	
escreve_4:

	la, $a1, quatro
	j escreve_num_arquivo
	
escreve_5:

	la, $a1, cinco
	j escreve_num_arquivo
	
escreve_6:

	la, $a1, seis
	j escreve_num_arquivo
	
escreve_7:

	la, $a1, sete
	j escreve_num_arquivo
	
escreve_8:

	la, $a1, oito
	j escreve_num_arquivo
	
escreve_9:

	la, $a1, nove
	j escreve_num_arquivo
	
	
escreve_instrucao_desconhecida:

	li $v0, 15
	move $a0, $s0
	la $a1, instrucao_desconhecida
	li $a2, 22
	syscall
	
	j escreve_enter
	
escreve_inst_R:

	beq $t2, 0x20, escreve_add
	beq $t2, 0x21, escreve_addu
	beq $t2, 0x08, escreve_jr
	beq $t2, 0x2, escreve_mul
	beq $t2, 0xc, escreve_syscall
	
	j escreve_instrucao_desconhecida
	
opecode_nulo:

	#achar o campo funct
	#carrega o valor da intrução em $t2
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#separa os 6 bits menos significativos
	sll $t2, $t2, 26
	srl $t2, $t2, 26
	
	j escreve_inst_R
	
opecode_nao_nulo:

	beq, $t2, 0x8, escreve_addi
	beq $t2, 0x9, escreve_addiu
	beq $t2, 0x23, escreve_lw
	beq $t2, 0x2b, escreve_sw
	beq $t2, 0x5, escreve_bne
	beq $t2, 0x2, escreve_j
	beq $t2, 0x3, escreve_jal
	beq $t2, 0xf, escreve_lui
	beq $t2, 0xd, escreve_ori
	
	j escreve_instrucao_desconhecida
	
acha_opcode:
	
	#carrega o valor da intrução em $t2
	lw $t1, cont_instrucao
	mul $t1, $t1, 4
	la $t3, conteudo_arquivo
	add $t3, $t3, $t1
	lw $t2, 0($t3)
	
	#separa os 6 bits mais significativos
	srl $t2, $t2, 26
	
	jr $ra
	
escreve_espaco:

	li $v0, 15
	move $a0, $s0
	la $a1, espaco
	li $a2, 1
	syscall
	
	jr $ra
	
escreve_virgula_espaco:

	li $v0, 15
	move $a0, $s0
	la $a1, virgula_espaco
	li $a2, 2
	syscall
	
	jr $ra
	
escreve_enter:

	li $v0, 15
	move $a0, $s0
	la $a1, enter
	li $a2, 1
	syscall
	
	j main_loop
	
escreve_abre_parenteses:

	li $v0, 15
	move $a0, $s0
	la $a1, abre_parenteses
	li $a2, 1
	syscall
	
	jr $ra
	
escreve_fecha_parenteses:

	li $v0, 15
	move $a0, $s0
	la $a1, fecha_parenteses
	li $a2, 1
	syscall
	
	jr $ra

encontra_num_instrucao:
	
	lw $t7, cont_instrucao
	mul $t7, $t7, 4
	la $t6, conteudo_arquivo
	add $t6, $t6, $t7
	
        
converte_hex_para_string:

	lw $a0, 0($t6)  # converte o valor que se encontra em $t6
	move $t1, $a0             # Copiar el nÃºmero de word a $t1
	li $t2, 16                # Cargar 16 en $t2 (base hexadecimal)
	la $t3, hex_buffer        # Cargar la direcciÃ³n del buffer en $t3
	addi $t3, $t3, 9  
    
	# Convertir el word a cadena hexadecimal (de derecha a izquierda)
	li $t4, 8                 # Inicializar el contador del bucle (8 dÃ­gitos hexadecimales)

convert_loop:
	divu $t5, $t1, $t2        # Dividir el nÃºmero por 16
	mfhi $t1                  # Obtener el residuo (dÃ­gito hexadecimal)
    
	ble $t1, 9, less_than_10
	addi $t1, $t1, 55
	j continue

less_than_10:
	addi $t1, $t1, 48         # Convertir el dÃ­gito a su valor ASCII

continue:
	sb $t1, 0($t3)            # Almacenar el dÃ­gito en el buffer (de derecha a izquierda)
	move $t1, $t5
	subi $t4, $t4, 1          # Decrementar el contador del bucle
	subi $t3, $t3, 1
	bnez $t4, convert_loop    # Bucle hasta que hayamos convertido todos los dÃ­gitos
    
	sb $zero, 10($t3)          # Terminador nulo para finalizar la cadena
	    
	#escrever no arquivo txt
	li $v0, 15
	move $a0, $s0
	la $a1, hex_buffer
	li $a2, 10
	syscall
	
	jr $ra
	
fim:	
	#fechar arquivo
	li $v0, 16
	move $a0, $s0
	syscall
	
	#encerrar programa
	li $v0, 10		
	syscall
	

.data

	nome_arquivo_escrita: .ascii "C:/Users/Ana/Documents/Ciencia da Computacao/Semestre 2/Organizacao de Computadores/Trabalho 1/teste.txt"
		
	
