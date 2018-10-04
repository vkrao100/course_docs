//################################################################################################################
//Project  : Bitcoin Hashing
//Course   : ECE6710 FALL 2016
//Group    : 5710_12
//Author(s): Vikas Rao, Yomi Karthik Rupesh, Rajath Bindigan, Sreejita Saha
//Module   : sha 256 math operations
//description: this module performs the core math operations of the SHA-256, which include shiting,
//			 rotation, xor, choose, majority, and mod 32 addition. We will be using finite state machine 
//			 model for flow control structure.
//			 All the operations are on 32 bit Dword registers.
//################################################################################################################

module sha_math_core(
                   input wire            clk,
                   input wire            reset_n,

                   input wire            first_state,
                   input wire [511 : 0]  message_block,
                   input wire [255 : 0]  initial_state,

                   output wire           status,
                   output wire [255 : 0] hash,
                   output wire           valid_block
                  );
  //--------------------------------------------------------------------------------------------------------------
  //parameter definitions
  //-------------------------------------------------------------------------------------------------------------
  parameter total_iterations = 63;

  parameter idle_state_control   = 0;
  parameter total_rounds_control = 1;
  parameter completetion_control   = 2;
  //-------------------------------------------------------------------------------------------------------------
  //Registers and wires
  //-------------------------------------------------------------------------------------------------------------
  reg [31 : 0] a_present;
  reg [31 : 0] a_latest;
  reg [31 : 0] b_present;
  reg [31 : 0] b_latest;
  reg [31 : 0] c_present;
  reg [31 : 0] c_latest;
  reg [31 : 0] d_present;
  reg [31 : 0] d_latest;
  reg [31 : 0] e_present;
  reg [31 : 0] e_latest;
  reg [31 : 0] f_present;
  reg [31 : 0] f_latest;
  reg [31 : 0] g_present;
  reg [31 : 0] g_latest;
  reg [31 : 0] h_present;
  reg [31 : 0] h_latest;
  reg          a_update_h_w;

  reg [31 : 0] present_H0;
  reg [31 : 0] latest_H0;
  reg [31 : 0] present_H1;
  reg [31 : 0] latest_H1;
  reg [31 : 0] present_H2;
  reg [31 : 0] latest_H2;
  reg [31 : 0] present_H3;
  reg [31 : 0] latest_H3;
  reg [31 : 0] present_H4;
  reg [31 : 0] latest_H4;
  reg [31 : 0] present_H5;
  reg [31 : 0] latest_H5;
  reg [31 : 0] present_H6;
  reg [31 : 0] latest_H6;
  reg [31 : 0] present_H7;
  reg [31 : 0] latest_H7;
  reg          update_h;

  reg [5 : 0] control_register;
  reg [5 : 0] control_latest;
  reg         control_w_update;
  reg         control_increment;
  reg         control_reset;

  reg register_valid;	
  reg new_reg_valid;
  reg new_w_valid;

  reg [1 : 0] reg_256_cnt;
  reg [1 : 0] reg_256_new;
  reg         w_cnt_256;

  reg initializer_dig;
  reg latest_dig;

  reg initial_status;
  reg update_status;

  reg block_primary;

  reg status_flag;

  reg [31 : 0] t1_value;
  reg [31 : 0] t2_value;

  wire [31 : 0] k_value;

  reg           initial_w_value;
  reg           next_w;
  wire [31 : 0] data_w_value;
  //-------------------------------------------------------------------------------------------------------------
  //Calculates the k value for every ith iteration for i=0 to i=63
  // k are 64 32-bit constants which are initialized to
  //the first 32 bits of the fractional parts of the cube roots of the
  //first 64 prime numbers
  //-------------------------------------------------------------------------------------------------------------

  k_calculator constant_k_call(
                                      .address_input(control_register),
                                      .output_k(k_value)
                                     );

  //-------------------------------------------------------------------------------------------------------------
  //calculates w value for every ith iteration for i=0 to i=63
  //w values are the outputs of the expansion stage of SHA-256 algorithm
  //-------------------------------------------------------------------------------------------------------------
  sha_w_calculator w_value_calculator(
                          .clock(clk),
                          .n_reset(reset_n),

                          .message_block(message_block),

                          .w_initial(initial_w_value),
                          .w_next(next_w),
                          .w_output_value(data_w_value)
                         );
  //-------------------------------------------------------------------------------------------------------------
  //Intermediate hash and status flag nets
  //-------------------------------------------------------------------------------------------------------------

  assign status = status_flag;

  assign hash = {present_H0, present_H1, present_H2, present_H3,
                   present_H4, present_H5, present_H6, present_H7};

  assign valid_block = register_valid;

  //-------------------------------------------------------------------------------------------------------------
  //Register update. All registers are positive edge triggered with synchronous active low reset
  //-------------------------------------------------------------------------------------------------------------

  always @ (posedge clk or negedge reset_n)
    begin : update_begins
      if (!reset_n)
        begin
          a_present            <= 32'h0;
          b_present            <= 32'h0;
          c_present            <= 32'h0;
          d_present            <= 32'h0;
          e_present            <= 32'h0;
          f_present            <= 32'h0;
          g_present            <= 32'h0;
          h_present            <= 32'h0;
          present_H0           <= 32'h0;
          present_H1           <= 32'h0;
          present_H2           <= 32'h0;
          present_H3           <= 32'h0;
          present_H4           <= 32'h0;
          present_H5           <= 32'h0;
          present_H6           <= 32'h0;
          present_H7           <= 32'h0;
          register_valid       <= 0;
          control_register     <= 6'h0;
          reg_256_cnt          <= idle_state_control;
        end
      else
        begin

          if (a_update_h_w)
            begin
              a_present <= a_latest;
              b_present <= b_latest;
              c_present <= c_latest;
              d_present <= d_latest;
              e_present <= e_latest;
              f_present <= f_latest;
              g_present <= g_latest;
              h_present <= h_latest;
            end

          if (update_h)
            begin
              present_H0 <= latest_H0;
              present_H1 <= latest_H1;
              present_H2 <= latest_H2;
              present_H3 <= latest_H3;
              present_H4 <= latest_H4;
              present_H5 <= latest_H5;
              present_H6 <= latest_H6;
              present_H7 <= latest_H7;
            end

          if (control_w_update)
            control_register <= control_latest;

          if (new_w_valid)
            register_valid   <= new_reg_valid;

          if (w_cnt_256)
            reg_256_cnt      <= reg_256_new;
        end
    end//update_begins

  //-------------------------------------------------------------------------------------------------------------
  //Calculates the T1 function for SHA-256 compression stage using previous H values, summation_1,
  //choosing function,k constants and w values 
  //-------------------------------------------------------------------------------------------------------------

  always @*
    begin : t1_logic_begin
      reg [31 : 0] summation_one;
      reg [31 : 0] choose_calc;

      summation_one = {e_present[5  : 0], e_present[31 :  6]} ^
             {e_present[10 : 0], e_present[31 : 11]} ^
             {e_present[24 : 0], e_present[31 : 25]};

      choose_calc = (e_present & f_present) ^ ((~e_present) & g_present);

      t1_value = h_present + summation_one + choose_calc + data_w_value + k_value;
    end//t1_logic_begin

  //-------------------------------------------------------------------------------------------------------------
  //Calculates the T2 function for SHA-256 compression stage using summation_1 and majority function
  //-------------------------------------------------------------------------------------------------------------

  always @*
    begin : t2_logic_begin
      reg [31 : 0] summation_zero;
      reg [31 : 0] majority_calc;

      summation_zero = {a_present[1  : 0], a_present[31 :  2]} ^
             		   {a_present[12 : 0], a_present[31 : 13]} ^
             		   {a_present[21 : 0], a_present[31 : 22]};

	  majority_calc  = (a_present & b_present) ^ 
      				  (a_present & c_present) ^ 
      				  (b_present & c_present);
      t2_value       = summation_zero + majority_calc;
    end//t2_logic begin 

  //-------------------------------------------------------------------------------------------------------------
  //Intermediate hash value update logic for every ith iteration for 64 iterations
  //-------------------------------------------------------------------------------------------------------------
  always @*
    begin : digest_logic
      latest_H0 = 32'h0;
      latest_H1 = 32'h0;
      latest_H2 = 32'h0;
      latest_H3 = 32'h0;
      latest_H4 = 32'h0;
      latest_H5 = 32'h0;
      latest_H6 = 32'h0;
      latest_H7 = 32'h0;
      update_h = 0;

      if (initializer_dig)
        begin
          update_h = 1;
          latest_H0 = initial_state[31:0]; 
          latest_H1 = initial_state[63:32];
          latest_H2 = initial_state[95:64];
          latest_H3 = initial_state[127:96];
          latest_H4 = initial_state[159:128];
          latest_H5 = initial_state[191:160];
          latest_H6 = initial_state[223:192];
          latest_H7 = initial_state[255:224];
        end

      if (latest_dig)
        begin
          latest_H0 = present_H0 + a_present;
          latest_H1 = present_H1 + b_present;
          latest_H2 = present_H2 + c_present;
          latest_H3 = present_H3 + d_present;
          latest_H4 = present_H4 + e_present;
          latest_H5 = present_H5 + f_present;
          latest_H6 = present_H6 + g_present;
          latest_H7 = present_H7 + h_present;
          update_h = 1;
        end
    end//digest_logic 
  
  //-------------------------------------------------------------------------------------------------------------
  //Updates the value of A, B, C, D, E, F, G, H every ith iteration for 64 iterations
  //-------------------------------------------------------------------------------------------------------------
  always @*
    begin : logical_state_begin
      a_latest  = 32'h0;
      b_latest  = 32'h0;
      c_latest  = 32'h0;
      d_latest  = 32'h0;
      e_latest  = 32'h0;
      f_latest  = 32'h0;
      g_latest  = 32'h0;
      h_latest  = 32'h0;
      a_update_h_w = 0;

      if (initial_status)
        begin
          a_update_h_w = 1;
          if (block_primary)
            begin          
              a_latest  =  initial_state[31:0];
              b_latest  =  initial_state[63:32];
              c_latest  =  initial_state[95:64];
              d_latest  =  initial_state[127:96];
              e_latest  =  initial_state[159:128];
              f_latest  =  initial_state[191:160];
              g_latest  =  initial_state[223:192];
              h_latest  =  initial_state[255:224];
            end
          else
            begin
              a_latest  = present_H0;
              b_latest  = present_H1;
              c_latest  = present_H2;
              d_latest  = present_H3;
              e_latest  = present_H4;
              f_latest  = present_H5;
              g_latest  = present_H6;
              h_latest  = present_H7;
            end
        end

      if (update_status)
        begin
          a_latest  = t1_value + t2_value;
          b_latest  = a_present;
          c_latest  = b_present;
          d_latest  = c_present;
          e_latest  = d_present + t1_value;
          f_latest  = e_present;
          g_latest  = f_present;
          h_latest  = g_present;
          a_update_h_w = 1;
        end
    end //logical_state_begin


  //-------------------------------------------------------------------------------------------------------------
  //w schedule address counter
  //-------------------------------------------------------------------------------------------------------------
  always @*
    begin : controller_t_begin
      control_latest     = 0;
      control_w_update   = 0;

      if (control_reset)
        begin
          control_latest    = 0;
          control_w_update  = 1;
        end

      if (control_increment)
        begin
          control_latest    = control_register + 1'b1;
          control_w_update  = 1;
        end
    end //controller_t_begin


  //-------------------------------------------------------------------------------------------------------------
  //sha-256 fsm logic
  //-------------------------------------------------------------------------------------------------------------
  always @*
    begin : fsm_begin
      initializer_dig   = 0;
      latest_dig    		= 0;
      initial_status    = 0;
      update_status     = 0;
      block_primary   	= 0;
      status_flag     	= 0;
      initial_w_value   = 0;
      next_w           	= 0;
      control_increment = 0;
      control_reset     = 0;
      new_reg_valid 		= 0;
      new_w_valid  			= 0;
      reg_256_new 			= idle_state_control;
      w_cnt_256   			= 0;
					  

      case (reg_256_cnt)
        idle_state_control:
          begin
            status_flag = 1;

            if (first_state)
              begin
                initializer_dig  = 1;
                initial_w_value  = 1;
                initial_status   = 1;
                block_primary    = 1;
                control_reset    = 1;
                new_reg_valid		 = 0;
                new_w_valid  		 = 1;
                reg_256_new  		 = total_rounds_control;
                w_cnt_256  			 = 1;
              end
          end


        total_rounds_control:
          begin
            next_w      		  = 1;
            update_status		  = 1;
            control_increment = 1;

            if (control_register == total_iterations)
              begin
                reg_256_new 	= completetion_control;
                w_cnt_256   	= 1;
              end
          end


        completetion_control:
          begin
            latest_dig     = 1;
            new_reg_valid  = 1;
            new_w_valid    = 1;
            reg_256_new    = idle_state_control;
            w_cnt_256      = 1;
          end
      endcase 
    end//fsm_begin 
endmodule 
