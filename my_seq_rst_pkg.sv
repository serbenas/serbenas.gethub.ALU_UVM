package ALU_reset_sequence_pkg;
  import uvm_pkg::*;
  import ALU_seq_item_pkg::*;
`include "uvm_macros.svh"


 class ALU_reset_sequence extends uvm_sequence #(ALU_seq_item);
    `uvm_object_utils( ALU_reset_sequence)
	 ALU_seq_item seq_item;
 
    function new(string name="ALU_reset_sequence");
    super.new(name);
    endfunction
  
	 task body;
   
   
	 seq_item=ALU_seq_item ::type_id::create("seq_item");
	 start_item(seq_item);
	 seq_item.rst=1;
	 seq_item.srcCy=0;
	 seq_item.srcAc=0;
	 seq_item.bit_in=0;
	 seq_item.op_code=0;
	 seq_item.src1=0;
	 seq_item.src2 = 0;
	 seq_item.src3 = 0;
	
	 finish_item(seq_item);
	
   endtask
  endclass
  endpackage 
  