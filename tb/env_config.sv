class env_config extends uvm_object;

	`uvm_object_utils(env_config)
	
	bit has_sagent = 1;
	bit has_dagent = 1;
	bit has_virtual_sequencer=1;
	int no_of_src=1;
	int no_of_dst=3;
	bit has_scoreboard =1;


	router_dst_agt_config d_agt_cfg[];
	router_src_agt_config s_agt_cfg[];

	function new(string name="env_config");
		super.new(name);
	endfunction

endclass
