**************
UID - U1072596
README.txt
LAB8
**************

#############################
## files/directory structure  
#############################

compiled_files - Has v2lvs.sp file which was generated using the verilog file mult.dcopt.v and scripts (mult*.tcl and mult*.csh).
clk_snapshots - 
	-- hsim_clk_clkr has before and after RC circuit addition clock signal in HSIM
	-- hspice_clk_clkr has before and after RC circuit addition clock signal in hspice
	-- hsim_hspice_clkr compares two tools after RC circuit clock
first_sim_files - (both power and ground pins connected)
	-wf_snapshots-
		--hsim_hspice_gnd_first_sim.png - comparing hsim and hspice ground connections in single waveform
		--hsim_hspice_pwr_first_sim.png - comparing hsim and hspice power connections in single waveform
		--hsim_hspice_pwr_gnd_first_sim.png - comparing hsim and hspice power and ground connections in single waveform
	-hsim.fsdb - database file from hsim
	-results.tr0 - database file for hspice
	-hsim.log - log file for hsim run
	-results.lis - log file for hspice
	-packagedalu.control - control file for first sim run
second_sim_files - (with only ground pin connected)
	-wf_snapshots-
		--hsim_hspice_gnd_second_sim.png - comparing hsim and hspice ground connections in single waveform
		--hsim_hspice_pwr_second_sim.png - comparing hsim and hspice power connections in single waveform
		--hsim_hspice_pwr_gnd_second_sim.png - comparing hsim and hspice power and ground connections in single waveform
	-hsim.fsdb - database file from hsim
	-results.tr0 - database file for hspice
	-hsim.log - log file for hsim run
	-results.lis - log file for hspice
	-packagedalu.control - control file for second sim run

For simulations, the .sp file and control files were modified to have PWR and GND variable names as common for rail voltages.

(a) first simulation -
		hspice : total CPU time:        26.71(s)
		hsimplus : CPU time used:50.06 sec (50.06 sec wall)
	second simulation -
		hspice : total CPU time:        27.58(s)
		hsimplus : CPU time used:50.56 sec (50.56 sec wall)
	The 2x difference in cpu time is due to the extensive calculations and corrections hsimplus tool does compared to hspice which is reflected clearly in the power supply noise simulation snapshots.
(b) the package causes it to slow down, rise and fall is much slower.
(c) The closer GND and PWR pins are running parallel/orthogonal across the chips, there will be less noise and delays.
(d) The power signal which is disconnected just has noise on the signal as any open wire.
(e) The rise and fall times are much slower compared to the original signal due to RC constant.
(f) There will be much more delays in the circuit, and there might be more noise as well as switching activity would increase and di/dt would shoot up.
(g) Decoupling protects the circuit from high frequency noise signals and glitches.
(h) inductance induces false reset.
