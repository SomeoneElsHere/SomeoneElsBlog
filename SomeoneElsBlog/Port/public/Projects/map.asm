.data

horz: .word 0,0,0 #0:x1 1:x2 2:y 
ver: .word 0,0,0 #0:y1 1:y2 2:x 

.text 
main:
li $s2, 0x10040000 # s2is the adress
li $s3, 0xffffff00  #s3 is the color
li $s0, 64 #s0 is the width
li $s1, 64 #s1 is the length
#when resizing, (first is pixel size, second is display
# 1:$s0 for width
# 1:$s1 for height

#<START METHODS HERE>

#box
li $t0, 1
li $t1, 62
li $t2, 1
jal, doHorz
addiu $sp, $sp, 4 #method postfix

li $t0, 1
li $t1, 62
li $t2, 62
jal, doHorz
addiu $sp, $sp, 4 #method postfix

li $t0, 1
li $t1, 62
li $t2, 1
jal, doVer
addiu $sp, $sp, 4 #method postfix

li $t0, 1
li $t1, 62
li $t2, 62
jal, doVer
addiu $sp, $sp, 4 #method postfix
#box

#eyes
li $t0, 12
li $t1, 24
li $t2, 20
jal, doVer
addiu $sp, $sp, 4 #method postfix

li $t0, 12
li $t1, 24
li $t2, 43
jal, doVer
addiu $sp, $sp, 4 #method postfix
#eyes

#mouth
li $t0, 32
li $t1, 44
li $t2, 20
jal, doVer
addiu $sp, $sp, 4 #method postfix

li $t0, 32
li $t1, 44
li $t2, 43
jal, doVer
addiu $sp, $sp, 4 #method postfix

li $t0, 20
li $t1, 43
li $t2, 44
jal, doHorz
addiu $sp, $sp, 4 #method postfix
#mouth

#<END METHODS HERE>

li $v0, 10  #exit
syscall



#METHODS#

userDot: # [optional] function used to ask the user to place a dot on the screen
addiu $sp, $sp, -4 #method prefix
sw $ra, 0($sp)

#read the x and y coords into t0 and t1, and run getCoords
li $v0, 5  
syscall
la $t0, ($v0)
li $v0, 5  
syscall
la $t1, ($v0)
jal getCoords  
addiu $sp, $sp, 4 #method postfix

#use that data to run writeDot
la $t0, ($t2)
la $t1, ($s3)
jal writeDot
 addiu $sp, $sp, 4 #method postfix

 
 
getCoords: #turn coords stored in t0(x) and t1(y) into a single number at t2
addiu $sp, $sp, -4 #method prefix
sw $ra, 0($sp)

mul $t1, $t1, $s1  #convert to length
add $t2, $t1, $t0  # add offset x and length y

mul $t2, $t2, 4 # convert for wordsize

li $t0, 0 #cleaning :3
li $t1, 0


lw $t7, 0($sp)
jr $t7 #exit


writeDot: #use single num coord t0 and color t1 to create a dot. t2 is the adress and is not used in input
addiu $sp, $sp, -4 #method prefix
sw $ra, 0($sp)

la $t2, ($s2) #load adress


add $t2, $t0, $t2 #go to coords
sw $t1, ($t2) # color it!

li $t0, 0 #cleaning :3
li $t1, 0
li $t2, 0

lw $t7, 0($sp)
jr $t7 #exit


doHorz: # t0:x1 t1:x2 t2:y 
addiu $sp, $sp, -4
sw $ra, 0($sp)
#Horz method start 
#set a0 to horz
la $a0, horz

#li 0(horz)
la $a1, ($t0)
sw $a1 0($a0) 

#li 1(horz)
la $a1, ($t1) 
sw $a1 4($a0) 

#li 2(horz)
la $a1, ($t2)
sw $a1 8($a0) 

#Cleaning :3
la $a1, ($zero)
jal writeHorz
addiu $sp, $sp, 4 #method postfix

lw $t7, 0($sp)
jr $t7 #exit
#Horz method end

writeHorz: # data in Horz: 0:x1 4:x2 8:y 
addiu $sp, $sp, -4 #method prefix
sw $ra, 0($sp)


writeHorzLoop: 

lw $t0, 0($a0) 
lw $t1, 8($a0) 
jal getCoords  #get coords method
addiu $sp, $sp, 4 #method postfix

la $t0, ($t2)
la $t1, ($s3)
jal writeDot #write dot method
addiu $sp, $sp, 4 #method postfix

#increment the horizontal by 1
lw $t0, 0($a0)
add $t0, $t0, 1
sw $t0, 0($a0)
li $t0, 0 #clean out t0


#bne 0($a0), 1($a0), writeHorzLoop
lw $t0, 0($a0)
lw $t1, 4($a0)
bne $t0, $t1, writeHorzLoop

#cleaning :3

#li 0(horz), 0 
li $a1, 0 
sw $a1 0($a0) 

#li 1(horz), 0 
li $a1, 0 
sw $a1 4($a0) 

#li 2(horz), 0
li $a1, 0 
sw $a1 8($a0) 

la $a0, ($zero)

lw $t7, 0($sp)
jr $t7 #exit

doVer:
#Ver method start 1, 62, 62
addiu $sp, $sp, -4 #method prefix
sw $ra, 0($sp)
#set a0 to horz, 
la $a0, ver

#li 0(ver), 1  y1
la $a1,  ($t0)
sw $a1 0($a0) 

#li 1(ver), 63  y2
la $a1, ($t1) 
sw $a1 4($a0) 

#li 2(ver), 62 x
la $a1, ($t2)  
sw $a1 8($a0) 

#Cleaning :3
la $a1, ($zero)
jal writeVer
addiu $sp, $sp, 4 #method postfix

lw $t7, 0($sp)
jr $t7 #exit
#Ver method end



writeVer: # data in Ver: 0:y1 4:y2 8:x 

addiu $sp, $sp, -4 #method prefix
sw $ra, 0($sp)

writeVerLoop:

lw $t0, 8($a0)
lw $t1, 0($a0)
jal getCoords
addiu $sp, $sp, 4 #method postfix

la $t0, ($t2)
la $t1, ($s3)
jal writeDot
addiu $sp, $sp, 4 #method postfix

#add 0(ver), 1 increment the vertical by 1
lw $t0, 0($a0)
add $t0, $t0, 1
sw $t0, 0($a0)
li $t0, 0 #clean out t0


#bne 0(ver), 1(ver), writeVerLoop
lw $t0, 0($a0)
lw $t1, 4($a0)
bne $t0, $t1, writeVerLoop

#Cleaning :3
la $a0, ver 

#li 0(ver), 0 

li $a1, 0 
sw $a1 0($a0) 

#li 1(ver), 0
li $a1, 0 
sw $a1 4($a0) 

#li 2(ver), 0
li $a1, 0 
sw $a1 8($a0) 

la $a0, ($zero) 

lw $t7, 0($sp)
jr $t7 #exit


