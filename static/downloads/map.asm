.data
letter: .word 0,0,0 #x,y,val
horz: .word 0,0,0 #0:x1 1:x2 2:y 
ver: .word 0,0,0 #0:y1 1:y2 2:x 
address: .word 0x10040000
color: .word 0xffffffff
width: .word 64
length: .word 64
.text 
main:
#li $s2, 0x10040000 # s2is the adress
#li $s3, 0xffffff00  #s3 is the color
#li $s0, 64 #s0 is the width
#li $s1, 64 #s1 is the length
#when resizing, (first is pixel size, second is display
# 1:$s0 for width
# 1:$s1 for height 7

#<START METHODS HERE>


#HELLO
addi $t0, $zero, 0  #x
addi $t1, $zero, 0  #y
addi $t2, $zero, 'H'

jal writeTextCapital
addi $sp, $sp, 4

addi $t0, $zero, 9 
addi $t1, $zero, 0
addi $t2, $zero, 'E'

jal writeTextCapital
addi $sp, $sp, 4

addi $t0, $zero, 18
addi $t1, $zero, 0
addi $t2, $zero, 'L'

jal writeTextCapital
addi $sp, $sp, 4

addi $t0, $zero, 27
addi $t1, $zero, 0
addi $t2, $zero, 'L'

jal writeTextCapital

addi $sp, $sp, 4
addi $t0, $zero, 36
addi $t1, $zero, 0
addi $t2, $zero, 'O'

jal writeTextCapital
addi $sp, $sp, 4


#WORLD!
addi $t0, $zero, 0  #x
addi $t1, $zero, 11  #y
addi $t2, $zero, 'W'

jal writeTextCapital
addi $sp, $sp, 4

addi $t0, $zero, 9 
addi $t1, $zero, 11
addi $t2, $zero, 'O'

jal writeTextCapital
addi $sp, $sp, 4

addi $t0, $zero, 18
addi $t1, $zero, 11
addi $t2, $zero, 'R'

jal writeTextCapital
addi $sp, $sp, 4

addi $t0, $zero, 27
addi $t1, $zero, 11
addi $t2, $zero, 'L'

jal writeTextCapital

addi $sp, $sp, 4
addi $t0, $zero, 36
addi $t1, $zero, 11
addi $t2, $zero, 'D'

jal writeTextCapital
addi $sp, $sp, 4

addi $sp, $sp, 4
addi $t0, $zero, 45
addi $t1, $zero, 11
addi $t2, $zero, '!'

jal writeTextPunct
addi $sp, $sp, 4


#<END METHODS HERE>

li $v0, 10  #exit
syscall



#METHODS#

doDot: # function that adds a dot t0 is x t1 is y
addi $sp, $sp, -4 #method prefix
sw $ra, 0($sp)
lw $s3, color
#read the x and y coords into t0 and t1, and run getCoords

jal getCoords  
addi $sp, $sp, 4 #method postfix

#use that data to run writeDot
la $t0, ($t2)
la $t1, ($s3)
jal writeDot
addi $sp, $sp, 4 #method postfix

lw $t7, 0($sp)
jr $t7 #exit
 
 
getCoords: #turn coords stored in t0(x) and t1(y) into a single number at t2
addi $sp, $sp, -4 #method prefix
sw $ra, 0($sp)
lw  $s1, length
mul $t1, $t1, $s1  #convert to length
add $t2, $t1, $t0  # add offset x and length y

mul $t2, $t2, 4 # convert for wordsize

li $t0, 0 #cleaning :3
li $t1, 0


lw $t7, 0($sp)
jr $t7 #exit


writeDot: #use single num coord t0 and color t1 to create a dot. t2 is the adress and is not used in input
addi $sp, $sp, -4 #method prefix
sw $ra, 0($sp)

lw $t2, address #load adress


add $t2, $t0, $t2 #go to coords
sw $t1, ($t2) # color it!

li $t0, 0 #cleaning :3
li $t1, 0
li $t2, 0

lw $t7, 0($sp)
jr $t7 #exit


doHorz: # t0:x1 t1:x2 t2:y 
addi $sp, $sp, -4
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
addi $sp, $sp, 4 #method postfix

lw $t7, 0($sp)
jr $t7 #exit
#Horz method end

writeHorz: # data in Horz: 0:x1 4:x2 8:y 
addi $sp, $sp, -4 #method prefix
sw $ra, 0($sp)


writeHorzLoop: 

lw $t0, 0($a0) 
lw $t1, 8($a0) 
jal getCoords  #get coords method
addi $sp, $sp, 4 #method postfix

la $t0, ($t2)
lw $t1, color
jal writeDot #write dot method
addi $sp, $sp, 4 #method postfix

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
addi $sp, $sp, -4 #method prefix
sw $ra, 0($sp)
#set a0 to horz, 
la $a0, ver

#li 0(ver),  y1
la $a1,  ($t0)
sw $a1 0($a0) 

#li 1(ver),   y2
la $a1, ($t1) 
sw $a1 4($a0) 

#li 2(ver),  x
la $a1, ($t2)  
sw $a1 8($a0) 

#Cleaning :3
la $a1, ($zero)
jal writeVer
addi $sp, $sp, 4 #method postfix

lw $t7, 0($sp)
jr $t7 #exit
#Ver method end



writeVer: # data in Ver: 0:y1 4:y2 8:x 

addi $sp, $sp, -4 #method prefix
sw $ra, 0($sp)

writeVerLoop:

lw $t0, 8($a0)
lw $t1, 0($a0)
jal getCoords
addi $sp, $sp, 4 #method postfix

la $t0, ($t2)
lw $t1, color
jal writeDot
addi $sp, $sp, 4 #method postfix

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


writeTextDecimal: #t0 or 0 is the x value of the top left corner, t1 or 4 is the y value of that corner, t2 or 8 is the value 0-9 in decimal
addi $sp, $sp, -4 #method prefix
sw $ra, 0($sp)
#save values in memory

la $a0, letter

#li 0(letter)
la $a1, ($t0)
sw $a1 0($a0) 

#li 2(letter)
la $a1, ($t1) 
sw $a1 4($a0) 

#li 3(letter)
la $a1, ($t2)
sw $a1 8($a0) 


#each number will take a 8 by 10 grid 
bne $t2,0, writeTextDecimaln0

#x y val

#if 0

#top dohorz t0 x1 t2 x2 t2 y
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 
#left
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#right 
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 5 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

j writeTextDecimalExit
writeTextDecimaln0:


bne $t2,1, writeTextDecimaln1
#if 1

#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 
#middle

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 8 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 4 #add 1 to x to go right 4

jal doVer
addi $sp, $sp, 4 

#diag

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 3 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 4 #y1

jal doDot
addi $sp, $sp, 4 

j writeTextDecimalExit
writeTextDecimaln1: 

bne $t2,2, writeTextDecimaln2
#if 2
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

#diag middle

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 9 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 8 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 7 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 6 #y1


jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 6 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 5 #y1

jal doDot
addi $sp, $sp, 4 


# top

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 6 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 4 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 3 #y1

jal doDot
addi $sp, $sp, 4 


la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 2 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 2 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 3 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 1 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 4 #y1

jal doDot
addi $sp, $sp, 4 

j writeTextDecimalExit
writeTextDecimaln2:

bne $t2,3, writeTextDecimaln3
#if 3

#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 5 to x to go right 6

jal doVer
addi $sp, $sp, 4 

#top, bottom
#top dohorz t0 x1 t2 x2 t2 y
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 5 #x2 is x1 by right 4
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 

j writeTextDecimalExit
writeTextDecimaln3:


bne $t2,4, writeTextDecimaln4
#if 4

#do 1 without bottom

#middle

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 4 #add 1 to x to go right 4

jal doVer
addi $sp, $sp, 4 

#diag

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 3 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 4 #y1

jal doDot
addi $sp, $sp, 4 


# dot 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 1 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 5 #y1

jal doDot
addi $sp, $sp, 4 

#cross

la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 3 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 

j writeTextDecimalExit
writeTextDecimaln4:


bne $t2,5, writeTextDecimaln5
#if 5

#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 6 #down 6
addi $t1, $t0, 5 # y2 is y1 down 4
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 6 to x to go right 6

jal doVer
addi $sp, $sp, 4 

#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 5 # y2 is y1 down 4
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
#top dohorz t0 x1 t2 x2 t2 y
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 

j writeTextDecimalExit
writeTextDecimaln5:


bne $t2,6, writeTextDecimaln6
#if 6

#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 7 # y2 is y1 down 6
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 6 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 7 #down 7
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 5 #x2 is x1 by right 4
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 


j writeTextDecimalExit
writeTextDecimaln6:


bne $t2,7, writeTextDecimaln7
#if 7

#top 
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4

#diag

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 3 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 4 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 5 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 6 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3#x1
lw $t1, 4($a0) #y
addi $t1, $t1, 7 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 8 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2#x1
lw $t1, 4($a0) #y
addi $t1, $t1, 9 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 10 #y1

jal doDot
addi $sp, $sp, 4 


j writeTextDecimalExit
writeTextDecimaln7:


bne $t2,8, writeTextDecimaln8
#if 8
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 7 #down 7
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 7 #down 7
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 

j writeTextDecimalExit
writeTextDecimaln8:


bne $t2,9, writeTextDecimaln9
#if 9
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 7 # y2 is y1 down 6
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 
j writeTextDecimalExit
writeTextDecimaln9:



writeTextDecimalExit:
lw $t7, 0($sp)
jr $t7 #exit


writeTextCapital:
addi $sp, $sp, -4 #method prefix
sw $ra, 0($sp)
#save values in memory

la $a0, letter

#li 0(letter)
la $a1, ($t0)
sw $a1 0($a0) 

#li 2(letter)
la $a1, ($t1) 
sw $a1 4($a0) 

#li 3(letter)
la $a1, ($t2)
sw $a1 8($a0) 

bne $t2,65, writeTextCapitalna
#A
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 1

jal doVer
addi $sp, $sp, 4 

#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 6

jal doVer
addi $sp, $sp, 4 

#top
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 


#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 
j writeTextCapitalExit
writeTextCapitalna:

bne $t2,66, writeTextCapitalnb
#B
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 7 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 



#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 7 #down 7
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 

j writeTextCapitalExit
writeTextCapitalnb:
bne $t2,67, writeTextCapitalnc
#C
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 7 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 
#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 


j writeTextCapitalExit
writeTextCapitalnc:
bne $t2,68, writeTextCapitalnd
#D
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 3
addi $t1, $t0, 9 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 


#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 7
addi $t1, $t0, 7 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

j writeTextCapitalExit
writeTextCapitalnd:
bne $t2,69, writeTextCapitalne
#E
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 5 to x to go right 6

jal doVer
addi $sp, $sp, 4 

#top, bottom
#top dohorz t0 x1 t2 x2 t2 y
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 5 #x2 is x1 by right 4
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 

j writeTextCapitalExit
writeTextCapitalne:
bne $t2,70, writeTextCapitalnf
#F
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 5 to x to go right 6

jal doVer
addi $sp, $sp, 4 

#top, bottom
#top dohorz t0 x1 t2 x2 t2 y
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 5 #x2 is x1 by right 4
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 

j writeTextCapitalExit
writeTextCapitalnf:
bne $t2,71, writeTextCapitalng
#G

#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 7 # y2 is y1 down 6
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 6 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 7 #down 7
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 4 #move right 1
addi $t1, $t0, 2 #x2 is x1 by right 4
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 


j writeTextCapitalExit
writeTextCapitalng:
bne $t2,72, writeTextCapitalnh
#H
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 3
addi $t1, $t0, 4 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 7 #down 7
addi $t1, $t0, 4 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 7 #down 7
addi $t1, $t0, 4 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 3
addi $t1, $t0, 4 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 

j writeTextCapitalExit
writeTextCapitalnh:
bne $t2,73, writeTextCapitalni
#I
#middle

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 7 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 3 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 


#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 3 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 3 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 


j writeTextCapitalExit
writeTextCapitalni:
bne $t2,74, writeTextCapitalnj
#J


#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 7
addi $t1, $t0, 8 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 



#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 8 #down 7
addi $t1, $t0, 2 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 


j writeTextCapitalExit
writeTextCapitalnj:
bne $t2,75, writeTextCapitalnk

#K

#do 1 without bottom

#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 4

jal doVer
addi $sp, $sp, 4 

#diag


la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 4 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 5 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 2 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 3 #y1

jal doDot
addi $sp, $sp, 4 



la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 8 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 7 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 10 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 9 #y1

jal doDot
addi $sp, $sp, 4 

j writeTextCapitalExit
writeTextCapitalnk:
bne $t2,76, writeTextCapitalnl
#L


#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 7
addi $t1, $t0, 8 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 



#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 


j writeTextCapitalExit
writeTextCapitalnl:
bne $t2,77, writeTextCapitalnm
#M
#left
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#right 
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 4 #down 2
addi $t1, $t0, 7 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 3 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 4 #down 2
addi $t1, $t0, 7 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 4 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 


#left and right dot

la $a0, letter #r
lw $t0, 0($a0) #x
addi $t0, $t0, 2 
lw $t1, 4($a0) #y
addi $t1, $t1, 3 

jal doDot
addi $sp, $sp, 4 

la $a0, letter #r
lw $t0, 0($a0) #x
addi $t0, $t0, 5 
lw $t1, 4($a0) #y
addi $t1, $t1, 3 

jal doDot
addi $sp, $sp, 4 
j writeTextCapitalExit
writeTextCapitalnm:
bne $t2,78, writeTextCapitalnn
#N


#left
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#right 
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

#diag

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 3 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 4 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 5 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 6 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4#x1
lw $t1, 4($a0) #y
addi $t1, $t1, 7 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 8 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5#x1
lw $t1, 4($a0) #y
addi $t1, $t1, 9 #y1

jal doDot
addi $sp, $sp, 4 

j writeTextCapitalExit
writeTextCapitalnn:
bne $t2,79, writeTextCapitalno
#O
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 7 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 


#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 7
addi $t1, $t0, 7 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 
j writeTextCapitalExit
writeTextCapitalno:
bne $t2,80, writeTextCapitalnp
#P
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 8 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 


#right


la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 


#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 
j writeTextCapitalExit
writeTextCapitalnp:
bne $t2,81, writeTextCapitalnq
#Q
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 7 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 


#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 7
addi $t1, $t0, 7 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

#diag


la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 6 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4#x1
lw $t1, 4($a0) #y
addi $t1, $t1, 7 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 8 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5#x1
lw $t1, 4($a0) #y
addi $t1, $t1, 9 #y1

jal doDot
addi $sp, $sp, 4 

j writeTextCapitalExit
writeTextCapitalnq:
bne $t2,82, writeTextCapitalnr
#R
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 8 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 


#right


la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 


#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 

#diag 
la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 8 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 7 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 10 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 9 #y1

jal doDot
addi $sp, $sp, 4 


j writeTextCapitalExit
writeTextCapitalnr:
bne $t2,83, writeTextCapitalns
#S
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 7 #down 7
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 
#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 6 #y is down 6

jal doHorz
addi $sp, $sp, 4 

j writeTextCapitalExit
writeTextCapitalns:
bne $t2,84, writeTextCapitalnt
#T
#middle

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 8 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 4 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 5 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 

j writeTextCapitalExit
writeTextCapitalnt:
bne $t2,85, writeTextCapitalnu
#U
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 3
addi $t1, $t0, 8 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 


#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 7
addi $t1, $t0, 8 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 10

jal doHorz
addi $sp, $sp, 4 
j writeTextCapitalExit
writeTextCapitalnu:
bne $t2,86, writeTextCapitalnv
#V
#left
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 5 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#right 
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 5 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 7 #down 2
addi $t1, $t0, 3 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 2 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 7#down 2
addi $t1, $t0, 3 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 5 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 


#left and right dot

la $a0, letter #r
lw $t0, 0($a0) #x
addi $t0, $t0, 3 
lw $t1, 4($a0) #y
addi $t1, $t1, 10 

jal doDot
addi $sp, $sp, 4 

la $a0, letter #r
lw $t0, 0($a0) #x
addi $t0, $t0, 4
lw $t1, 4($a0) #y
addi $t1, $t1, 10

jal doDot
addi $sp, $sp, 4 
j writeTextCapitalExit
writeTextCapitalnv:
bne $t2,87, writeTextCapitalnw
#W
#left
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#right 
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 9 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 4 #down 2
addi $t1, $t0, 6 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 3 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 4 #down 2
addi $t1, $t0, 6 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 4 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 


#left and right dot

la $a0, letter #r
lw $t0, 0($a0) #x
addi $t0, $t0, 2 
lw $t1, 4($a0) #y
addi $t1, $t1, 10 

jal doDot
addi $sp, $sp, 4 

la $a0, letter #r
lw $t0, 0($a0) #x
addi $t0, $t0, 5 
lw $t1, 4($a0) #y
addi $t1, $t1, 10 

jal doDot
addi $sp, $sp, 4 
j writeTextCapitalExit
writeTextCapitalnw:
bne $t2,88, writeTextCapitalnx
#X
#diag

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 1 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 2 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 3 #y1

jal doDot
addi $sp, $sp, 4 


la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 6 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 2 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 3 #y1

jal doDot
addi $sp, $sp, 4 


la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 1 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 10 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 9 #y1

jal doDot
addi $sp, $sp, 4 


la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 6 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 10 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 9 #y1

jal doDot
addi $sp, $sp, 4 


la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 4 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 4 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 8 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 8 #y1

jal doDot
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 5 #down 2
addi $t1, $t0, 3 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 3 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 5 #down 2
addi $t1, $t0, 3 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 4 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

j writeTextCapitalExit
writeTextCapitalnx:
bne $t2,89, writeTextCapitalny
#Y


#middle
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 6 #down 2
addi $t1, $t0, 5 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 3 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

#middle
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 6 #down 2
addi $t1, $t0, 5 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 4 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 


#left
la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 3 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2,  1#add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 5 #down 2
addi $t1, $t0, 1 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2,  2#add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 2
addi $t1, $t0, 3 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2,  6#add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 5 #down 2
addi $t1, $t0, 1 # y2 is y1 down 8
lw $t2, 0($a0) #load x
addi $t2, $t2, 5 #add 4 to x to go right 5

jal doVer
addi $sp, $sp, 4 
j writeTextCapitalExit
writeTextCapitalny:
bne $t2,90, writeTextCapitalnz
#Z



#top 
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4

#bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 1 #move right 1
addi $t1, $t0, 6 #x2 is x1 by right 5
lw $t2, 4($a0) #y
addi $t2, $t2, 10 #y is down 2

jal doHorz
addi $sp, $sp, 4

#diag

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 3 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 5 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 4 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 5 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 6 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3#x1
lw $t1, 4($a0) #y
addi $t1, $t1, 7 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 8 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2#x1
lw $t1, 4($a0) #y
addi $t1, $t1, 9 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 2 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 10 #y1

jal doDot
addi $sp, $sp, 4 
j writeTextCapitalExit
writeTextCapitalnz:





writeTextCapitalExit:
lw $t7, 0($sp)
jr $t7 #exit

writeTextPunct:
addi $sp, $sp, -4 #method prefix
sw $ra, 0($sp)
#save values in memory

la $a0, letter

#li 0(letter)
la $a1, ($t0)
sw $a1 0($a0) 

#li 2(letter)
la $a1, ($t1) 
sw $a1 4($a0) 

#li 3(letter)
la $a1, ($t2)
sw $a1 8($a0) 



bne $t2, 33, writeTextPunctnex
#!
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 7
addi $t1, $t0, 5 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 8 #down 7
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4


j writeTextPunctExit
writeTextPunctnex:

bne $t2,63, writeTextPunctnqu

#?


#right

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 3 #down 3
addi $t1, $t0, 4 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 6 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4 

#top, bottom
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 2 #move right 2
addi $t1, $t0, 4 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 2 #y is down 2

jal doHorz
addi $sp, $sp, 4 


#middle
la $a0, letter #restore
lw $t0, 0($a0) #x1
addi $t0, $t0, 3 #move right 2
addi $t1, $t0, 3 #x2 is x1 by right 3
lw $t2, 4($a0) #y
addi $t2, $t2, 7 #y is down 6

jal doHorz
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 10 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 1 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 3 #y1

jal doDot
addi $sp, $sp, 4 

j writeTextPunctExit
writeTextPunctnqu:

bne $t2,46, writeTextPunctndot
#.

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 10 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 10 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 3 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 9 #y1

jal doDot
addi $sp, $sp, 4 

la $a0, letter #restore
lw $t0, 0($a0) #x
addi $t0, $t0, 4 #x1
lw $t1, 4($a0) #y
addi $t1, $t1, 9 #y1

jal doDot
addi $sp, $sp, 4 

j writeTextPunctExit
writeTextPunctndot:

bne $t2,58, writeTextPunctncol
#:
#left

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 2 #down 7
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4

la $a0, letter #restore
lw $t0, 4($a0) #y1
addi $t0, $t0, 8 #down 7
addi $t1, $t0, 3 # y2 is y1 down 2
lw $t2, 0($a0) #load x
addi $t2, $t2, 1 #add 1 to x to go right 1

jal doVer
addi $sp, $sp, 4

j writeTextPunctExit
writeTextPunctncol:


writeTextPunctExit:
lw $t7, 0($sp)
jr $t7 #exit
