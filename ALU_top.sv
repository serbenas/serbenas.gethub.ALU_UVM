import ALU_test_pkg ::*;
import uvm_pkg ::*;
`include "uvm_macros.svh"
`include "oc8051_timescale.v"
module ALU_top ();

 bit clk;
  initial begin
   forever #1 clk=~clk;
 end
 
  ALU_inf ALU_if(clk);
  
  oc8051_alu   DUT(  .clk          (clk),
                     .srcCy          (ALU_if.srcCy),
                     .srcAc          (ALU_if.srcAc),
                     .bit_in        (ALU_if. bit_in),
                     .rst            (ALU_if.rst),
                     .op_code        (ALU_if.op_code),
                     .src1           (ALU_if.src1),
				     .src2           (ALU_if.src2),
				     .src3           (ALU_if.src3),
				     .desCy          (ALU_if.desCy),
				     .desAc          (ALU_if.desAc),
				     .desOv          (ALU_if.desOv),
				     .des1           (ALU_if.des1),
				     .des2           (ALU_if.des2),
				     .des_acc        (ALU_if.des_acc),
				     .sub_result     (ALU_if.sub_result));
					 
					 
//assertions
 assertions asr(     .clk          (clk),
                     .srcCy          (DUT.srcCy),
                     .srcAc          (DUT.srcAc),
                     .bit_in         (DUT. bit_in),
                     .rst            (DUT.rst),
                     .op_code        (DUT.op_code),
                     .src1           (DUT.src1),
				     .src2           (DUT.src2),
				     .src3           (DUT.src3),
				     .desCy          (DUT.desCy),
				     .desAc          (DUT.desAc),
				     .desOv          (DUT.desOv),
				     .des1           (DUT.des1),
				     .des2           (DUT.des2),
				     .des_acc        (DUT.des_acc),
				     .sub_result     (DUT.sub_result));
    

 
 initial begin
 uvm_config_db#(virtual ALU_inf) ::set (null, "uvm_test_top", "ALU_IF",ALU_if);
  run_test ("ALU_test");
 end
endmodule 


