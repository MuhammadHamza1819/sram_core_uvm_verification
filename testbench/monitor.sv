class monitor extends uvm_monitor;
  virtual apb_if vif;
  seq_item mon_item;

  uvm_analysis_port #(seq_item) item_collect_port;

  `uvm_component_utils(monitor)

  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
    item_collect_port = new("item_collect_port", this);
    mon_item = new(); // new object per transaction

  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Interface not set using config_db");
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    wait (vif.PRESETn == 1);
    forever begin
      
      @(posedge vif.PCLK);
      
      if (vif.PSEL && vif.PENABLE) begin
		
        mon_item.PADDR   = vif.PADDR;
        mon_item.PWRITE  = vif.PWRITE;
        mon_item.PENABLE = vif.PENABLE;
        mon_item.PSEL    = vif.PSEL;
  		
        
      @(posedge vif.PCLK);
      
        wait(vif.PREADY);

        mon_item.PREADY  = vif.PREADY;
        
      @(posedge vif.PCLK);
        if (vif.PWRITE && vif.PREADY && vif.PSEL) begin
          mon_item.PWDATA = vif.PWDATA;
          `uvm_info(get_type_name(), $sformatf("WRITE: PADDR=%0h, PWDATA=%0h", mon_item.PADDR, mon_item.PWDATA), UVM_LOW);
        end else if(!vif.PWRITE )
          begin
          mon_item.PRDATA = vif.PRDATA;
          `uvm_info(get_type_name(), $sformatf("READ: PADDR=%0h, PRDATA=%0h", mon_item.PADDR, mon_item.PRDATA), UVM_LOW);
        end

        item_collect_port.write(mon_item);

      end
    end
  endtask

endclass
