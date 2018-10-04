// This is a signature analyzer for a 16-bit Galois lfsr
// Resets to all 1's. (could include load)
module sa16 (clk, reset, in, out);

   input         clk, reset;
   input  [15:0] in;
   output [15:0] out;

   reg  [15:0] 	 lfsr;
   wire [15:0] 	 out;

   always @(posedge clk)
     begin
	if (reset) begin
           lfsr <= 16'b 1111_1111_1111_1111;
	end
	else 
	  begin
	     lfsr[0]  <= in[0]  ^ lfsr[15];
	     lfsr[1]  <= in[1]  ^ lfsr[0];
	     lfsr[2]  <= in[2]  ^ lfsr[1];
	     lfsr[3]  <= in[3]  ^ lfsr[2] ^ lfsr[15];
	     lfsr[4]  <= in[4]  ^ lfsr[3];
	     lfsr[5]  <= in[5]  ^ lfsr[4];
	     lfsr[6]  <= in[6]  ^ lfsr[5];
	     lfsr[7]  <= in[7]  ^ lfsr[6] ^ lfsr[15];
	     lfsr[8]  <= in[8]  ^ lfsr[7];
	     lfsr[9]  <= in[9]  ^ lfsr[8];
	     lfsr[10] <= in[10] ^ lfsr[9] ^ lfsr[15];
	     lfsr[11] <= in[11] ^ lfsr[10];
	     lfsr[12] <= in[12] ^ lfsr[11];
	     lfsr[13] <= in[13] ^ lfsr[12];
	     lfsr[14] <= in[14] ^ lfsr[13];
	     lfsr[15] <= in[15] ^ lfsr[14];
	  end
     end

   assign out = lfsr;

endmodule
