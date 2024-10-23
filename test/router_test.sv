
class router_test extends uvm_test;
	`uvm_component_utils(router_test)
	
	env_config m_cfg;
	router_src_agt_config s_cfg[];
	router_dst_agt_config d_cfg[];
	router_tb env_h;
	
	
	bit has_sagent = 1;
	bit has_dagent = 1;
	int no_of_src =1;
	int no_of_dst =3;
	
	
	function new(string name="router_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	
	function void config_router();
		
		if(has_sagent)
		begin
		s_cfg =new[no_of_src];
		foreach(s_cfg[i])
			begin
				s_cfg[i] = router_src_agt_config::type_id::create($sformatf("s_cfg[%0d]",i));
			
				if(!uvm_config_db #(virtual src_if)::get(this,"","vif",s_cfg[i].vif))
					`uvm_fatal("TEST","Get function Failed")
				s_cfg[i].is_active = UVM_ACTIVE;
				m_cfg.s_agt_cfg[i] = s_cfg[i];
			end
		end
		
		if(has_dagent)
		begin
		d_cfg = new[no_of_dst];
		foreach(d_cfg[i])
			begin
				d_cfg[i] = router_dst_agt_config::type_id::create($sformatf("d_cfg[%0d]",i));
				
				if(!uvm_config_db #(virtual dst_if)::get(this,"",$sformatf("vif[%0d]",i),d_cfg[i].vif))
					`uvm_fatal("TEST","Get function Failed")
				d_cfg[i].is_active = UVM_ACTIVE;
				m_cfg.d_agt_cfg[i] = d_cfg[i];
			end
		end
		
		m_cfg.has_sagent = has_sagent;
		m_cfg.has_dagent = has_dagent;
		m_cfg.no_of_src = no_of_src;
		m_cfg.no_of_dst = no_of_dst;
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_cfg = env_config::type_id::create("m_cfg");
		
		if(has_sagent)
			m_cfg.s_agt_cfg = new[no_of_src];
		
		if(has_dagent)
			m_cfg.d_agt_cfg = new[no_of_dst];
		
		config_router();
		
		uvm_config_db #(env_config)::set(this,"*","env_config",m_cfg);
		
		env_h=router_tb::type_id::create("env_h",this);	
	endfunction	
	
	
	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info("Test","start of simulation phase",UVM_LOW)
		super.start_of_simulation_phase(phase);
			uvm_top.print_topology();
	endfunction
	
	
endclass 
	
class small_test extends router_test;
	`uvm_component_utils(small_test)
	
	small_pkt_vseq v_seq;
	bit [1:0] address;
	
	function new(string name="small_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
	endfunction	
	
	task run_phase(uvm_phase phase);
		
//		repeat(20)
			begin
				address={$random}%3;
				uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",address);
				phase.raise_objection(this);
				v_seq = small_pkt_vseq::type_id::create("v_seq");
	
				v_seq.start(env_h.v_sequencer);
				phase.drop_objection(this);
			end
		
	endtask
endclass	

	
class medium_test extends router_test;
	`uvm_component_utils(medium_test)
	
	medium_pkt_vseq v_seq;
	bit [1:0] address;
	
	function new(string name="medium_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
	endfunction	
	
	task run_phase(uvm_phase phase);
		
		//repeat(20)
			begin
				address={$random}%3;
				uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",address);
				phase.raise_objection(this);
				v_seq = medium_pkt_vseq::type_id::create("v_seq");
	
				v_seq.start(env_h.v_sequencer);
				phase.drop_objection(this);
			end
		
	endtask
endclass

class large_test extends router_test;
	`uvm_component_utils(large_test)
	
	large_pkt_vseq v_seq;
	
	bit [1:0] address;
	
	function new(string name="large_test",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
	endfunction	
	
	task run_phase(uvm_phase phase);
	
		//repeat(20)
			begin
				address={$random}%3;
				uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",address);
				phase.raise_objection(this);
				v_seq = large_pkt_vseq::type_id::create("v_seq");
	
				v_seq.start(env_h.v_sequencer);
				phase.drop_objection(this);
			end	
		
	endtask
endclass
