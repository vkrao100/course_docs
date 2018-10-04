
module pipeline4 (go_l, go_r);
	input go_l, go_r;

	wire lr, la, rr, ra, r1, a1, r2, a2, r3, a3,rd1, ad1,
	     rd2, ad2, rd3,ad3, rst;

	LHS    l0 (.go_l(go_l), .rst(rst), .out(lr), .in(la));
	LC_BM  p0 (.lr(lr), .la(la), .rr(r1), .ra(a1), .rst(rst));
	
	delay1 d0 (.lr(r1), .rr(rd1)); 
	LC_BM  p1 (.lr(rd1), .la(a1), .rr(r2), .ra(a2), .rst(rst));
	
	delay1 d1 (.lr(r2), .rr(rd2));
	LC_BM  p2 (.lr(rd2), .la(a2), .rr(r3), .ra(a3), .rst(rst));
	
	delay1 d2 (.lr(r3), .rr(rd3));
	LC_BM  p3 (.lr(rd3), .la(a3), .rr(rr), .ra(ra), .rst(rst));

	RHS    r0 (.go_r(go_r), .in(rr), .out(ra));

endmodule 
