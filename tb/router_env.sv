class router_tb extends uvm_env;
	`uvm_component_utils(router_tb)
	
	env_config m_cfg;
	router_dst_agt_top d_ag_t;
	router_src_agt_top s_ag_t;
	
	router_scoreboard sb;
	router_virtual_sequencer v_sequencer;
	
	function new(string name="router_tb",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		 if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
	    `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
		
		if(m_cfg.has_sagent)
			s_ag_t=router_src_agt_top::type_id::create("s_ag_t",this);
			
		if(m_cfg.has_dagent)	
			d_ag_t=router_dst_agt_top::type_id::create("d_ag_t",this);
			
		if(m_cfg.has_virtual_sequencer)
		     v_sequencer = router_virtual_sequencer::type_id::create("v_sequencer",this);
		
		if(m_cfg.has_scoreboard)
			sb= router_scoreboard::type_id::create("sb",this);
			
	endfunction
	
	function void connect_phase(uvm_phase phase);  //to point the sequencer handles in virtual sequence to the physical sequencers
		if(m_cfg.has_virtual_sequencer)
			begin
			if(m_cfg.has_sagent)
				begin
					for(int i=0;i<m_cfg.no_of_src;i++)
					begin
						v_sequencer.s_seqrh[i] = s_ag_t.s_agnth[i].seqr_h;
					end
				end
			
			if(m_cfg.has_dagent)
				begin
					for(int i=0;i<m_cfg.no_of_dst;i++)
					begin
						v_sequencer.d_seqrh[i] = d_ag_t.d_agnth[i].seqr_h;
					end
				end
			end	
		if(m_cfg.has_scoreboard)
			begin
				if(m_cfg.has_sagent)
					begin
						foreach(m_cfg.s_agt_cfg[i])
							begin
								s_ag_t.s_agnth[i].mon_h.monitor_port.connect(sb.fifo_src.analysis_export);
							end
					end
				if(m_cfg.has_dagent)
					begin
						foreach(m_cfg.d_agt_cfg[i])
							begin
								d_ag_t.d_agnth[i].mon_h.monitor_port.connect(sb.fifo_dst[i].analysis_export);
							end
					end
			end		
	endfunction		
endclass

