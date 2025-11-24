----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2025 12:30:32 PM
-- Design Name: 
-- Module Name: pulser - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.uartbus.all;
use work.daq_package.all;

entity pulser is
    port
        (
        clk:                    in  std_logic;
        reset:                  in  std_logic;
        uartbus_in:             in  uart_wbus;
        uartbus_out:            out uart_rbus;
        inj_pulse:              out std_logic
        );
end pulser;

architecture behavioral of pulser is

signal ack:             std_logic;
signal int_pulse:       std_logic;

begin

inj_pulse   <= int_pulse;

process(clk)
	begin
	   if(rising_edge(clk)) then
			if(reset = '1') then
			     ack             <= '0';
			     int_pulse       <= '0';
			elsif(uartbus_in.uart_strobe = '1' and uartbus_in.uart_write = '1') then
			     ack             <= uartbus_in.uart_strobe and not ack;   
			     int_pulse       <= '1';
			else
			     ack             <= '0';
			     int_pulse       <= '0';
			end if;
	   end if;
end process;

end behavioral;
