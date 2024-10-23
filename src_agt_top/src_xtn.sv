class src_xtn extends uvm_sequence_item;
	`uvm_object_utils(src_xtn)
	
	rand bit [7:0] header;
	rand bit [7:0] payload[];
	
	bit [7:0] parity;
	bit error;
	
	constraint C1 {header [1:0] !=3;}
	constraint C2 {payload.size == header[7:2];}
	constraint C3 {header [7:2]!=0;}
	
	function new(string name = "src_xtn");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		super.do_print(printer);
		
		printer.print_field("header",this.header,8,UVM_HEX);
		
		foreach(payload[i])
			printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_HEX);
		printer.print_field("parity",parity,8,UVM_HEX); //edit
	endfunction

	function void post_randomize();
		parity = header;
		foreach(payload[i])
			parity = payload[i]^parity;
	endfunction

endclass	

