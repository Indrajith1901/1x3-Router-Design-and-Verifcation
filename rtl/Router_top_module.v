module top_module(clock,resetn,read_enb_0,read_enb_1,read_enb_2,
				  pkt_valid,data_in,data_out_0,data_out_1,data_out_2,
				  valid_out_0,valid_out_1,valid_out_2,error,busy);
				  
	input clock,resetn;
	input read_enb_0,read_enb_1,read_enb_2;
	input [7:0] data_in;
	input pkt_valid;
	
	output wire [7:0] data_out_0,data_out_1,data_out_2;
	output valid_out_0,valid_out_1,valid_out_2;
	output error,busy;
	
	wire [2:0] write_enb;
	wire [7:0] dout;
	 
	 fifo FIFO_0(.clock(clock),
				 .resetn(resetn),
				 .write_enb(write_enb[0]),
				 .soft_reset(soft_reset_0),
				 .read_enb(read_enb_0),
				 .data_in(dout),
				 .lfd_state(lfd_state),
				 .empty(empty_0),
				 .full(full_0),
				 .data_out(data_out_0));
				 
	fifo FIFO_1(.clock(clock),
				 .resetn(resetn),
				 .write_enb(write_enb[1]),
				 .soft_reset(soft_reset_1),
				 .read_enb(read_enb_1),
				 .data_in(dout),
				 .lfd_state(lfd_state),
				 .empty(empty_1),
				 .full(full_1),
				 .data_out(data_out_1));			 
				 
	fifo FIFO_2(.clock(clock),
				 .resetn(resetn),
				 .write_enb(write_enb[2]),
				 .soft_reset(soft_reset_2),
				 .read_enb(read_enb_2),
				 .data_in(dout),
				 .lfd_state(lfd_state),
				 .empty(empty_2),
				 .full(full_2),
				 .data_out(data_out_2));			 
	
	fsm FSM (.clock(clock),
			 .resetn(resetn),
			 .pkt_valid(pkt_valid),
			 .busy(busy),
			 .parity_done(parity_done),
			 .data_in(data_in[1:0]),
			 .soft_reset_0(soft_reset_0),
			 .soft_reset_1(soft_reset_1),
			 .soft_reset_2(soft_reset_2),
			 .fifo_full(fifo_full),
			 .low_pkt_valid(low_pkt_valid),
			 .fifo_empty_0(empty_0),
			 .fifo_empty_1(empty_1),
			 .fifo_empty_2(empty_2),
			 .detect_add(detect_add),
			 .ld_state(ld_state),
			 .laf_state(laf_state),
			 .full_state(full_state),
			 .write_enb_reg(write_enb_reg),
			 .rst_int_reg(rst_int_reg),
			 .lfd_state(lfd_state));
	
	synchronizer SYNCHRONIZER(.clock(clock),
					      .resetn(resetn),
						  .detect_add(detect_add),
						  .data_in(data_in[1:0]),
						  .write_enb_reg(write_enb_reg),
						  .vld_out_0(valid_out_0),
						  .vld_out_1(valid_out_1),
						  .vld_out_2(valid_out_2),
						  .read_enb_0(read_enb_0),
						  .read_enb_1(read_enb_1),
						  .read_enb_2(read_enb_2),
						  .write_enb(write_enb),
						  .fifo_full(fifo_full),
						  .empty_0(empty_0),
						  .empty_1(empty_1),
						  .empty_2(empty_2),
						  .soft_reset_0(soft_reset_0),
						  .soft_reset_1(soft_reset_1),
						  .soft_reset_2(soft_reset_2),
						  .full_0(full_0),
						  .full_1(full_1),
						  .full_2(full_2));
						  
	register REGISTER(.clock(clock),
					  .resetn(resetn),
					  .pkt_valid(pkt_valid),
					  .data_in(data_in),
					  .fifo_full(fifo_full),
					  .rst_int_reg(rst_int_reg),
					  .detect_add(detect_add),
					  .ld_state(ld_state),
					  .laf_state(laf_state),
					  .full_state(full_state),
					  .lfd_state(lfd_state),
					  .parity_done(parity_done),
					  .low_pkt_valid(low_pkt_valid),
					  .err(error),
					  .dout(dout));
endmodule					  