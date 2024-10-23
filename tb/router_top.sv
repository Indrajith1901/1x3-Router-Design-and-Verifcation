module router_top;

	import router_package::*;
	import uvm_pkg::*;

	bit clock;
	
	initial
		begin
			forever
				#10 clock =~clock;
		end	
	
	src_if vif(clock);
	
	dst_if vif0(clock);
	dst_if vif1(clock);
	dst_if vif2(clock);
	
	top_module DUV(.clock(clock),
				   .resetn(vif.resetn),
				   .pkt_valid(vif.pkt_valid),
				   .data_in(vif.data_in),
				   .error(vif.error),
				   .busy(vif.busy),
				   .read_enb_0(vif0.read_enb),
				   .valid_out_0(vif0.valid_out),
				   .data_out_0(vif0.data_out),
				   .read_enb_1(vif1.read_enb),
				   .valid_out_1(vif1.valid_out),
				   .data_out_1(vif1.data_out),
				   .read_enb_2(vif2.read_enb),
				   .valid_out_2(vif2.valid_out),
				   .data_out_2(vif2.data_out));				   
	
	initial
		begin
		
		uvm_config_db#(virtual src_if)::set(null,"*","vif",vif);
		uvm_config_db#(virtual dst_if)::set(null,"*","vif[0]",vif0);
		uvm_config_db#(virtual dst_if)::set(null,"*","vif[1]",vif1);
		uvm_config_db#(virtual dst_if)::set(null,"*","vif[2]",vif2);
		
		run_test();
		end
	/*
	property stable_data;
		@(posedge clock) vif.busy |=> $stable(vif.data_in);
	endproperty

	property busy_check;
		@(posedge clock) $rose(vif.pkt_valid) -> vif.busy ;
	endproperty	
			
	property valid_signal;
		@(posedge clock) $rose(vif.pkt_valid) |-> ##3 (vif0.valid_out | vif1.valid_out |vif2.valid_out);
	endproperty	
	
	property rd_enb0;
      @(posedge clock)
      vif0.valid_out |-> ## [0:29] vif0.read_enb;
   endproperty	
	
	property rd_enb1;
      @(posedge clock)
      vif1.valid_out |-> ## [0:29] vif1.read_enb;
   endproperty
   
	property rd_enb2;
      @(posedge clock)
      vif2.valid_out |-> ## [0:29] vif2.read_enb;
   endproperty
   
   property rd_enb0_low;
		@(posedge clock)
		$fell(vif0.valid_out) |=> $fell(vif0.read_enb);
	endproperty	
	
	property rd_enb1_low;
		@(posedge clock)
		$fell(vif1.valid_out) |=> $fell(vif1.read_enb);
	endproperty	
	
	property rd_enb2_low;
		@(posedge clock)
		$fell(vif2.valid_out) |=> $fell(vif2.read_enb);
	endproperty	
	
	C1:assert property(stable_data)
		$display("Assertion is successfull for stable data");
		else
		$display("Assertion is NOT successfull for stable data");
	
	C2:assert property(busy_check)
		$display("Assertion is successfull for busy_check");
		else
		$display("Assertion is NOT successfull for busy_check");
		
	C3:assert property(valid_signal)
		$display("Assertion is successfull for valid_signal");
		else
		$display("Assertion is NOT successfull for valid_signal");
	
	C4:assert property(rd_enb0)
		$display("Assertion is successfull for rd_enb0");
		else
		$display("Assertion is NOT successfull for rd_enb0");
			
	C5:assert property(rd_enb1)
		$display("Assertion is successfull for rd_enb1");
		else
		$display("Assertion is NOT successfull for rd_enb1");
			
	C6:assert property(rd_enb2)
		$display("Assertion is successfull for rd_enb2");
		else
		$display("Assertion is NOT successfull for rd_enb2");	
		
	C7:assert property(rd_enb0_low)
		$display("Assertion is successfull for rd_enb0_low");
		else
		$display("Assertion is NOT successfull for rd_enb0_low");
			
	C8:assert property(rd_enb1_low)
		$display("Assertion is successfull for rd_enb1_low");
		else
		$display("Assertion is NOT successfull for rd_enb1_low");	
		
	C9:assert property(rd_enb2_low)
		$display("Assertion is successfull for rd_enb2_low");
		else
		$display("Assertion is NOT successfull for rd_enb2_low");	
		*/
endmodule