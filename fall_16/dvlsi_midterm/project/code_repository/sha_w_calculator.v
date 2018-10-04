//################################################################################################################
//Project  : Bitcoin Hashing
//Course   : ECE6710 FALL 2016
//Group    : 5710_12
//Author(s): Vikas Rao, Yomi Karthik Rupesh, Rajath Bindigan, Sreejita Saha
//Module   : sha-256 w value calculator
//description: this module performs SHA-256 expansion stage. It takes in a 512 bit message block and expands it into
//             64-32 bit words. It computes the w value for 64 iterations.
//             For the first 16 iterations w words are the same as the 16 32-bit blocks of the 512-bit message block
//             For the rest 48 iterations w value is calculated using rotating and shifting functions on 
//             previously computed w values 
//			   All the operations are on 32 bit Dword registers.
//################################################################################################################


module sha_w_calculator(
                    input wire           clock,
                    input wire           n_reset,
                    input wire [511 : 0] message_block,
                    input wire           w_initial,
                    input wire           w_next,
                    output wire [31 : 0] w_output_value
                   );

 
  //-------------------------------------------------------------------------------------------------------------
  //Parameter definitions
  //-------------------------------------------------------------------------------------------------------------
  parameter value_idle_count   = 0;
  parameter update_idle_count  = 1;


  //-------------------------------------------------------------------------------------------------------------
  //Registers
  //-------------------------------------------------------------------------------------------------------------
  reg [31 : 0] w_value_array [0 : 15];
  reg [31 : 0] w_slot0;
  reg [31 : 0] w_slot1;
  reg [31 : 0] w_slot2;
  reg [31 : 0] w_slot3;
  reg [31 : 0] w_slot4;
  reg [31 : 0] w_slot5;
  reg [31 : 0] w_slot6;
  reg [31 : 0] w_slot7;
  reg [31 : 0] w_slot8;
  reg [31 : 0] w_slot9;
  reg [31 : 0] w_slot10;
  reg [31 : 0] w_slot11;
  reg [31 : 0] w_slot12;
  reg [31 : 0] w_slot13;
  reg [31 : 0] w_slot14;
  reg [31 : 0] w_slot15;
  reg          w_temp_update;

  reg [5 : 0] reg_w;
  reg [5 : 0] new_w;
  reg         update_w_all;
  reg         increment_w;
  reg         reset_w;

  reg [1 : 0]  reg_control;
  reg [1 : 0]  new_control_w;
  reg          all_control_w;
  reg [31 : 0] temp_slot;
  reg [31 : 0] new_slot;

  assign w_output_value = temp_slot;


  //-------------------------------------------------------------------------------------------------------------
  //Register update. Registers are positive edge triggered with synchronous active low resets
  //-------------------------------------------------------------------------------------------------------------
  always @ (posedge clock or negedge n_reset)
    begin : update_loop_begin
      if (!n_reset)
        begin
          w_value_array[00]             <= 32'h0;
          w_value_array[01]             <= 32'h0;
          w_value_array[02]             <= 32'h0;
          w_value_array[03]             <= 32'h0;
          w_value_array[04]             <= 32'h0;
          w_value_array[05]             <= 32'h0;
          w_value_array[06]             <= 32'h0;
          w_value_array[07]             <= 32'h0;
          w_value_array[08]             <= 32'h0;
          w_value_array[09]             <= 32'h0;
          w_value_array[10]             <= 32'h0;
          w_value_array[11]             <= 32'h0;
          w_value_array[12]             <= 32'h0;
          w_value_array[13]             <= 32'h0;
          w_value_array[14]             <= 32'h0;
          w_value_array[15]             <= 32'h0;
          reg_w             <= 6'h00;
          reg_control <= value_idle_count;
        end
      else
        begin
          if (w_temp_update)
            begin
              w_value_array[00] <= w_slot0;
              w_value_array[01] <= w_slot1;
              w_value_array[02] <= w_slot2;
              w_value_array[03] <= w_slot3;
              w_value_array[04] <= w_slot4;
              w_value_array[05] <= w_slot5;
              w_value_array[06] <= w_slot6;
              w_value_array[07] <= w_slot7;
              w_value_array[08] <= w_slot8;
              w_value_array[09] <= w_slot9;
              w_value_array[10] <= w_slot10;
              w_value_array[11] <= w_slot11;
              w_value_array[12] <= w_slot12;
              w_value_array[13] <= w_slot13;
              w_value_array[14] <= w_slot14;
              w_value_array[15] <= w_slot15;
            end

          if (update_w_all)
            reg_w <= new_w;

          if (all_control_w)
            reg_control <= new_control_w;
        end
    end//update_loop_begin


  //-------------------------------------------------------------------------------------------------------------
  //w schedule address counter depending on the state of expander
  //-------------------------------------------------------------------------------------------------------------

  always @*
    begin : w_control_set_begin
      new_w = 0;
      update_w_all  = 0;

      if (reset_w)
        begin
          new_w = 6'h00;
          update_w_all  = 1;
        end

      if (increment_w)
        begin
          new_w = reg_w + 6'h01;
          update_w_all  = 1;
        end
    end // w_control_set_begin


  //-------------------------------------------------------------------------------------------------------------
  //w schedule FSM logic
  //-------------------------------------------------------------------------------------------------------------
  always @*
    begin : fsm_control_begin
      reset_w = 0;
      increment_w = 0;

      new_control_w = value_idle_count;
      all_control_w  = 0;

      case (reg_control)
        value_idle_count:
          begin
            if (w_initial)
              begin
                reset_w             = 1;
                new_control_w = update_idle_count;
                all_control_w  = 1;
              end
          end

        update_idle_count:
          begin
            if (w_next)
              begin
                increment_w = 1;
              end

            if (reg_w == 6'h3f)
              begin
                new_control_w = value_idle_count;
                all_control_w  = 1;
              end
          end
      endcase 
    end // fsm_control_begin

  //-------------------------------------------------------------------------------------------------------------
  //selects the w value for ith iteration for 64 iterations
  //-------------------------------------------------------------------------------------------------------------
  always @*
    begin : w_slot_selection_begin
      if (reg_w < 16)
        begin
          temp_slot = w_value_array[reg_w[3 : 0]];
        end
      else
        begin
          temp_slot = new_slot;
        end
    end // w_slot_selection_begin


  //-------------------------------------------------------------------------------------------------------------
  //Calculate the w value using rotation and shifting operations depending on the value of i for every ith
  //iteration for 64 iterations
  //-------------------------------------------------------------------------------------------------------------
  always @*
    begin : w_slot_update_begin
      reg [31 : 0] w_0;
      reg [31 : 0] w_1;
      reg [31 : 0] w_9;
      reg [31 : 0] w_14;
      reg [31 : 0] d0;
      reg [31 : 0] d1;

      w_slot0 = 32'h0;
      w_slot1 = 32'h0;
      w_slot2 = 32'h0;
      w_slot3 = 32'h0;
      w_slot4 = 32'h0;
      w_slot5 = 32'h0;
      w_slot6 = 32'h0;
      w_slot7 = 32'h0;
      w_slot8 = 32'h0;
      w_slot9 = 32'h0;
      w_slot10 = 32'h0;
      w_slot11 = 32'h0;
      w_slot12 = 32'h0;
      w_slot13 = 32'h0;
      w_slot14 = 32'h0;
      w_slot15 = 32'h0;
      w_temp_update    = 0;

      w_0  = w_value_array[0];
      w_1  = w_value_array[1];
      w_9  = w_value_array[9];
      w_14 = w_value_array[14];

      d0 = {w_1[6  : 0], w_1[31 :  7]} ^
           {w_1[17 : 0], w_1[31 : 18]} ^
           {3'b000, w_1[31 : 3]};

      d1 = {w_14[16 : 0], w_14[31 : 17]} ^
           {w_14[18 : 0], w_14[31 : 19]} ^
           {10'b0000000000, w_14[31 : 10]};

      new_slot = d1 + w_9 + d0 + w_0;

      if (w_initial)
        begin
          w_slot0 = message_block[511 : 480];
          w_slot1 = message_block[479 : 448];
          w_slot2 = message_block[447 : 416];
          w_slot3 = message_block[415 : 384];
          w_slot4 = message_block[383 : 352];
          w_slot5 = message_block[351 : 320];
          w_slot6 = message_block[319 : 288];
          w_slot7 = message_block[287 : 256];
          w_slot8 = message_block[255 : 224];
          w_slot9 = message_block[223 : 192];
          w_slot10 = message_block[191 : 160];
          w_slot11 = message_block[159 : 128];
          w_slot12 = message_block[127 :  96];
          w_slot13 = message_block[95  :  64];
          w_slot14 = message_block[63  :  32];
          w_slot15 = message_block[31  :   0];
          w_temp_update    = 1;
        end
      else if (reg_w > 15)
        begin
          w_slot0 = w_value_array[01];
          w_slot1 = w_value_array[02];
          w_slot2 = w_value_array[03];
          w_slot3 = w_value_array[04];
          w_slot4 = w_value_array[05];
          w_slot5 = w_value_array[06];
          w_slot6 = w_value_array[07];
          w_slot7 = w_value_array[08];
          w_slot8 = w_value_array[09];
          w_slot9 = w_value_array[10];
          w_slot10 = w_value_array[11];
          w_slot11 = w_value_array[12];
          w_slot12 = w_value_array[13];
          w_slot13 = w_value_array[14];
          w_slot14 = w_value_array[15];
          w_slot15 = new_slot;
          w_temp_update    = 1;
        end
    end //w_slot_update_ begin

endmodule 
