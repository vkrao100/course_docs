read_library lib2_and_xor_inv.lib
read_eqn 4x4_SG_SP_AR_RC_fh.eqn
sweep
resub -a
write_blif -n 4x4_SG_SP_AR_RC_fh_axi_map.blif
quit
