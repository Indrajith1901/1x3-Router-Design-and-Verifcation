class router_dst_agt_top extends uvm_env;
	`uvm_component_utils(router_dst_agt_top)
	
	env_config m_cfg;
	router_dst_agent d_agnth[]; //agent handle
	
	function new(string name="router_dst_agt_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
			`uvm_fatal("CONFIG","Have u sent it?")
			
		d_agnth = new[m_cfg.no_of_dst];
		super.build_phase(phase);
		foreach(d_agnth[i]) 
			begin
				d_agnth[i]=router_dst_agent::type_id::create($sformatf("d_agnth[%0d]",i),this);
				uvm_config_db #(router_dst_agt_config)::set(this,"*","router_dst_agt_config",m_cfg.d_agt_cfg[i]);
			end
	endfunction	
	
endclass
