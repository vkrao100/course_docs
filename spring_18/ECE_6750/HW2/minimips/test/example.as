load_map:      addi   $a0, $zero, 360        # Base address for array v
               addi   $a1, $zero, 30        
                                         
               add    $t0, $a0, $zero        
               add    $t1, $a1, $zero        
               add    $t2, $zero, $zero      

load_no_map:   addi   $0, $0, 360            # Base address for array v
               addi   $1, $0, 30        
                                         
               add    $0, $0, $0        
               add    $1, $1, $0        
               add    $2, $0, $0      
