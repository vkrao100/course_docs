This is the second submission of the lab, the first one is at 130nm technology node, the latest updated one is at the required 65nm technology node, apologies for the confusion created.



***placement of files
The files are placed in the following manner :-

1. The pipeline modules are in the folder called pipelines.
2. The delay elements are kept in a single file called "delays.v".
3. The verilog testbench is in a file named "pipeline-testbench.v".
4. The results of all the simulations are in a file called "values.txt"
5. Modelsim transcripts of all those values are listed in the folder called transcripts.

pipeline1 - the one with 4 stage LC_BM controllers.
pipeline2 - the one with 4 stage LC_CC controllers.
pipeline3 - the one with 2 stage LC_BM and 2 stage LC_CC controllers.
pipeline4 - the one with 4 stage LC_BM controllers with 1 delay.
pipeline5 - the one with 4 stage LC_CC controllers with 3 delay.
pipeline6 - the one with different delays.

**** Behaviour of the simulation script ****
When the go_l signal goes from low to high, the simulation starts. The forward latency is found by essentially finding the difference between the time where lr and rr becomes high. It is the time taken for a signal to travel through the pipeline in the forward direction (from LHS to RHS).

Similarly, for backward latency, the time from where ra goes high to the time where la goes high is calculated. It is the time taken for the acknowledgment to travel in the reverse direction (RHS to LHS).
Cycle time is calculated between two high lr instances. Buffering depth is the amount of data that can be put into the pipeline with the other end blocked. say, if the data is fed from LHS and the RHS side is blocked, then the amount of data that can be held in the pipeline with out actually changing the data for further use. Buffering depth is calculated whenever la goes from high to low. The loop is broken whenever there is no request for more than three cycles or if the specified break time has reached from the point where the simulation has started.

LHS is the block left of the pipeline. It generates lr signal which propagates through the pipeline. RHS is the block to the right of pipeline. It generates ra signal upon the reciept of the right request signal which propagates in pipeline from right to left. When lr is high, the pipeline starts filling and RHS asserts with an acknowledge signal once the pipeline is filled. Now the pipeline is emptied. 

The difficulty was to understand the tcl testbench and 'translating' it to verilog. understanding how things worked and what time units are followed, i had trouble figuring that thing out. 

The main difference in writing a testbench for asynchronous design and a synchronous design is there is no global clock when you are writing a test bench for asynchronous design. The working of the design depends on the states of the signals and is independent of the clock, so you essentially end up specifying everything based on the stuff that is available to ups, the inputs and time, however this time is not segregated into periods, rather is discrete and continuous, meaning, events can change at any given time and they matter at the sam etime rather than at an arbitarily pre defined moment (clock edge). 


**** Answers for 9th question ****
a. We have used the C-element based controller (LC_C) and Burst mode controller (LC_BM), because of the differences in their build there is difference in the buffering depth.   

b. The main difference is that LC_C holds the control and data signals for two stages whereas LC_BM holds the signals for only one stage. This results in the buffer depths of 2 and 4 respectively. 

c. By combining different protocols, we are essentially adding buffer depth, say in pipeline3 we have two LC_C controllers resulting in a buffer depth of 1 added with two individual LC_BM controllers giving a buffer depth of two more and a total buffering depth of 3.

d. The largest delay in the pipeline is always considered despite of the presence of multiple delay elements. I think it generalizes to almost all async pipelines having LC_C and LC_BM controllers in them because asynchronous design obeys modularity and the individual devices' property matters adn hence the delay condition holds. 

e. Clocked pipeline depends on a global clock so the clock speed is constant. Even if the execution time of some stages are less than the clock speed, the stage should be in idle till the next clock pulse. This is not the case in asynchronous pipeline. In asynchronous pipelining different stages takes different time to execute and they won’t wait for any clock pulse to go to next stage. This results in better timing performance compared to clocked design.
