interface src_if(input bit clock);

	logic [7:0] data_in;
	logic pkt_valid,resetn,error,busy;
	
	clocking drv_cb@(posedge clock);
		default input #1 output #1;
		output pkt_valid,resetn,data_in;
		input busy,error;
	endclocking	
	
	clocking mon_cb@(posedge clock);
		default input #1 output #1;
		input pkt_valid,resetn,data_in;
		input busy,error;
	endclocking

	modport DRV_MP(clocking drv_cb);
	modport MON_MP(clocking mon_cb);
	
endinterface	
		