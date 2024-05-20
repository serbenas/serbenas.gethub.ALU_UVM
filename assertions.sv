module assertions (
 
  input        srcCy, srcAc, bit_in, clk, rst,
  input        [3:0] op_code,
  input        [7:0] src1, src2, src3,
  input        desCy, desAc, desOv,
  input        [7:0] des1, des2, des_acc, sub_result
 );
  
assert property(@(posedge clk) disable iff (rst) (op_code==4'b0001) |-> ( des1 == src1 && DUT.enable_mul==1'b0 && DUT.enable_div==1'b0)); 
assertion_addition: cover property(@(posedge clk) disable iff (rst) (op_code==4'b0001) |-> ( des1 == src1 && DUT.enable_mul==1'b0 && DUT.enable_div==1'b0)); 


assert property(@(posedge clk) disable iff (rst) (op_code==4'b0010) |-> 
                                                 (  des_acc == sub_result && des1==8'b00 && des2==8'b00&& DUT.enable_mul==1'b0 && DUT.enable_div==1'b0));
												 
assertion_subtraction: cover property(@(posedge clk) disable iff (rst) (op_code==4'b0010) |-> 
                                                 (  des_acc == sub_result&& des1==8'b00 &&des2==8'b00&& DUT.enable_mul==1'b0 && DUT.enable_div==1'b0));
 
assert property(@(posedge clk) disable iff (rst) (op_code==4'b0101 && (srcAc==1'b1 | src1[3:0]>4'b1001)) |->
                                                                                 ( {DUT.da_tmp, des_acc[3:0]} == {1'b0, src1[3:0]}+ 5'b00110));
																				 
assertion_DA: cover property(@(posedge clk) disable iff (rst) (op_code==4'b0101 && (srcAc==1'b1 | src1[3:0]>4'b1001)) |-> 
                                                                                 ( {DUT.da_tmp, des_acc[3:0]} == {1'b0, src1[3:0]}+ 5'b00110));

assert property(@(posedge clk) disable iff (rst) (op_code==4'b0110 ) |-> 
 ( des_acc ==~src1&& des1== ~src1 && des2 == 8'h00 && desCy == !srcCy && desAc == 1'b0 && desOv == 1'b0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0));
   
assertion_NOT: cover property(@(posedge clk) disable iff (rst) (op_code==4'b0110 ) |-> 
 ( des_acc ==~src1&& des1== ~src1 && des2 == 8'h00 &&  desCy == !srcCy  && desAc == 1'b0 && desOv == 1'b0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0));

assert property(@(posedge clk) disable iff (rst) (op_code==4'b0111 ) |-> 
 (des_acc == (src1 &src2) && des2 == 8'h00 && desCy == (srcCy & bit_in ) && desAc == 1'b0 && desOv == 1'b0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0));
 
assertion_AND: cover property(@(posedge clk) disable iff (rst) (op_code==4'b0111 ) |->
 (des_acc == (src1 & src2) && des2 == 8'h00 && desCy == (srcCy & bit_in) && desAc == 1'b0 && desOv == 1'b0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0));

assert property(@(posedge clk) disable iff (rst) (op_code==4'b1000 ) |-> 
 (des_acc == (src1 ^ src2) &&des1 == (src1 ^ src2) && des2 == 8'h00 && desCy == (srcCy ^ bit_in) && desAc == 1'b0 && desOv == 1'b0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0));
 
assertion_XOR: cover property(@(posedge clk) disable iff (rst) (op_code==4'b1000 ) |->
 (des_acc == (src1 ^ src2) &&des1 == (src1 ^ src2) && des2 == 8'h00 && desCy ==  (srcCy ^ bit_in) && desAc == 1'b0 && desOv == 1'b0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0));

assert property(@(posedge clk) disable iff (rst) (op_code==4'b1001 ) |-> 
 (des_acc == ( src1 | src2) && des2 == 8'h00 && desCy == (srcCy | bit_in) && desAc == 1'b0 && desOv == 1'b0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0));
 
assertion_OR: cover property(@(posedge clk) disable iff (rst) (op_code==4'b1001 ) |->
 (des_acc == ( src1 | src2) && des2 == 8'h00 && desCy == (srcCy | bit_in) && desAc == 1'b0 && desOv == 1'b0 && DUT.enable_mul == 1'b0 && DUT.enable_div == 1'b0));


endmodule
