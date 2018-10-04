###################################################
#  U1072596 - Vikas kumar rao
#  readme describing the transistor naming/sizing
#  output format/strategy and test vetor selection.  
###################################################

circuit_schematic.pdf - scanned copy of the circuit schematic describing the structure used.

issues/questions - It was not very clear on what this means - "Rise and fall saturated ramps will be identical at 40 ps for the
130 nm node, and 20 ps for the 32 nm node." Does this mean, we need to have PWL samples at these intervals or half of these intervals? For my experiments, I used it as the mid ramp value, meaning - for 32nm, I took 20ps timestamp as my 50% ramp transition(either rise or fall) on the input, and for 130nm, I took 40ps as my 50% ramp transition(eiterh rise or fall) on the input. Also the other issue which i faced was on why we need to measure average power across 400ps, while the transition is only occuring until max of 30ps(for 32nm) and 60ps(for 130nm).

Transistor input/naming/sizing - 

pmos scaling value - I did experiment with different pmos scaling value (2 against - 2.5 and 3), but it results in a increasesd power usage, but reduced delay, but since power has a lower decimal exponential (order of '-5' as compared to delay '-11'), the value of power will have a major impact on the final calculated performace value (lower power-  better performace numbers, higher power - lower performance numbers), hence chose to go with the lowest scaling value of 2.

nmos
i/p   - Trn  - Trn size(with logical effort) 
--------------------------------------------------------------
a     - M0   - 4
d     - M1   - 4
c     - M2   - 4
b     - M3   - 4
e     - M4   - 2
out1  - M10  - 5
out   - M12  - (4+4)*10 -- (max i/p load on 'a' -[(nmos+pmos)*10x])

pmos -
i/p   - Trn  - Trn size(with logical effort and pmos scaling) 
--------------------------------------------------------------
a     - M6   - 2
d     - M9   - 4
c     - M8   - 4
b     - M7   - 4
e     - M5   - 4
out1  - M11  - 10

Design strategy for transistor sizing in firsts stage-
I have used the standar AOI gates to model the function. The regular (3 input and + OR + AND) will result in 
a structure comprising 14 transistors, while it can be implemented with one less transistor in AOI.
Transistor M0 here can either take size 4 considering the series path with transistor M4 or take 4 considering the series path with (M1-M2-M3).
I have chosen the latter to fit the best path delay timing.

In case of pmos, transistor pairs (M5-M7, M5-M8, M5-M9) form a straighforward series thus taking size of 4, and M6 is just takes single transistor pmos sizing which is 2. 

Transistor sizing in case of inverter -
The inverter is driving a load of 10x. We know that as the width of a device increases, the flow of current increases, gate capacitance increases and hence transmission delay decreases. Given that the delay can be modeled as d=gh+P where (g- logical effort, h - electrical effort, P - parasitic delay).
The delay maximizes if we take a unit size transistor with 1 and 3 for nmos and pmos respectively. to account for less delay, we will use a sizing 5 on nmos and 10 in case of pmos to reduce the delay. 

The test vector for worst case fall is chosen as transition from - 11110(A-1, B-1, C-1, D-1, E-0) to 11100 as this exercises 4 nmos transistors in series 
and hence having a higher switching activity+delay recorded from 4 transistors to keep the initial output value at 1, and then we turn on M9 to charge vdd onto M9-M5 path, thus causing a fall in the output value.

The test vector for best case fall is chosen as transition from - 11111(A-1, B-1, C-1, D-1, E-1) to 00000, as this causes the entire series to to be closed initially thus keeping the output state at 1 from the best possible path, and when transitioned, will cause M0-M1-M2-M3-M4 to open and all M6-M7-M8-M9-M10 to be closed, thus switching the output and making it fall drastically. 

The test vector for best case rise is chosen as transition from - 01111(A-0, B-1, C-1, D-1, E-1) to 11111, as this keeps M0 open, M6 to be closed, thus keeping the output at 0, and when a is flipped, causes the short on M0/M4 to drag the out1 to 0, thus rising the output value to 1 with just one transistor switching activity.

The test vector for worst case rise is chosen as transition from - 11100(A-1, B-1, C-1, D-0, E-0) to 11110, as this uses the two series path M9-M5 to keep the output at 0, and then to flip the output to 1, we will use the longest discharge path M0-M1-M2-M3, increasing the switching activity and hence the delay. 


file names and waveforms, each control files used, output files mt0 are all in their respective directories and the names are self explanatory on what technology and conditions were the experiment run on.

for example - 
function_130_worst_case_rise - run on 130nm with condition for worst case rise.

         -----------------------------------------------------------
         |             best           |             worst          |
         -----------------------------------------------------------
         | rising time | falling time | rising time | falling time | 
--------------------------------------------------------------------
|        |             |              |             |              |
| 130nm  |  6.632e-11  |  7.796e-11   |  1.038e-10  |  1.378e-10   |  
|        |             |              |             |              | 
-------------------------------------------------------------------
| power  |  2.564e-4   |  3.092e-4    |  3.085e-4   |  3.296e-4    |
--------------------------------------------------------------------
|        |             |              |             |              |
|  32nm  |  2.301e-11  |  2.402e-11   |  3.970e-11  |  4.269e-11   |
|        |             |              |             |              |
-------------------------------------------------------------------
| power  |  2.472e-5   |  2.594e-5    |  2.795e-5   |  2.742e-5    |
--------------------------------------------------------------------

performance calculations -
for 130nm - 

total Tau   = adding all values from row 1 above      = 3.8588e-10
total power = adding all pwer values from row 2 above = 12.037e-4
sampling period  = 400ps = 400e-12

Energy = total power * period = 12.037e-4 * 400e-12 =  4814.8e-16 Joules

performance = Energy*total Tau = 4814.8e-16 * 3.8588e-10 = 18579.35e-26


for 32nm - 

total Tau   = adding all values from row 1 above      = 12.942e-11
total power = adding all pwer values from row 2 above = 10.603e-5
sampling period  = 400ps = 400e-12

Energy = total power * period = 10.603e-5 * 400e-12 =  4241.2e-17 Joules

performance = Energy*total Tau = 4241.2e-17 * 12.942e-11 = 54889.61e-28

