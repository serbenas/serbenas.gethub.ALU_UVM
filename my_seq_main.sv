
package ALU_main_sequence_pkg;
  import uvm_pkg::*;
  import ALU_seq_item_pkg::*;
`include "uvm_macros.svh"

 class ALU_main_sequence extends uvm_sequence #(ALU_seq_item);
  
    `uvm_object_utils( ALU_main_sequence)
	 ALU_seq_item  seq_item ;
    function new(string name="ALU_main_sequence");
      super.new(name);
    endfunction
	
    task body();
   
     repeat(2000) begin
        
	    seq_item= ALU_seq_item ::type_id::create("seq_item");
	    start_item(seq_item);
	    assert(seq_item.randomize ());
	    finish_item(seq_item);
		
		
	end
	
   endtask
  endclass
  endpackage 
  