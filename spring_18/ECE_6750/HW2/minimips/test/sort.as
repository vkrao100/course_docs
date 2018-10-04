load:      addi   $a0, $zero, 360        # Base address for array v
           addi   $a1, $zero, 30         # Size of array v is n
                                         # sort( v, n ) is procedure call
           add    $t0, $a0, $zero        # reg $t0 = $a0 address of v
           add    $t1, $a1, $zero        # reg $t1 = $a1 n
           add    $t2, $zero, $zero      # reg $t2 hold the data for the array 

loop:      sw     $t2, 0($t0)            # mem[$t1] = $t2
           addi   $t1, $t1, -1           # i = i - 1 decrement the counter
           addi   $t0, $t0, 4            # j = j + 1 increment index
           addi   $t2, $t2, 1            # k = k + 1 increment data to save
           bne    $t1, $zero, loop       # if i == 0 break out of loop

           jal    sort                   # sort the array of elements
           dump                          # dump the memory contents

sort:      addi   $sp, $sp, -20          # make room on the stack for 5 registers
           sw     $ra, 16($sp)           # save $ra on stack
           sw     $s3, 12($sp)           # save $s3 on stack
           sw     $s2, 8($sp)            # save $s2 on stack
           sw     $s1, 4($sp)            # save $s1 on stack
           sw     $s0, 0($sp)            # save $s0 on stack
           
           add    $s2, $a0, $zero        # copy parameter $a0 into $s2 (save $a0)
           add    $s3, $a1, $zero        # copy parameter $a1 into $s3 (save $a1)
           
           add    $s0, $zero, $zero      # i = 0
for1tst:   slt    $t0, $s0, $s3          # reg $t0 = 0 if $s0 >= $s3 (i >= n)
           beq    $t0, $zero, exit1      # go to exit1 if $s0 >= $s4 (i >= n)

           addi   $s1, $s0, -1           # j = i - 1
for2tst:   slt    $t0, $s1, $zero        # reg $t0 = 1 if $s1 < 0 (j < 0)
           bne    $t0, $zero, exit2      # go to exit2 if $s1 < 0 (j < 0)
           add    $t1, $s1, $s1          # reg $t1 = j * 2
           add    $t1, $t1, $t1          # reg $t1 = j * 4
           add    $t2, $s2, $t1          # reg $t2 = v + (j * 4)
           lw     $t3, 0($t2)            # reg $t3 = v[j]
           lw     $t4, 4($t2)            # reg $t4 = v[j+1]            
           slt    $t0, $t4, $t3          # reg $t0 = 0 if $t4 >= $t3
           beq    $t0, $zero, exit2      # go to exit2 if $t4 >= $t3
          
           add   $a0, $s2, $zero         # 1st parameter of swap is v (old $a0)
           add   $a1, $s1, $zero         # 2nd parameter of swap is j 
           jal    swap                   # Goto the swap routine

           addi   $s1, $s1, -1           # j = j - 1
           j      for2tst                # jump to test of inner loop
         
exit2:     addi   $s0, $s0, 1            # i = i + 1
           j      for1tst                # jump to test of outer loop

exit1:     lw     $s0, 0($sp)            # restore $s0 from stack
           lw     $s1, 4($sp)            # restore $s1 from stack
           lw     $s2, 8($sp)            # restore $s2 from stack
           lw     $s3, 12($sp)           # restore $s3 from stack
           lw     $ra, 16($sp)           # restore $ra from stack
           addi   $sp, $sp, 20           # restore stack pointer

           jr     $ra                    # return to calling routine
           

swap:      add    $t1, $a1, $a1          # reg $t1 = k * 2
           add    $t1, $t1, $t1          # reg $t1 = k * 4
           add    $t1, $a0, $t1          # reg $t1 = v + (k*4)
                                         # reg $t1 has the address of v[k]
           lw     $t0, 0($t1)            # reg $t0 (temp) = v[k]
           lw     $t2, 4($t1)            # reg $t2 = v[k+1]
                                         # refers to next element of v
           sw     $t2, 0($t1)            # v[k] = reg $t2
           sw     $t0, 4($t1)            # v{k+1] = reg $t0 (temp)

           jr     $ra                    # return to calling routine
