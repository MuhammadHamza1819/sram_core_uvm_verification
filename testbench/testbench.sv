`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
`include "base_test.sv"

module tb_top;
  bit PCLK;
  bit PRESETn = 1;
  always #2 PCLK = ~PCLK;
  
  initial begin
    //clk = 0;
    PRESETn = 0;
    #5; 
    PRESETn = 1;
  end

  apb_if vif(PCLK, PRESETn);
  
  apb_sram DUT
  (
   .PCLK(vif.PCLK),
   .PRESETn(vif.PRESETn),
   .PSEL(vif.PSEL),
   .PENABLE(vif.PENABLE),
   .PWRITE(vif.PWRITE),
   .PADDR(vif.PADDR),
   .PWDATA(vif.PWDATA),
   .PRDATA(vif.PRDATA),
   .PREADY(vif.PREADY),
   .PSLVERR(vif.PSLVERR)
   
  );
  
  initial begin
    // set interface in config_db
    uvm_config_db#(virtual apb_if)::set(uvm_root::get(), "*", "vif", vif);
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end
  initial begin
    run_test("base_test");
//     run_test("directed_test");
//     run_test("error_resp_test");
      // run _test("random_test");
    //  run _test("cover_missing_test");
 
  end
endmodule