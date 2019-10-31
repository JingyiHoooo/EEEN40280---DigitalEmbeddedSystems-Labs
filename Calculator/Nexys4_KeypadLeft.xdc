# This file is for the Nexys4 rev B board, to define keypad signals for
# 24-key keypad connected to ports JC and JD, on the left side of the board.


#Pmod Header JC
#Bank = 35, Pin name = IO_L23P_T3_35,						Sch name = JC1
set_property PACKAGE_PIN K2 [get_ports {kprow[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {kprow[1]}]
#Bank = 35, Pin name = IO_L6P_T0_35,						Sch name = JC2
set_property PACKAGE_PIN E7 [get_ports {kprow[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {kprow[2]}]
#Bank = 35, Pin name = IO_L22P_T3_35,						Sch name = JC3
set_property PACKAGE_PIN J3 [get_ports {kprow[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {kprow[3]}]
#Bank = 35, Pin name = IO_L21P_T3_DQS_35,					Sch name = JC4
set_property PACKAGE_PIN J4 [get_ports {kpcol[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {kpcol[5]}]
#Bank = 35, Pin name = IO_L23N_T3_35,						Sch name = JC7
set_property PACKAGE_PIN K1 [get_ports {kprow[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {kprow[0]}]

#Pmod Header JD
#Bank = 35, Pin name = IO_L21N_T2_DQS_35,					Sch name = JD1
set_property PACKAGE_PIN H4 [get_ports {kpcol[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {kpcol[3]}]
#Bank = 35, Pin name = IO_L17P_T2_35,						Sch name = JD2
set_property PACKAGE_PIN H1 [get_ports {kpcol[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {kpcol[2]}]
#Bank = 35, Pin name = IO_L17N_T2_35,						Sch name = JD3
set_property PACKAGE_PIN G1 [get_ports {kpcol[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {kpcol[1]}]
#Bank = 35, Pin name = IO_L20N_T3_35,						Sch name = JD4
set_property PACKAGE_PIN G3 [get_ports {kpcol[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {kpcol[0]}]
#Bank = 35, Pin name = IO_L15P_T2_DQS_35,					Sch name = JD7
set_property PACKAGE_PIN H2 [get_ports {kpcol[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {kpcol[4]}]
