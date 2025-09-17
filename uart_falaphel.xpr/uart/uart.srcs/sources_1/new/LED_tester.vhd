library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.uartbus.all;

entity LED_tester is
    port
    (
        clk: in std_logic;
        reset: in std_logic;
        uartbus_in: in uart_wbus;
        uartbus_out: out uart_rbus;
        userleds: out std_logic_vector(4 downto 1)
    );
end LED_tester;

architecture rtl of LED_tester is

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

	signal reg: std_logic_vector(3 downto 0);
	signal sel: integer range 0 to 3 := 0;
	signal ack: std_logic;
	
--	signal probe0:              std_logic_vector(31 downto 0);
--    signal probe1:              std_logic_vector(31 downto 0);
--    signal probe2:              std_logic_vector(31 downto 0);
--    signal probe3:              std_logic_vector(31 downto 0);

begin

    ---------------------------------------------------------------
    -- debug
    ---------------------------------------------------------------
    
--    probe0(1 downto 0)      <= uartbus_in.uart_addr(1 downto 0);
--    probe0(2)               <= uartbus_in.uart_strobe;
--    probe0(3)               <= uartbus_in.uart_write;
--    probe0(4)               <= uartbus_in.uart_wdata(0);
--    probe0(5)               <= ack;
--    probe0(9 downto 6)      <= reg; 
--    probe0(31 downto 10)    <= (others => '0');
    
--    probe1(31 downto 0)     <= (others => '0');
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

    sel <= to_integer(unsigned(uartbus_in.uart_addr(1 downto 0)));

	process(clk, reset)
	begin
         if(rising_edge(clk)) then
            if(reset = '1') then
                reg <= "1111";
                ack <= '0';
            else
                if(uartbus_in.uart_strobe ='1' and uartbus_in.uart_write = '1') then
                    reg(sel) <= uartbus_in.uart_wdata(0);
                end if;
                uartbus_out.uart_rdata(0)   <= reg(sel);
                ack                         <= uartbus_in.uart_strobe and not ack;	
            end if;
		end if;
	end process;
	
	uartbus_out.uart_ack                   <= ack;
	uartbus_out.uart_err                   <= '0';
	uartbus_out.uart_rdata(31 downto 1)    <= (others => '0');
	
	userleds(1) <= reg(0);         
    userleds(2) <= reg(1);
    userleds(3) <= reg(2);
    userleds(4) <= reg(3);

end rtl;