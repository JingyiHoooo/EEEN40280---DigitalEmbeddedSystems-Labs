@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.2\\bin
call %xv_path%/xsim TB_AHBgpio_behav -key {Behavioral:sim_gpio:Functional:TB_AHBgpio} -tclbatch TB_AHBgpio.tcl -view C:/Users/lab/Documents/EmbeddedSystems/Tuesday/DES_SoC/Hardware/TB_AHBgpio_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
