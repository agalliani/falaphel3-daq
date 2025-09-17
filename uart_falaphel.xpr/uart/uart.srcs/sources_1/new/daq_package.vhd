----------------------------------------------------------------------------------
-- Company: INFN BO
-- Engineer: Davide Falchieri
-- 
-- Create Date: 03/26/2021 12:10:23 PM
-- Design Name: 
-- Module Name: daq_package - behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package daq_package is

constant A_FWREV:    			std_logic_vector(15 downto 0) := x"0000";  -- R   - firmware revision
constant A_BOARD_ID:   			std_logic_vector(15 downto 0) := x"0001";  -- RW  - board ID register
constant A_STATUS: 				std_logic_vector(15 downto 0) := x"0002";  -- R   - status register
constant A_CTRL: 				std_logic_vector(15 downto 0) := x"0003";  -- RW  - ctrl register
constant A_DEBUG:               std_logic_vector(15 downto 0) := x"0007";  -- RW  - debug register
constant A_MODE:                std_logic_vector(15 downto 0) := x"0008";  -- RW  - test/data taking mode register
                                                                                 -- if x"0000" normal mode, else test mode

subtype REGISTER_TYPE          is std_logic_vector(31 downto 0); 

type REGS_RECORD is record
    fwrev:   			REGISTER_TYPE;  	-- R   - firmware revision
    board_id:  			REGISTER_TYPE;  	-- RW  - board ID register  	
    status: 			REGISTER_TYPE;  	-- R   - status register
    ctrl: 				REGISTER_TYPE;  	-- RW  - ctrl register
    debug:              REGISTER_TYPE;      -- RW  - debug register
    mode:               REGISTER_TYPE;      -- RW  - test/data taking mode register
end record;

  -------------------------------------------------------------------------------------------------------------------------------------------
  -- Default values of teh registers  -------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant D_BOARD_ID:  REGISTER_TYPE := x"00000000";  	-- RW - board_id register
  constant D_CTRL: 	    REGISTER_TYPE := x"00000000";  	-- RW - ctrl register
  constant D_DEBUG: 	REGISTER_TYPE := X"AAAA1234";   -- R/W - debug register
  constant D_MODE:  	REGISTER_TYPE := X"00000000";   -- R/W - test/data taking mode register
  
  -------------------------------------------------------------------------------------------------------------------------------------------
  -- STATUS (0x02) --------------------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------------------------------------------------------------------------
  constant STATUS_MODE: 		integer :=  0;  -- mode
  constant STATUS_OK: 			integer :=  1;  -- everything ok
  
end daq_package;

package body daq_package is

end daq_package;