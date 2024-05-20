package  ALU_seq_item_pkg;
 
  import uvm_pkg::*;
 `include "uvm_macros.svh"
 class ALU_seq_item extends uvm_sequence_item;
  `uvm_object_utils(ALU_seq_item )
  
  rand  bit   srcCy, srcAc, bit_in,rst;
  rand  bit   [3:0] op_code;
  rand  bit   [7:0] src1, src2, src3;

   
  logic        desCy, desAc, desOv;
  logic        [7:0] des1, des2, des_acc, sub_result;
 
  // constraints 
  
  constraint n1 {rst dist {1:=2, 0:=98}; 
                 op_code inside{4'b0000 ,4'b0001,4'b0010,4'b0101,4'b0110,4'b0111,4'b1000,4'b1001,4'b1010,
				                                                  4'b1011,4'b1100,4'b1101,4'b1110,4'b1111};
				 }

  function new(string name="ALU_seq_item ");
    super.new(name);
  endfunction

  //print function
  function string convert2string();
    return $sformatf("%s  rst=0b%b,srcCy=0b%b, srcAc=0b%b, bit_in=0b%b, opcode=0b%b, src1=0b%b, src2=0b%b, src3=0b%b,  desCy=0b%b, desAc=0b%b ,desOv=0b%b, des1=0b%b ,des2=0b%b ,des_acc=0b%b, sub_result=0b%b ",super.convert2string(),rst,srcCy, srcAc, bit_in, op_code, src1, src2, src3,  desCy, desAc ,desOv, des1 ,des2 ,des_acc, sub_result);
  endfunction
   
  function string convert2string_stimulus();
    return $sformatf("  rst=0b%b,srcCy=0b%b, srcAc=0b%b, bit_in=0b%b, opcode=0b%b, src1=0b%b, src2=0b%b, src3=0b%b,  desCy=0b%b, desAc=0b%b ,desOv=0b%b, des1=0b%b ,des2=0b%b ,des_acc=0b%b, sub_result=0b%b",rst,srcCy, srcAc, bit_in, op_code, src1, src2, src3,  desCy, desAc ,desOv, des1 ,des2 ,des_acc, sub_result);
  endfunction
 
  endclass
  endpackage 
  
  
  
  