#=========================================
# Project Settings
#=========================================

WORK = work

RTL = ../rtl/*.v ../rtl/*.sv
ABV = ../Assertions/*.sv

SVTB1 = ../tb/top.sv
SVTB2 = ../test/test_pkg.sv

INC = \
+incdir+../rtl \
+incdir+../tb \
+incdir+../test \
+incdir+../wr_agt_top \
+incdir+../rd_agt_top \
+incdir+../assertion

#=========================================
# Simulation Options
#=========================================

VSIMOPT  = -vopt -voptargs=+acc
VSIMCOV  = -coverage -sva

VSIMBATCH1 = -c -do "log -r /*; coverage save -onexit mem_cov1; run -all; quit -f"
VSIMBATCH2 = -c -do "log -r /*; coverage save -onexit mem_cov2; run -all; quit -f"
VSIMBATCH3 = -c -do "log -r /*; coverage save -onexit mem_cov3; run -all; quit -f"
VSIMBATCH4 = -c -do "log -r /*; coverage save -onexit mem_cov4; run -all; quit -f"

#=========================================
# Help
#=========================================

help:
        @echo "============================================================="
        @echo " clean      : Remove generated files"
        @echo " sv_cmp     : Compile RTL and TB"
        @echo " run_test   : Run SMALL_PACKET_TEST"
        @echo " run_test1  : Run MEDIUM_PACKET_TEST"
        @echo " run_test2  : Run LARGE_PACKET_TEST"
        @echo " run_test3  : Run ERROR_PACKET_TEST"
        @echo " regress    : Run all tests"
        @echo " report     : Merge coverage"
        @echo " cov_html   : Open HTML coverage"
        @echo " cov_txt    : Coverage report in terminal"
        @echo "============================================================="

#=========================================
# Compile
#=========================================

sv_cmp:
        vlib $(WORK)
        vmap work $(WORK)

        vlog -mfcu -work $(WORK) \
        $(RTL) \
        $(ABV) \
        $(INC) \
        $(SVTB2) \
        $(SVTB1)

#=========================================
# Test-1 (Small Packet)
#=========================================

run_test: sv_cmp
        vsim \
        -cvgperinstance \
        $(VSIMOPT) \
        $(VSIMCOV) \
        $(VSIMBATCH1) \
        -wlf wave_file1.wlf \
        -l test1.log \
        -sv_seed 1039716597 \
        work.top \
        +UVM_TESTNAME=test1

        vcover report \
        -cvg \
        -details \
        -nocompactcrossbins \
        -codeAll \
        -assert \
        -directive \
        -html mem_cov1

#=========================================
# Test-2 (Medium Packet)
#=========================================

run_test1: sv_cmp
        vsim \
        -cvgperinstance \
        $(VSIMOPT) \
        $(VSIMCOV) \
        $(VSIMBATCH2) \
        -wlf wave_file2.wlf \
        -l test2.log \
        -sv_seed 1528354628 \
        work.top \
        +UVM_TESTNAME=test2

        vcover report \
        -cvg \
        -details \
        -nocompactcrossbins \
        -codeAll \
        -assert \
        -directive \
        -html mem_cov2

#=========================================
# Test-3 (Large Packet)
#=========================================

run_test2: sv_cmp
        vsim \
        -cvgperinstance \
        $(VSIMOPT) \
        $(VSIMCOV) \
        $(VSIMBATCH3) \
        -wlf wave_file3.wlf \
        -l test3.log \
        -sv_seed 3254310782 \
        work.top \
        +UVM_TESTNAME=test3

        vcover report \
        -cvg \
        -details \
        -nocompactcrossbins \
        -codeAll \
        -assert \
        -directive \
        -html mem_cov3

#=========================================
# Test-4 (Error Packet)
#=========================================

run_test3: sv_cmp
        vsim \
        -cvgperinstance \
        $(VSIMOPT) \
        $(VSIMCOV) \
        $(VSIMBATCH4) \
        -wlf wave_file4.wlf \
        -l test4.log \
        -sv_seed random \
        work.top \
        +UVM_TESTNAME=test4

        vcover report \
        -cvg \
        -details \
        -nocompactcrossbins \
        -codeAll \
        -assert \
        -directive \
        -html mem_cov4

#=========================================
# Regression
#=========================================

regress: clean run_test run_test1 run_test2 run_test3 report

#=========================================
# Merge Coverage
#=========================================

report:
        vcover merge mem_cov mem_cov1 mem_cov2 mem_cov3 mem_cov4
        vcover report \
        -cvg \
        -details \
        -nocompactcrossbins \
        -codeAll \
        -assert \
        -directive \
        -html mem_cov

#=========================================
# Coverage Viewer
#=========================================

cov_html:
        firefox covhtmlreport/index.html &

cov_txt:
        vcover report -details mem_cov

#=========================================
# Clean
#=========================================

clean:
        rm -rf \
        work \
        transcript* \
        *.log \
        *.wlf \
        mem_cov* \
        covhtmlreport \
        modelsim.ini

        clear
