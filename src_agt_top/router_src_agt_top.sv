class router_src_agt_top extends uvm_env;
	`uvm_component_utils(router_src_agt_top)
	
	env_config m_cfg;
	//router_src_agt_config s_cfg;
	//router_src_agt_config s_cfg[];
	router_src_agent s_agnth[];
	
	function new(string name="router_src_agt_top",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
			`uvm_fatal("Source Agent Top","Get Method Failed")
		//s_cfg = new[m_cfg.no_of_src];
		s_agnth = new[m_cfg.no_of_src];
		
		foreach(s_agnth[i])
			begin
				s_agnth[i]=router_src_agent::type_id::create($sformatf("s_agnth[%0d]",i),this);
				//s_cfg[i]=router_src_agt_config::type_id::create($sformatf("s_cfg[%0d]",i));
				//s_cfg=router_src_agt_config::type_id::create("s_cfg");
				//s_cfg[i]=m_cfg.s_cfg[i];
				uvm_config_db #(router_src_agt_config)::set(this,"*","router_src_agt_config",m_cfg.s_agt_cfg[i]);
			end
	endfunction
	
endclass	