module register(clock,resetn,pkt_valid,data_in,fifo_full,
				rst_int_reg,detect_add,ld_state,laf_state,
				full_state,lfd_state,parity_done,low_pkt_valid,
				err,dout);
	input clock,resetn;
	input pkt_valid;
	input [7:0] data_in;
	input fifo_full,rst_int_reg,ld_state,detect_add,laf_state,full_state,lfd_state;
	
	output reg parity_done,low_pkt_valid,err;
	output reg [7:0] dout;
	
	reg [7:0] header_byte_register;
	reg [7:0] fifo_full_state_byte_register;
	reg [7:0] internal_parity_byte_register;
	reg [7:0] packet_parity_byte_register;
	
	//dout_logic
	always@(posedge clock)
		begin
		if(!resetn)
		dout<=0;
		else if(lfd_state)
		dout<=header_byte_register;
		else if(ld_state && !fifo_full)
		dout<=data_in;
		else if(laf_state)
		dout<=fifo_full_state_byte_register;
		else 
		dout<=dout;
		end
		
	//header_byte_register_and_fifo_full_state_byte_register_logic 
	always@(posedge clock)
		begin 
		if(!resetn)
		{header_byte_register,fifo_full_state_byte_register}<=0;
		else if(pkt_valid && detect_add && data_in !=3)
		header_byte_register<=data_in;
		else if(ld_state && fifo_full)
		fifo_full_state_byte_register<=data_in;
		end
		
	//parity_done_logic	
	always@(posedge clock)
		begin
		if(!resetn || detect_add)
		parity_done<=0;
		else if(ld_state && ~fifo_full && ~pkt_valid)
		parity_done<=1'b1;
		else if(laf_state && ~parity_done && low_pkt_valid)
		parity_done<=1'b1;
		end
		
	//low_pkt_valid_logic
	always@(posedge clock)
		begin
		if(~resetn || rst_int_reg)
		low_pkt_valid<=0;
		else if(ld_state && !pkt_valid)
		low_pkt_valid<=1'b1;
		end
		
	//packet_parity_logic
	always@(posedge clock)
		begin
		if(!resetn)
		packet_parity_byte_register<=0;
		else if(ld_state && !pkt_valid)
		packet_parity_byte_register<=data_in;
		/*else if(detect_add)
		packet_parity_byte_register<=0;*/
		end	
		
		
	//internal_parity_byte_logic	
	always@(posedge clock)
		begin
		if(!resetn)
		internal_parity_byte_register<=0;
		else if(detect_add)
		internal_parity_byte_register<=0;
		else if(lfd_state)
		internal_parity_byte_register<=internal_parity_byte_register^header_byte_register;
		else if(pkt_valid && ld_state && !full_state)
		internal_parity_byte_register<=internal_parity_byte_register ^ data_in;
		/*else if(rst_int_reg)
		internal_parity_byte_register<=0;*/
		end
		
	//error_logic
		always@(posedge clock)
		begin
		if(!resetn)
		err<=0;
		else 
			begin
			if(parity_done) 
				begin
					if(internal_parity_byte_register!=packet_parity_byte_register)			
						err<=1'b1;
					else
						err<=1'b0;
				end
			end	
		end
	endmodule
	