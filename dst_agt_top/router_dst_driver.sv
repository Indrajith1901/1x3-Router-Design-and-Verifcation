class router_dst_driver extends uvm_driver#(dst_xtn);
	`uvm_component_utils(router_dst_driver)
	
	virtual dst_if.DRV_MP vif;
	
	router_dst_agt_config d_cfg;
	
	function new(string name ="router_dst_driver",uvm_component parent);
		super.new(name,parent);
	endfunction	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(router_dst_agt_config)::get(this,"","router_dst_agt_config",d_cfg))
			`uvm_fatal("Driver","Get function failed")
	endfunction
	
	function void connect_phase(uvm_phase phase);
		vif=d_cfg.vif;
	endfunction	
	
	task run_phase(uvm_phase phase);
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end	
	endtask	
	
	task send_to_dut(dst_xtn xtn); //wait for valid_out to go high and once it goes high,then read_enb should go high between 1-29 cycles
		/*
		repeat(xtn.no_of_delay)
			wait(vif.drv_cb.valid_out==1)
		@(vif.drv_cb);
		vif.drv_cb.read_enb <= 1'b1;
		wait(vif.drv_cb.valid_out==0)
		@(vif.drv_cb);
		vif.drv_cb.read_enb <= 1'b0; //whenever valid_out goes low read_enb should be made low,otherwise zero or unkown values will be read.
		repeat(29)
			@(vif.drv_cb);
			*/
		begin	
		`uvm_info("ROUTER_DST_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW)	
		@(vif.drv_cb);
		wait(vif.drv_cb.valid_out==1)
		repeat(xtn.no_of_delay)
		@(vif.drv_cb);
		vif.drv_cb.read_enb <= 1'b1;
		wait(vif.drv_cb.valid_out==0)
		vif.drv_cb.read_enb <= 1'b0;
		@(vif.drv_cb);
		end
	endtask	
endclass	