class router_dst_agent extends uvm_agent;
	`uvm_component_utils(router_dst_agent)
	
	router_dst_driver drv_h;
	router_dst_monitor mon_h;
	router_dst_sequencer seqr_h;
	
	router_dst_agt_config d_cfg;
	
	//uvm_active_passive_enum is_active=UVM_ACTIVE; //local defining 
	
	function new(string name ="router_dst_agent",uvm_component parent);
		super.new(name,parent);
	endfunction	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//d_cfg =router_dst_agt_config::type_id::create("d_cfg");
		if(!uvm_config_db #(router_dst_agt_config)::get(this,"","router_dst_agt_config",d_cfg))
		  `uvm_fatal("CONFIG","cannot get() d_cfg from uvm_config_db. Have you set() it?") 
		mon_h=router_dst_monitor::type_id::create("mon_h",this);
		if(d_cfg.is_active==UVM_ACTIVE)
			begin
				drv_h=router_dst_driver::type_id::create("drv_h",this);
				seqr_h=router_dst_sequencer::type_id::create("seqr_h",this);
			end	
	endfunction
	 
	function void connect_phase(uvm_phase phase);
		if(d_cfg.is_active ==UVM_ACTIVE)
				drv_h.seq_item_port.connect(seqr_h.seq_item_export);
	
	endfunction
endclass