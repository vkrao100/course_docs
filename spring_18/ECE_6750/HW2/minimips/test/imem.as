L: lw $v0, 0($at)
   lw $a0, 0($v1)
   add $a0, $a1, $a0
   and $a1, $v1, $a0
   sw $a0, 0($v1)
M: sub $a0,$a0,$v0
   beq $a0,$zero,L
   j M
