// Testbench bitcoin hash
//


`timescale 1ns/1ps

module bitcoin_hash_tb ();

	reg clk = 1'b0;
	reg tb_reset_n = 1'b0;
	reg [255:0] midstate_buf;
	reg [95:0] data_buf;
	reg [31:0] nonce;
	wire [31:0] golden_nonce;
	wire golden_nonce_valid;

	bitcoin_hash_top dut (clk, tb_reset_n, midstate_buf, data_buf, nonce, golden_nonce, golden_nonce_valid);

	reg [31:0] cycle = 32'd0;

	initial begin
		clk = 0;
		
		#100 

		reset_dut();

		#50

		// Test data
		midstate_buf = 256'h228ea4732a3c9ba860c009cda7252b9161a5e75ec8c582a5f106abb3af41f790;
		data_buf     = 512'h000002800000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000002194261a9395e64dbed17115;
		nonce        = 32'h0e33337a - 256;	// Minus a little so we can exercise the code a bit

		while(1)
		  begin
      	    #5 clk = 1; #5 clk = 0;
          end
	end
    //----------------------------------------------------------------
    // reset_dut()
    //
    // Toggle reset to put the DUT into a well known state.
    //----------------------------------------------------------------
    task reset_dut;
      begin
        $display("*** Toggle reset.");
        tb_reset_n = 0;
        #(4 * clk);
        tb_reset_n = 1;
      end
    endtask // reset_dut

	always @ (posedge clk)
	begin
		cycle <= cycle + 32'd1;
	end

endmodule

