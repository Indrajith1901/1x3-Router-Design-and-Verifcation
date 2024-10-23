class router_dst_base_sequence extends uvm_sequence #(dst_xtn);
	`uvm_object_utils(router_dst_base_sequence)
	
	function new(string name = "router_dst_base_sequence");
		super.new(name);
	endfunction	
	
endclass

class router_dst_xtn1 extends router_dst_base_sequence;
	`uvm_object_utils(router_dst_xtn1)
	
	function new(string name = "router_dst_xtn1");
		super.new(name);
	endfunction

	task body();
		//repeat(10);
			begin
				req = dst_xtn::type_id::create("req");
				start_item(req);
				assert(req.randomize() with {no_of_delay inside {[1:28]};});
				`uvm_info("ROUTER_DST_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW) 
				finish_item(req);
				`uvm_info(get_type_name(),"AFTER FINSIH ITEM INSIDE SEQUENCE",UVM_HIGH)
			end
	endtask
	 
endclass

class router_dst_xtn2 extends router_dst_base_sequence;
	`uvm_object_utils(router_dst_xtn2)
	
	function new(string name = "router_dst_xtn2");
		super.new(name);
	endfunction

	task body();
		//repeat(10);
			begin
				req = dst_xtn::type_id::create("req");
				start_item(req);
				assert(req.randomize() with {no_of_delay inside {[30:40]};});
				`uvm_info("ROUTER_DST_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW) 
				finish_item(req);
			end
	endtask
	 
endclass