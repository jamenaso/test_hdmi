## Clock Signal
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {clk}]

## Reset
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {rst}]

## HDMI out
set_property IOSTANDARD TMDS_33 [get_ports {tmdsb[3]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmdsb[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmdsb[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmdsb[0]}]

set_property IOSTANDARD TMDS_33 [get_ports {tmds[3]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds[0]}]

set_property PACKAGE_PIN B21 [get_ports {tmds[3]}] 
set_property PACKAGE_PIN A21 [get_ports {tmdsb[3]}]
set_property PACKAGE_PIN A15 [get_ports {tmds[2]}]
set_property PACKAGE_PIN A16 [get_ports {tmdsb[2]}]
set_property PACKAGE_PIN A18 [get_ports {tmds[1]}]
set_property PACKAGE_PIN A19 [get_ports {tmdsb[1]}]
set_property PACKAGE_PIN B20 [get_ports {tmds[0]}]
set_property PACKAGE_PIN A20 [get_ports {tmdsb[0]}]

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]