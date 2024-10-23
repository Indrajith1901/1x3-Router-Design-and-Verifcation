interface dst_if(input bit clock);
	
	logic read_enb,valid_out;
	logic [7:0] data_out;

	clocking drv_cb@(posedge clock);
		default input #1 output #0;
		output read_enb;
		input valid_out;
	endclocking

	clocking mon_cb@(posedge clock);
		default input #1 output #0;
		input data_out,read_enb;
	endclocking	
	
	modport DRV_MP(clocking drv_cb);
	modport MON_MP(clocking mon_cb);
	
endinterface	