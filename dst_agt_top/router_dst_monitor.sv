class router_dst_monitor extends uvm_monitor;
	`uvm_component_utils(router_dst_monitor)
	
	virtual dst_if.MON_MP vif;
	
	router_dst_agt_config d_cfg;
	
	uvm_analysis_port #(dst_xtn) monitor_port; //To connect Monitor and scoreboard
	
	function new(string name ="router_dst_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port", this); //can be done in both constructor or build phase
	endfunction	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//d_cfg = router_dst_agt_config::type_id::create("d_cfg");
		if(!uvm_config_db#(router_dst_agt_config)::get(this,"","router_dst_agt_config",d_cfg))
			`uvm_fatal("Monitor","Get function failed")
	endfunction
	
	function void connect_phase(uvm_phase phase);
		vif=d_cfg.vif;
	endfunction	
	
	task run_phase(uvm_phase phase);
		forever
			begin
				collect_data();
			end
	endtask			
	
	task collect_data();
		dst_xtn xtn;
		xtn = dst_xtn::type_id::create("xtn");
		@(vif.mon_cb);
		wait(vif.mon_cb.read_enb==1);
		@(vif.mon_cb); //one cycle delay to get the header (refer to output protocols)
		xtn.header = vif.mon_cb.data_out; //sampling header
		xtn.payload=new[xtn.header[7:2]]; //extracting packet length and allocating it as payload length
		@(vif.mon_cb); //sampling payload in next cycle
		foreach(xtn.payload[i])
			begin
				xtn.payload[i]=vif.mon_cb.data_out;
				@(vif.mon_cb); //in the next cycle only next information arrives
			end
		xtn.parity = vif.mon_cb.data_out;
		@(vif.mon_cb); //delay for next information
		`uvm_info("ROUTER_DST_MONITOR",$sformatf("printing from monitor \n %s", xtn.sprint()),UVM_LOW)
		monitor_port.write(xtn);  //senting to scoreboard
endtask
		
endclass