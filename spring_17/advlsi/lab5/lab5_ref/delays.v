`timescale 1ns/1ps

module delay1 (lr, rr);
   input lr;
   output reg rr;
 
    //assign #0.01 rr = lr;
   always @(*) begin
      if (lr) rr <= #0.01 lr;
      else rr <= lr;
   end
   
    
 endmodule //delay1 


module delay3 (lr, rr);
   input lr;
   output rr;
  
    //assign #0.03 rr = lr; 
   always @(*) begin
      if (lr) rr <= #0.03 lr;
      else rr <= lr;
   end

endmodule //delay3


module delay5 (lr, rr);
   input lr;
   output rr;
  
  //assign #0.05  rr =  lr;
   always @(*) begin
      if (lr) rr <= #0.05 lr;
      else rr <= lr;
   end
   
endmodule //delay5
