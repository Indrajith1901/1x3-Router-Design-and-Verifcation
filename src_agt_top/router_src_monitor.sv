class router_src_monitor extends uvm_monitor;
	`uvm_component_utils(router_src_monitor)
	
	virtual src_if.MON_MP vif;
	router_src_agt_config s_cfg;
	
	uvm_analysis_port #(src_xtn) monitor_port;
	
	
	function new(string name ="router_src_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port", this);
	endfunction	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//s_cfg = router_src_agt_config::type_id::create("s_cfg");
		if(!uvm_config_db#(router_src_agt_config)::get(this,"","router_src_agt_config",s_cfg))
			`uvm_fatal("Monitor","Get function failed")
	endfunction
	
	function void connect_phase(uvm_phase phase);
		vif = s_cfg.vif;
	endfunction
	
	task run_phase(uvm_phase phase);
		forever
			collect_data();
	endtask
	
	task collect_data();
		src_xtn xtn;
		xtn = src_xtn::type_id::create("xtn");
		@(vif.mon_cb); 
		wait(vif.mon_cb.busy==0) 
		wait(vif.mon_cb.pkt_valid==1)
		xtn.header=vif.mon_cb.data_in;
		xtn.payload = new[xtn.header[7:2]];
		@(vif.mon_cb);	
		foreach(xtn.payload[i])
			begin
				wait(vif.mon_cb.busy==0) 
					xtn.payload[i] = vif.mon_cb.data_in;
					@(vif.mon_cb); // one more delay for next information to be sampled
			end
		wait(vif.mon_cb.busy==0) 
		wait(vif.mon_cb.pkt_valid==0) 
		xtn.parity = vif.mon_cb.data_in;
		repeat(2) // To avoid manually defining delays(clock cycles) 
			@(vif.mon_cb); //2 times 
		xtn.error = vif.mon_cb.error; 
		`uvm_info("ROUTER_SRC_MONITOR",$sformatf("printing from monitor \n %s", xtn.sprint()),UVM_LOW) 
		//xtn.print();
		monitor_port.write(xtn); // senting to scoreboard
				
	endtask				
		
		
endclass	