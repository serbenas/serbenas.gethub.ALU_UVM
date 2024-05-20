package ALU_monitor_pkg;

  import ALU_seq_item_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class ALU_monitor extends uvm_monitor;
    `uvm_component_utils(ALU_monitor) 
	virtual ALU_inf ALU_vif;
    ALU_seq_item rsp_seq_item;
    uvm_analysis_port #(ALU_seq_item) mon_ap;
	function new(string name = "ALU_monitor", uvm_component parent = null);
       super.new (name, parent);
    endfunction
    function void build_phase (uvm_phase phase);
       super.build_phase (phase);
       mon_ap = new ("mon_ap", this);
    endfunction: build_phase
	
    task run_phase (uvm_phase phase);
        super.run_phase (phase);
        forever begin
             rsp_seq_item = ALU_seq_item ::type_id::create("rsp_seq_item");
             @(negedge ALU_vif.clk);
             rsp_seq_item.rst = ALU_vif.rst;
             rsp_seq_item.srcCy = ALU_vif.srcCy;
             rsp_seq_item.srcAc = ALU_vif.srcAc;
             rsp_seq_item.bit_in = ALU_vif.bit_in;
             rsp_seq_item.op_code= ALU_vif.op_code;
             rsp_seq_item.src1=ALU_vif.src1; 
             rsp_seq_item.src2=ALU_vif.src2; 
             rsp_seq_item.src3=ALU_vif.src3; 
             rsp_seq_item.desCy=ALU_vif.desCy; 
             rsp_seq_item.desAc=ALU_vif.desAc; 
             rsp_seq_item.desOv=ALU_vif.desOv; 
             rsp_seq_item.des1=ALU_vif.des1; 
             rsp_seq_item.des2=ALU_vif.des2; 
             rsp_seq_item.des_acc=ALU_vif.des_acc; 
             rsp_seq_item.sub_result=ALU_vif. sub_result; 
           
             mon_ap.write(rsp_seq_item);
             `uvm_info("run_phase", rsp_seq_item.convert2string(), UVM_HIGH)
        end 
    endtask
endclass
endpackage
