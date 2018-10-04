### Tcl test bench for the pipelined multipler
###
### See /uusoc/facility/cad_tools/Synopsys/sold/sold for modelsim interface
### http://www.tcl.tk/man/tcl8.5/tutorial/tcltutorial.html for tcl tutorial
###
### kss, 10/31/2005

view wave

add wave -radix decimal A B RESULT
add wave CLK RESET


# define clock
set clk_period 15000

# open golden reference model to validate against its results
set infile [open "test/GoldenResult" r]
set outfile [open "test/VerilogResult" w]

# Arguments are expected sum and carry out values to validate:
proc muleval { a b outfile clkper} {
    force A $a
    force B $b
    run $clkper
    # show the results at this simulation point
    set str "a = [exa -un A], b = [exa -un B], result = [exa -un RESULT]"
    echo $str
    # store results in same format as golden reference model
    set str "a = [exa A], b = [exa B], result = [exa RESULT]"
    puts $outfile $str
}


# initialize network, reset sytem
force A 0
force B 0
force -repeat $clk_period CLK 0 0, 1 [expr 0.5 * $clk_period]
force RESET 1
run [expr 2 * $clk_period]
force RESET 0
run [expr 0.5 * $clk_period]

echo starting simulation...

while { $clk_period && [gets $infile line] >= 0 } {
    set res [regexp {a = +([0-9]+), b = +([0-9]+), result = +([0-9]+)} $line match ain bin res]
    set notbinary [regexp {[2-9+]} $ain]
    if { $notbinary == 1 } {
	set ain "10\#$ain"
    }
    set notbinary [regexp {[2-9+]} $bin]
    if { $notbinary == 1 } {
	set bin "10\#$bin"
    }
    if { $res == 1 } {
    	muleval $ain $bin $outfile $clk_period
    }
}

echo ... simulation done!

# close file handles
close $infile
close $outfile

quit
