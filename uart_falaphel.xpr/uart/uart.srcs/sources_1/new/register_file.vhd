----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2020 12:25:12
-- Design Name: 
-- Module Name: ip_register_file - behavioral
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

entity register_file is
    port
        (
        clk:                    in  std_logic;
        reset:                  in  std_logic;
        uartbus_in:             in  uart_wbus;
        uartbus_out:            out uart_rbus;
        regs:                   inout REGS_RECORD
        );
end register_file;

architecture behavioral of register_file is

--    component ila_debug
--    port 
--      (
--        clk:        in std_logic;
--        probe0:     in std_logic_vector(31 downto 0);
--        probe1:     in std_logic_vector(31 downto 0);
--        probe2:     in std_logic_vector(31 downto 0);
--        probe3:     in std_logic_vector(31 downto 0)
--      );
--    end component ila_debug;

    constant ADDR_WIDTH:  positive := 4;
    
	signal sel:                std_logic_vector (ADDR_WIDTH-1 downto 0) := (others => '0');
	signal ack:                std_logic;
	
	signal read_bus:           std_logic_vector(31 downto 0);
	
--	signal probe0:              std_logic_vector(31 downto 0);
--    signal probe1:              std_logic_vector(31 downto 0);
--    signal probe2:              std_logic_vector(31 downto 0);
--    signal probe3:              std_logic_vector(31 downto 0);

begin

    ---------------------------------------------------------------
    -- debug
    ---------------------------------------------------------------
    
--    probe0(31 downto 0)     <= read_bus;
--    probe1(0)               <= uartbus_in.uart_strobe;
--    probe1(1)               <= uartbus_in.uart_write;
--    probe1(2)               <= ack;    
--    probe1(31 downto 3)     <= (others => '0');
--    probe2(31 downto 0)     <= (others => '0');
--    probe3(31 downto 0)     <= (others => '0');
    
--    ila_debug_instance: ila_debug
--    port map 
--      (
--        clk         => clk, 
--        probe0      => probe0,
--        probe1      => probe1,
--        probe2      => probe2,
--        probe3      => probe3
--      );
      
    ---------------------------------------------------------------


sel <= uartbus_in.uart_addr(ADDR_WIDTH-1 downto 0);

regs.fwrev          <= x"20250917";

	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset = '1') then
				regs.board_id     <= D_BOARD_ID;
				regs.ctrl         <= D_CTRL;
				regs.debug        <= D_DEBUG;
				regs.mode         <= D_MODE;
				regs.status       <= (others => '0');
				ack               <= '0';
			elsif(uartbus_in.uart_strobe = '1' and uartbus_in.uart_write = '1') then
				case sel is
					when A_BOARD_ID(ADDR_WIDTH-1 downto 0) => regs.board_id <= uartbus_in.uart_wdata;
					when A_CTRL(ADDR_WIDTH-1 downto 0)     => regs.ctrl <= uartbus_in.uart_wdata;
					when A_DEBUG(ADDR_WIDTH-1 downto 0)    => regs.debug <= uartbus_in.uart_wdata;
					when A_MODE(ADDR_WIDTH-1 downto 0)     => regs.mode <= uartbus_in.uart_wdata;
					when others => null;
				end case; 
			end if;

			case sel is 
				when A_FWREV(ADDR_WIDTH-1 downto 0)         => read_bus <= regs.fwrev;
				when A_BOARD_ID(ADDR_WIDTH-1 downto 0)      => read_bus <= regs.board_id;
				when A_STATUS(ADDR_WIDTH-1 downto 0)        => read_bus <= regs.status;
				when A_CTRL(ADDR_WIDTH-1 downto 0)          => read_bus <= regs.ctrl;
				when A_DEBUG(ADDR_WIDTH-1 downto 0)         => read_bus <= regs.debug;
				when A_MODE(ADDR_WIDTH-1 downto 0)          => read_bus <= regs.mode;
				when others => read_bus <= regs.fwrev;
			end case;

			ack <= uartbus_in.uart_strobe and not ack;	
		end if;
	end process;

	uartbus_out.uart_rdata <= read_bus;

	uartbus_out.uart_ack <= ack;
	uartbus_out.uart_err <= '0';
	
end behavioral;
