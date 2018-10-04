### This is the script for optimizing the verilog


#----------------------------------------------------------------------#
#                        DESIGN DEFINITION                             #
#----------------------------------------------------------------------#


set design_name  mult
set design_dir   "."


### EDIT $design_name.cstr.tcl for timing and other constraints!



############## technology files #########################
### can include multiple .db files in string.

## Utah
set lib_name  "UofU_Digital_v1_2"
set lib_db    "UofU_Digital_v1_2.db"
set lib_dir   "/uusoc/facility/cad_common/local/Cadence/lib/UofU_Digital_v1_2/"
## set lib_pdb   physical db defs

## UWashington 130nm:
#set lib_name  "static184cg_1.5V_25C"
#set lib_db    "static184cg_1.5V_25C.db"
#set lib_dir   "/uusoc/facility/cad_common/local/Cadence/lib/cg_lib13_v096/"
##set lib_pdb   physical db defs

## Artisan 130nm:
#set lib_name  "typical"
#set lib_db    "typical.db"
#set lib_dir   "/uusoc/facility/cad_common/IBM/Artisan/8RF-1.2v/aci/sc-x/synopsys/"
#set lib_pdb   "ibm13svt_8lm_2thick_3rf.pdb"

## Artisan 65nm:
#set lib_name  "scadv12_cmos10sf_rvt_tt_1p0v_25c"
#set lib_db    "scadv12_cmos10sf_rvt_tt_1p0v_25c.db"
#set lib_dir   "/uusoc/facility/cad_common/Artisan/GF/cmos65g/aci/sc-adv12/synopsys"
##set lib_pdb



############# custom library files #############################
#set custom_cells ../lib/custom-cells.v
#set custom_seq   ../lib/custom-sequentials.v



################################################
#            DC configuration variables
# Milkyway related variables
set mw_design_library $design_name.mw
#set mw_power_net   VDD
#set mw_ground_net  VSS
set mw_logic1_net  VDD
set mw_logic0_net  VSS
set mw_power_port  VDD
set mw_ground_port VSS
##set mw_tech_file /.../milkyway/tcbn90ghphvt_130a/techfiles/tsmcn90_7lm_6x6.tf
##set mw_reference_library [list /../milkyway/tcbn90ghphvt_130a /../milkyway/tcbn90ghplvt_130a]


# db and cache configuration
set cache_read  {}
set cache_write {}
set allow_newer_db_files       true
set write_compressed_db_files  true
set sh_source_uses_search_path true
#################################################


# Define checkpoint function
proc checkpoint {name} {
  echo "CPU-$name: [cputime -self -child]"
  echo "MEM-$name: [mem]"
  echo "CLK-$name: [clock seconds]"
}

#----------------------------------------------------------------------#
#                             DESIGN SETUP                             #
#----------------------------------------------------------------------#

set search_path [concat  . $design_dir $lib_dir $search_path]
set search_path "$search_path ${synopsys_root}/libraries/syn"
set search_path "$search_path ${synopsys_root}/dw/sim_ver"


################################################################
# DC library definitions
set local_link_library [list ]
set target_library $lib_db

set synthetic_library "dw_foundation.sldb"
set link_library [concat * $lib_db $synthetic_library]
if [info exists lib_pdb] {
    set physical_library $lib_pdb
} else {
    set physical_library [list ]
}

set symbol_library [list ]
################################################################


if [info exists dc_shell_mode] {
    set suppress_errors "$suppress_errors TRANS-1 TIM-111 TIM-164 OPT-109 UID-101 TIM-134 DDB-74"
}

checkpoint setup

#----------------------------------------------------------------------#
#                        READ DB FROM RTLOPT                           #
#----------------------------------------------------------------------#
read_file -format ddc $design_name.rtlopt.ddc
checkpoint read

current_design $design_name
link
checkpoint link



#----------------------------------------------------------------------#
#                           READ CONSTRAINTS                           #
#----------------------------------------------------------------------#
current_design $design_name
#set formality_link_debug true
set svf_file_records_change_names_changes true
set enable_dw_datapath_in_svf true
#set enable_ununiquify_in_svf true
set hlo_write_svf_info true
set synlib_fmlink_output_verilog true
set enable_constant_propagation_in_svf true
set_svf $design_name.dcopt.svf
set_vsdc $design_name.dcopt.vsdc
current_design  $design_name
source $design_name.cstr.tcl
###source $design_name.tcl
checkpoint cstr



#----------------------------------------------------------------------#
#                                COMPILE                               #
#----------------------------------------------------------------------#
#current_design $design_name
#set ungroup_record_report_info true

list_designs -show_file
current_design $design_name
echo "Start: [cputime -self -child]"

## Do retiming?
#set_balance_registers true
check_design

## clock gate design
insert_clock_gating

## compile design
compile -area_effort high -map_effort high
#compile -area_effort high -power_effort high
#compile -area_effort high -power_effort high -map_effort medium -ungroup_all
#compile -area_effort high -power_effort high -map_effort high -ungroup_all -verify_effort high

## guarantee naming consistency
source namingrules.dc

echo "End: [cputime -self -child]"
checkpoint compile

check_design

#----------------------------------------------------------------------#
#                           FINAL QOR REPORT                           #
#----------------------------------------------------------------------#
current_design $design_name
file delete $design_name.profile_post.out
report_qor
report_area
report_timing -attributes
report_constraints

checkpoint report

#----------------------------------------------------------------------#
#                                 WRITE                                #
#----------------------------------------------------------------------#
current_design $design_name
write -format ddc -hierarchy -output $design_name.dcopt.ddc
write -format verilog -hierarchy -output $design_name.dcopt.v
write_sdc $design_name.dcopt.sdc
write_sdf -context verilog $design_name.dcopt.sdf
redirect $design_name.dcopt.constraints { report_constraints -all_violators -verbose -significant_digits 3}
redirect $design_name.dcopt.paths { report_timing -path end -delay max -max_paths 20 -nworst 100 -significant_digits 3 }
redirect $design_name.dcopt.fullpaths { report_timing -path full -delay max -max_paths 20 -nworst 100 -significant_digits 3 }
redirect $design_name.dcopt.area { report_area }
redirect $design_name.dcopt.power { report_power }
# write_mw_verilog -design $design_name $design_name.mw.v
#write_parasitics -format reduced -output $design_name.spef

checkpoint write

exit
