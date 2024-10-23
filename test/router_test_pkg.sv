package router_package;
	import uvm_pkg::*;
	
	`include "uvm_macros.svh"
	
	`include "src_xtn.sv"
	`include "router_dst_agt_config.sv"
	`include "router_src_agt_config.sv"
	`include "env_config.sv"
	
	`include "router_src_driver.sv"
	`include "router_src_monitor.sv"
	`include "router_src_sequencer.sv"
	`include "router_src_agent.sv"
	`include "router_src_agt_top.sv"
	`include "router_src_seq.sv"
	
	`include "dst_xtn.sv"
	`include "router_dst_driver.sv"
	`include "router_dst_monitor.sv"
	`include "router_dst_sequencer.sv"
	`include "router_dst_agent.sv"
	`include "router_dst_agt_top.sv"
	`include "router_dst_seq.sv"
	
	`include "router_virtual_sequencer.sv"
	`include "router_virtual_seq.sv"
	`include "router_scoreboard.sv"
	
	`include "router_env.sv"
	
	`include "router_test.sv"
endpackage	