//======================================================================
//
// module - sha256_math_tb.v
// ----------------
// Testbench for the SHA-256 math operations core
//
//
//
//======================================================================

`timescale 1ns/1ps

module sha_math_tb();

  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  parameter CLK_HALF_PERIOD = 2;
  parameter CLK_PERIOD = 2 * CLK_HALF_PERIOD;


  //----------------------------------------------------------------
  // Register and Wire declarations.
  //----------------------------------------------------------------
  reg [31 : 0] cycle_ctr;
  reg [31 : 0] error_ctr;
  reg [31 : 0] tc_ctr;

  reg            tb_clk;
  reg            tb_reset_n;
  reg            tb_init;
  reg            tb_next;
  reg [511 : 0]  tb_block;
  reg [255 : 0]  tb_state_ip;
  wire           tb_ready;
  wire [255 : 0] tb_digest;
  wire           tb_digest_valid;


  //----------------------------------------------------------------
  // sha256 first core for generating hash for first 512 bit input
  //----------------------------------------------------------------
  sha_math_core core1(
                  .clk(tb_clk),
                  .reset_n(tb_reset_n),

                  .init(tb_init),
                  .next(tb_next),
                  .init_state(tb_state_ip),   
                  .block(tb_block),

                  .ready(tb_ready),

                  .digest(tb_digest),
                  .digest_valid(tb_digest_valid)
                 );


  //----------------------------------------------------------------
  // clk_gen
  //
  // Always running clock generator process.
  //----------------------------------------------------------------
  always
    begin : clk_gen
      #CLK_HALF_PERIOD;
      tb_clk = !tb_clk;
    end // clk_gen

  //----------------------------------------------------------------
  // dump_dut_state()
  //
  // Dump the state of the dump when needed.
  //----------------------------------------------------------------
  task dump_dut_state;
    begin
      $display("State of DUT");
      $display("------------");
      $display("Inputs and outputs:");
      $display("init   = 0x%01x, next  = 0x%01x",
               core1.init, core1.next);
      $display("block  = 0x%0128x", core1.block);

      $display("ready  = 0x%01x, valid = 0x%01x",
               core1.ready, core1.digest_valid);
      $display("digest = 0x%064x", core1.digest);
      $display("H0_reg = 0x%08x, H1_reg = 0x%08x, H2_reg = 0x%08x, H3_reg = 0x%08x",
               core1.H0_reg, core1.H1_reg, core1.H2_reg, core1.H3_reg);
      $display("H4_reg = 0x%08x, H5_reg = 0x%08x, H6_reg = 0x%08x, H7_reg = 0x%08x",
               core1.H4_reg, core1.H5_reg, core1.H6_reg, core1.H7_reg);
      $display("");

      $display("Control signals and counter:");
      $display("sha256_ctrl_reg = 0x%02x", core1.sha256_ctrl_reg);
      $display("digest_init     = 0x%01x, digest_update = 0x%01x",
               core1.digest_init, core1.digest_update);
      $display("state_init      = 0x%01x, state_update  = 0x%01x",
               core1.state_init, core1.state_update);
      $display("first_block     = 0x%01x, ready_flag    = 0x%01x, w_init    = 0x%01x",
               core1.first_block, core1.ready_flag, core1.w_init);
      $display("t_ctr_inc       = 0x%01x, t_ctr_rst     = 0x%01x, t_ctr_reg = 0x%02x",
               core1.t_ctr_inc, core1.t_ctr_rst, core1.t_ctr_reg);
      $display("");

      $display("State registers:");
      $display("a_reg = 0x%08x, b_reg = 0x%08x, c_reg = 0x%08x, d_reg = 0x%08x",
               core1.a_reg, core1.b_reg, core1.c_reg, core1.d_reg);
      $display("e_reg = 0x%08x, f_reg = 0x%08x, g_reg = 0x%08x, h_reg = 0x%08x",
               core1.e_reg, core1.f_reg, core1.g_reg, core1.h_reg);
      $display("");
      $display("a_new = 0x%08x, b_new = 0x%08x, c_new = 0x%08x, d_new = 0x%08x",
               core1.a_new, core1.b_new, core1.c_new, core1.d_new);
      $display("e_new = 0x%08x, f_new = 0x%08x, g_new = 0x%08x, h_new = 0x%08x",
               core1.e_new, core1.f_new, core1.g_new, core1.h_new);
      $display("");

      $display("State update values:");
      $display("w  = 0x%08x, k  = 0x%08x", core1.w_data, core1.k_data);
      $display("t1 = 0x%08x, t2 = 0x%08x", core1.t1, core1.t2);
      $display("");
    end
  endtask // dump_dut_state


  //----------------------------------------------------------------
  // reset_dut()
  //
  // Toggle reset to put the DUT into a well known state.
  //----------------------------------------------------------------
  task reset_dut;
    begin
      $display("*** Toggle reset.");
      tb_reset_n = 0;
      #(4 * CLK_HALF_PERIOD);
      tb_reset_n = 1;
    end
  endtask // reset_dut


  //----------------------------------------------------------------
  // init_sim()
  //
  // Initialize all counters and testbed functionality as well
  // as setting the DUT inputs to defined values.
  //----------------------------------------------------------------
  task init_sim;
    begin
      cycle_ctr = 0;
      error_ctr = 0;
      tc_ctr = 0;

      tb_clk = 0;
      tb_reset_n = 1;

      tb_init = 0;
      tb_next = 0;
      tb_state_ip = 256'h000000000000000000000000000000000000000000000000000000000000000;
      tb_block = 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    end
  endtask // init_dut


  //----------------------------------------------------------------
  // display_test_result()
  //
  // Display the accumulated test results.
  //----------------------------------------------------------------
  task display_test_result;
    begin
      if (error_ctr == 0)
        begin
          $display("*** All %02d test cases completed successfully", tc_ctr);
        end
      else
        begin
          $display("*** %02d test cases did not complete successfully.", error_ctr);
        end
    end
  endtask // display_test_result


  //----------------------------------------------------------------
  // wait_ready()
  //
  // Wait for the ready flag in the dut to be set.
  //
  // Note: It is the callers responsibility to call the function
  // when the dut is actively processing and will in fact at some
  // point set the flag.
  //----------------------------------------------------------------
  task wait_ready;
    begin
      while (!tb_ready)
        begin
          #(CLK_PERIOD);
        end
    end
  endtask // wait_ready


  //----------------------------------------------------------------
  // single_block_core_test()
  //
  // Run a test case spanning a single data block.
  //----------------------------------------------------------------
  task single_block_test(input [7 : 0]   tc_number,
                         input [511 : 0] block,
                         input [255 : 0] state_ip,
                         input [255 : 0] expected);
   begin
     $display("*** TC %0d single block test case started.", tc_number);
     tc_ctr = tc_ctr + 1;
     tb_state_ip = state_ip;
     tb_block = block;
     tb_init = 1;
     #(CLK_PERIOD);
     wait_ready();


     if (tb_digest == expected)
       begin
         $display("*** TC %0d successful.", tc_number);
         $display("");
       end
     else
       begin
         $display("*** ERROR: TC %0d NOT successful.", tc_number);
         $display("Expected: 0x%064x", expected);
         $display("Got:      0x%064x", tb_digest);
         $display("");

         error_ctr = error_ctr + 1;
       end
   end
  endtask // single_block_test


  //----------------------------------------------------------------
  // double_block_test()
  //
  // Run a test case spanning two data blocks. We check both
  // intermediate and final digest.
  //----------------------------------------------------------------
  task double_block_test(input [7 : 0]   tc_number,
                         input [511 : 0] block1,
                         // input [255 : 0] state1,
                         input [255 : 0] expected1,
                         input [511 : 0] block2,
                         // input [255 : 0] state22,
                         input [255 : 0] expected2);

     reg [255 : 0] db_digest1;
     reg [255 : 0] db_digest2;
     reg           db_error;
   begin
     $display("*** TC %0d double block test case started.", tc_number);
     db_error = 0;
     tc_ctr = tc_ctr + 1;

     $display("*** TC %0d first block started.", tc_number);
     // tb_state_ip = state1;
     tb_block = block1;
     tb_init = 1;
     #(CLK_PERIOD);
     tb_init = 0;
     wait_ready();
     db_digest1 = tb_digest;
     $display("*** TC %0d first block done.", tc_number);

     $display("*** TC %0d second block started.", tc_number);
     // tb_state_ip = state2;
     tb_block = block2;
     tb_next = 1;
     #(CLK_PERIOD);
     tb_next = 0;
     wait_ready();
     db_digest2 = tb_digest;
     $display("*** TC %0d second block done.", tc_number);

     if (DEBUG)
       begin
         $display("Generated digests:");
         $display("Expected 1: 0x%064x", expected1);
         $display("Got      1: 0x%064x", db_digest1);
         $display("Expected 2: 0x%064x", expected2);
         $display("Got      2: 0x%064x", db_digest2);
         $display("");
       end

     if (db_digest1 == expected1)
       begin
         $display("*** TC %0d first block successful", tc_number);
         $display("");
       end
     else
       begin
         $display("*** ERROR: TC %0d first block NOT successful", tc_number);
         $display("Expected: 0x%064x", expected1);
         $display("Got:      0x%064x", db_digest1);
         $display("");
         db_error = 1;
       end

     if (db_digest2 == expected2)
       begin
         $display("*** TC %0d second block successful", tc_number);
         $display("");
       end
     else
       begin
         $display("*** ERROR: TC %0d second block NOT successful", tc_number);
         $display("Expected: 0x%064x", expected2);
         $display("Got:      0x%064x", db_digest2);
         $display("");
         db_error = 1;
       end

     if (db_error)
       begin
         error_ctr = error_ctr + 1;
       end
   end
  endtask // single_block_test


  //----------------------------------------------------------------
  // sha_math_core
  // main math core testing functionality.
  //
  //----------------------------------------------------------------
  initial
    begin : sha256_math_core_test
      reg [511 : 0] tc1;
      reg [511 : 0] st1;
      reg [255 : 0] res1;

      reg [511 : 0] tc2_1;
      reg [255 : 0] res2_1;
      // reg [255 : 0] st2_1;
      reg [511 : 0] tc2_2;
      reg [255 : 0] res2_2;
      // reg [255 : 0] st2_2;

      $display("   -- Testbench for sha256 core started --");

      init_sim();
      dump_dut_state();
      reset_dut();
      dump_dut_state();

      // TC1: Single block message: "abc".
      tc1 = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
      st1 = 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667;
      res1 = 256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD;
      single_block_test(1, tc1, st1, res1);

      // TC2: Double block message.
      // "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
      // tc2_1 = 512'h6162636462636465636465666465666765666768666768696768696A68696A6B696A6B6C6A6B6C6D6B6C6D6E6C6D6E6F6D6E6F706E6F70718000000000000000;
      // res2_1 = 256'h85E655D6417A17953363376A624CDE5C76E09589CAC5F811CC4B32C1F20E533A;

      // tc2_2 = 512'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001C0;
      // res2_2 = 256'h248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1;
      // double_block_test(2, tc2_1, res2_1, tc2_2, res2_2);

      display_test_result();
      $display("*** Simulation done.");
      $finish;
    end // sha_math_core
endmodule // sha_math_tb

//======================================================================
// EOF sha_math_tb.v
//======================================================================
