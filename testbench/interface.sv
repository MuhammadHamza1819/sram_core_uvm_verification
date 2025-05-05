`define ADDR_BUS_WIDTH 32        // Width of Address bus i.e. PADDR
`define DATA_BUS_WIDTH 32        // Width of Data bus (i.e. PWDATA and PRDATA)

interface apb_if (input logic PCLK, PRESETn);
  
  logic PSEL;
  logic PENABLE;
  logic PWRITE;
  logic [`ADDR_BUS_WIDTH-1:0]    PADDR;
  logic [`DATA_BUS_WIDTH-1:0]    PWDATA;
  logic [`DATA_BUS_WIDTH-1:0]    PRDATA;
  logic PREADY;
  logic PSLVERR;

  covergroup cg @(posedge PCLK);
    c1: coverpoint PADDR { bins       b1 = {[0:50]};
                           bins       b2 = {[51:100]};
                           ignore_bins b3 = {[101:$]};
                         }

    c2: coverpoint PWDATA{ bins b1 = {[0:100]};
                           bins b2 = {[101:300]};
                           ignore_bins b3 = {[301:$]};
                          } 

    c3: coverpoint PRDATA { bins b1 = {[0:100]};
                            bins b2 = {[101:300]};
                            ignore_bins b3 = {[301:$]};
                          }                                          
  endgroup : cg
  
  cg cover_inst = new();

  // cover_inst.sample();
endinterface
