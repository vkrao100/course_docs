********************************************************************
* spice file describing a 130nm netlist for implementing 
* function (abcd+ae) driving an Inverter which is inturn driving
* driving a 10x load nmos output.
* 
* Node mapping: 
* vdd   = 1.8V
* gnd   = 0 (default)
* AD/AS = 2*n*w
* PS/PD = 4*n + w
********************************************************************

********************************************************************
* constant parameter declarations
********************************************************************
.PARAM le_scale_factor       = '2'
.PARAM pmos_scale            = '2'
.PARAM inverter_load_scaling = '5'

********************************************************************
*initial values with normal load balancing and effort
********************************************************************
*    D   G    S    B
M0 outI ina   wa   0   nmos  L=130n W='300n*le_scale_factor*le_scale_factor'  AD='2*130n*300n*le_scale_factor*le_scale_factor' AS='2*130n*300n*le_scale_factor*le_scale_factor' PD='4*130n+300n*le_scale_factor*le_scale_factor' PS='4*130n+300n*le_scale_factor*le_scale_factor' M=1
M1  wa  ind   wc   0   nmos  L=130n W='300n*le_scale_factor*le_scale_factor'  AD='2*130n*300n*le_scale_factor*le_scale_factor' AS='2*130n*300n*le_scale_factor*le_scale_factor' PD='4*130n+300n*le_scale_factor*le_scale_factor' PS='4*130n+300n*le_scale_factor*le_scale_factor' M=1
M2  wc  inc   wb   0   nmos  L=130n W='300n*le_scale_factor*le_scale_factor'  AD='2*130n*300n*le_scale_factor*le_scale_factor' AS='2*130n*300n*le_scale_factor*le_scale_factor' PD='4*130n+300n*le_scale_factor*le_scale_factor' PS='4*130n+300n*le_scale_factor*le_scale_factor' M=1
M3  wb  inb   0    0   nmos  L=130n W='300n*le_scale_factor*le_scale_factor'  AD='2*130n*300n*le_scale_factor*le_scale_factor' AS='2*130n*300n*le_scale_factor*le_scale_factor' PD='4*130n+300n*le_scale_factor*le_scale_factor' PS='4*130n+300n*le_scale_factor*le_scale_factor' M=1
M4  wa  ine   0    0   nmos  L=130n W='300n*le_scale_factor'  AD='2*130n*300n*le_scale_factor' AS='2*130n*300n*le_scale_factor' PD='4*130n+300n*le_scale_factor' PS='4*130n+300n*le_scale_factor' M=1
M5 outI ine   wi  vdd  pmos  L=130n W='300n*le_scale_factor*pmos_scale' AD='2*130n*300n*le_scale_factor*pmos_scale' AS='2*130n*300n*le_scale_factor*pmos_scale' PD='4*130n+300n*le_scale_factor*pmos_scale' PS='4*130n+300n*le_scale_factor*pmos_scale' M=1
M6 outI ina  vdd  vdd  pmos  L=130n W='300n*pmos_scale'  AD='2*130n*300n*pmos_scale' AS='2*130n*300n*pmos_scale' PD='4*130n+300n*pmos_scale' PS='4*130n+300n*pmos_scale' M=1
M7  wi  inb  vdd  vdd  pmos  L=130n W='300n*le_scale_factor*pmos_scale' AD='2*130n*300n*le_scale_factor*pmos_scale' AS='2*130n*300n*le_scale_factor*pmos_scale' PD='4*130n+300n*le_scale_factor*pmos_scale' PS='4*130n+300n*le_scale_factor*pmos_scale' M=1
M8  wi  inc  vdd  vdd  pmos  L=130n W='300n*le_scale_factor*pmos_scale' AD='2*130n*300n*le_scale_factor*pmos_scale' AS='2*130n*300n*le_scale_factor*pmos_scale' PD='4*130n+300n*le_scale_factor*pmos_scale' PS='4*130n+300n*le_scale_factor*pmos_scale' M=1
M9  wi  ind  vdd  vdd  pmos  L=130n W='300n*le_scale_factor*pmos_scale' AD='2*130n*300n*le_scale_factor*pmos_scale' AS='2*130n*300n*le_scale_factor*pmos_scale' PD='4*130n+300n*le_scale_factor*pmos_scale' PS='4*130n+300n*le_scale_factor*pmos_scale' M=1
M10 out outI  0    0   nmos  L=130n W='300n*inverter_load_scaling'  AD='2*130n*300n*inverter_load_scaling'  AS='2*130n*300n*inverter_load_scaling'  PD='4*130n+300n*inverter_load_scaling'  PS='4*130n+300n*inverter_load_scaling'  M=1
M11 out outI vdd  vdd  pmos  L=130n W='300n*inverter_load_scaling*pmos_scale'  AD='2*130n*300n*inverter_load_scaling*pmos_scale'  AS='2*130n*300n*inverter_load_scaling*pmos_scale'  PD='4*130n+300n*inverter_load_scaling*pmos_scale'  PS='4*130n+300n*inverter_load_scaling*pmos_scale'  M=1
* output load gate - 10x load
M12  0  out   0    0   nmos  L=130n W='(4+2*le_scale_factor)*10*300n' AD='2*130n*(4+2*le_scale_factor)*10*300n' AS='2*130n*(4+2*le_scale_factor)*10*300n' PD='4*130n+(4+2*le_scale_factor)*10*300n' PS='4*130n+(4+2*le_scale_factor)*10*300n' M=1
