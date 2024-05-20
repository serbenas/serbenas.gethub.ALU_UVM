package ALU_scoreboard_pkg ;

     import uvm_pkg::*;
    `include "uvm_macros.svh"
     import ALU_seq_item_pkg::*;
    `include "oc8051_timescale.v"
    `include "oc8051_defines.v"
 
	 
  class   ALU_scoreboard  extends uvm_scoreboard;
     `uvm_component_utils( ALU_scoreboard)
	 uvm_analysis_export   #(ALU_seq_item) sb_export;
	 uvm_tlm_analysis_fifo #(ALU_seq_item) sb_fifo;
	 ALU_seq_item  seq_item_sb;
	  
	
     logic      desCy_ref, desAc_ref, desOv_ref;
     logic [7:0] des1_ref, des2_ref, des_acc_ref, sub_result_ref;
	 
	 
	 
	 //add :internal variables

     bit [4:0] add1, add2, add3, add4;
     bit [3:0] add5, add6, add7, add8;
     bit [1:0] add9, adda, addb, addc;
 

     //sub :internal variables

     bit [4:0] sub1, sub2, sub3, sub4;
     bit [3:0] sub5, sub6, sub7, sub8;
     bit [1:0] sub9, suba, subb, subc;
     bit [7:0] sub_result;
 

     //da :internal variables

     bit da_tmp, da_tmp1;

     // inc :internal variables
 
     bit [15:0] inc, dec;
	 bit enable_mul;
	 bit enable_div;
	 int error_count=0;
	 int correct_count=0;
	  
	  
	  function new (string name="ALU_scoreboard ", uvm_component parent= null);
	    super.new(name,parent);
	  endfunction
    
     function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        sb_export =new("sb_export", this);
		sb_fifo =new("sb_fifo", this);
		
     endfunction	
	 function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
	endfunction
	
		
	task run_phase(uvm_phase phase);
	  super.run_phase(phase);
	  forever begin
	    sb_fifo.get(seq_item_sb);
		ref_model(seq_item_sb);
		
         if (seq_item_sb.desCy!= desCy_ref|| seq_item_sb.desAc != desAc_ref || seq_item_sb.desOv != desOv_ref || seq_item_sb.des1!= des1_ref ||seq_item_sb.des2 != des2_ref || seq_item_sb.des_acc != des_acc_ref || seq_item_sb.sub_result != sub_result_ref) begin 
		    `uvm_error("run_phase", $sformatf ("comparsion failed, transaction received by DUT :%s, while ****,desCy_ref=0b%0b,desAc_ref=0b%0b,desOv_ref=0b%0b,des1_ref=0b%0b,des2_ref=0b%0b,des_acc_ref=0b%0b,sub_result_ref=0b%0b",seq_item_sb.convert2string(),desCy_ref,desAc_ref,desOv_ref,des1_ref,des2_ref,des_acc_ref,sub_result_ref));
			 error_count++;
		end
        else begin
             `uvm_info("run_phase", $sformatf ("correct ALSU_out: %s",seq_item_sb.convert2string()),UVM_HIGH);		
		      correct_count++;
		end	
     end		
     endtask

    task ref_model (ALU_seq_item seq_item_chk);
	
	   
         add1 = {1'b0,seq_item_sb.src1[3:0]};
         add2 = {1'b0,seq_item_sb.src2[3:0]};
		 add3 = {3'b000,seq_item_sb.srcCy};
		 add4 = add1+add2+add3;
 
		 add5 = {1'b0,seq_item_sb.src1[6:4]};
		 add6 = {1'b0,seq_item_sb.src2[6:4]};
		 add7 = {1'b0,1'b0,1'b0,add4[4]};
		 add8 = add5+add6+add7;
 
		 add9 = {1'b0,seq_item_sb.src1[7]};
		 adda = {1'b0,seq_item_sb.src2[7]};
		 addb = {1'b0,add8[3]};
		 addc = add9+adda+addb;
 

		 sub1 = {1'b1,seq_item_sb.src1[3:0]};
		 sub2 = {1'b0,seq_item_sb.src2[3:0]};
		 sub3 = {1'b0,1'b0,1'b0,seq_item_sb.srcCy};
		 sub4 = sub1-sub2-sub3;
 
		 sub5 = {1'b1,seq_item_sb.src1[6:4]};
		 sub6 = {1'b0,seq_item_sb.src2[6:4]};
		 sub7 = {1'b0,1'b0,1'b0, !sub4[4]};
		 sub8 = sub5-sub6-sub7;
 
		 sub9 = {1'b1,seq_item_sb.src1[7]};
		 suba = {1'b0,seq_item_sb.src2[7]};
		 subb = {1'b0,!sub8[3]};
		 subc = sub9-suba-subb;
 
		 sub_result = {subc[0],sub8[2:0],sub4[3:0]};
 

		 inc = {seq_item_sb.src2, seq_item_sb.src1} + {15'h0, 1'b1};
		 dec = {seq_item_sb.src2, seq_item_sb.src1} - {15'h0, 1'b1};
	   
		case (seq_item_sb.op_code) 
			//operation add
			`OC8051_ALU_ADD: begin
			des_acc_ref = {addc[0],add8[2:0],add4[3:0]};
			des1_ref = seq_item_sb.src1;
			des2_ref = seq_item_sb.src3+ {7'b0, addc[1]};
			desCy_ref = addc[1];
			desAc_ref = add4[4];
			desOv_ref = addc[1] ^ add8[3];
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			//operation subtract
			`OC8051_ALU_SUB: begin
			des_acc_ref = sub_result_ref;
			des1_ref = 8'h00;
			des2_ref = 8'h00;
			desCy_ref = !subc[1];
			desAc_ref = !sub4[4];
			desOv_ref = !subc[1] ^ !sub8[3];
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			//operation decimal adjustment
			`OC8051_ALU_DA: begin
 
			if (seq_item_sb.srcAc==1'b1 | seq_item_sb.src1[3:0]>4'b1001)
				{da_tmp, des_acc_ref[3:0]} = {1'b0, seq_item_sb.src1[3:0]}+ 5'b00110;
			else 
				{da_tmp, des_acc_ref[3:0]} = {1'b0, seq_item_sb.src1[3:0]};
 
			if (seq_item_sb.srcCy | da_tmp | seq_item_sb.src1[7:4]>4'b1001)
				{da_tmp1, des_acc_ref[7:4]} = {seq_item_sb.srcCy, seq_item_sb.src1[7:4]}+ 5'b00110 + {4'b0, da_tmp};
			else 
				{da_tmp1, des_acc_ref[7:4]} = {seq_item_sb.srcCy, seq_item_sb.src1[7:4]} + {4'b0, da_tmp};
 
			desCy_ref = da_tmp | da_tmp1;
			des1_ref = seq_item_sb.src1;
			des2_ref = 8'h00;
			desAc_ref = 1'b0;
			desOv_ref = 1'b0;
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			//operation not
			// bit operation not
			`OC8051_ALU_NOT: begin
			des_acc_ref = ~seq_item_sb.src1;
			des1_ref = ~seq_item_sb.src1;
			des2_ref = 8'h00;
			desCy_ref = !seq_item_sb.srcCy;
			desAc_ref = 1'b0;
			desOv_ref = 1'b0;
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			//operation and
			//bit operation and
			`OC8051_ALU_AND: begin
			des_acc_ref = seq_item_sb.src1 & seq_item_sb.src2;
			des1_ref = seq_item_sb.src1 & seq_item_sb.src2;
			des2_ref = 8'h00;
			desCy_ref = seq_item_sb.srcCy & seq_item_sb.bit_in;
			desAc_ref = 1'b0;
			desOv_ref = 1'b0;
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			//operation xor
			// bit operation xor
			`OC8051_ALU_XOR: begin
			des_acc_ref = seq_item_sb.src1 ^ seq_item_sb.src2;
			des1_ref = seq_item_sb.src1 ^ seq_item_sb.src2;
			des2_ref = 8'h00;
			desCy_ref = seq_item_sb.srcCy ^ seq_item_sb.bit_in;
			desAc_ref = 1'b0;
			desOv_ref = 1'b0;
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			//operation or
			// bit operation or
			`OC8051_ALU_OR: begin
			des_acc_ref = seq_item_sb.src1 | seq_item_sb.src2;
			des1_ref = seq_item_sb.src1 | seq_item_sb.src2;
			des2_ref = 8'h00;
			desCy_ref = seq_item_sb.srcCy | seq_item_sb.bit_in;
			desAc_ref = 1'b0;
			desOv_ref = 1'b0;
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			//operation rotate left
			// bit operation cy= cy or (not ram)
			`OC8051_ALU_RL: begin
			des_acc_ref = {seq_item_sb.src1[6:0], seq_item_sb.src1[7]};
			des1_ref = seq_item_sb.src1 ;
			des2_ref = 8'h00;
			desCy_ref = seq_item_sb.srcCy | !seq_item_sb.bit_in;
			desAc_ref = 1'b0;
			desOv_ref = 1'b0;
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			//operation rotate left with carry and swap nibbles
			`OC8051_ALU_RLC: begin
			des_acc_ref = {seq_item_sb.src1[6:0], seq_item_sb.srcCy};
			des1_ref = seq_item_sb.src1 ;
			des2_ref = {seq_item_sb.src1[3:0], seq_item_sb.src1[7:4]};
			desCy_ref = seq_item_sb.src1[7];
			desAc_ref = 1'b0;
			desOv_ref = 1'b0;
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			//operation rotate right
			`OC8051_ALU_RR: begin
			des_acc_ref = {seq_item_sb.src1[0], seq_item_sb.src1[7:1]};
			des1_ref = seq_item_sb.src1 ;
			des2_ref = 8'h00;
			desCy_ref = seq_item_sb.srcCy & !seq_item_sb.bit_in;
			desAc_ref = 1'b0;
			desOv_ref = 1'b0;
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			//operation rotate right with carry
			`OC8051_ALU_RRC: begin
			des_acc_ref = {seq_item_sb.srcCy, seq_item_sb.src1[7:1]};
			des1_ref = seq_item_sb.src1 ;
			des2_ref = 8'h00;
			desCy_ref = seq_item_sb.src1[0];
			desAc_ref = 1'b0;
			desOv_ref = 1'b0;
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			//operation pcs Add
			`OC8051_ALU_INC: begin
			if (seq_item_sb.srcCy) begin
				des_acc_ref = dec[7:0];
				des1_ref = dec[7:0];
				des2_ref = dec[15:8];
			end
			else begin
				des_acc_ref = inc[7:0];
				des1_ref = inc[7:0];
				des2_ref = inc[15:8];
			end
			desCy_ref = 1'b0;
			desAc_ref = 1'b0;
			desOv_ref = 1'b0;
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			//operation exchange
			//if carry = 0 exchange low order digit
			`OC8051_ALU_XCH: begin
			if (seq_item_sb.srcCy)
			begin
				des_acc_ref = seq_item_sb.src2;
				des1_ref = seq_item_sb.src2;
				des2_ref = seq_item_sb.src1;
			end 
			else begin
				des_acc_ref = {seq_item_sb.src1[7:4],seq_item_sb.src2[3:0]};
				des1_ref = {seq_item_sb.src1[7:4],seq_item_sb.src2[3:0]};
				des2_ref = {seq_item_sb.src2[7:4],seq_item_sb.src1[3:0]};
			end
			desCy_ref = 1'b0;
			desAc_ref = 1'b0;
			desOv_ref = 1'b0;
			enable_mul = 1'b0;
			enable_div = 1'b0;
			end
			`OC8051_ALU_NOP: begin
			des_acc_ref = seq_item_sb.src1;
			des1_ref = seq_item_sb.src1;
			des2_ref = seq_item_sb.src2;
			desCy_ref = seq_item_sb.srcCy;
			desAc_ref = seq_item_sb.srcAc;
			desOv_ref = 1'b0;
			enable_mul = 1'b0;
			enable_div = 1'b0;
    end
  endcase

  

  
	endtask
   
    
    function void report_phase(uvm_phase  phase);
        super.report_phase(phase);
        `uvm_info("report_phase", $sformatf("total succesful transactions: %0d",correct_count),UVM_MEDIUM);
      	`uvm_info("report_phase", $sformatf("total failled transactions: %0d",error_count),UVM_MEDIUM);	
	endfunction
	
  endclass
endpackage	
