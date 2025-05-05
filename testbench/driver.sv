class driver extends uvm_driver#(seq_item);
  virtual apb_if vif;
  `uvm_component_utils(driver)

  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Not set at top level")
  endfunction

  task wait_for_reset_release();
    wait(!vif.PRESETn);

    vif.PENABLE <= 1;
    vif.PWRITE  <= 0;
    vif.PSEL    <= 1;
    vif.PADDR   <= 0;
    vif.PWDATA  <= 0;

    #5;
    vif.PENABLE <= 0;
    vif.PSEL    <= 0;

    `uvm_info(get_type_name(), "Reset Released", UVM_LOW)
  endtask

  task do_write(seq_item req);
    
    @(posedge vif.PCLK);
    #5;
    vif.PADDR  <= req.PADDR;
    vif.PWRITE <= req.PWRITE;
    vif.PSEL   <= req.PSEL;
    vif.PWDATA <= req.PWDATA;

    @(posedge vif.PCLK);
// 
    vif.PSEL   <= req.PSEL;
    vif.PENABLE <= req.PENABLE;
    
    @(posedge vif.PCLK);
    
     wait(vif.PREADY);
    
    @(posedge vif.PCLK);

    if(vif.PENABLE)
      begin
		vif.PENABLE <= 0;
    	vif.PSEL    <= 0;		
    `uvm_info(get_type_name(), "----------------------------------------------------------------------------", UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("REQ: PADDR = %0h, PWDATA = %0h", req.PADDR, req.PWDATA), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("PREADY = %d", vif.PREADY), UVM_LOW)
    `uvm_info(get_type_name(), "WRITE transaction_complete!", UVM_LOW)
    `uvm_info(get_type_name(), "----------------------------------------------------------------------------", UVM_LOW)
      end 
    
  endtask

  task do_read(seq_item req);
    @(posedge vif.PCLK);
    
    `uvm_info(get_type_name(), "----------------------------------------------------------------------------", UVM_LOW)
    `uvm_info(get_type_name(), "READ transaction_start!", UVM_LOW)

    vif.PADDR  <= req.PADDR;
    vif.PWRITE <= req.PWRITE;
    vif.PSEL   <= 1;

    @(posedge vif.PCLK);
    vif.PSEL   <= 1;
    vif.PENABLE <= 1;
    
    @(posedge vif.PCLK);
    
     wait(vif.PREADY);
    
    @(posedge vif.PCLK);

    if(vif.PENABLE)
      begin
		vif.PENABLE <= 0;
    	vif.PSEL    <= 0;		
      end 
    
  endtask
    
    

  task run_phase(uvm_phase phase);
	    
		wait_for_reset_release();  
    
    forever begin
      @(posedge vif.PCLK);
      seq_item_port.get_next_item(req);   ///this method blocks untill the sequence is available
   	
      if(req.PWRITE)
        do_write(req);
      
      @(posedge vif.PCLK);
	  
      if(!req.PWRITE)
      	do_read(req);
     
      seq_item_port.item_done();
    
    
      
    end
  endtask

endclass
