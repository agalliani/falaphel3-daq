
#######################################################

set_property IOSTANDARD LVDS [get_ports {sysclk_*}]
set_property PACKAGE_PIN AD12 [get_ports sysclk_p]
set_property PACKAGE_PIN AD11 [get_ports sysclk_n]

#create_clock -name sysclk -period 5 [get_ports sysclk_p]

set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS15} [get_ports reset]

set_property IOSTANDARD LVCMOS15 [get_ports {userleds[*]}]
set_property SLEW SLOW [get_ports {userleds[*]}]
set_property PACKAGE_PIN AB8 [get_ports {userleds[1]}]
set_property PACKAGE_PIN AA8 [get_ports {userleds[2]}]
set_property PACKAGE_PIN AC9 [get_ports {userleds[3]}]
set_property PACKAGE_PIN AB9 [get_ports {userleds[4]}]

set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports rx]
set_property -dict {PACKAGE_PIN K24 IOSTANDARD LVCMOS25} [get_ports tx]

set_property -dict {PACKAGE_PIN Y23 IOSTANDARD LVCMOS25} [get_ports debug_gpio1]
set_property -dict {PACKAGE_PIN Y20 IOSTANDARD LVCMOS25} [get_ports debug_gpio2]

#######################################################

# LA07 
set_property -dict {PACKAGE_PIN H13 	IOSTANDARD LVDS_25} [get_ports asic_ss_p] 
set_property -dict {PACKAGE_PIN H14 	IOSTANDARD LVDS_25} [get_ports asic_ss_n]

# LA12 
set_property -dict {PACKAGE_PIN G15 	IOSTANDARD LVDS_25} [get_ports asic_sdi_p]
set_property -dict {PACKAGE_PIN G16 	IOSTANDARD LVDS_25} [get_ports asic_sdi_n]

# LA33 
set_property -dict {PACKAGE_PIN G36 	IOSTANDARD LVDS_25} [get_ports asic_sdo_p]
set_property -dict {PACKAGE_PIN G37 	IOSTANDARD LVDS_25} [get_ports asic_sdo_n]

# LA08 
set_property -dict {PACKAGE_PIN G12 	IOSTANDARD LVDS_25} [get_ports asic_sclk_p]
set_property -dict {PACKAGE_PIN G13 	IOSTANDARD LVDS_25} [get_ports asic_sclk_n]

#######################################################

# CLK_0 
set_property -dict {PACKAGE_PIN H4 	IOSTANDARD LVDS_25} [get_ports sck_dac_p]
set_property -dict {PACKAGE_PIN H5 	IOSTANDARD LVDS_25} [get_ports sck_dac_n]

# LA02 
set_property -dict {PACKAGE_PIN H7 	IOSTANDARD LVDS_25} [get_ports cs_ld_dac_p]
set_property -dict {PACKAGE_PIN H8 	IOSTANDARD LVDS_25} [get_ports cs_ld_dac_n]

# CLK_1 
set_property -dict {PACKAGE_PIN G2 	IOSTANDARD LVDS_25} [get_ports sdi_dac_p]
set_property -dict {PACKAGE_PIN G3 	IOSTANDARD LVDS_25} [get_ports sdi_dac_n]

# LA03 
set_property -dict {PACKAGE_PIN G9 	IOSTANDARD LVDS_25} [get_ports clr_dac_p]
set_property -dict {PACKAGE_PIN G10 	IOSTANDARD LVDS_25} [get_ports clr_dac_n]

####################################################

# LA16
set_property -dict {PACKAGE_PIN G18 	IOSTANDARD LVDS_25} [get_ports clk40_p]
set_property -dict {PACKAGE_PIN G19 	IOSTANDARD LVDS_25} [get_ports clk40_n]

# LA20 
set_property -dict {PACKAGE_PIN G21 	IOSTANDARD LVDS_25} [get_ports clk640_p]
set_property -dict {PACKAGE_PIN G22 	IOSTANDARD LVDS_25} [get_ports clk640_n]

# LA25 
set_property -dict {PACKAGE_PIN G27 	IOSTANDARD LVDS_25} [get_ports resetn_p]
set_property -dict {PACKAGE_PIN G28 	IOSTANDARD LVDS_25} [get_ports resetn_n]

####################################################

# LA22
set_property -dict {PACKAGE_PIN G24 	IOSTANDARD LVDS_25} [get_ports inj_pulse_p]
set_property -dict {PACKAGE_PIN G25 	IOSTANDARD LVDS_25} [get_ports inj_pulse_n]

# LA31 
set_property -dict {PACKAGE_PIN G33 	IOSTANDARD LVDS_25} [get_ports inj_out_buf_p]
set_property -dict {PACKAGE_PIN G34 	IOSTANDARD LVDS_25} [get_ports inj_out_buf_n]

# LA29 
set_property -dict {PACKAGE_PIN G30 	IOSTANDARD LVDS_25} [get_ports orwide_buf_p]
set_property -dict {PACKAGE_PIN G31 	IOSTANDARD LVDS_25} [get_ports orwide_buf_n]

