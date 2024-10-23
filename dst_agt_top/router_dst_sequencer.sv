class router_dst_sequencer extends uvm_sequencer #(dst_xtn);
	`uvm_component_utils(router_dst_sequencer)
	
	function new(string name ="router_dst_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction	
	
	//function void build_phase(uvm_phase phase);
	//	super.build_phase(phase);
	//endfunction

endclass	