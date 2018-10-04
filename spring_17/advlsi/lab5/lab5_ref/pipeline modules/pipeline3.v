module pipeline3 (go_l, go_r);
   input go_l, go_r;

   wire  lr, la, rr, ra, rst;

   LHS    l0 (.go_l(go_l), .rst(rst), .out(lr), .in(la));
   LC_BM p0 (.lr(lr), .la(la), .rr(r1), .ra(a1), .rst(rst));
   LC_C  p1 (.lr(r1), .la(a1), .rr(r2), .ra(a2), .rst(rst));
   LC_C p2 (.lr(r2), .la(a2), .rr(r3), .ra(a3), .rst(rst));
   LC_BM  p3 (.lr(r3), .la(a3), .rr(rr), .ra(ra), .rst(rst)); 
   RHS    r0 (.go_r(go_r), .in(rr), .out(ra));

endmodule 
