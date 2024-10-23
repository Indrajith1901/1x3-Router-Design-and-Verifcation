class router_src_base_sequence extends uvm_sequence #(src_xtn);
	`uvm_object_utils(router_src_base_sequence)
	
	function new(string name = "router_src_base_sequence");
		super.new(name);
	endfunction	
	
endclass

class router_src_small_sequence	extends router_src_base_sequence;
	`uvm_object_utils(router_src_small_sequence)
	
	bit[1:0]address;
	
	function new(string name = "router_src_small_sequence");
		super.new(name);
	endfunction

	task body();
			if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
				`uvm_fatal("small_sequence","get function failed")
				req = src_xtn::type_id::create("req");
				start_item(req);
				//assert(req.randomize() with {header[1:0]==2'b00;header[1:0]==2'b01;header[1:0]==2'b10; 
										//	 header[7:2] inside {[1:15]};});
				assert(req.randomize() with {header[7:2] inside {[1:15]} && header[1:0]==address;});
				`uvm_info("ROUTER_SRC_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
				finish_item(req);
	endtask
	 
endclass	

class router_src_medium_sequence extends router_src_base_sequence;
	`uvm_object_utils(router_src_medium_sequence)
	
	bit[1:0]address;
	
	function new(string name = "router_src_medium_sequence");
		super.new(name);
	endfunction

	task body();
			if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
				`uvm_fatal("medium_sequence","get function failed")
				req = src_xtn::type_id::create("req");
				start_item(req);
				//assert(req.randomize() with {header[1:0]==2'b00;header[1:0]==2'b01;header[1:0]==2'b10;
											// header[7:2] inside {[16:32]};});
				assert(req.randomize() with {header[7:2] inside {[16:31]} && header[1:0]==address;});
				`uvm_info("ROUTER_SRC_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
				finish_item(req);
				
	endtask
	 
endclass	

class router_src_large_sequence extends router_src_base_sequence;
	`uvm_object_utils(router_src_large_sequence)
	
	bit[1:0]address;
	
	function new(string name = "router_src_large_sequence");
		super.new(name);
	endfunction

	task body();
			if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
				`uvm_fatal("Large_sequence","get function failed")
				req = src_xtn::type_id::create("req");
				start_item(req);
				//assert(req.randomize() with {header[1:0]==2'b00;header[1:0]==2'b01;header[1:0]==2'b10;
											// header[7:2] inside {[32:63]};});
				assert(req.randomize() with {header[7:2] inside {[32:63]} && header[1:0]==address;});
				`uvm_info("ROUTER_SRC_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
				finish_item(req);
				
	endtask
	 
endclass	