library IEEE;
use IEEE.STD_LOGIC_1164.all;

package uartbus is

-- The signals going from master to slaves - parallel bus
	type uart_wbus is
		record
			uart_addr: std_logic_vector(31 downto 0);
			uart_wdata: std_logic_vector(31 downto 0);
			uart_strobe: std_logic;
			uart_write: std_logic;
		end record;

	type uart_wbus_array is array(natural range <>) of uart_wbus;

-- The signals going from slaves to master - parallel bus
	type uart_rbus is
    record
			uart_rdata: std_logic_vector(31 downto 0);
			uart_ack: std_logic;
			uart_err: std_logic;
    end record;

	type uart_rbus_array is array(natural range <>) of uart_rbus;
	
	constant UART_RBUS_NULL: uart_rbus := ((others => '0'), '0', '0');
	constant UART_WBUS_NULL: uart_wbus := ((others => '0'), (others => '0'), '0', '0');

end uartbus;