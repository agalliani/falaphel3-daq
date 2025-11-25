----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2025 03:34:47 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

library UNISIM;
use UNISIM.VComponents.all;

use work.uartbus.all;
use work.daq_package.all;

entity top is
    generic 
    (
        --g_CLKS_PER_BIT : integer := 5208        -- baud rate = 9600
        g_CLKS_PER_BIT : integer := 347         -- baud rate = 115200 @ 40 MHz (= 40000000 / 115200)
    );
    port
    (
            -- input clock + reset
        sysclk_p:           in  std_logic;
        sysclk_n:           in  std_logic;
        reset:              in  std_logic;
            -- UART lines
        rx:                 in  std_logic; 
        tx:                 out std_logic;
            -- GPIOs + LEDs
        debug_gpio1:        out std_logic;
        debug_gpio2:        out std_logic;
        userleds:           out std_logic_vector(4 downto 1);
            -- SPI Falaphel
        asic_ss_p:          out std_logic;
        asic_ss_n:          out std_logic;
        asic_sdi_p:         out std_logic;
        asic_sdi_n:         out std_logic;
        asic_sdo_p:         in  std_logic;
        asic_sdo_n:         in  std_logic;
        asic_sclk_p:        out std_logic;
        asic_sclk_n:        out std_logic;
            -- SPI DAC
        sck_dac_p:          out std_logic;
        sck_dac_n:          out std_logic;
        cs_ld_dac_p:        out std_logic;
        cs_ld_dac_n:        out std_logic;
        sdi_dac_p:          out std_logic;
        sdi_dac_n:          out std_logic;
            -- DAC I/OS
        clr_dac_p:          out std_logic;
        clr_dac_n:          out std_logic;
            -- Falaphel I/Os
        clk640_p:           out std_logic;
        clk640_n:           out std_logic;
        clk40_p:            out std_logic;
        clk40_n:            out std_logic;
        resetn_p:           out std_logic;
        resetn_n:           out std_logic;
        inj_pulse_p:        out std_logic;
        inj_pulse_n:        out std_logic;
        inj_out_buf_p:      in  std_logic;
        inj_out_buf_n:      in  std_logic;
        orwide_buf_p:       in  std_logic;
        orwide_buf_n:       in  std_logic
    );
end top;

architecture behavioral of top is

component uart_rx is
  generic 
  (
    g_CLKS_PER_BIT : integer     
  );
  port 
  (
    i_Clk       : in  std_logic;
    i_RX_Serial : in  std_logic;
    o_RX_DV     : out std_logic;
    o_RX_Byte   : out std_logic_vector(7 downto 0)
  );
end component uart_rx;

component uart_tx is
generic 
  (
    g_CLKS_PER_BIT : integer     
  );
  port (
    i_Clk       : in  std_logic;
    i_TX_DV     : in  std_logic;
    i_TX_Byte   : in  std_logic_vector(7 downto 0);
    o_TX_Active : out std_logic;
    o_TX_Serial : out std_logic;
    o_TX_Done   : out std_logic
    );
end component uart_tx;

component uart_decoder is
port
    (
            -- from uart_rx block
        clk:            in  std_logic;
        reset:          in  std_logic;
            --
        data_in:        in  std_logic_vector(7 downto 0); 
        valid:          in  std_logic;
            --
        data_out:       out std_logic_vector(7 downto 0); 
        tx_valid:       out std_logic;
        tx_busy:        in  std_logic;
            -- uartb bus signals
        uartbus_out:    out uart_wbus;
        uartbus_in:     in  uart_rbus
    );
end component uart_decoder;

component payload is
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
end component payload;

component clock_wizard 
 port
 (
  clk_out1:     out std_logic;  --  40 MHz
  clk_out2:     out std_logic;  -- 640 MHz
  reset:        in  std_logic;
  locked:       out std_logic;
  clk_in1_p:    in  std_logic;
  clk_in1_n:    in  std_logic
 );
end component clock_wizard;

--component ila_debug
--port 
--  (
--    clk:        in std_logic;
--    probe0:     in std_logic_vector(31 downto 0);
--    probe1:     in std_logic_vector(31 downto 0);
--    probe2:     in std_logic_vector(31 downto 0);
--    probe3:     in std_logic_vector(31 downto 0)
--  );
--end component ila_debug;

signal uart_data_out:       std_logic_vector(7 downto 0);
signal uart_valid:          std_logic;

signal tx_data:             std_logic_vector(7 downto 0);
signal tx_valid:            std_logic;
signal tx_busy:             std_logic;

signal uartbus_out:         uart_wbus;
signal uartbus_in:          uart_rbus;

signal clk40:               std_logic;
signal clk640:              std_logic;

signal clk40_out_ddr:       std_logic;
signal clk640_out_ddr:      std_logic;

signal tx_int:              std_logic;

signal asic_ss:             std_logic;
signal asic_sdi:            std_logic;
signal asic_sdo:            std_logic;
signal asic_sclk:           std_logic;

signal sck_dac:             std_logic;
signal cs_ld_dac:           std_logic;
signal sdi_dac:             std_logic;

signal resetn:              std_logic;

signal inj_pulse:           std_logic;
signal inj_out_buf:         std_logic;
signal orwide_buf:          std_logic;

signal clr_dac:             std_logic;

--signal probe0:              std_logic_vector(31 downto 0);
--signal probe1:              std_logic_vector(31 downto 0);
--signal probe2:              std_logic_vector(31 downto 0);
--signal probe3:              std_logic_vector(31 downto 0);

begin

---------------------------------------------------------------
-- debug
---------------------------------------------------------------

--probe0(7 downto 0)      <= uart_data_out;
--probe0(8)               <= uart_valid;
--probe0(9)               <= rx;
--probe0(31 downto 10)    <= (others => '0');

--probe1(31 downto 0)     <= (others => '0');
--probe2(31 downto 0)     <= (others => '0');
--probe3(31 downto 0)     <= (others => '0');

--ila_debug_instance: ila_debug
--port map 
--  (
--    clk         => clk40, 
--    probe0      => probe0,
--    probe1      => probe1,
--    probe2      => probe2,
--    probe3      => probe3
--  );
-----------------------------------------------------------------------------------------------------------------------

-- debug
debug_gpio1  <= inj_out_buf;
debug_gpio2  <= orwide_buf;

tx          <= tx_int;
	
clk640_out_ODDR: ODDR
	generic map
	(
		DDR_CLK_EDGE => "SAME_EDGE",
		INIT => '0',
		SRTYPE => "SYNC"
	)
	port map 
	(
		Q		=> clk640_out_ddr,
		C		=> clk640,
		CE		=> '1',
		D1		=> '0',
		D2		=> '1',
		R		=> '0',
		S		=> '0'
	);

	clk640_obufds : OBUFDS
    generic map 
    (
      IOSTANDARD => "LVDS_25"
	 )
    port map 
    (
      O	=> clk640_p,
      OB	=> clk640_n,
      I	=> clk640_out_ddr
    );

------------------------------------------ 
clk40_out_ODDR: ODDR
	generic map
	(
		DDR_CLK_EDGE => "SAME_EDGE",
		INIT => '0',
		SRTYPE => "SYNC"
	)
	port map 
	(
		Q		=> clk40_out_ddr,
		C		=> clk40,
		CE		=> '1',
		D1		=> '0',
		D2		=> '1',
		R		=> '0',
		S		=> '0'
	);

	clk40_obufds : OBUFDS
    generic map 
    (
      IOSTANDARD => "LVDS_25"
	 )
    port map 
    (
      O	=> clk40_p,
      OB	=> clk40_n,
      I	=> clk40_out_ddr
    );
 
 ------------------------------------------------------------
 
 resetn_obufds : OBUFDS
    generic map 
    (
      IOSTANDARD => "LVDS_25"
	 )
    port map 
    (
      O	=> resetn_p,
      OB	=> resetn_n,
      I	=> resetn
    );
    
    resetn <= not reset;
       
    inj_pulse_obufds : OBUFDS
    generic map 
    (
      IOSTANDARD => "LVDS_25"
	 )
    port map 
    (
      O	=> inj_pulse_p,
      OB	=> inj_pulse_n,
      I	=> inj_pulse
    );
    
    inj_out_buf_ibufds: IBUFDS
	generic map 
	(
		DIFF_TERM		=> TRUE,
		IBUF_LOW_PWR	=> FALSE,
		IOSTANDARD		=> "LVDS_25"
	)
	port map 
	(
		I          => inj_out_buf_p,
		IB         => inj_out_buf_n,
		O          => inj_out_buf
	);
	
	orwide_buf_p_ibufds: IBUFDS
	generic map 
	(
		DIFF_TERM		=> TRUE,
		IBUF_LOW_PWR	=> FALSE,
		IOSTANDARD		=> "LVDS_25"
	)
	port map 
	(
		I          => orwide_buf_p,
		IB         => orwide_buf_n,
		O          => orwide_buf
	);

-----------------------------------------------------------------------------------------------------------------------
    -- SPI Fal LVDS
-----------------------------------------------------------------------------------------------------------------------
spi_ss_obufds: OBUFDS
    generic map 
    (
      IOSTANDARD => "LVDS_25"
	)
    port map 
    (
      O	=> asic_ss_p,
      OB => asic_ss_n,
      I	=> asic_ss
    );
    
spi_mosi_obufds: OBUFDS
    generic map 
    (
      IOSTANDARD => "LVDS_25"
	)
    port map 
    (
      O	=> asic_sdi_p,
      OB => asic_sdi_n,
      I	=> asic_sdi
    );
    
spi_miso_ibufds: IBUFDS
	generic map 
	(
		DIFF_TERM		=> TRUE,
		IBUF_LOW_PWR	=> FALSE,
		IOSTANDARD		=> "LVDS_25"
	)
	port map 
	(
		I          => asic_sdo_p,
		IB         => asic_sdo_n,
		O          => asic_sdo
	);
	
spi_sclk_obufds: OBUFDS
    generic map 
    (
      IOSTANDARD => "LVDS_25"
	)
    port map 
    (
      O	=> asic_sclk_p,
      OB => asic_sclk_n,
      I	=> asic_sclk
    );
-----------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------
    -- SPI DAC LVDS
-----------------------------------------------------------------------------------------------------------------------
spi_sclk_dac_obufds: OBUFDS
    generic map 
    (
      IOSTANDARD => "LVDS_25"
	)
    port map 
    (
      O	=> sck_dac_p,
      OB => sck_dac_n,
      I	=> sck_dac
    );
    
 cs_ld_dac_obufds: OBUFDS
    generic map 
    (
      IOSTANDARD => "LVDS_25"
	)
    port map 
    (
      O	=> cs_ld_dac_p,
      OB => cs_ld_dac_n,
      I	=> cs_ld_dac
    );
    
  sdi_dac_dac_obufds: OBUFDS
    generic map 
    (
      IOSTANDARD => "LVDS_25"
	)
    port map 
    (
      O	=> sdi_dac_p,
      OB => sdi_dac_n,
      I	=> sdi_dac
    );
    
  clr_dac_obufds : OBUFDS
    generic map 
    (
      IOSTANDARD => "LVDS_25"
	 )
    port map 
    (
      O	=> clr_dac_p,
      OB	=> clr_dac_n,
      I	=> clr_dac
    );
    
    clr_dac <= reset;       -- to be checked out !
-----------------------------------------------------------------------------------------------------------------------

clock_wizard_inst: clock_wizard 
 port map
 (
  clk_out1      => clk40,
  clk_out2      => clk640,
  reset         => reset,
  locked        => open,
  clk_in1_p     => sysclk_p,
  clk_in1_n     => sysclk_n
 );

uart_rx_inst: uart_rx
    generic map
    (
        g_CLKS_PER_BIT  => g_CLKS_PER_BIT
    )
    port map 
    (
        i_Clk           => clk40,
        i_RX_Serial     => rx,
        o_RX_Byte       => uart_data_out,
        o_RX_DV         => uart_valid
    );

uart_tx_inst: uart_tx
    generic map
    (
        g_CLKS_PER_BIT  => g_CLKS_PER_BIT
    )
    port map
    ( 
        i_Clk           => clk40,
        i_TX_DV         => tx_valid,
        i_TX_Byte       => tx_data,
        o_TX_Active     => tx_busy,
        o_TX_Serial     => tx_int,
        o_TX_Done       => open
    );
        
uart_decoder_inst: uart_decoder
    port map
    (
        clk             => clk40,
        reset           => reset,
        data_in         => uart_data_out,
        valid           => uart_valid,
        data_out        => tx_data,
        tx_valid        => tx_valid,
        tx_busy         => tx_busy,
        uartbus_out     => uartbus_out,
        uartbus_in      => uartbus_in
    );
    
payload_inst: payload
    port map
    (
        clk             => clk40,
        reset           => reset,
        uartbus_in      => uartbus_out,
        uartbus_out     => uartbus_in,
        userleds        => userleds,
            -- SPI falaphel
        spi_ss          => asic_ss,
        spi_mosi        => asic_sdi,
        spi_miso        => asic_sdo,
        spi_sclk        => asic_sclk,
            -- SPI DAC
        sck_dac         => sck_dac,
        cs_ld_dac       => cs_ld_dac,
        sdi_dac         => sdi_dac,
            -- pulser
        inj_pulse       => inj_pulse
    );

end behavioral;
