module synchronizer(
	input [1:0] data_in,
	input clock,resetn,detect_add,write_enb_reg,
	output vld_out_0,vld_out_1,vld_out_2,
	input read_enb_0,read_enb_1,read_enb_2,
	output reg [2:0] write_enb,
	output reg fifo_full,
	input empty_0,empty_1,empty_2,
	output reg soft_reset_0,soft_reset_1,soft_reset_2,
	input full_0,full_1,full_2);
	
	reg [1:0] int_addr;
	reg [4:0] temp_0;
	reg [4:0] temp_1;
	reg [4:0] temp_2;
	
	//address logic
	always@(posedge clock)
	begin
	if(!resetn)
	int_addr<=0;
	else if(detect_add==1)
	int_addr<=data_in;
	end
	
	//write enable logic
	always@(*)
	begin
	write_enb =3'b000;
	if(write_enb_reg)
		begin
		case (int_addr)
        2'b00: write_enb = 3'b001;
        2'b01: write_enb = 3'b010;
        2'b10: write_enb = 3'b100;
        default: write_enb = 3'b000;
		endcase
		end
	end	
	
	//fifo full logic
	always@(*)
	begin
	case (int_addr)
        2'b00: fifo_full = full_0;
        2'b01: fifo_full = full_1;
        2'b10: fifo_full = full_2;
        default: fifo_full= 1'b0;
		endcase
		
	end
	
	assign vld_out_0=~empty_0;
	assign vld_out_1=~empty_1;
	assign vld_out_2=~empty_2;
	
	//soft reset timer logic
	always@(posedge clock)
	begin
	if(!resetn)
	begin
		temp_0<=0;
		soft_reset_0<=0;
	end
	else if(vld_out_0)
	begin
		if(!read_enb_0)
		begin 
			if(temp_0==5'd29)
			begin
				temp_0<=0;
				soft_reset_0<=1'b1;
			end
			else 
			begin
				temp_0<=temp_0+1'b1;
				soft_reset_0<=0;
			end
		end
	end
	end
	
	always@(posedge clock)
	begin
	if(!resetn)
	begin
		temp_1<=0;
		soft_reset_1<=0;
	end
	else if(vld_out_1)
	begin
		if(!read_enb_1)
		begin 
			if(temp_1==5'd29)
			begin
				temp_1<=0;
				soft_reset_1<=1'b1;
			end
			else 
			begin
				temp_1<=temp_1+1'b1;
				soft_reset_1<=0;
			end
		end
	end
	end
	
	always@(posedge clock)
	begin
	if(!resetn)
	begin
		temp_2<=0;
		soft_reset_2<=0;
	end
	else if(vld_out_2)
	begin
		if(!read_enb_2)
		begin 
			if(temp_2==5'd29)
			begin
				temp_2<=0;
				soft_reset_2<=1'b1;
			end
			else 
			begin
				temp_2<=temp_2+1'b1;
				soft_reset_2<=0;
			end
		end
	end
	end
endmodule
	