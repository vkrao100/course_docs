 //Project: Bitcoin Hashing
// Course: ECE6710 FALL 2016
// Group: 5710_12
// Author(s): Yomi Karthik Rupesh, Vikas Rao, Rajath Bindigan, Sreejita Saha
// This module is used to return all the required 32-bit constant values for
// evaluating SHA-256. Constant values are returned based on constant_address 
// parsed during instantiation of this module.
// The first 8 address locations correspond to the fractional parts of the 
// square roots of the first 8 prime numbers.
// The remaining 64 addresses loop.e from (addresses 08 to 71) correspond to the first 
// thirty-two bits of the fractional parts of the cube roots of the first 
// sixty-four prime numbers.
// total number of blocks , 512bit blocks


`timescale 1ns/1ps
`define ELEMENT(x) ((x + 1)*(32)-1):(x * 32)

module SHAcore #(		
	parameter ITERATIONS = 6'd4	
) (
	input clk,
	input feeder,	
	input [5:0] count_value,	
	input [255:0] state_input,		
	input [511:0] message_block,		
	output reg [255:0] output_hash		
);

	localparam K_constants = {
		32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5,
		32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
		32'hd807aa98, 32'h12835b01, 32'h243185be, 32'h550c7dc3,
		32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7, 32'hc19bf174,
		32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc,
		32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da,
		32'h983e5152, 32'ha831c66d, 32'hb00327c8, 32'hbf597fc7,
		32'hc6e00bf3, 32'hd5a79147, 32'h06ca6351, 32'h14292967,
		32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc, 32'h53380d13,
		32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
		32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3,
		32'hd192e819, 32'hd6990624, 32'hf40e3585, 32'h106aa070,
		32'h19a4c116, 32'h1e376c08, 32'h2748774c, 32'h34b0bcb5,
		32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f, 32'h682e6ff3,
		32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208,
		32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2};


	genvar loop;	

	// generate

		for (loop = 0; loop < 64/ITERATIONS; loop = loop + 1) begin : HASHERS
			wire [255:0] present_state;			
			wire [511:0] w_update;		

			if(loop == 0)
				SHA_mathoperations U (			
					.clk(clk),
					.k_value(K_constants[32*(63-count_value) +: 32]),
					.w_value(feeder ? w_update : message_block),
					.state_input(feeder ? present_state : state_input),
					.w_output(w_update),
					.present_state(present_state)
				);
			else
				SHA_mathoperations U (
					.clk(clk),
					.k_value(K_constants[32*(63-ITERATIONS*loop-count_value) +: 32]),
					.w_value(feeder ? w_update : HASHERS[loop-1].w_update),
					.state_input(feeder ? present_state : HASHERS[loop-1].present_state),
					.w_output(w_update),
					.present_state(present_state)
				);
		end

	// endgenerate

	always @ (posedge clk)
	begin
		if (!feeder)
		begin
			output_hash[`ELEMENT(7)] <= state_input[`ELEMENT(7)] + HASHERS[64/ITERATIONS-6'd1].present_state[`ELEMENT(7)];
			output_hash[`ELEMENT(6)] <= state_input[`ELEMENT(6)] + HASHERS[64/ITERATIONS-6'd1].present_state[`ELEMENT(6)];
			output_hash[`ELEMENT(5)] <= state_input[`ELEMENT(5)] + HASHERS[64/ITERATIONS-6'd1].present_state[`ELEMENT(5)];
			output_hash[`ELEMENT(4)] <= state_input[`ELEMENT(4)] + HASHERS[64/ITERATIONS-6'd1].present_state[`ELEMENT(4)];
			output_hash[`ELEMENT(3)] <= state_input[`ELEMENT(3)] + HASHERS[64/ITERATIONS-6'd1].present_state[`ELEMENT(3)];
			output_hash[`ELEMENT(2)] <= state_input[`ELEMENT(2)] + HASHERS[64/ITERATIONS-6'd1].present_state[`ELEMENT(2)];
			output_hash[`ELEMENT(1)] <= state_input[`ELEMENT(1)] + HASHERS[64/ITERATIONS-6'd1].present_state[`ELEMENT(1)];
			output_hash[`ELEMENT(0)] <= state_input[`ELEMENT(0)] + HASHERS[64/ITERATIONS-6'd1].present_state[`ELEMENT(0)];
		end
	end


endmodule


module SHA_mathoperations (clk, k_value, w_value, state_input, w_output, present_state);
	input clk;
	input [31:0] k_value;
	input [511:0] w_value;
	input [255:0] state_input;

	output reg [511:0] w_output;
	output reg [255:0] present_state;

	wire [31:0] epsa0, epsa1, choose_value, maj, sigma0, sigma1;


	e0	epsa0_call	(state_input[`ELEMENT(0)], epsa0);
	e1	epsa1_call	(state_input[`ELEMENT(4)], epsa1);
	ch	choose_call	(state_input[`ELEMENT(4)], state_input[`ELEMENT(5)], state_input[`ELEMENT(6)], choose_value);
	maj	majority_call	(state_input[`ELEMENT(0)], state_input[`ELEMENT(1)], state_input[`ELEMENT(2)], maj);
	s0	sigma0_call	(w_value[63:32], sigma0);
	s1	sigma1_call	(w_value[479:448], sigma1);

	wire [31:0] t1_value = state_input[`ELEMENT(7)] + epsa1 + choose_value + w_value[31:0] + k_value;
	wire [31:0] t2_value = epsa0 + maj;
	wire [31:0] w_modifier = sigma1 + w_value[319:288] + sigma0 + w_value[31:0];
	

	always @ (posedge clk)
	begin
		w_output[511:480] <= w_modifier;
		w_output[479:0] <= w_value[511:32];

		present_state[`ELEMENT(7)] <= state_input[`ELEMENT(6)];
		present_state[`ELEMENT(6)] <= state_input[`ELEMENT(5)];
		present_state[`ELEMENT(5)] <= state_input[`ELEMENT(4)];
		present_state[`ELEMENT(4)] <= state_input[`ELEMENT(3)] + t1_value;
		present_state[`ELEMENT(3)] <= state_input[`ELEMENT(2)];
		present_state[`ELEMENT(2)] <= state_input[`ELEMENT(1)];
		present_state[`ELEMENT(1)] <= state_input[`ELEMENT(0)];
		present_state[`ELEMENT(0)] <= t1_value + t2_value;
	end

endmodule



module e0 (in, out);	

	input [31:0] in;
	output [31:0] out;

	assign out = {in[1:0],in[31:2]} ^ {in[12:0],in[31:13]} ^ {in[21:0],in[31:22]};

endmodule


module e1 (in, out);	

	input [31:0] in;
	output [31:0] out;

	assign out = {in[5:0],in[31:6]} ^ {in[10:0],in[31:11]} ^ {in[24:0],in[31:25]};

endmodule


module ch (a, b, c, y);

	input [31:0] a, b, c;
	output [31:0] y;

	assign y = c ^ (a & (b ^ c));

endmodule


module maj (a, b, c, y);	

	input [31:0] a, b, c;
	output [31:0] y;

	assign y = (a & b) | (c & (a | b));

endmodule


module s0 (in, out);	

	input [31:0] in;
	output [31:0] out;

	assign out[31:29] = in[6:4] ^ in[17:15];
	assign out[28:0] = {in[3:0], in[31:7]} ^ {in[14:0],in[31:18]} ^ in[31:3];

endmodule


module s1 (in, out);	

	input [31:0] in;
	output [31:0] out;

	assign out[31:22] = in[16:7] ^ in[18:9];
	assign out[21:0] = {in[6:0],in[31:17]} ^ {in[8:0],in[31:19]} ^ in[31:10];

endmodule


