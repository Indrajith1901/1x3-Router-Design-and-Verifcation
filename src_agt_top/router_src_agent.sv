class router_src_agent extends uvm_agent;
	`uvm_component_utils(router_src_agent)
	
	router_src_driver drv_h;
	router_src_monitor mon_h;
	router_src_sequencer seqr_h;
	router_src_agt_config s_cfg;
	
	function new(string name ="router_src_agent",uvm_component parent);
		super.new(name,parent);
	endfunction	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//s_cfg =router_src_agt_config::type_id::create("s_cfg"); //local config instance creation takeout when using get function
		if(!uvm_config_db #(router_src_agt_config)::get(this,"","router_src_agt_config",s_cfg))
		  `uvm_fatal("CONFIG","cannot get() s_cfg from uvm_config_db. Have you set() it?") 
		mon_h=router_src_monitor::type_id::create("mon_h",this);
		if(s_cfg.is_active==UVM_ACTIVE)
			begin
			drv_h=router_src_driver::type_id::create("drv_h",this);
			seqr_h=router_src_sequencer::type_id::create("seqr_h",this);
			end	
	endfunction
	
	function void connect_phase(uvm_phase phase);
		if(s_cfg.is_active ==UVM_ACTIVE)
			begin
				drv_h.seq_item_port.connect(seqr_h.seq_item_export);
			end
	endfunction
endclass	