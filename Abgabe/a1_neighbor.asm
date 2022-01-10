	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------

.data

test_neighbor_header: .asciiz "\nPos\toben\tlinks\tunten\trechts\n---\t----\t-----\t-----\t------\n"

.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

main:   
	li $v0, SYS_PUTSTR
	la $a0, test_neighbor_header
	syscall
	
	move $s0, $zero

test_neighbor_loop_position:

	li $v0, SYS_PUTINT
	move $a0, $s0
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, '\t'
	syscall
	
	move $s1, $zero

test_neighbor_loop_direction:
	move $v0, $zero
	move $a0, $s0
	move $a1, $s1
	jal neighbor
	
	move $a0, $v0   
	li $v0, SYS_PUTINT
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, '\t'
	syscall
	
	addi $s1, $s1, 1
	blt $s1, 4, test_neighbor_loop_direction

	li $v0, SYS_PUTCHAR
	li $a0, '\n'
	syscall

	addi $s0, $s0, 1
	blt $s0, 64, test_neighbor_loop_position

	li $v0, SYS_EXIT
	syscall

	#+ BITTE VERVOLLSTAENDIGEN: Persoenliche Angaben zur Hausaufgabe 
	#+ -------------------------------------------------------------

	# Vorname: Tilman
	# Nachname: Battke
	# Matrikelnummer: 0469719
	
	#+ Loesungsabschnitt
	#+ -----------------

neighbor:
	#Erfassen der Richtung
	beq $a1, 0, directionZero
	beq $a1, 1, directionOne
	beq $a1, 2, directionTwo	
	beq $a1, 3, directionThree
	
	#Ermitteln der Position
directionZero:
	addi $v0, $a0, -8		#abziehen von 8 entspricht dem Feld oberhalb
	j ueberpruefePosition
	
directionOne:
	addi $v0, $a0, -1		#abziehen von 1 entspricht dem Feld links
	j ueberpruefeSelbeReihe

directionTwo:
	addi $v0, $a0, 8		#addieren von 8 entspricht dem Feld unterhalb
	j ueberpruefePosition
	
directionThree:
	addi $v0, $a0, 1		#addieren von 1 entspricht dem Feld rechts
	j ueberpruefeSelbeReihe
	
ueberpruefeSelbeReihe:
	srl $t0, $a0, 3			#verschieben der bits um 3 nach rechts ergibt die Reihe der Postion
	srl $t1, $v0, 3			#$t0 enthaelt die Reihe der gegebenen Position und $t1 die Reihe der gefundenen Position
	bne $t0, $t1, keinePosition	#wenn die Reihen gleich sind, sind sie Nachbarn
	j ueberpruefePosition

ueberpruefePosition:
	blt $v0, 0, keinePosition	#pruefen, ob das Ergebnis out-of-bounce ist. Zahlen kleiner 0 sind nicht im Labyrinth
	bgt $v0, 63, keinePosition	#pruefen, ob das Ergebnis out-of-bounce ist. Zahlen groesser 63 sind nicht im Labyrinth
	jr $ra
	
	#Position ist nicht auf dem Feld
keinePosition:
	li $v0, -1
	jr $ra
	
