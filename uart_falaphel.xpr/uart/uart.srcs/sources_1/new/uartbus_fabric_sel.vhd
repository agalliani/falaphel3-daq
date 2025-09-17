
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.uartbus.all;

entity uartbus_fabric_sel is
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

end uartbus_fabric_sel;

architecture rtl of uartbus_fabric_sel is

	signal sel_i:              integer range 0 to NSLV;
	signal ored_ack:           std_logic_vector(NSLV downto 0);
	signal ored_err:           std_logic_vector(NSLV downto 0);
	signal qstrobe:            std_logic;

begin

	sel_i <= to_integer(unsigned(sel)) when NSLV > 1 else 0;

	ored_ack(NSLV) <= '0';
	ored_err(NSLV) <= '0';
	
	qstrobe <= uartbus_in.uart_strobe when STROBE_GAP = false else
	           uartbus_in.uart_strobe and not (ored_ack(0) or ored_err(0));

	busgen: for i in NSLV - 1 downto 0 generate
	begin

		uartbus_to_slaves(i).uart_addr    <= uartbus_in.uart_addr;
		uartbus_to_slaves(i).uart_wdata   <= uartbus_in.uart_wdata;
		uartbus_to_slaves(i).uart_strobe  <= qstrobe when sel_i = i else '0';
		uartbus_to_slaves(i).uart_write   <= uartbus_in.uart_write;
		ored_ack(i) <= ored_ack(i+1) or uartbus_from_slaves(i).uart_ack;
		ored_err(i) <= ored_err(i+1) or uartbus_from_slaves(i).uart_err;		

	end generate;

  uartbus_out.uart_rdata    <= uartbus_from_slaves(sel_i).uart_rdata when sel_i /= NSLV else (others => '0');
  uartbus_out.uart_ack      <= ored_ack(0);
  uartbus_out.uart_err      <= ored_err(0);
  
end rtl;