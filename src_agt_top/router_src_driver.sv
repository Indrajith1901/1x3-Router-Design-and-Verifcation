class router_src_driver extends uvm_driver #(src_xtn) ;
	`uvm_component_utils(router_src_driver)
	
	virtual src_if.DRV_MP vif;
	
	router_src_agt_config s_cfg;
	
	
	function new(string name ="router_src_driver",uvm_component parent);
		super.new(name,parent);
	endfunction	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(router_src_agt_config)::get(this,"","router_src_agt_config",s_cfg))
			`uvm_fatal("Driver","Get function failed")
	endfunction
	
	function void connect_phase(uvm_phase phase);
		vif = s_cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		 @(vif.drv_cb); //first clock cycle
		 vif.drv_cb.resetn <=1'b0;
		 @(vif.drv_cb);//second clock cycle
		 @(vif.drv_cb); //third clock cycle
		 vif.drv_cb.resetn <=1'b1;
		 forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut(src_xtn xtn);
	`uvm_info("ROUTER_SRC_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW)
		//xtn.print();
		@(vif.drv_cb);
		wait(vif.drv_cb.busy==0) //dont put " ; " as it will terminate the check condition for every loop
		vif.drv_cb.pkt_valid <=1'b1;
		vif.drv_cb.data_in <=xtn.header;
		@(vif.drv_cb); // only in the next clock cycle after the header is driven the payload is driven.
		foreach(xtn.payload[i])  //for(int i=0;i<xtn.header[7:2];i++)
			begin
				wait(vif.drv_cb.busy==0)
					vif.drv_cb.data_in <= xtn.payload[i];
					@(vif.drv_cb); 
				end
		wait(vif.drv_cb.busy==0)	
		vif.drv_cb.pkt_valid <=1'b0;	//make pkt_valid as low after driving the payload
		vif.drv_cb.data_in <= xtn.parity; //In the same cycle when pkt_valid goes low parity is driven
		repeat(2)@(vif.drv_cb);
		xtn.error = vif.drv_cb.error; //edit
		seq_item_port.put_response(xtn); //edit
	endtask
	
endclass