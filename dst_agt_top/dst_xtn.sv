class dst_xtn extends uvm_sequence_item;
	`uvm_object_utils(dst_xtn)
	bit [7:0] header;         //header,payload and parity is sampled but read_enb is driven to the dut.
	bit [7:0] payload[];
	bit [7:0] parity;
	bit valid_out,read_enb;  //Although read_enb is the signal driven to the dut, it is not randomized. 
							//It is generated based on checking the valid_out signal. hence 'rand'  keyword is not used.
	rand bit [5:0] no_of_delay;	 //fopr randomizing the cycles for the soft reset(1-29)
	
	function new(string name ="dst_xtn");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		super.do_print(printer);
		
		printer.print_field("header",this.header,8,UVM_HEX);
		
		foreach(payload[i])
			printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_HEX);
			
		printer.print_field("parity",this.parity,8,UVM_HEX);
		//printer.print_field("valid_out",this.valid_out,8,UVM_HEX);
		//printer.print_field("read_enb",this.read_enb,8,UVM_HEX);
		printer.print_field("no_of_delay",this.no_of_delay,6,UVM_DEC);
		
	endfunction
endclass	