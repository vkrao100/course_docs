/*
Project  : Bitcoin Hashing
Course   : ECE6710 FALL 2016
Group    : 5710_12
Author(s): Vikas Rao, Yomi Karthik Rupesh, Rajath Bindigan, Sreejitha Saha
Module   : sha 256 math operations
description: this module performs the core math operations of the SHA-256, which include shiting,
			 rotation, xor, choose, majority, and mod 32 addition. We will be using finite state machine 
			 model for flow control structure.
			 All the operations are on 32 bit Dword registers to maintain a good hash rate.
*/

// index define to offset 32-bit words inside a our 256 bit register 
`define INDEX(x) (((x)+1)*(32)-1):((x)*(32))

module sha256_math_operations(
                  			  input wire            clk,
                  			  input wire            reset_neg,
                  			  input wire            initialize,
                  			  input wire            operations,
                  			  input wire [511 : 0]  block_message,
			  
                  			  output wire           acknowledge,
                  			  output wire [255 : 0] hash,
                  			  output wire           hash_valid
                  			 );

   //total number of j loops 
   parameter BLOCK_512_ITERATOR = 63;
   
   //control operators for operation mode
   parameter OPERATIONS_IDLE   = 0;
   parameter OPERATIONS_ROUNDS = 1;
   parameter OPERATIONS_DONE   = 2;
   
   //initial H0 register declarations and new storage flops for the same   
   reg [31 : 0] H0_reg;
   reg [31 : 0] H0_new;
   reg [31 : 0] H1_reg;
   reg [31 : 0] H1_new;
   reg [31 : 0] H2_reg;
   reg [31 : 0] H2_new;
   reg [31 : 0] H3_reg;
   reg [31 : 0] H3_new;
   reg [31 : 0] H4_reg;
   reg [31 : 0] H4_new;
   reg [31 : 0] H5_reg;
   reg [31 : 0] H5_new;
   reg [31 : 0] H6_reg;
   reg [31 : 0] H6_new;
   reg [31 : 0] H7_reg;
   reg [31 : 0] H7_new;
   reg          H_we;

   // a..h register declarations.
   reg [31 : 0] a_reg;
   reg [31 : 0] a_new;
   reg [31 : 0] b_reg;
   reg [31 : 0] b_new;
   reg [31 : 0] c_reg;
   reg [31 : 0] c_new;
   reg [31 : 0] d_reg;
   reg [31 : 0] d_new;
   reg [31 : 0] e_reg;
   reg [31 : 0] e_new;
   reg [31 : 0] f_reg;
   reg [31 : 0] f_new;
   reg [31 : 0] g_reg;
   reg [31 : 0] g_new;
   reg [31 : 0] h_reg;
   reg [31 : 0] h_new;
   reg          update_registers;
 
   reg [5 : 0] t_ctr_reg;
   reg [5 : 0] t_ctr_new;
   reg         t_ctr_we;
   reg         t_ctr_inc;
   reg         t_ctr_rst;
 
   reg hash_valid_reg;
   reg hash_valid_new;
   reg hash_valid_we;
 
   reg [1 : 0] sha256_ctrl_reg;
   reg [1 : 0] sha256_ctrl_new;
   reg         sha256_ctrl_we;
 
 
   //################################################################
   // Wires.
   //################################################################
   reg hash_initialize;
   reg hash_update;
 
   reg state_initialize;
   reg state_update;
 
   reg first_block;
 
   reg ready_flag;
 
   reg [31 : 0] t1;
   reg [31 : 0] t2;
 
   wire [31 : 0] k_data;
 
   reg           w_initialize;
   reg           w_next;
   wire [31 : 0] w_data;
 
   //################################################################
   // constant module instantiantion for a..h,k return values.
   //################################################################
   constants_return H_K_constants_inst(
                                       .constant_address(t_ctr_reg),
                                       .constant_value(k_data)
                                      );
 
 
   // sha256_w_mem w_mem_inst(
   //                         .clk(clk),
   //                         .reset_n(reset_neg),
 
   //                         .block(block_message),
 
   //                         .initialize(w_initialize),
   //                         .next(w_next),
   //                         .w(w_data)
   //                        );
 
   // Concurrent connectivity for ports etc.
   assign acknowledge = ready_flag;
 
   assign hash = {H0_reg, H1_reg, H2_reg, H3_reg,
                    H4_reg, H5_reg, H6_reg, H7_reg};
 
   assign hash_valid = hash_valid_reg;
 
 
   //################################################################
   // reg_update
   // Update functionality for all registers in the core.
   // All registers are positive edge triggered with asynchronous
   // active low reset. All registers have write enable.
   //################################################################
   always @ (posedge clk or negedge reset_neg)
     begin : reg_update
       if (!reset_neg)
         begin
           a_reg            <= 32'h0;
           b_reg            <= 32'h0;
           c_reg            <= 32'h0;
           d_reg            <= 32'h0;
           e_reg            <= 32'h0;
           f_reg            <= 32'h0;
           g_reg            <= 32'h0;
           h_reg            <= 32'h0;
           H0_reg           <= 32'h0;
           H1_reg           <= 32'h0;
           H2_reg           <= 32'h0;
           H3_reg           <= 32'h0;
           H4_reg           <= 32'h0;
           H5_reg           <= 32'h0;
           H6_reg           <= 32'h0;
           H7_reg           <= 32'h0;
           hash_valid_reg <= 0;
           t_ctr_reg        <= 6'h0;
           sha256_ctrl_reg  <= OPERATIONS_IDLE;
         end
       else
         begin
 
           if (update_registers)
             begin
               a_reg <= a_new;
               b_reg <= b_new;
               c_reg <= c_new;
               d_reg <= d_new;
               e_reg <= e_new;
               f_reg <= f_new;
               g_reg <= g_new;
               h_reg <= h_new;
             end
 
           if (H_we)
             begin
               H0_reg <= H0_new;
               H1_reg <= H1_new;
               H2_reg <= H2_new;
               H3_reg <= H3_new;
               H4_reg <= H4_new;
               H5_reg <= H5_new;
               H6_reg <= H6_new;
               H7_reg <= H7_new;
             end
 
           if (t_ctr_we)
             t_ctr_reg <= t_ctr_new;
 
           if (hash_valid_we)
             hash_valid_reg <= hash_valid_new;
 
           if (sha256_ctrl_we)
             sha256_ctrl_reg <= sha256_ctrl_new;
         end
     end // reg_update
 
 
   //################################################################
   // hash_logic
   //
   // The logic needed to initialize as well as update the hash.
   //################################################################
   always @*
     begin : hash_logic
       H0_new = 32'h0;
       H1_new = 32'h0;
       H2_new = 32'h0;
       H3_new = 32'h0;
       H4_new = 32'h0;
       H5_new = 32'h0;
       H6_new = 32'h0;
       H7_new = 32'h0;
       H_we = 0;
 
       if (hash_initialize)
         begin
           H_we = 1;
           H0_new = SHA256_H0_0;
           H1_new = SHA256_H0_1;
           H2_new = SHA256_H0_2;
           H3_new = SHA256_H0_3;
           H4_new = SHA256_H0_4;
           H5_new = SHA256_H0_5;
           H6_new = SHA256_H0_6;
           H7_new = SHA256_H0_7;
         end
 
       if (hash_update)
         begin
           H0_new = H0_reg + a_reg;
           H1_new = H1_reg + b_reg;
           H2_new = H2_reg + c_reg;
           H3_new = H3_reg + d_reg;
           H4_new = H4_reg + e_reg;
           H5_new = H5_reg + f_reg;
           H6_new = H6_reg + g_reg;
           H7_new = H7_reg + h_reg;
           H_we = 1;
         end
     end // hash_logic
 
 
   //################################################################
   // t1_logic
   //
   // The logic for the T1 function.
   //################################################################
   always @*
     begin : t1_logic
       reg [31 : 0] sum1;
       reg [31 : 0] ch;
 
       sum1 = {e_reg[5  : 0], e_reg[31 :  6]} ^
              {e_reg[10 : 0], e_reg[31 : 11]} ^
              {e_reg[24 : 0], e_reg[31 : 25]};
 
       ch = (e_reg & f_reg) ^ ((~e_reg) & g_reg);
 
       t1 = h_reg + sum1 + ch + w_data + k_data;
     end // t1_logic
 
 
   //################################################################
   // t2_logic
   //
   // The logic for the T2 function
   //################################################################
   always @*
     begin : t2_logic
       reg [31 : 0] sum0;
       reg [31 : 0] maj;
 
       sum0 = {a_reg[1  : 0], a_reg[31 :  2]} ^
              {a_reg[12 : 0], a_reg[31 : 13]} ^
              {a_reg[21 : 0], a_reg[31 : 22]};
 
       maj = (a_reg & b_reg) ^ (a_reg & c_reg) ^ (b_reg & c_reg);
 
       t2 = sum0 + maj;
     end // t2_logic
 
 
   //################################################################
   // state_logic
   //
   // The logic needed to initialize as well as update the state during
   // round processing.
   //################################################################
   always @*
     begin : state_logic
       a_new  = 32'h0;
       b_new  = 32'h0;
       c_new  = 32'h0;
       d_new  = 32'h0;
       e_new  = 32'h0;
       f_new  = 32'h0;
       g_new  = 32'h0;
       h_new  = 32'h0;
       update_registers = 0;
 
       if (state_initialize)
         begin
           update_registers = 1;
           if (first_block)
             begin
                 a_new  = SHA256_H0_0;
                 b_new  = SHA256_H0_1;
                 c_new  = SHA256_H0_2;
                 d_new  = SHA256_H0_3;
                 e_new  = SHA256_H0_4;
                 f_new  = SHA256_H0_5;
                 g_new  = SHA256_H0_6;
                 h_new  = SHA256_H0_7;
             end
           else
             begin
               a_new  = H0_reg;
               b_new  = H1_reg;
               c_new  = H2_reg;
               d_new  = H3_reg;
               e_new  = H4_reg;
               f_new  = H5_reg;
               g_new  = H6_reg;
               h_new  = H7_reg;
             end
         end
 
       if (state_update)
         begin
           a_new  = t1 + t2;
           b_new  = a_reg;
           c_new  = b_reg;
           d_new  = c_reg;
           e_new  = d_reg + t1;
           f_new  = e_reg;
           g_new  = f_reg;
           h_new  = g_reg;
           update_registers = 1;
         end
     end // state_logic
 
 
   //################################################################
   // t_ctr
   //
   // Update logic for the round counter, a monotonically
   // increasing counter with reset.
   //################################################################
   always @*
     begin : t_ctr
       t_ctr_new = 0;
       t_ctr_we  = 0;
 
       if (t_ctr_rst)
         begin
           t_ctr_new = 0;
           t_ctr_we  = 1;
         end
 
       if (t_ctr_inc)
         begin
           t_ctr_new = t_ctr_reg + 1'b1;
           t_ctr_we  = 1;
         end
     end // t_ctr
 
 
   //################################################################
   // sha256_ctrl_fsm
   //
   // Logic for the state machine controlling the core behaviour.
   //################################################################
   always @*
     begin : sha256_ctrl_fsm
       hash_initialize      = 0;
       hash_update    = 0;
 
       state_initialize       = 0;
       state_update     = 0;
 
       first_block      = 0;
       ready_flag       = 0;
 
       w_initialize           = 0;
       w_next           = 0;
 
       t_ctr_inc        = 0;
       t_ctr_rst        = 0;
 
       hash_valid_new = 0;
       hash_valid_we  = 0;
 
       sha256_ctrl_new  = OPERATIONS_IDLE;
       sha256_ctrl_we   = 0;
 
 
       case (sha256_ctrl_reg)
         OPERATIONS_IDLE:
           begin
             ready_flag = 1;
 
             if (initialize)
               begin
                 hash_initialize      = 1;
                 w_initialize           = 1;
                 state_initialize       = 1;
                 first_block      = 1;
                 t_ctr_rst        = 1;
                 hash_valid_new = 0;
                 hash_valid_we  = 1;
                 sha256_ctrl_new  = OPERATIONS_ROUNDS;
                 sha256_ctrl_we   = 1;
               end
 
             if (operations)
               begin
                 t_ctr_rst        = 1;
                 w_initialize           = 1;
                 state_initialize       = 1;
                 hash_valid_new = 0;
                 hash_valid_we  = 1;
                 sha256_ctrl_new  = OPERATIONS_ROUNDS;
                 sha256_ctrl_we   = 1;
               end
           end
 
 
         OPERATIONS_ROUNDS:
           begin
             w_next       = 1;
             state_update = 1;
             t_ctr_inc    = 1;
 
             if (t_ctr_reg == SHA256_ROUNDS)
               begin
                 sha256_ctrl_new = OPERATIONS_DONE;
                 sha256_ctrl_we  = 1;
               end
           end
 
 
         OPERATIONS_DONE:
           begin
             hash_update    = 1;
             hash_valid_new = 1;
             hash_valid_we  = 1;
 
             sha256_ctrl_new  = OPERATIONS_IDLE;
             sha256_ctrl_we   = 1;
           end
       endcase // case (sha256_ctrl_reg)
     end // sha256_ctrl_fsm
 
endmodule

