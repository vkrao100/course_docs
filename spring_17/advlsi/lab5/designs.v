// This contains unit-delay simulation models for various asynchronous pipelines

`timescale 1ns/1ps



module testbench (go_l, go_r);
   input go_l, go_r;

   wire  lr, la, rr, ra, rst;

   LHS    l0 (.go_l(go_l), .rst(rst), .out(lr), .in(la));
   //// your design goes here ////
   RHS    r0 (.go_r(go_r), .in(rr), .out(ra));

endmodule // testbench



//////////////////////////////////////////////////////////////
///////////////////////  library cells ///////////////////////
//////////////////////////////////////////////////////////////


// This is the extra forward delay between 
`define data_delay  1


// You may want to change the DELAY module into three modules
// with hard wired delays, e.g. DELAY1, DELAY3, DELAY5.

// provides a programmable delay line to the design
// delay based on macro data_delay
module DELAY(lr, rr);
   
   input  lr;
   output rr;
   reg 	  rr;

   // make delay line in rising edge to match function logic
   always @(*) begin
      if (lr) rr <= #`data_delay lr;
      else rr <= lr;
   end

endmodule // FUNDEL



// This is the "go left" module.
// It gives a two gate delay turnaround between the req/ack pairs
// It asserts reset until go is asserted and then lowers reset and
// inserts tokens into the pipeline.

// Left go signal also resets the system
module LHS(go_l, rst, out, in);
   output rst, out;
   input  go_l, in;

   assign rst = ~go_l;
   assign #1 out = go_l & ~in;

endmodule // LHS



// Right go signal pauses the output.
// Must ensure that this is lowered when in = 0 for correct operation.
module RHS(go_r, out, in);
   output out;
   input  in, go_r;

   assign #1 out = go_r & in;

endmodule // RHS

	
module LC_C (lr, la, rr, ra, rst);
   input  lr, ra, rst;
   output la, rr;

   wire   ra_, rst_;

   assign rr = la;
   
   NOR2X1A12TR  n0  (.A(ra), .B(rst), .Y(ra_));
   C_ELEMENT    c0  (.a(lr), .b(ra_), .c(la));

endmodule // LC_C


module LC_BM (lr, la, rr, ra, rst);
   input  lr, ra, rst;
   output la, rr;

   wire   la_, rr_, ra_, y_, y;

   INVX1A12TR    lc0  (.A(ra), .Y(ra_));
   AOI32X1A12TR  lc1  (.A0(lr), .A1(ra_), .A2(y_), .B0(lr), .B1(la), .Y(la_));
   NOR2X1A12TR   lc2  (.A(la_), .B(rst), .Y(la));
   AOI32X1A12TR  lc3  (.A0(ra_), .A1(lr), .A2(y_), .B0(ra_), .B1(rr), .Y(rr_));
   NOR2X1A12TR   lc4  (.A(rr_), .B(rst), .Y(rr));
   C_ELEMENT     lc5  (.a(la), .b(rr), .c(y));
   INVX1A12TR    lc6  (.A(y), .Y(y_));

endmodule // LC_BM

module C_ELEMENT (a, b, c);
   input  a, b;
   output c;

   wire   ab, ac, bc;

   NAND2X1A12TR   n0  (.A(a), .B(b), .Y(ab));
   NAND2X1A12TR   n1  (.A(a), .B(c), .Y(ac));
   NAND2X1A12TR   n2  (.A(b), .B(c), .Y(bc));
   NAND3X1A12TR   n3  (.A(ab), .B(ac), .C(bc), .Y(c));

endmodule // C_ELEMENT


