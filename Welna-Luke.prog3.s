#############################################
## Name:  Luke Welna		  			   #
## Email: nitro.luke@gmail.com  				   #
#############################################
##                                          				   #
##  This program produces a Lucas sequence  		   #
##  of the first (U) or second (V) order,   			   #
##  given a number N, and constants          		   #
##  P and Q.                                				   #
##                                          				   #
#############################################

.globl main

#############################################
#                                          				  #
#                   Data                    				  #
#                                           				  #
#############################################
.data
	menuWelcomeMessage: .asciiz "Lucas Sequence Generator: \n\n"
	menuOption1message:  .asciiz "  (1) U(n, P, Q)\n\n"
	menuOption2message:  .asciiz "  (2) V(n, P, Q)\n\n"
	menuOption3message:  .asciiz "  (3) Exit the program\n\n"
	selectionMessage:    .asciiz "Enter your selection: "
	requestNmessage:	 .asciiz "Please enter integer  N: "
	requestPmessage:	 .asciiz "Please enter constant P: "
	requestQmessage:	 .asciiz "Please enter constant Q: "
	newline:             .asciiz "\n"
	notYetImplemented:	 .asciiz "\nThis procedure is not yet implemented!\n"
	exitMessage:         .asciiz "\nThank you, come again!"
	comma:	         .asciiz ","
	badInput:	         .asciiz "Bad Input: Please enter a N value greater than 0! \n"
.text
#############################################
#                                          				   #
#                  Program                  				   #
#                                          				   #
#############################################
main:
	la $a0, menuWelcomeMessage	# load menu introductory message
	jal printString				#print message

	la $a0, menuOption1message	# load menu prompt 1
	jal printString				# print message

	la $a0, menuOption2message	# load menu prompt 2
	jal printString				# print message

	la $a0, menuOption3message	# load menu prompt 3
	jal printString				# print message

	la $a0, selectionMessage	# load message for menu selection input
	jal scanInteger		# print selection prompt and get user input
	addi $a3, $v0, -1		# adjust result to make zero-indexed (0 or 1),
	                           		# and store value in $a3

	la $a0, newline          	# print a newline \n
	jal printString

	li $t0, 1			# load temp value for range testing
	blt $t0, $a3, __sysExit	# user entered int > 2; exit program
	blt $a3, $0, __sysExit	# user entered int < 1; exit program

	la $a0, requestNmessage   # load message to enter integer N
	jal scanInteger		# print selection prompt and get user input
	move $s0, $v0		# store n in $s0 (for now)

	la $a0, requestPmessage   # load message to enter integer P
	jal scanInteger		# print selection prompt and get user input
	move $a1, $v0		# store P in $a1

	la $a0, requestQmessage   # load message to enter integer Q
	jal scanInteger		# print selection prompt and get user input
	move $a2, $v0		# store Q in $a2

	move $a0, $s0		# copy n from $s0 to $a0

	jal lucasSequence		# print the lucas sequence for N, P, and Q

	la $a0, newline          	# print a newline \n
	jal printString

	la $a0, newline          	# print a newline \n
	jal printString

	j main				# loop to main menu again


#############################################
# Procedure: lucasSequence        		    		   #
#############################################
#   - produces the Lucas sequence of the    		   #
#     first (U) or second (V) order for     			   #
#     given constants P and Q.              			   #
#                                           				   #
#     The procedure produces all numbers    		   #
#     in the sequence U or V from n=0       		   #
#	  up to n=N.                     	    			   #
#                                           				   #
#   - inputs : $a0-integer N                			   #
#              $a1-constant P               			   #
#              $a2-constant Q               			   #
#              $a3-function U (0) or V (1)  			   #
#   - outputs: none                         				   #
#								   #
#############################################

lucasSequence:
	add $sp, $sp, -4
	sw $ra, 0($sp)

	slti $t3, $a0, 0				#$t3 = 0 if $a0 < 0
	beq $t3, 1, badInputCheck			# if $a0 < 0 go to badInput

	add $s0, $a0, $zero 			# stores $a0 (N) in $s0
	move $s1, $zero
	add $t0, $zero, $zero 			# innitializes our counter (n) to 0

	LoopLucas:
		beq $t0, $s0, returnM		#if our counter($s1) = N($) return to main
		beq $t0, 0, skipComma

		la $a0, comma
		jal printString

		skipComma:
		jal lucasSequenceNumber

		move $a0, $v0 			#loads the return value to print
		jal printInt

		move $t0, $s1			#restore $t0
		addi $s1, $s1, 1
		addi $t0, $t0, 1 			#increment the counter
		j LoopLucas

	returnM:
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		jr $ra

	badInputCheck:
		la $a0, badInput
		jal printString
		la $a0, newline
		jal printString
		j main


#############################################
# Procedure: lucasSequenceNumber         		   #
#############################################
#   - produces the Lucas number of the      		   #
#     first (U) and second (V) order for     			   #
#     number n, given constants P and Q.    		   #
#								   #
#   - inputs : $a0-integer n                			   #
#              $a1-constant P               			   #
#              $a2-constant Q               			   #
#              $a3-function U (0) or V (1)  			   #
#   - outputs: $v0-value of U(n,P,Q) or  			   #
#                  value of V(n,P,Q)        			   #
#								   #
#############################################


lucasSequenceNumber:
	addi $sp, $sp, -8				# adjust the stack for 2 items
	sw $ra,  4($sp)				# Store the return address the stack
	move $v0, $t0 				#preload return value as n
	slti $t1, $t0, 2 				# if n < 2
	bne $t1, $zero, decideFunc			#decide which function to use
	sw $t0, 0($sp)				#save a copy of n
	addi $t0, $t0 -1 				# n - 1
	jal lucasSequenceNumber
	lw $t0, 0($sp)					# retrieve n
	mul $v0, $a1, $v0
	sw $v0, 0($sp)				# save result of lucasSequenceNumber(n - 1)
	addi $t0, $t0, -2 				# n - 2
	jal lucasSequenceNumber
	lw $v1, 0($sp)				#retrieve lucasSequenceNumber(n-1) or is it (n-2)?
	mul $t2, $a2, $v0 				# Q * (n - 2)
	sub $t0, $v1, $t2 				# P * (n-1) - Q * (n - 2)

	funcU:
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		move $v0, $t0
		jr $ra

	funcV:
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		beq $t0, 1, returnP			# if $s1 (n) == 1 return P
		return2:
			li $v0, 2
			jr $ra
		returnP:
			move $v0, $a1
			jr $ra

	decideFunc:
	beq $a3, 0, funcU 				# if $a3 (function indicator) == 0 go to funcU
	beq $a3, 1, funcV				# if $a3 == 1 go to funcV

#############################################
# Procedure: scanInteger         		    		   #
#############################################
#   - prints a message and gets an integer  		   #
#     from user                             				   #
#								   #
#   - inputs : $a0-address of string prompt 		   #
#   - outputs: $v0-integer return value     			   #
#								   #
#############################################

scanInteger:
	addi $sp, $sp, -4	# adjust stack
	sw $ra, 0($sp)	# push return address
	jal printString            # print message prompt

	li $v0, 5		# read integer from console
	syscall

	lw $ra, 0($sp)	# pop return address
	addi $sp, $sp, 4	# adjust stack
	jr $ra			# return

#############################################
# Procedure: printString   				    	   #
#############################################
#   - print a string to console             			   #
#								   #
#   - inputs : $a0 - address of string      			   #
#   - outputs: none                         				   #
#								   #
#############################################
printString:
	li $v0, 4
	syscall
	jr $ra

printInt:
	li $v0, 1
	syscall
	jr $ra

#############################################
# Procedure: __sysExit   				             #
#############################################
#   - exit the program                      			   #
#								   #
#   - inputs : none                         				   #
#   - outputs: none                         				   #
#								   #
#############################################
__sysExit:
	la $a0, exitMessage		# print exit message
	jal printString
	li $v0, 10			# exit program
	syscall


