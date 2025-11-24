----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2025 04:30:11 PM
-- Design Name: 
-- Module Name: payload - behavioral
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
use work.uartbus_decode_table.all;
use work.daq_package.all;

entity payload is
    port
    (
        clk:                    in  std_logic;
        reset:                  in  std_logic;
        uartbus_in:             in  uart_wbus;
        uartbus_out:            out uart_rbus;
        userleds:               out std_logic_vector(4 downto 1);
            -- SPI Falaphel
        spi_ss:                 out std_logic;
        spi_mosi:               out std_logic;
        spi_miso:               in  std_logic;
        spi_sclk:               out std_logic;
            -- SPI DAC
        sck_dac:                out std_logic;
        cs_ld_dac:              out std_logic;
        sdi_dac:                out std_logic;
            -- pulser
        inj_pulse:              out std_logic
    );
end payload;

architecture behavioral of payload is

component uartbus_fabric_sel is
  generic
  (
    NSLV: positive;
    STROBE_GAP: boolean := false;
    SEL_WIDTH: natural
   );
  port
  (
  	sel:                    in  std_logic_vector(SEL_WIDTH - 1 downto 0);
    uartbus_in:             in  uart_wbus;
    uartbus_out:            out uart_rbus;
    uartbus_to_slaves:      out uart_wbus_array(NSLV - 1 downto 0);
    uartbus_from_slaves:    in  uart_rbus_array(NSLV - 1 downto 0) := (others => UART_RBUS_NULL)
  );
end component uartbus_fabric_sel;

component LED_tester is
    port
    (
        clk: in std_logic;
        reset: in std_logic;
        uartbus_in: in uart_wbus;
        uartbus_out: out uart_rbus;
        userleds: out std_logic_vector(4 downto 1)
    );
end component LED_tester;

component register_file is
    port
        (
        clk:                    in  std_logic;
        reset:                  in  std_logic;
        uartbus_in:             in  uart_wbus;
        uartbus_out:            out uart_rbus;
        regs:                   inout REGS_RECORD
        );
end component register_file;

component spi_master is
	generic
	(
		N_SS: positive;
		ID: integer
	);
	port
	(
		uartbus_clk: in std_logic;
		falaphel_clk: in std_logic;
		rst: in std_logic;
		uartbus_in: in uart_wbus;
		uartbus_out: out uart_rbus;
		ss: out std_logic;
		mosi: out std_logic;
		miso: in std_logic;
		sclk: out std_logic
	);
end component spi_master;

component pulser is
    port
        (
        clk:                    in  std_logic;
        reset:                  in  std_logic;
        uartbus_in:             in  uart_wbus;
        uartbus_out:            out uart_rbus;
        inj_pulse:              out std_logic
        );
end component pulser;

signal ipbw:    uart_wbus_array(N_SLAVES - 1 downto 0);
signal ipbr:    uart_rbus_array(N_SLAVES - 1 downto 0);

signal regs: 	REGS_RECORD;

signal spi_ss_i:      std_logic;
signal spi_mosi_i:    std_logic;
signal spi_miso_i:    std_logic;
signal spi_sclk_i:    std_logic;

signal sck_dac_i:     std_logic;
signal cs_ld_dac_i:   std_logic;
signal sdi_dac_i:     std_logic;

begin

spi_ss      <= spi_ss_i;
spi_mosi    <= spi_mosi_i;
spi_miso_i  <= spi_miso;
spi_sclk    <= spi_sclk_i;

sck_dac     <= sck_dac_i;
cs_ld_dac   <= cs_ld_dac_i;
sdi_dac     <= sdi_dac_i;

  ------------------------------------------------------------------------------------------------
  fabric : uartbus_fabric_sel
    generic map 
    (
      NSLV          => N_SLAVES,
      STROBE_GAP    => false,
      SEL_WIDTH     => UARTBUS_SEL_WIDTH
    )
    port map (
      uartbus_in            => uartbus_in,
      uartbus_out           => uartbus_out,
      sel                   => uartbus_sel(uartbus_in.uart_addr),
      uartbus_to_slaves     => ipbw,
      uartbus_from_slaves   => ipbr
    );
  ------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------
    leds_instance: LED_tester                
    port map
    (
        clk                 => clk,
        reset               => reset,
        uartbus_in          => ipbw(N_SLV_LEDs),
        uartbus_out         => ipbr(N_SLV_LEDs),
        userleds            => userleds
    );
  ------------------------------------------------------------------------------------------------
  
  ------------------------------------------------------------------------------------------------
  register_file_inst: register_file
    port map
        (
        clk                 => clk,
        reset               => reset,
        uartbus_in          => ipbw(N_SLV_REGs),
        uartbus_out         => ipbr(N_SLV_REGs),
        regs                => regs
        );
  ------------------------------------------------------------------------------------------------
  
  ------------------------------------------------------------------------------------------------
  -- SPI Falaphel
  ------------------------------------------------------------------------------------------------
  spi_master_fal: spi_master
	generic map
	(
		N_SS  => 1,
		ID    => 0
	)
	port map
	(
		uartbus_clk       => clk,
		falaphel_clk      => clk,
		rst               => reset,
		uartbus_in        => ipbw(N_SLV_SPI_FAL),
		uartbus_out       => ipbr(N_SLV_SPI_FAL),
		ss                => spi_ss_i,
		mosi              => spi_mosi_i,
		miso              => spi_miso_i,
		sclk              => spi_sclk_i
	);
  ------------------------------------------------------------------------------------------------
	
  ------------------------------------------------------------------------------------------------
  -- SPI DAC
  ------------------------------------------------------------------------------------------------
  spi_master_dac: spi_master
	generic map
	(
		N_SS  => 1,
		ID    => 0
	)
	port map
	(
		uartbus_clk       => clk,
		falaphel_clk      => clk,
		rst               => reset,
		uartbus_in        => ipbw(N_SLV_SPI_DAC),
		uartbus_out       => ipbr(N_SLV_SPI_DAC),
		ss                => cs_ld_dac_i,
		mosi              => sdi_dac_i,
		miso              => '0',
		sclk              => sck_dac_i
	);
  ------------------------------------------------------------------------------------------------
  
  ------------------------------------------------------------------------------------------------
  -- SPI DAC
  ------------------------------------------------------------------------------------------------
  pulser_inst: pulser
    port map
        (
        clk             => clk,
        reset           => reset,
        uartbus_in      => ipbw(N_SLV_PULSER),
		uartbus_out     => ipbr(N_SLV_PULSER),
        inj_pulse       => inj_pulse
        );
   ------------------------------------------------------------------------------------------------

end behavioral;
