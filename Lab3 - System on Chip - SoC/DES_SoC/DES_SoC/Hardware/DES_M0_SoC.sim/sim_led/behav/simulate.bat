@echo off
set xv_path=D:\\Xilinx\\vivado\\Vivado\\2017.2\\bin
call %xv_path%/xsim TB_ledtest_behav -key {Behavioral:sim_led:Functional:TB_ledtest} -tclbatch TB_ledtest.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
