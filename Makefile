# Makefile
TEST 		= directed_test
TIME_OUT	= 9200000
SEED        = 123

RTL_DIR = rtl
TB_DIR  = testbench
RTL= $(RTL_DIR)/design.sv
SVTB= $(TB_DIR)/testbench.sv

# to compile the code on vcs, run `make compile` command in the terminal
compile:
	vcs -timescale=1ns/1ps $(RTL) $(SVTB) +incdir+$(RTL_DIR) +incdir+$(TB_DIR) -ntb_opts uvm-1.2 -sverilog -cm line+cond+tgl+fsm -ova_cov -cm_name ${TEST} -LDFLAGS -Wl,--no-as-needed -full64 -debug_all
	cd ./results && rm -rf $(TEST)_build/SEED_$(SEED)
	cd ./results && mkdir -p $(TEST)_build/SEED_$(SEED)
	mv -f csrc* simv* vc_hdrs.h ./results/$(TEST)_build/SEED_$(SEED)/
	cd ./results/$(TEST)_build/SEED_$(SEED) && ./simv +UVM_TESTNAME=${TEST} -cm line+cond+tgl+fsm +UVM_TIMEOUT=${TIME_OUT} ->log_${TEST}_build.log
# for simulation, run `make sim` command in the terminal

# To view waveform, run `make gui` command in the terminal
gui: 
	cd ./results/$(TEST)_build/SEED_$(SEED) && ./simv +UVM_TESTNAME=$(TEST) -cm line+cond+tgl+fsm +UVM_TIMEOUT=${TIME_OUT} -gui/ &	
# More advance make targets
allclean:
	clear
	rm -rf ./results/* 
clean: 
	rm -rf csrc DVEfiles inter.vpd simv simv.daidir simv.vdb tr_db.log ucli.key vc_hdrs.h novas.conf novas_dump.log *.txt *.vdb *.daidir test *.cst *.log 

all:
	make compile TEST=directed_test 
	make compile TEST=base_test 
	make compile TEST=error_resp_test 
	make compile TEST=random_test 
	make compile TEST=cover_missing_test 

dve_cov:
	dve -covdir simv.vdb

code_cov:
	urg -full64 -report ./results/code_coverage_report -dir ./results/*_build/SEED_*/*.vdb
func_cov:
	urg -full64 -report ./results/func_coverage_report -dir ./results/*_build/SEED_*/*.vdb	
func_cov_test:
	urg -full64 -report ./results/func_coverage_report_${TEST} -dir ./results/${TEST}_build/SEED_*/*.vdb	


