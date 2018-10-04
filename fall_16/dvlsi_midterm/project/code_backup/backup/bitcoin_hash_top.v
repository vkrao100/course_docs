/*
Project     : Bitcoin Hashing
Course      : ECE6710 FALL 2016
Group       : 5710_12
Author      : Vikas Rao
Co-author(s): Yomi Karthik Rupesh, Rajath Bindigan, Sreejitha Saha
Module      : Bitcoin hashing top
description : This module instantiates the core math modules of the SHA-256. The first core 
			   instantiation uses the message block generated from bitcoin network input.
			   The output of first core is stored in registers and used for second core 
			   state instantiation to generate the intermediate hash. The second core calculates
			   the hash based on nonce data and is incremented until the target is met. 
*/

`timescale 1ns/1ps
`define MIDSTATE_INIT 1

module bitcoin_hash_top (clk, reset_n);

	// LOOP 64 iterator to get the 
	localparam [5:0] ITERATOR     = 6'd1;
	localparam [31:0] NONCE_COUNT = 32'h0;

	// reg/wire declaration for data to be loaded into core-1 
	reg [255:0]  core1_state = 0;
	reg [511:0]  core1_data  = 0;
	wire [255:0] core1_hash  = 0;

	// reg/wire declaration for data to be loaded into core-1 
	reg [255:0] core2_state = 0;
	reg [511:0] core2_data  = 0;
    reg [31:0]  nonce       = 32'h00000000;
    wire [255:0] core3_hash = 0;

	// reg/wire declaration for data to be loaded into core-1 
	reg [255:0]  core3_state = 0;
	reg [511:0]  core3_data  = 0;
	wire [255:0] core3_hash  = 0;
    
	reg [5:0] cnt     = 6'd0;
	reg feedback      = 1'b0;
	reg midstate_init = 1'b0;
    wire [255:0] final_hash;

    always @ (posedge clk)
	begin
    	`ifdef MIDSTATE_INIT
			midstate_buf  <= 256'h2b3f81261b3cfd001db436cfd4c8f3f9c7450c9a0d049bee71cba0ea2619c0b5;
			data_buf      <= 256'h00000000000000000000000080000000_00000000_39f3001b6b7b8d4dc14bfc31;
			nonce         <= 30411740;
			mesasge_input <= 640'h02000000aaf8ab82362344f49083ee4edef795362cf135293564c4070000000000000000c009bb6222e9bc4cdb8f26b2e8a2f8d163509691a4038fa692abf9a474c9b21476800755c02e17181fe6c1c3;
			//final output hash (00000000000000001354e21fea9c1ec9ac337c8a6c0bda736ec1096663383429) 
		`else
			midstate_buf  <= msg_streamer_ip1;
			data_buf      <= msg_streamer_ip2;
		`endif

		cnt         <= cnt_next;
		feedback    <= feedback_next;
		feedback_d1 <= feedback;

		// Give new data to the hasher
		state <= midstate_buf;
		data  <= {384'h000002800000000000000000000000000000000000000000000000000000000000000000000000000000000080000000, nonce_next, data_buf[95:0]};
		nonce <= nonce_next;
    end

    // Virtual Wire Control
	reg [255:0] midstate_buf = 0, data_buf = 0;
	wire [255:0] midstate_vw, data2_vw;

	// Virtual Wire Output
	reg [31:0] golden_nonce = 0;

	// Control Unit
	reg is_golden_ticket = 1'b0;
	reg feedback_d1     = 1'b1;
	wire [5:0] cnt_next;
	wire [31:0] nonce_next;
	wire feedback_next;

	assign cnt_next =  reset_n ? 6'd0 : (LOOP == 1) ? 6'd0 : (cnt + 6'd1) & (LOOP-1);
	// On the first count (cnt==0), load data from previous stage (no feedback)
	// on 1..LOOP-1, take feedback from current stage
	// This reduces the throughput by a factor of (LOOP), but also reduces the design size by the same amount
	assign feedback_next = (LOOP == 1) ? 1'b0 : (cnt_next != {(LOOP_LOG2){1'b0}});
	assign nonce_next = reset_n ? 32'd0 : feedback_next ? nonce : (nonce + 32'd1);

    //##############################################################################
    //  SHA -core 1 instantiation where we take data input from 
    //##############################################################################
	SHA256_core core1(
		.clk(clk),
		.reset_n(reset_n),
		.feedback(feedback),
		.cnt(cnt),
		.rx_state(init_state),
		.rx_input(core1_data),
		.tx_hash(core1_hash)
	);

	//##############################################################################
    //  SHA -core 2 instantiation where we take data input from 
    //##############################################################################
	SHA256_core core2 (
		.clk(clk),
		.reset_n(reset_n),
		.feedback(feedback),
		.cnt(cnt),
		.rx_state(256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667),
		.rx_input({256'h0000010000000000000000000000000000000000000000000000000080000000, core1_hash}),
		.tx_hash(core2_hash)
	);

	//##############################################################################
    //  SHA -core 3 instantiation where we take data input from 
    //##############################################################################
	SHA256_core core3 (
		.clk(clk),
		.reset_n(reset_n),
		.feedback(feedback),
		.cnt(cnt),
		.rx_state(256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667),
		.rx_input({256'h0000010000000000000000000000000000000000000000000000000080000000, core2_hash}),
		.tx_hash(core3_hash)
	);
	
	always @ (posedge hash_clk)
	begin
		// Check to see if the last hash generated is valid.
		is_golden_ticket <= (hash2[255:224] == 32'h00000000) && !feedback_d1;
		if(is_golden_ticket)
		begin
			// TODO: Find a more compact calculation for this
			if (LOOP == 1)
				golden_nonce <= nonce - 32'd131;
			else if (LOOP == 2)
				golden_nonce <= nonce - 32'd66;
			else
				golden_nonce <= nonce - GOLDEN_NONCE_OFFSET;
		end
	end

endmodule



