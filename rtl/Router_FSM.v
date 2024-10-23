module fsm(clock,resetn,pkt_valid,busy,parity_done,data_in,soft_reset_0,soft_reset_1,soft_reset_2,
			fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,
			detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);
	parameter DECODE_ADDRESS=3'b000,
			  LOAD_FIRST_DATA=3'b001,
			  LOAD_DATA	=3'b010,
			  FIFO_FULL_STATE=3'b011,
			  LOAD_AFTER_FULL=3'b100,
			  LOAD_PARITY=3'b101,
			  CHECK_PARITY_ERROR=3'b110,
			  WAIT_TILL_EMPTY=3'b111;		  
	
	input clock,resetn,pkt_valid,parity_done;
	input [1:0] data_in;
	input soft_reset_0,soft_reset_1,soft_reset_2;
	input fifo_full,low_pkt_valid;
	input fifo_empty_0,fifo_empty_1,fifo_empty_2;
	
	output busy;
	output detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state;
	
	reg [2:0] PRESENT_STATE,NEXT_STATE;
	reg [1:0] addr;
	
	//reset and softreset logic
	always @(posedge clock)
		begin
		if(!resetn)
		addr<=0;
		else if((soft_reset_0==1 && data_in==2'b00 )|| (soft_reset_1==1 && data_in==2'b01) || (soft_reset_2==1 && data_in==2'b10))
		addr<=0;
		else if(data_in)
		addr<=data_in;
		end
		
	//present state logic
	always @(posedge clock)
		begin
		if(!resetn)
		PRESENT_STATE<=DECODE_ADDRESS;
		else if((soft_reset_0 && data_in==2'b00 )|| (soft_reset_1 && data_in==2'b01) || (soft_reset_2 && data_in==2'b10))
		PRESENT_STATE<=DECODE_ADDRESS;
		else
		PRESENT_STATE<=NEXT_STATE;
		end
		
	//next state logic
	always@(*)
		begin
		NEXT_STATE=DECODE_ADDRESS;
		
		case(PRESENT_STATE)
		3'b000:	begin
						if((pkt_valid && data_in==0 && fifo_empty_0)||(pkt_valid && data_in==1 && fifo_empty_1)||(pkt_valid && data_in==2 && fifo_empty_2))
						NEXT_STATE=LOAD_FIRST_DATA;
						else if((pkt_valid && data_in==0 && ~fifo_empty_0)||(pkt_valid && data_in==1 && ~fifo_empty_1)||(pkt_valid && data_in==2 && ~fifo_empty_2))
						NEXT_STATE=WAIT_TILL_EMPTY;
						else 
						NEXT_STATE=DECODE_ADDRESS;
						end	
						
		3'b001:begin
						NEXT_STATE=LOAD_DATA;
						end
						
		3'b010:begin
				  if(fifo_full)
				  NEXT_STATE=FIFO_FULL_STATE;
				  else if(fifo_full==0 && pkt_valid==0)
				  NEXT_STATE=LOAD_PARITY;
				  else
				  NEXT_STATE=LOAD_DATA;
				  end
		
		3'b011:begin
						
						if(fifo_full)
						NEXT_STATE=FIFO_FULL_STATE;
						else
						NEXT_STATE=LOAD_AFTER_FULL;
						end
						
		3'b100:begin
						if(parity_done)
						NEXT_STATE=DECODE_ADDRESS;
						else if(parity_done==0 && low_pkt_valid==1)
						NEXT_STATE=LOAD_PARITY;
						else if(parity_done==0 && low_pkt_valid==0)
						NEXT_STATE=LOAD_DATA;
						end
		
		3'b101:begin
					NEXT_STATE=CHECK_PARITY_ERROR;
					end
		
		3'b110:begin
						   if(fifo_full)
						   NEXT_STATE=FIFO_FULL_STATE;
						   else
						   NEXT_STATE=DECODE_ADDRESS;
						   end
				
		3'b111:begin					
						if(~fifo_empty_0 && addr==2'b00||(~fifo_empty_0 && addr==2'b01)||(~fifo_empty_0 && addr==2'b10))
						   NEXT_STATE=WAIT_TILL_EMPTY;
						else if(fifo_empty_0 && addr ==2'b00||fifo_empty_1 && addr ==2'b01||fifo_empty_2 && addr ==2'b10)
						   NEXT_STATE=LOAD_FIRST_DATA;
						end
						
		default:NEXT_STATE=DECODE_ADDRESS;
		endcase
		end
		
	//output logic
	assign detect_add=(PRESENT_STATE==DECODE_ADDRESS)?1'b1:1'b0;
	assign ld_state=(PRESENT_STATE==LOAD_DATA)?1'b1:1'b0;
	assign laf_state=(PRESENT_STATE==LOAD_AFTER_FULL)?1'b1:1'b0;
	assign full_state=(PRESENT_STATE==FIFO_FULL_STATE)?1'b1:1'b0;
	assign write_enb_reg=(PRESENT_STATE==LOAD_DATA || 
						  PRESENT_STATE==LOAD_PARITY || 
						  PRESENT_STATE==LOAD_AFTER_FULL)?1'b1:1'b0;
	assign rst_int_reg=(PRESENT_STATE==CHECK_PARITY_ERROR)?1'b1:1'b0;
	assign lfd_state=(PRESENT_STATE==LOAD_FIRST_DATA)?1'b1:1'b0;
	assign busy=((PRESENT_STATE==LOAD_AFTER_FULL ||
				  PRESENT_STATE==FIFO_FULL_STATE ||
				  PRESENT_STATE==LOAD_AFTER_FULL ||
				  PRESENT_STATE==LOAD_PARITY ||
				  PRESENT_STATE==CHECK_PARITY_ERROR ||
				  PRESENT_STATE==WAIT_TILL_EMPTY))?1'b1:1'b0;
				  			  
endmodule	
	
	
	
	
		
								
		
								
						
			
			
		