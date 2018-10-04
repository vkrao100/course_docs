//################################################################################################################
//Project  : Bitcoin Hashing
//Course   : ECE6710 FALL 2016
//Group    : 5710_12
//Author(s): Vikas Rao, Yomi Karthik Rupesh, Rajath Bindigan, Sreejita Saha
//Module   : bitcoin_hash testbench
//description: This module performs the injection of the input vectors clk, tb_rest_n, midstate_buf, data_buf, nonce 
//             to our bitcoin_hash top module to verify its functionality  
//################################################################################################################


`timescale 1ns/1ps

module bitcoin_hash_tb ();

	reg clk = 1'b0;
	reg tb_reset_n = 1'b0;
	reg [255:0] midstate_buf;
	reg [95:0] data_buf;
	reg [31:0] nonce;
    wire [31:0] golden_nonce = 32'd0;
    wire golden_nonce_valid = 1'b0;

	bitcoin_hash_top dut (clk, tb_reset_n, midstate_buf, data_buf, nonce, golden_nonce, golden_nonce_valid);

	initial begin
		clk = 0;
		
		#100 

		reset_dut();

		#50

		// Test data
		midstate_buf = 256'h228ea4732a3c9ba860c009cda7252b9161a5e75ec8c582a5f106abb3af41f790;
        data_buf     = 512'h000002800000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000002194261a9395e64dbed17115;
		nonce        = 32'h0e33337;
		// midstate_buf = 256'ha32b6cc68f4c6a5b9e4fa7d8c3d6e2d9f178451a9bdfa8e42bcaefc746910ea4;
  //       data_buf     = 512'h000002800000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000003780fb456cffac812ed60468;
		// nonce        = 32'h0f930356;
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
    
    always @(posedge clk)
      begin
        if (golden_nonce_valid)
          begin
            $display("*****found golden nonce%32x\n",golden_nonce);
            $finish;
          end
      end
        
endmodule

