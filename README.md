# 1x3 Router Design And Verification
A router is a networking device that forwards data packets between computer LANs. It follows the TCP/IP layer 3 network protocol.

## About The Project
The RTL design consists of FSM, Register, FIFO( x3), and synchroniser blocks. The router has Clock, resetn,data_in, pkt_valid, and read_enb(x3) as input signals and data_out(x3), valid_out(x3), error and  busy as output signals. reset is active low. In the packet, the first byte is the header where the first 2 bits will define the address, and the rest is the payload length. Then followed by payload data and the last byte is parity byte. 

HDL: Verilog
HVL: System Verilog
TB Methodology: UVM
EDA Tools: Synopsis - VCS / Siemens - Questa Sim and Xilinx ISE

## Input Protocol
All inputs are synchronous to the clock and driven at negedge to avoid meta stability between DUT and testbench.Pkt_valid goes high when the first packet enters. If busy is high then the transaction is extended. Before driving parity byte pkt_valid goes low. When pkt_valid goes high busy goes high.

## Output Protocol
Output is synchronous to the posedge to the clock and inputs data_in and pkt_valid are synchronous to the negedge of the clock. When valid_out is high, after 30 cycles soft reset will go high and internal reset will happen. The read_enb signal should go high before that to prevent it from happening.

## Register 
Acts like a loadable register and uses control, and signals from FSM and loads the packets in the order, Header, payload, and parity to data_out. Generate error signal by comparing source parity and internal parity.

## FSM
FSM is the Main hub of the architecture which generates control signals to control the rest of the subblock. 

## Synchronizer

Synchroniser captures the address of the packet and generates a write enable signal which is further used for connecting the write enable pin of each FIFO. Also generates the timeout logic.

## FIFO 
To store packets based on the relevant address given by the source LAN.

## Verification
Verification was done using system verilog and UVM framework. Various constraints were added to limit the randomized values to meaningful values. Explicit bins were added for coverage and regressive testing was done using different test cases which simulated small packets, medium packets and Large packets.







