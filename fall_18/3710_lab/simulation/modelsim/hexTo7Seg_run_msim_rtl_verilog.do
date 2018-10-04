transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/18.0/quartus/3710_lab {C:/intelFPGA_lite/18.0/quartus/3710_lab/hexTo7Seg.v}

