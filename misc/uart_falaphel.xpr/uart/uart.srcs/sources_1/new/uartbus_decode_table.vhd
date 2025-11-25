----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2025 04:41:19 PM
-- Design Name: 
-- Module Name: uartbus_decode_table - behavioral
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


package uartbus_decode_table is

  constant UARTBUS_SEL_WIDTH: positive := 5;
  subtype uartbus_sel_t is std_logic_vector(UARTBUS_SEL_WIDTH - 1 downto 0);
  function uartbus_sel(addr : in std_logic_vector(31 downto 0)) return uartbus_sel_t;

  constant N_SLV_LEDs:      integer := 0;
  constant N_SLV_REGs:      integer := 1;
  constant N_SLV_SPI_FAL:   integer := 2;
  constant N_SLV_SPI_DAC:   integer := 3;
  constant N_SLV_PULSER:    integer := 4;
  
  constant N_SLAVES:        integer := 5;

end uartbus_decode_table;

package body uartbus_decode_table is

  function uartbus_sel(addr : in std_logic_vector(31 downto 0)) return uartbus_sel_t is
    variable sel: uartbus_sel_t;
  begin

    if    std_match(addr, "------------0001---0------------") then
        sel := uartbus_sel_t(to_unsigned(N_SLV_LEDs, UARTBUS_SEL_WIDTH));         -- leds / base 0x00010000 / mask 0x00071000
    elsif std_match(addr, "------------0010---0------------") then
        sel := uartbus_sel_t(to_unsigned(N_SLV_REGs, UARTBUS_SEL_WIDTH));         -- regs / base 0x00020000 / mask 0x00071000    
    elsif std_match(addr, "------------0011---0------------") then
        sel := uartbus_sel_t(to_unsigned(N_SLV_SPI_FAL, UARTBUS_SEL_WIDTH));      -- SPI fal / base 0x00030000 / mask 0x00071000
    elsif std_match(addr, "------------0100---0------------") then
        sel := uartbus_sel_t(to_unsigned(N_SLV_SPI_DAC, UARTBUS_SEL_WIDTH));      -- SPI dac / base 0x00040000 / mask 0x00071000
    elsif std_match(addr, "------------0101---0------------") then
        sel := uartbus_sel_t(to_unsigned(N_SLV_PULSER, UARTBUS_SEL_WIDTH));      -- pulser / base 0x00050000 / mask 0x00071000         
    else
        sel := uartbus_sel_t(to_unsigned(N_SLAVES, UARTBUS_SEL_WIDTH));
    end if;

    return sel;
  end function uartbus_sel;


end uartbus_decode_table;
