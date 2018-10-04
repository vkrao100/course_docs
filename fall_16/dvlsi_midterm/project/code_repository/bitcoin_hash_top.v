//################################################################################################################
//Project  : Bitcoin Hashing
//Course   : ECE6710 FALL 2016
//Group    : 5710_12
//Author(s): Vikas Rao, Yomi Karthik Rupesh, Rajath Bindigan, Sreejita Saha
//Module   : bitcoin_hash top module
//description: this module generates the golden nonce and the final hash value based on the target check
//################################################################################################################

// `timescale 1ns/1ps
// `define SIM 1

module bitcoin_hash_top(input tb_clk, input reset_n, input wire [255:0] midstate_buf, input wire [95:0] data_buf, input wire [31:0] nonce, output reg [31:0] golden_nonce_out, output reg golden_nonce_valid);

  parameter idle_state           = 0;
  parameter core1_iteration_done = 1;
  parameter core2_iteration      = 2;
  parameter golden_ticket_check  = 3;
  parameter exit_iteration       = 4;
  //----------------------------------------------------------------
  // Register and Wire declarations.
  //----------------------------------------------------------------
  reg            tb_init1;
  reg            tb_init2;
  reg [511 : 0]  tb_block1;
  reg [511 : 0]  tb_block2;
  reg [255 : 0]  tb_state_ip1;
  reg [255 : 0]  tb_state_ip2;
  wire           core1_ready;
  reg            core1_ready_reg;
  wire           core2_ready;
  reg            core2_ready_reg;
  wire [255 : 0] core1_hash;
  reg  [255 : 0] core1_hash_reg;
  wire [255 : 0] core2_hash;
  reg  [255 : 0] core2_hash_reg;
  wire           core1_hash_valid;
  reg            core1_hash_valid_reg;
  wire           core2_hash_valid;
  reg            core2_hash_valid_reg;
  reg            repeat_iteration_flag;
  reg            repeat_iteration_flag_reg;
  reg  [31:0]    nonce_next;

  reg [255:0] midstate_buf_reg; 
  reg [95:0] data_buf_reg;
  reg [31:0]golden_nonce=32'd0;
  reg golden_nonce_valid_net=1'b0;
  reg is_golden_ticket;
  reg is_golden_ticket_reg;
  reg [2:0] core_loop_status;
  reg [2:0] core_loop_status_reg;

  // `ifdef SIM
    // $display("-- bitcoin hashing core started --");
  // `endif

  //----------------------------------------------------------------
  // sha256 first core for generating hash for first 512 bit input
  //----------------------------------------------------------------
  sha_math_core core1(
                  .clk(tb_clk),
                  .reset_n(reset_n),

                  .first_state(tb_init1),
                  .initial_state(tb_state_ip1),   
                  .message_block(tb_block1),

                  .status(core1_ready),

                  .hash(core1_hash),
                  .valid_block(core1_hash_valid)
                 );
  sha_math_core core2(
                  .clk(tb_clk),
                  .reset_n(reset_n),

                  .first_state(tb_init2),
                  .initial_state(tb_state_ip2),   
                  .message_block(tb_block2),

                  .status(core2_ready),

                  .hash(core2_hash),
                  .valid_block(core2_hash_valid)
                 );

  //----------------------------------------------------------------
  // reset()
  //
  // Initialize all counters and testbed functionality as well
  // as setting the DUT inputs to defined values.
  //----------------------------------------------------------------
  always @ (posedge tb_clk or negedge reset_n)
  begin:initialize_cores
    if (!reset_n)
      begin
        is_golden_ticket_reg      <= 0;
        repeat_iteration_flag_reg <= 1'b0;
        core1_ready_reg           <= 1'b0;
        core2_ready_reg           <= 1'b0;
        core1_hash_valid_reg      <= 1'b0;
        core2_hash_valid_reg      <= 1'b0;
        golden_nonce_out          <= 32'd0;
        golden_nonce_valid        <= 1'b0;
      end
    else
      begin
        core1_ready_reg            <= core1_ready;
        core2_ready_reg            <= core2_ready;
        is_golden_ticket_reg       <= is_golden_ticket;
        core_loop_status_reg       <= core_loop_status;
        midstate_buf_reg           <= midstate_buf;
        data_buf_reg               <= data_buf;
        repeat_iteration_flag_reg  <= repeat_iteration_flag;
        core1_hash_valid_reg       <= core1_hash_valid;
        core2_hash_valid_reg       <= core2_hash_valid;
        golden_nonce_out           <= golden_nonce;
        golden_nonce_valid         <= golden_nonce_valid_net;
        if (core1_hash_valid)
          	core1_hash_reg         <= core1_hash;
 
        if (core2_hash_valid)
          	core2_hash_reg         <= core2_hash;
    end
  end //initialize_cores



always @(posedge tb_clk )
begin 
if (reset_n == 1'b1)	 
  begin : fsm_logic_flow
	case (core_loop_status_reg)
      idle_state:
        begin
          if (core1_ready_reg)
            begin
              nonce_next[31:0] = repeat_iteration_flag_reg ? nonce_next[31:0] : nonce[31:0];
              is_golden_ticket = 1'b0;
              tb_init1         = 1'b1;
              tb_state_ip1     = midstate_buf_reg;
              tb_block1        = {384'h00000280_00000000000000000000000000000000000000000000000000000000000000000000000000000000_80000000, nonce_next[31:0], data_buf_reg[95:0]};
              core_loop_status = core1_iteration_done;
            end
        end
      core1_iteration_done:
        begin
          if (core1_hash_valid_reg)
            begin
              is_golden_ticket      = 1'b0; 
              tb_init1              = 1'b0;
              repeat_iteration_flag = 1'b0;
              if (core2_ready_reg)
                begin
                  core_loop_status = core2_iteration;
                  tb_block2        = ({256'h0000010000000000000000000000000000000000000000000000000080000000, core1_hash_reg});
                  tb_init2         = 1'b1;
                  tb_state_ip2     = 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667;
                end
            end
        end
      core2_iteration:
        begin
          if (core2_hash_valid_reg)   
            begin
              // Check to see if the last hash generated is valid.
              tb_init2         = 1'b0;
              is_golden_ticket = (core2_hash_reg[255:248] == 8'h00);
              core_loop_status = golden_ticket_check;
            end  
        end
      golden_ticket_check:
        begin
          if(is_golden_ticket_reg)
            begin
              golden_nonce          = nonce_next;
              golden_nonce_valid_net= is_golden_ticket_reg;
              is_golden_ticket      = 1'b0;
              repeat_iteration_flag = 1'b0;
              core_loop_status      = exit_iteration;
            end
          else
            begin  
              core_loop_status      = idle_state;
              nonce_next            = nonce_next + 1'd1;
              repeat_iteration_flag = 1'b1;
            end
        end
      exit_iteration:
        begin
          tb_init1              = 1'b0;
          tb_init2              = 1'b0;
          repeat_iteration_flag = 1'b0;
        end
      default:
        begin
          tb_init1              = 1'b0;
          tb_init2              = 1'b0;
          repeat_iteration_flag = 1'b0;
          is_golden_ticket      = 1'b0;
          core_loop_status      = idle_state;
        end
    endcase 

  end
end

endmodule // sha_math_tb


