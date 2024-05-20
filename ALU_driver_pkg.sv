package ALU_driver_pkg;
   import uvm_pkg::*;
   `include "uvm_macros.svh"
   import ALU_seq_item_pkg::*;
  
 class ALU_driver extends uvm_driver #(ALU_seq_item);
 `uvm_component_utils(ALU_driver)
 
 virtual ALU_inf  ALU_vif;
 
 ALU_seq_item stim_seq_item;

   function new (string name ="ALU_driver", uvm_component parent= null);
      super.new(name,parent);
   endfunction 

   task run_phase(uvm_phase phase); 
      super.run_phase(phase);
      forever begin
        stim_seq_item =ALU_seq_item ::type_id::create(" stim_seq_item");
        seq_item_port.get_next_item(stim_seq_item);
        ALU_vif.rst=stim_seq_item.rst;  
        ALU_vif.srcCy=stim_seq_item.srcCy;     
        ALU_vif.srcAc=stim_seq_item.srcAc; 
        ALU_vif.bit_in=stim_seq_item.bit_in; 
        ALU_vif.op_code=stim_seq_item.op_code; 
        ALU_vif.src1=stim_seq_item.src1; 
        ALU_vif.src2=stim_seq_item.src2; 
        ALU_vif.src3=stim_seq_item.src3;    
        @(negedge ALU_vif.clk); 
      
       seq_item_port.item_done();
       `uvm_info("run_phase",stim_seq_item.convert2string_stimulus(),UVM_HIGH)
     end	 
 
    endtask
 endclass
endpackage

