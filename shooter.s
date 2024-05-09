main:
    lw $r4, 20($0)  #high score is stored in mem location 20
main_loop:
    lw $r3, 5($0)        
    bne $r3, $zero, start_game
    j main_loop

start_game:
    addi $sp, $zero, 0            # Register $sp will be used as temporary storage
    addi $ra, $zero, 0            # Register $ra will be used as temporary storage

    # Initialize a flag to indicate if initialization has been done
    addi $t0, $zero, 0            # $t0 will be used as a flag. Initialize to 0.

    # Load 180 and 0 into temporary registers
    addi $t1, $zero, 180       # Load maximum value into temporary register
    addi $t8, $zero, 0            # Load minimum value into temporary register
    addi $r4, $zero, 0             #initialzize score to 0

set_LEDS:   
    addi $r14, $zero, 1 
    nop
    nop
    sw $r14, 10($0) #LED on
    sw $r14, 12($0) #LED on 
    sw $r14, 14($0) #LED on
    sw $r14, 16($0) #LED on
    j loop
    

loop:
    # Check if initialization has been done
    bne $t0, $zero, check_signals # If flag is non-zero, skip initialization

    # Initialize $r1 and $r2 to 37500
    addi $r1, $zero, 120
    addi $r2, $zero, 90
    

    # Set flag to indicate initialization has been done
    addi $t0, $zero, 1            # Set flag to non-zero

check_signals:
    # Check up signal
    lw $r3, 1($0)                 # Load the status of up signal from register $0 into register $r3
    bne $r3, $zero, up_pressed    # If up signal is high, go to up_pressed

    # Check down signal
    lw $r3, 2($0)                 # Load the status of down signal from register $0 into register $r3
    bne $r3, $zero, down_pressed  # If down signal is high, go to down_pressed

    # Check right signal
    lw $r3, 3($0)                 # Load the status of right signal from register $0 into register $r3
    bne $r3, $zero, right_pressed # If right signal is high, go to right_pressed

    # Check left signal
    lw $r3, 4($0)                 # Load the status of left signal from register $0 into register $r3
    bne $r3, $zero, left_pressed  # If left signal is high, go to left_pressed

    # No signal pressed, do nothing
    j no_signal_pressed

up_pressed:
    addi $r1, $r1, 1             # Add 1 to up/down register
    blt $r1, $t1, wait_horizontal   # Check if $r1 is less than 180
    addi $r1, $zero, 180      # Set $r1 to 180 (max value)
    j wait_horizontal

down_pressed:
    addi $r1, $r1, -1            # Subtract 1 from up/down register
    blt $t8, $r1, wait_horizontal  # Check if $r1 is greater than 0
    addi $r1, $zero, 0           # Set $r1 to 0 (min value)
    j wait_horizontal

left_pressed:
    addi $r2, $r2, -1            # Subtract 1 from left/right register
    blt $t8, $r2, wait_horizontal  # Check if $r2 is greater than 0
    addi $r2, $zero, 0           # Set $r2 to 0 (min value)
    j wait_horizontal

right_pressed:
    addi $r2, $r2, 1             # Add 1 to left/right register
    blt $r2, $t1, wait_horizontal   # Check if $r2 is less than 75000
    addi $r2, $zero, 180       # Set $r2 to 75000 (max value)
    j wait_horizontal

no_signal_pressed:
    # No signal pressed, do nothing
    j end_movement

wait_horizontal:
    #initialize r25 and r26 in order to start wait sequence
    addi $r26, $r0, 1
    sll $r26, $r26, 20
    addi $r25, $r0, 0

wait_horizontal_loop:
    # Stall loop, stall until r25 > r26. APproximately 1 millinon cycles which should be around 20 ms
    blt $r26, $r25, end_movement
    addi $r25, $r25, 1
    j wait_horizontal_loop

wait_vertical:
    #initialize r25 and r26 in order to start wait sequence
    addi $r26, $r0, 1
    sll $r26, $r26, 30
    addi $r25, $r0, 0

wait_vertical_loop:
    # Stall loop, stall until r25 > r26. APproximately 1 millinon cycles which should be around 20 ms
    blt $r26, $r25, end_movement
    addi $r25, $r25, 1
    j wait_vertical_loop

end_movement:
    # Repeat the loop
    lw $r3, 5($0) 
    nop
    addi $r21, $r0, 1       
    nop
    nop
    bne $r21, $r3, check_high_score
    j check_hit

check_hit:
    #check if correct target was hit. use reg 10, 11
    #top left
tl_check:
    lw $r10, 10($0) #LED
    lw $r11, 11($0) #PT
    addi $r13, $r0, 1
    and $r12, $r10, $r11        #only register point if both LED and Phototransisotr are hot
    bne $r12, $r13, tr_check
    sw $r0, 10($0)          # update LED to 0, turn off
    nop
    nop
    addi $r4, $r4, 1        #add one to score
    j fin

tr_check:
    lw $r10, 12($0) #LED
    lw $r11, 13($0) #PT
    addi $r13, $r0, 1
    and $r12, $r10, $r11             #only register point if both LED and Phototransisotr are hot
    bne $r12, $r13, bl_check
    sw $r0, 12($0)           # update LED to 0, turn off
    nop
    nop
    addi $r4, $r4, 1        #add one to score
    j fin

bl_check:
    lw $r10, 14($0) #LED
    lw $r11, 15($0) #PT
    addi $r13, $r0, 1
    and $r12, $r10, $r11             #only register point if both LED and Phototransisotr are hot
    bne $r12, $r13, br_check
    sw $r0, 14($0)              # update LED to 0, turn off
    nop
    nop
    addi $r4, $r4, 1            #add one to score
    j fin

br_check:
    lw $r10, 16($0) #LED
    lw $r11, 17($0) #PT
    addi $r13, $r0, 1
    and $r12, $r10, $r11            #only register point if both LED and Phototransisotr are hot      
    bne $r12, $r13, loop
    sw $r0, 16($0)              # update LED to 0, turn off
    nop
    nop
    addi $r4, $r4, 1                #add one to score
    j fin

fin: 
    addi $r15, $0, 4
    bne $r15, $r4, loop
    addi $r14, $zero, 1 
    nop
    nop
    nop
    sw $r14, 10($0) #LED on
    sw $r14, 12($0) #LED on 
    sw $r14, 14($0) #LED on
    sw $r14, 16($0) #LED on
    j loop

check_high_score:
    lw $r5, 20($0)                     #put high score into r5
    nop
    nop
    sw $r0, 10($0) #LED off
    nop
    nop
    sw $r0, 12($0) #LED off
    nop
    nop
    sw $r0, 14($0) #LED off
    nop
    nop
    sw $r0, 16($0) #LED off
    blt $r5, $r4, update_high_score     #if current game score > high score, branch to update score
    nop
    nop
    j main

update_high_score:
    nop
    nop
    sw $r4, 20($0)         #the new high score = current score
    nop
    nop
    nop
    j main                  #go back to main
    
