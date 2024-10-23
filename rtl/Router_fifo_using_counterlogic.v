module fifo (
    input clock, resetn, soft_reset, write_enb, read_enb, lfd_state,
    input [7:0] data_in,
    output full, empty,
    output reg [7:0] data_out);
    reg [4:0] wr_pt;
    reg [4:0] rd_pt;
    reg [4:0] fifo_counter;
    reg [8:0] mem [15:0];
    reg lfd_state_s;
    integer i;

//fifo_counter logic
always@(posedge clock)
begin
if(!resetn)
begin
	fifo_counter<=0;
end
else if(soft_reset)
begin
	fifo_counter<=0;
end
else if(read_enb & !empty)
begin
	if(mem[rd_pt[3:0]][8]==1'b1)//header
	fifo_counter<=mem[rd_pt[3:0]][7:2]+1'b1;//slice payload till parity
	else if(fifo_counter != 0)//if header is 1
	fifo_counter<=fifo_counter-1'b1;
end
end

//delay lfd_state by one cycle
always@(posedge clock)
begin
	if(!resetn)
	lfd_state_s<=0;
	else 
	lfd_state_s<=lfd_state;
end


//write logic
always@(posedge clock)
begin
if(!resetn)
begin
	for(i=0;i<16;i=i+1)
	begin
	mem[i]<=0;
	end
end
else if(soft_reset)
begin
	for(i=0;i<16;i=i+1)
	begin
	mem[i]<=0;
	end
end
else
begin
	if(write_enb && !full)
	begin
	{mem[wr_pt[3:0]]}<={lfd_state_s,data_in};
	end
end
end

//read logic
wire w1=(fifo_counter ==0 && data_out!=0)?1'b1:1'b0;


always@(posedge clock)
begin
if(!resetn)
	begin
	data_out<=8'b00000000;
	end
else if(soft_reset)
	begin
	data_out<=8'bzzzzzzzz;
	end
else
begin
	if(w1)
	begin
	data_out<=8'bzzzzzzzz;
	end
	else if(read_enb && !empty)
	begin
	data_out<=mem[rd_pt[3:0]];
	end
end
end

//pointer increment
always@(posedge clock)
begin
if(!resetn)
begin
	rd_pt<=5'b00000;
	wr_pt<=5'b00000;
end
else if(soft_reset)
begin
	rd_pt<=5'b00000;
	wr_pt<=5'b00000;
end
else
begin
	if(write_enb && !full)
	wr_pt<=wr_pt+1;
	
	
	else 
	wr_pt<=wr_pt;
 
	if(read_enb && !empty)
	rd_pt<=rd_pt+1;
 
	else
	rd_pt<=rd_pt;
end
end

assign full=(wr_pt=={~rd_pt[4],rd_pt[3:0]})?1'b1:1'b0;
assign empty=(wr_pt==rd_pt)?1'b1:1'b0;
endmodule