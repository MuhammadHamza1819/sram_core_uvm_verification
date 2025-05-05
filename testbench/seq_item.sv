class seq_item extends uvm_sequence_item;

randc bit [`ADDR_BUS_WIDTH-1:0] PADDR;
randc bit [`DATA_BUS_WIDTH-1:0] PWDATA;
randc  bit   PWRITE;

randc bit   PSEL;
randc bit   PENABLE;
  
  bit [`DATA_BUS_WIDTH-1:0]PRDATA;
  bit PREADY;
  bit PSLVERR;

  function new(string name = "seq_item");
    super.new(name);
  endfunction

`uvm_object_utils_begin(seq_item)
  `uvm_field_int(PSEL,    UVM_ALL_ON)
  `uvm_field_int(PADDR,   UVM_ALL_ON)
  `uvm_field_int(PWDATA,  UVM_ALL_ON)
  `uvm_field_int(PENABLE, UVM_ALL_ON)
  `uvm_field_int(PWRITE,  UVM_ALL_ON)
  `uvm_field_int(PRDATA,  UVM_ALL_ON)   
  `uvm_field_int(PREADY,  UVM_ALL_ON)   
  `uvm_field_int(PSLVERR, UVM_ALL_ON)   
`uvm_object_utils_end

//   constraint addr_c {PADDR < 63;}
endclass
