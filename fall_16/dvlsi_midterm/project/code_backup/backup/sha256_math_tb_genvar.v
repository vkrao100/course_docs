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

module sha256_math_tb();

  parameter CLK_HALF_PERIOD = 2;
  parameter CLK_PERIOD = 2 * CLK_HALF_PERIOD;
  parameter [5:0] ITERATOR = 6'd1;

  //----------------------------------------------------------------
  // Register and Wire declarations.
  //----------------------------------------------------------------
  reg            tb_clk;
  reg            tb_reset_n;
  reg [511 : 0]  test_block;
  reg  [255 : 0] ip_state;
  wire [255 : 0] op_hash;
  reg  [5:0]     cnt;
  reg            feeder;

  //----------------------------------------------------------------
  // Device Under Test.
  //----------------------------------------------------------------
  SHAcore #(.ITERATIONS(ITERATOR)) math_core1(
                     .clk(tb_clk),
                     .feeder(feeder),
                     .count_value(cnt),//6'd
                     .state_input(ip_state),//256 bit state
                     .message_block(test_block),//512 bit input
                     .output_hash(op_hash) // 256 bit hash
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
  // reset_dut()
  //
  // Toggle reset to put the DUT into a well known state.
  //----------------------------------------------------------------
  task reset_dut;
    begin
      $display(" negedge toggle reset ");
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
      tb_clk = 0;
      tb_reset_n = 1;
      ip_state = 256'h0000000000000000000000000000000000000000000000000000000000000000;
      test_block = 512'h00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    end
  endtask // init_dut


  //----------------------------------------------------------------
  // single_block_test()
  //
  // Run a test case spanning a single data block.
  //----------------------------------------------------------------
  task single_block_test (input [255 : 0] input_state,
                         input [511 : 0] block,
                         input [255 : 0] expected);
   begin
     ip_state = input_state;
     test_block = block;
     cnt =  (!tb_reset_n) ? 6'd0 : (ITERATOR == 1) ? 6'd0 : (cnt + 6'd1) & (ITERATOR-1);
     // On the first count (cnt==0), load data from previous stage (no feedback)
     // on 1..ITERATOR-1, take feedback from current stage
     // This reduces the throughput by a factor of (ITERATOR), but also reduces the design size by the same amount
     feeder = (ITERATOR == 1) ? 1'b0 : (cnt != 0);
     #(CLK_PERIOD);

     if (op_hash == expected)
       begin
         $display("*** Test case successful.");
         $display("");
       end
     else
       begin
         $display("Expected: 0x%064x", expected);
         $display("Got:      0x%064x", op_hash);
         $display("");

       end
   end
  endtask // single_block_test


  //----------------------------------------------------------------
  // double_block_test()
  //
  // Run a test case spanning two data blocks. We check both
  // intermediate and final digest.
  //----------------------------------------------------------------
  task double_core_test(input [511 : 0] block1,
                        input [255 : 0] expected1,
                        input [511 : 0] block2,
                        input [255 : 0] expected2);

   reg [255 : 0] db_digest1;
   reg [255 : 0] db_digest2;

   begin
     $display("*** Test case double block test case started.");

     $display("*** Test case first block started.");
     test_block = block1;
     #(CLK_PERIOD);
     db_digest1 = op_hash;
     $display("*** Test case first block done.");

     $display("*** Test case second block started.");
     test_block = block2;
     #(CLK_PERIOD);
     db_digest2 = op_hash;
     $display("*** Test case second block done.");

     if (db_digest1 == expected1)
       begin
         $display("*** Test case first block successful");
         $display("");
       end
     else
       begin
         $display("*** ERROR: Test case first block NOT successful");
         $display("Expected: 0x%064x", expected1);
         $display("Got:      0x%064x", db_digest1);
         $display("");
       end

     if (db_digest2 == expected2)
       begin
         $display("*** Testcase second block successful");
         $display("");
       end
     else
       begin
         $display("*** ERROR: Tests case second block NOT successful");
         $display("Expected: 0x%064x", expected2);
         $display("Got:      0x%064x", db_digest2);
         $display("");
       end
   end
  endtask // single_block_test


  //----------------------------------------------------------------
  // sha256_core_test
  // The main test functionality.
  //
  // Test cases taken from:
  // http://csrc.nist.gov/groups/ST/toolkit/documents/Examples/SHA256.pdf
  //----------------------------------------------------------------
  initial
    begin : sha256_core_test
      reg [511 : 0] tc1;
      reg [255 : 0] res1;
      reg [255 : 0] ist1;

      // reg [511 : 0] tc2_1;
      // reg [255 : 0] res2_1;
      // reg [511 : 0] tc2_2;
      // reg [255 : 0] res2_2;

      $display("   -- Testbench for sha256 core started --");

      init_sim();
      reset_dut();

      // TC1: Single block message: "abc".
      ist1 = 256'h5be0cd191f83d9ab9b05688c510e527fa54ff53a3c6ef372bb67ae856a09e667;
      tc1  = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
      res1 = 256'hBA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD;
      single_block_test(ist1, tc1, res1);

      // TC2: Double block message.
      // "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
      // tc2_1 = 512'h6162636462636465636465666465666765666768666768696768696A68696A6B696A6B6C6A6B6C6D6B6C6D6E6C6D6E6F6D6E6F706E6F70718000000000000000;
      // res2_1 = 256'h85E655D6417A17953363376A624CDE5C76E09589CAC5F811CC4B32C1F20E533A;

      // tc2_2 = 512'h000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001C0;
      // res2_2 = 256'h248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1;
      // double_block_test(2, tc2_1, res2_1, tc2_2, res2_2);

      $display("*** Simulation done.");
      $finish;
    end // sha256_core_test
endmodule // tb_sha256_core

//======================================================================
// EOF tb_sha256_core.v
//======================================================================
