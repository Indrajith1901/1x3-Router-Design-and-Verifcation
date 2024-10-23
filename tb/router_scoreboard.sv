class router_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(router_scoreboard)
	
	uvm_tlm_analysis_fifo #(src_xtn) fifo_src;
	uvm_tlm_analysis_fifo #(dst_xtn) fifo_dst[];
	src_xtn s_xtn;
	dst_xtn d_xtn;
	
	
	env_config m_cfg;
	
	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db#(env_config)::get(this,"","env_config",m_cfg))
			`uvm_fatal("SB","Get function failed")
			
		fifo_src=new("fifo_src",this);
		
		fifo_dst= new[m_cfg.no_of_dst];
		foreach(fifo_dst[i])
			begin	
				fifo_dst[i]=new($sformatf("fifo_dst[%0d]",i),this);
			end
	endfunction

	task run_phase(uvm_phase phase);
		forever
			begin
				fork
					begin
						fifo_src.get(s_xtn);
						`uvm_info("SRC_SB","SRC data" , UVM_LOW)
						s_xtn.print();
						src.sample();
					end	
					
					begin
						fork
							begin
								fifo_dst[0].get(d_xtn);
								`uvm_info("DST_SB_0","DST data" , UVM_LOW)
								d_xtn.print();
								dst.sample();
							end	
							
							begin
								fifo_dst[1].get(d_xtn);
								`uvm_info("DST_SB_1","DST data" , UVM_LOW)
								d_xtn.print();
								dst.sample();
							end	
							
							begin
								fifo_dst[2].get(d_xtn);
								`uvm_info("DST_SB_2","DST data" , UVM_LOW)
								d_xtn.print();
								dst.sample();
							end	
						join_any
						disable fork;	
					end	
					//compare(s_xtn,d_xtn);
				join
			end
	endtask

	function void compare(src_xtn s_xtn,dst_xtn d_xtn);
		if(s_xtn.header == d_xtn.header)
			`uvm_info("SB","Header comparison SUCCESSFULL",UVM_LOW)
		else 
			`uvm_error("SB","Header comparison UNSUCCESSFULL")
	
		if(s_xtn.payload==d_xtn.payload)	
			`uvm_info("SB","Payload comparison SUCCESSFULL",UVM_LOW)
		else 
			`uvm_error("SB","Payload comparison UNSUCCESSFULL")
		
		if(s_xtn.parity==d_xtn.parity)	
			`uvm_info("SB","Parity comparison SUCCESSFULL",UVM_LOW)
		else 
			`uvm_error("SB","Parity comparison UNSUCCESSFULL")	

	endfunction		
	
	covergroup src;
		ADDRESS	:coverpoint s_xtn.header[1:0]{	bins addr0 ={0};
												bins addr1 ={1};
												bins addr2 ={2}; }
										  
		PAYLOAD :coverpoint s_xtn.header[7:2]{	bins small_pkt ={[1:15]};
												bins medium_pkt={[16:31]};	
												bins large_pkt ={[32:63]}; }
										   
		ERROR:coverpoint s_xtn.error{	bins correct={0};
										bins wrong  ={1}; }
	
		ADDRESS_X_PAYLOAD: cross ADDRESS,PAYLOAD;
		ADDRESS_X_PAYLOAD_X_ERROR : cross ADDRESS,PAYLOAD,ERROR;
	
	endgroup
	
	covergroup dst;
	
		ADDRESS	:coverpoint d_xtn.header[1:0]{	bins addr0 ={0};
												bins addr1 ={1};
												bins addr2 ={2}; }
										  
		PAYLOAD :coverpoint d_xtn.header[7:2]{ 	bins small_pkt ={[1:15]};
												bins medium_pkt={[16:31]};	
												bins large_pkt ={[32:63]}; }
										   
		ADDRESS_X_PAYLOAD: cross ADDRESS,PAYLOAD;
	endgroup

	function new(string name="router_scoreboard",uvm_component parent);
		super.new(name,parent);
		src=new();
		dst=new();
	endfunction		
	
endclass