#######################################################################
# tcl variable $design_name defined in calling script

current_design $design_name

#######################################################################
# Define operational modes

set_operating_conditions "typical" -library $lib_name
set_wire_load_mode "segmented" 
set_max_fanout 64 $design_name


#######################################################################
# Define frequency parameters

set clk_period       650

set clk_port      "CLK"
set clk_name      "clock"

### Derived frequency values:

### 50% duty cycle, 5% variation in clock tree
set duty_cycle        0.50
set clk_skew_factor   0.05

set clk_phase   [expr $clk_period * $duty_cycle]


#######################################################################
# create clocks

create_clock -name $clk_name -period $clk_period -waveform "0 $clk_phase" [get_port $clk_port]



#######################################################################
# constrain clocks

set_clock_uncertainty [expr $clk_skew_factor * $clk_period] $clk_name
#set_propagated_clock [all_clocks]

set_fix_hold [all_clocks]
set_dont_touch_network $clk_port


#####################
### input output delay and load models
### caps in pf for Utah and Artisan, ff for UWash

set default_input_delay [expr 0.1 * $clk_period]
set default_output_delay [expr 0.1 * $clk_period]
set_default_load -wire_load 5

remove_input_delay -clock $clk_name [get_port $clk_port]

##set_clock_latency -source 0 [all_clocks]

set_load 20 [all_outputs]




#######################################################################
### size_only constraints
#set_size_only -all_instances { */linear_control0 }

#######################################################################
### Break loops:
#set_disable_timing -from A3 -to Z  [find -hier cell *linear_control0]

#######################################################################
### Timing Constraints:
#set_max_delay $clk_period -from R0_reg/q -to { R10_reg/d R11_reg/d }
