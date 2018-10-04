// This is a synchronous reset 16-bit Galois lfsr
// Resets to all 1's. (could include load)
module lfsr16(clk, reset, a, b);

   input clk, reset;
   output [7:0] a, b;

   reg  [15:0] 	 lfsr;
   wire [7:0] 	 a, b;

   always @(posedge clk)
     begin
	if (reset) begin
           lfsr <= 16'b 1111_1111_1111_1111;
	end
	else 
	  begin
	     lfsr[0]     <= lfsr[15];
	     lfsr[2:1]   <= lfsr[1:0];
	     lfsr[3]     <= lfsr[2] ^ lfsr[15];
	     lfsr[6:4]   <= lfsr[5:3];
	     lfsr[7]     <= lfsr[6] ^ lfsr[15];
	     lfsr[9:8]   <= lfsr[8:7];
	     lfsr[10]    <= lfsr[9] ^ lfsr[15];
	     lfsr[15:11] <= lfsr[14:10];
	  end
     end

   assign a = lfsr[15:8];
   assign b = lfsr[7:0];

endmodule
