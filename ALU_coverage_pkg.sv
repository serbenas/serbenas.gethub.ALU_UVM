package ALU_coverage_pkg;

 
   import ALU_seq_item_pkg::*;
   import uvm_pkg::*;
  `include "uvm_macros.svh"
   class ALU_coverage extends uvm_component;
      `uvm_component_utils (ALU_coverage)
       uvm_analysis_export #(ALU_seq_item) cov_export; 
	   uvm_tlm_analysis_fifo #(ALU_seq_item) cov_fifo;
       ALU_seq_item seq_item_cov;
       
	
          covergroup cvr_grp  ;
             rst_g:         coverpoint seq_item_cov.rst;
             srcCy_g:       coverpoint seq_item_cov.srcCy;
             srcAc_g:       coverpoint seq_item_cov.srcAc;
             bit_in_g:      coverpoint seq_item_cov.bit_in;
             op_code_g:     coverpoint seq_item_cov. op_code{ illegal_bins mul={4'b0011 }; illegal_bins div={4'b0100};}
             src1_g:        coverpoint seq_item_cov.src1;
             src2_g:        coverpoint seq_item_cov.src2;
             src3_g:        coverpoint seq_item_cov.src3;
             desCy_g:       coverpoint seq_item_cov.desCy;
             desAc_g:       coverpoint seq_item_cov.desAc;
             desOv_g:       coverpoint seq_item_cov.desOv;
             des1_g:        coverpoint seq_item_cov.des1;
             des2_g:        coverpoint seq_item_cov.des2;
             des_acc_g:     coverpoint seq_item_cov.des_acc;
             sub_result_g:  coverpoint seq_item_cov.sub_result;
            
            
		  endgroup;
			
			
       function new(string name = "ALU_coverage", uvm_component parent = null);
          super.new (name, parent);
          cvr_grp = new();
       endfunction
	   
	   
       function void build_phase (uvm_phase phase);
          super.build_phase (phase);
          cov_export = new("cov_export", this);
          cov_fifo = new("cov_fifo", this);
       endfunction
	   
        function void connect_phase (uvm_phase phase);
           super. connect_phase (phase);
           cov_export.connect (cov_fifo.analysis_export);
        endfunction
		
        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get (seq_item_cov); 
				cvr_grp.sample();
            end
        endtask
		
    endclass
endpackage	