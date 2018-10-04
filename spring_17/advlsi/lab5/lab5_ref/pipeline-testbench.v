`timescale 1ps/1ps

module test;
  
  reg go_l, go_r;

    integer break_time = 200000;
    integer break_time2 = 200000;

    integer zero_buf_cycle_break = 5;

    integer forward_latency =0;
    integer lr_up =0;
    integer rr_up =0;
    integer lhs_delay =0;

    integer backward_latency =0;
    integer ra_up =0;
    integer la_up =0;
    reg bl_go =1;

    integer cycle_time =0;
    reg last_lr_val =0;
    integer last_lr_up_time =0;
    reg last_la_val =0;
    integer last_la_dn_time =0;

    integer tokens = 0;
    integer all_tokens = 0;

 integer sim_start;
 integer i=0;
 wire la,lr,rr,ra;
 
 testbench p1(go_l, go_r); //replaces the testbench module in designs.v that has your pipeline
 
 assign la = p1.la;
 assign lr = p1.lr;
 assign rr = p1.rr;
 assign ra = p1.ra;
 

  
  initial
  begin
    go_l=0;
    go_r=0;
    
    #30000;
    sim_start = $realtime;
    
    go_l=1;
    
    while(i==0)
    begin
     last_lr_val = lr;
     last_la_val = la;

   
    #500;

 if (lr_up == 0 && lr == 1 ) begin
	 lr_up = $realtime;
	 lhs_delay = $realtime - sim_start;
  end
    if ( rr_up == 0 &&  rr == 1 ) begin
	 rr_up = $realtime;
	 forward_latency =rr_up - lr_up;
  end

    if ( last_lr_val == 0 &&  lr == 1 ) begin
	if ( last_lr_up_time > 0 
	     && (cycle_time < ($realtime-last_lr_up_time)) ) begin
	     cycle_time = $realtime - last_lr_up_time;
	    $display("cycle time set to %d", cycle_time);
	end
	last_lr_up_time=$realtime;
  end
  
    if ( last_la_val == 1 &&  la == 0 ) begin
	 last_la_dn_time = $realtime;
	 tokens = tokens+1;
  end

    if (cycle_time != 0) begin
	if ($realtime > (last_lr_up_time +(cycle_time * 4)) ) begin
	    $display( "Breaking loop - three times max cycle without another req");
	    $display("%d",$realtime > (last_lr_up_time +(cycle_time * 4)));
	   i=1; 
	end
	end
    if (($realtime > (break_time + sim_start))) begin
	if ( tokens != 0 ) begin
	    $display( "***Error: - needed to break out of loop");
	end
	i=1;
  end
end

$display( "Buffering depth: %d", tokens);
$display( "Forward Latency Delay: %d",   forward_latency);
$display( "Backward Latency Delay:%d " , backward_latency);
$display( "Max Cycle Time:%d",cycle_time);
$display( "%d",$realtime);


//### Calculate backward latency

//# Enable right interface
go_r =1;

i=0;

sim_start=$realtime;

if ( la == 1) begin
    bl_go=0;
end

if (tokens == 0 ) begin
    last_lr_up_time = $realtime;
end



while (i==0) begin
    last_lr_val =lr;

    last_la_val =la;


    #500;

    if (ra_up == 0 && ra == 1) begin
	   ra_up=$realtime;
    end
    if (bl_go == 0 && la == 0) begin
	   bl_go= 1;
    end

    if (la_up == 0 && la == 1 && bl_go == 1) begin
	 la_up = $realtime;
	 backward_latency = la_up - ra_up;
    end
    
    
    if (last_lr_val == 0 && lr == 1) begin
	if ((all_tokens >= tokens) &&
	     (cycle_time<($realtime-last_lr_up_time))) begin
	     cycle_time = $realtime - last_lr_up_time;
	    $display( "cycle time  to %d",cycle_time);
	    $display( "now - last la up: %d-%d = %d", $realtime, last_lr_up_time, cycle_time);

	end
	 last_lr_up_time =$realtime;
    end
    if (last_la_val == 1 && la == 0) begin
	 last_la_dn_time =$realtime;
	 all_tokens = all_tokens+1;
    end

    if (all_tokens > (2.5 * tokens )) begin
	if (tokens == 0 ) begin
	    if (all_tokens >= zero_buf_cycle_break ) begin
		i=1;
	    end
	end else begin
	    i=1;
	end
    end
    if ($realtime > (break_time2 +sim_start)) begin
	$display( "***Error - needed to break out of loop");
	$display( "tokens: %d : %d",all_tokens,tokens);
	i=1;
    end
end


////// Print results

$display( "Buffering depth: %d", tokens);
$display( "Forward Latency Delay: %d",   forward_latency);
$display( "Backward Latency Delay:%d " , backward_latency);
$display( "Max Cycle Time:%d",cycle_time);
$display( "Run Time: %d",$realtime);


end
  
endmodule
