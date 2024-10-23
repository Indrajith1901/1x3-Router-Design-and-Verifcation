class router_vbase_seq extends uvm_sequence #(uvm_sequence_item);
	`uvm_object_utils(router_vbase_seq)
	
	router_src_sequencer s_seqrh[];
	router_dst_sequencer d_seqrh[];

	router_virtual_sequencer v_seqrh;
	env_config m_cfg;
	
	function new(string name = "router_vbase_seq");
		super.new(name);
	endfunction
	
	task  body();
		if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",m_cfg))
			`uvm_fatal("virtual sequence","get function failed")
		s_seqrh = new[m_cfg.no_of_src];
		d_seqrh = new[m_cfg.no_of_dst]; 	
		
		assert($cast(v_seqrh,m_sequencer))
		else
			begin
				`uvm_error("virtual sequence","casting failed")
			end
		foreach(s_seqrh[i])
			s_seqrh[i] = v_seqrh.s_seqrh[i];
		foreach(d_seqrh[i])
			d_seqrh[i] = v_seqrh.d_seqrh[i];
	endtask		
endclass

class small_pkt_vseq extends router_vbase_seq;
	`uvm_object_utils(small_pkt_vseq)
	
	bit[1:0] address;
	router_src_small_sequence s_xtn;
	router_dst_xtn1 d_xtn;
	extern function new (string name = "small_pkt_vseq");
	extern task body();
endclass   

function small_pkt_vseq::new(string name ="small_pkt_vseq");
	 super.new(name);
endfunction

task small_pkt_vseq::body();
  
   super.body();
	 if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
	    `uvm_fatal(get_type_name(),"Get function failed")

 	 if(m_cfg.has_sagent) 
				 s_xtn = router_src_small_sequence::type_id::create("s_xtn");
				 
	 if(m_cfg.has_dagent) 
				  d_xtn= router_dst_xtn1::type_id::create("d_xtn");
   	   
	 fork
			begin
			    s_xtn.start(s_seqrh[0]);
			end
			
      begin
			     if(address ==2'b00)
				    d_xtn.start(d_seqrh[0]);
				 if(address == 2'b01)
				    d_xtn.start(d_seqrh[1]);
				 if(address == 2'b10)
				    d_xtn.start(d_seqrh[2]);

	 	  end
	 join  
	 		               
endtask        

class medium_pkt_vseq extends router_vbase_seq;
	`uvm_object_utils(medium_pkt_vseq)
	
	bit[1:0] address;
	router_src_medium_sequence s_xtn;
	router_dst_xtn1 d_xtn;
	extern function new (string name = "medium_pkt_vseq");
	extern task body();
	
endclass   

function medium_pkt_vseq::new(string name ="medium_pkt_vseq");
	 super.new(name);
endfunction

task medium_pkt_vseq::body();
  
   super.body();
	 if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
			`uvm_fatal(get_type_name(),"Get function failed")

 	 if(m_cfg.has_sagent) 
			s_xtn = router_src_medium_sequence::type_id::create("s_xtn");
	
	 if(m_cfg.has_dagent) 
			d_xtn= router_dst_xtn1::type_id::create("d_xtn");
		
   	   
	fork
		begin
			   s_xtn.start(s_seqrh[0]);
		end
			
        begin
			if(address ==2'b00)
				d_xtn.start(d_seqrh[0]);
			if(address == 2'b01)
				d_xtn.start(d_seqrh[1]);
			if(address == 2'b10)
				d_xtn.start(d_seqrh[2]);

	 	end
	join  
	 		               
endtask  

class large_pkt_vseq extends router_vbase_seq;
	`uvm_object_utils(large_pkt_vseq)
	
	bit[1:0] address;
	router_src_large_sequence s_xtn;
	router_dst_xtn1 d_xtn;
	extern function new (string name = "large_pkt_vseq");
	extern task body();
endclass   

function large_pkt_vseq::new(string name ="large_pkt_vseq");
	 super.new(name);
endfunction

task large_pkt_vseq::body();
  
   super.body();
	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
	    `uvm_fatal(get_type_name(),"Get function failed") 

	if(m_cfg.has_sagent) 
				 s_xtn = router_src_large_sequence::type_id::create("s_xtn");

	if(m_cfg.has_dagent)
				  d_xtn= router_dst_xtn1::type_id::create("d_xtn");
	
   	   
	fork
		begin
			s_xtn.start(s_seqrh[0]);
		end
			
        begin
			if(address ==2'b00)
				d_xtn.start(d_seqrh[0]);
			if(address == 2'b01)
				d_xtn.start(d_seqrh[1]);
			if(address == 2'b10)
				d_xtn.start(d_seqrh[2]);

	 	 end
	join  
	 		               
endtask 