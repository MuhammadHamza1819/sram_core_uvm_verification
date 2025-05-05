/////////// 

// you changed the index value according to your requirement !!

	// if byte_addressable memory then       Index_value = 4
	// if half_word_addressable memory then  Index_value = 2
	// if word_addressable memory then       Index_value = 1

///////////////////////////////

`define index_value 1

/////////////////////////////////////////////////base_test//////////////////////

class base_seq extends uvm_sequence#(seq_item);
  seq_item req;
    
  int num_writes = 63;
  int num_reads = 63;
  int data_val = 800;
  
  `uvm_object_utils(base_seq)
  
  function new (string name = "base_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Running Base Sequence", UVM_LOW);

    for (int i = 0; i <= num_writes; i = i + `index_value) begin
      `uvm_do_with(req, {
        
        req.PADDR == i;
        // req.PWDATA <= data_val;
        req.PWRITE == 1;
        req.PSEL == 1;                        // PSEL active
        req.PENABLE == 1;                     // PENABLE active

      });
    end

    for (int i = 0; i <= num_reads; i = i +`index_value) begin
      `uvm_do_with(req, {
        req.PADDR == i;
        req.PWRITE == 0;
        req.PSEL == 1;                        // PSEL active
        req.PENABLE == 1;                     // PENABLE active

      });
    end
    
  endtask

endclass

///////////directed_test/////////////////////////////


class directed_seq extends uvm_sequence#(seq_item);
  seq_item req;
  int address = 4;
  int num_writes = 32;
  int data_val = 800; 
  
  `uvm_object_utils(directed_seq)
  
  function new(string name = "directed_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Running Directed Sequence", UVM_LOW);

   for (int i = 0; i <= num_writes; i = i + `index_value) begin
      `uvm_do_with(req, {
        
        req.PADDR == i;
        // req.PWDATA <= data_val;
        req.PWRITE == 1;
        req.PSEL == 1;                        // PSEL active
        req.PENABLE == 1;                     // PENABLE active

        
      });
    end
   	
    `uvm_do_with(req, {req.PADDR == address ; req.PWRITE == 0; req.PSEL == 1; req.PENABLE == 1;}) 	
    
  endtask
endclass


///////////////////////error response test/////////////////////////////////////////////////////

class error_resp_seq extends uvm_sequence#(seq_item);
  seq_item req;
  `uvm_object_utils(error_resp_seq)
  
  function new (string name = "error_resp_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "error sequence : Inside Body", UVM_LOW);
    repeat(5)
      begin
        `uvm_do_with(req, {
          req.PADDR > 63;  
          req.PSEL == 1;                        // PSEL active
          req.PENABLE == 1;                     // PENABLE active
          req.PWRITE == 1;});
      end 
    repeat(5) begin 
      `uvm_do_with(req, {req.PADDR >= 64; req.PWRITE == 0;req.PSEL == 1; req.PENABLE == 1;});
      end

  endtask
endclass

class random_seq extends uvm_sequence#(seq_item);
  seq_item req;

  `uvm_object_utils(random_seq)

  function new(string name = "random_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Running Random Sequence", UVM_LOW);

    repeat(5) begin   
      `uvm_do_with(req, {
        req.PADDR inside {[0:25'h1FFFFFF]};   // Full 25-bit random address
        req.PWDATA inside {[0:32'hFFFFFFFF]}; // Random 32-bit data
        req.PWRITE inside {0,1};              // Randomly read(0) ya write(1)
        req.PSEL == 1;                        // PSEL active
        req.PENABLE == 1;                     // PENABLE active
      });
    end
 
    // repeat (5)
    // begin
    //   // PSEL = 1, PENABLE = 0
    //   `uvm_do_with(req, { req.PSEL == 1; req.PENABLE == 0; });

    //   // PSEL = 0, PENABLE = 1
    //   `uvm_do_with(req, { req.PSEL == 0; req.PENABLE == 1; });
    // end
  endtask
endclass


class cover_missing_seq extends uvm_sequence#(seq_item);
  seq_item req;
  `uvm_object_utils(cover_missing_seq)

  function new(string name = "cover_missing_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Running Cover Missing Sequence", UVM_LOW);

    // PSEL = 1, PENABLE = 0
    `uvm_do_with(req, { req.PSEL == 1; req.PENABLE == 0; });

    // PSEL = 0, PENABLE = 1
    `uvm_do_with(req, { req.PSEL == 0; req.PENABLE == 1; });
  endtask
endclass



