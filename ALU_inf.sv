interface ALU_inf (clk);
 
  input bit  clk ;

  logic        srcCy, srcAc, bit_in, rst;
  logic  [3:0] op_code;
  logic  [7:0] src1, src2, src3;
  logic        desCy, desAc, desOv;
  logic  [7:0] des1, des2, des_acc, sub_result;
 

endinterface 