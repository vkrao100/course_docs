module chip (CLK, RESET, signature);
   input CLK, RESET;
   output [15:0] signature;

   wire [7:0] 	 A, B;
   wire [15:0] 	 MULT_OUT;
   wire [15:0] 	 signature;
   
   
   lfsr16 lfsr16_0 (.CLK(CLK), .RESET(RESET), .A(A), .B(B));
   mult mult_0 (.CLK(CLK), .RESET(RESET), .A(A), .B(B), .RESULT(MULT_OUT) );
   signature_analyzer16 sig_analyzer16(.CLK(CLK), .RESET(RESET), .IN0(MULT_OUT), .OUT0(signature) );
   
endmodule // chip
