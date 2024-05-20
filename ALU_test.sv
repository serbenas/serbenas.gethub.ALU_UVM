package ALU_test_pkg;

import ALU_config_pkg::*;
import ALU_env_pkg::*;
import ALU_main_sequence_pkg::*;
import ALU_reset_sequence_pkg::*;
import ALU_agent_pkg::*;
import ALU_scoreboard_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALU_test extends uvm_test;
  `uvm_component_utils(ALU_test)
 
  ALU_env env;
  
  ALU_config ALU_cfg;
  
  ALU_main_sequence main_seq;
  ALU_reset_sequence reset_seq;
  
  
  function new (string name ="ALU_test", uvm_component parent= null);
     super.new(name,parent);
  endfunction

  function void build_phase (uvm_phase phase);
     super.build_phase(phase);
  
     env=ALU_env::type_id::create("env",this);
     ALU_cfg= ALU_config::type_id::create("ALU_cfg",this);
     main_seq=ALU_main_sequence::type_id::create("main_seq",this);
     reset_seq= ALU_reset_sequence::type_id::create("reset_seq",this);
	  
	  
	  
    if(!uvm_config_db #(virtual ALU_inf) ::get (this,"","ALU_IF",ALU_cfg.ALU_vif))
      `uvm_fatal("build_phase","test-unable to get virtual interface of FIFO");
	
    uvm_config_db #(ALU_config)	::set(this,"*","CFG",ALU_cfg);
 
   endfunction
 
  task run_phase(uvm_phase phase);
     super.run_phase(phase);
     phase.raise_objection(this);
 
    

    //resetfuction
   `uvm_info("run_phase", "reset_asserted",UVM_LOW)
    reset_seq.start(env.agt.sqr);
   `uvm_info("run_phase", "reset_deasserted",UVM_LOW)
  
    //main sequence
   `uvm_info("run_phase", "main_seq_asserted",UVM_LOW)
    main_seq.start(env.agt.sqr);
   `uvm_info("run_phase", "main_seq_deasserted",UVM_LOW)
   
    
   
     phase.drop_objection(this);
   
  endtask
 endclass
endpackage