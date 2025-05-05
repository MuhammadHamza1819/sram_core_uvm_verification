`include "package.sv"

////////////////////////////////////////////////////base_test/////////////////////////////////////////////////////////////////


class base_test extends uvm_test;
  env env_o;
  base_seq bseq;
  `uvm_component_utils(base_test)
  
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = env::type_id::create("env_o", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    uvm_objection obj;
    

    obj = phase.get_objection();
    obj.set_drain_time(this,10ns);
        
    phase.raise_objection(this);
    bseq = base_seq::type_id::create("bseq");
     
    bseq.start(env_o.agt.seqr);
       
    phase.drop_objection(this);
    `uvm_info(get_type_name, "End of testcase", UVM_LOW);
  endtask
endclass

/////////////////////////////////////////////////directed_test////////////////////////////////////////////////////////////////////

class directed_test extends uvm_test;
  env env_o;
  directed_seq dseq;

  `uvm_component_utils(directed_test)

  function new(string name = "directed_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = env::type_id::create("env_o", this);
  endfunction

  task run_phase(uvm_phase phase);
    
    uvm_objection obj;
    

    obj = phase.get_objection();
    obj.set_drain_time(this,10ns);
    
    
    phase.raise_objection(this);    
    
    dseq = directed_seq::type_id::create("dseq");
        
    dseq.start(env_o.agt.seqr);

    phase.drop_objection(this);
    `uvm_info(get_type_name(), "Directed Test Completed", UVM_LOW);
  endtask
endclass

//////////////////////////////////////////// error response test  ///////////////////////////////////////////////////////

class error_resp_test extends uvm_test;
  env env_o;
  error_resp_seq eseq;
  
  `uvm_component_utils(error_resp_test)
  

  function new(string name = "error_resp_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = env::type_id::create("env_o", this);
  endfunction

  task run_phase(uvm_phase phase);

    uvm_objection obj;
    

    obj = phase.get_objection();
    obj.set_drain_time(this,10ns);
    
    
    phase.raise_objection(this);  
    
    eseq = error_resp_seq::type_id::create("eseq");
   
    eseq.start(env_o.agt.seqr);
      
    phase.drop_objection(this);
    `uvm_info(get_type_name(), "error_resp_test Completed", UVM_LOW);
  endtask
  
endclass

/////////////////////////////////////////////////////////////////////////////////

class random_test extends uvm_test;
  env env_o;
  random_seq rseq;
  
  `uvm_component_utils(random_test)
  

  function new(string name = "random_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = env::type_id::create("env_o", this);
  endfunction

  task run_phase(uvm_phase phase);

    uvm_objection obj;
    

    obj = phase.get_objection();
    obj.set_drain_time(this,10ns);
    
    
    phase.raise_objection(this);  
    
    rseq = random_seq::type_id::create("rseq");
   
    rseq.start(env_o.agt.seqr);
      
    phase.drop_objection(this);
    `uvm_info(get_type_name(), "random_test Completed", UVM_LOW);
  endtask
  
endclass


class cover_missing_test extends uvm_test;
  env env_o;
  cover_missing_seq cseq;
  
  `uvm_component_utils(cover_missing_test)
  

  function new(string name = "cover_missing_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = env::type_id::create("env_o", this);
  endfunction

  task run_phase(uvm_phase phase);

    uvm_objection obj;
    

    obj = phase.get_objection();
    obj.set_drain_time(this,10ns);
    
    
    phase.raise_objection(this);  
    
    cseq = cover_missing_seq::type_id::create("cseq");
   
    cseq.start(env_o.agt.seqr);
      
    phase.drop_objection(this);
    `uvm_info(get_type_name(), "cover_missing_test Completed", UVM_LOW);
  endtask
  
endclass