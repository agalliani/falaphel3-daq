
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.uartbus.all;

entity uart_decoder is
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
end uart_decoder;

architecture behavioral of uart_decoder is

component ila_debug
port 
  (
    clk:        in std_logic;
    probe0:     in std_logic_vector(31 downto 0);
    probe1:     in std_logic_vector(31 downto 0);
    probe2:     in std_logic_vector(31 downto 0);
    probe3:     in std_logic_vector(31 downto 0)
  );
end component ila_debug;

type   word_to_frame_type is (IDLE, REC_WADDR_0, REC_WADDR_1, REC_WADDR_2, REC_WADDR_3,
                              REC_WDATA_0, REC_WDATA_1, REC_WDATA_2, REC_WDATA_3, REC_WCMD_EXE,
                              REC_RADDR_0, REC_RADDR_1, REC_RADDR_2, REC_RADDR_3, REC_RCMD_EXE);
signal state_frame_decode:  word_to_frame_type;

type   word_tx_type is (TX_IDLE, TX_SEND_BYTE0, TX_SEND_BYTE1, TX_SEND_BYTE2, TX_SEND_BYTE3,
                                 TX_SEND_BYTE0_WAIT, TX_SEND_BYTE1_WAIT, TX_SEND_BYTE2_WAIT);
signal state_tx_data:  word_tx_type;

signal waddr:               std_logic_vector(31 downto 0);
signal wdata:               std_logic_vector(31 downto 0);
signal uart_write_op_ok:    std_logic;

signal raddr:               std_logic_vector(31 downto 0);
signal uart_read_op_ok:     std_logic;

signal data_to_uart_tx:     std_logic_vector(31 downto 0);
signal data_to_uart_valid:  std_logic;

signal tx_valid_i:          std_logic;
signal data_out_i:          std_logic_vector(7 downto 0);

signal probe0:              std_logic_vector(31 downto 0);
signal probe1:              std_logic_vector(31 downto 0);
signal probe2:              std_logic_vector(31 downto 0);
signal probe3:              std_logic_vector(31 downto 0);

begin

---------------------------------------------------------------
-- debug
---------------------------------------------------------------

probe0(0)               <= data_to_uart_valid;
probe0(1)               <= tx_busy;
probe0(2)               <= tx_valid_i;
probe0(10 downto 3)     <= data_out_i;
probe0(31 downto 11)    <= (others => '0');

probe1(7 downto 0)      <= data_in;
probe1(15 downto 8)     <= waddr(7 downto 0);
probe1(16)              <= valid;
probe1(31 downto 17)    <= (others => '0');

probe2(31 downto 0)     <= uartbus_in.uart_rdata;

probe3(0)               <= uart_write_op_ok;
probe3(1)               <= data_to_uart_valid;
probe3(2)               <= uartbus_in.uart_ack;
probe3(3)               <= uart_read_op_ok;
probe3(31 downto 4)     <= (others => '0');

ila_debug_instance: ila_debug
port map 
  (
    clk         => clk, 
    probe0      => probe0,
    probe1      => probe1,
    probe2      => probe2,
    probe3      => probe3
  );
  
---------------------------------------------------------------

data_out        <= data_out_i;
tx_valid        <= tx_valid_i;

byte_to_frame_process: process(reset, clk)
begin
    if(reset = '1') then
        state_frame_decode  <= IDLE;
        uart_write_op_ok    <= '0';
        uart_read_op_ok     <= '0';
        waddr               <= (others => '0');
        wdata               <= (others => '0');
    elsif(rising_edge(clk)) then
        if(state_frame_decode = IDLE) then
            if(valid = '1' and data_in(7 downto 0) = x"A1") then        -- write frame
                state_frame_decode <= REC_WADDR_0;
            elsif(valid = '1' and data_in(7 downto 0) = x"B1") then     -- read frame
                state_frame_decode <= REC_RADDR_0;
            else
                state_frame_decode <= IDLE;
            end if;
            uart_write_op_ok   <= '0';
            uart_read_op_ok    <= '0';
        elsif(state_frame_decode = REC_WADDR_0) then
            if(valid = '1') then
                waddr(31 downto 24) <= data_in;
                state_frame_decode <= REC_WADDR_1;
            else
                state_frame_decode <= REC_WADDR_0;
            end if;
        elsif(state_frame_decode = REC_WADDR_1) then
            if(valid = '1') then
                waddr(23 downto 16) <= data_in;
                state_frame_decode <= REC_WADDR_2;
            else
                state_frame_decode <= REC_WADDR_1;
            end if;
        elsif(state_frame_decode = REC_WADDR_2) then
            if(valid = '1') then
                waddr(15 downto 8) <= data_in;
                state_frame_decode <= REC_WADDR_3;
            else
                state_frame_decode <= REC_WADDR_2;
            end if;
        elsif(state_frame_decode = REC_WADDR_3) then
            if(valid = '1') then
                waddr(7 downto 0)  <= data_in;
                state_frame_decode <= REC_WDATA_0;
            else
                state_frame_decode <= REC_WADDR_3;
            end if;
        elsif(state_frame_decode = REC_WDATA_0) then
            if(valid = '1') then
                wdata(31 downto 24) <= data_in;
                state_frame_decode  <= REC_WDATA_1;
            else
                state_frame_decode <= REC_WDATA_0;
            end if;
        elsif(state_frame_decode = REC_WDATA_1) then
            if(valid = '1') then
                wdata(23 downto 16) <= data_in;
                state_frame_decode <= REC_WDATA_2;
            else
                state_frame_decode <= REC_WDATA_1;
            end if;
        elsif(state_frame_decode = REC_WDATA_2) then
            if(valid = '1') then
                wdata(15 downto 8) <= data_in;
                state_frame_decode <= REC_WDATA_3;
            else
                state_frame_decode <= REC_WDATA_2;
            end if;
        elsif(state_frame_decode = REC_WDATA_3) then
            if(valid = '1') then
                wdata(7 downto 0) <= data_in;
                state_frame_decode <= REC_WCMD_EXE;
            else
                state_frame_decode <= REC_WDATA_3;
            end if;
        elsif(state_frame_decode = REC_WCMD_EXE) then
            if(valid = '1' and data_in(7 downto 0) = x"A2") then
                uart_write_op_ok   <= '1';
                state_frame_decode <= IDLE;
            elsif(valid = '1') then         -- wrong write command execute
                uart_write_op_ok   <= '0';
                state_frame_decode <= IDLE;
            else
                uart_write_op_ok   <= '0';
                state_frame_decode <= REC_WCMD_EXE;
            end if;
        elsif(state_frame_decode = REC_RADDR_0) then
            if(valid = '1') then
                raddr(31 downto 24) <= data_in;
                state_frame_decode <= REC_RADDR_1;
            else
                state_frame_decode <= REC_RADDR_0;
            end if;
        elsif(state_frame_decode = REC_RADDR_1) then
            if(valid = '1') then
                raddr(23 downto 16) <= data_in;
                state_frame_decode <= REC_RADDR_2;
            else
                state_frame_decode <= REC_RADDR_1;
            end if;
        elsif(state_frame_decode = REC_RADDR_2) then
            if(valid = '1') then
                raddr(15 downto 8) <= data_in;
                state_frame_decode <= REC_RADDR_3;
            else
                state_frame_decode <= REC_RADDR_2;
            end if;
        elsif(state_frame_decode = REC_RADDR_3) then
            if(valid = '1') then
                raddr(7 downto 0)  <= data_in;
                state_frame_decode <= REC_RCMD_EXE;
            else
                state_frame_decode <= REC_RADDR_3;
            end if;
        elsif(state_frame_decode = REC_RCMD_EXE) then
            if(valid = '1' and data_in(7 downto 0) = x"B2") then
                uart_read_op_ok    <= '1';
                state_frame_decode <= IDLE;
            elsif(valid = '1') then         -- wrong read command execute
                uart_read_op_ok    <= '0';
                state_frame_decode <= IDLE;
            else
                uart_read_op_ok    <= '0';
                state_frame_decode <= REC_RCMD_EXE;
            end if;
        end if;
    end if;
end process byte_to_frame_process;

drive_uart_bus_process: process(reset, clk)
begin
    if(reset = '1') then
        uartbus_out.uart_strobe <= '0';
        uartbus_out.uart_write  <= '0';
    elsif(rising_edge(clk)) then
        if(uart_write_op_ok = '1') then
            uartbus_out.uart_addr   <= waddr;
            uartbus_out.uart_wdata  <= wdata;
            uartbus_out.uart_strobe <= '1';
            uartbus_out.uart_write  <= '1';
        elsif(uart_read_op_ok = '1') then
            uartbus_out.uart_addr   <= raddr;
            uartbus_out.uart_wdata  <= (others => '0');
            uartbus_out.uart_strobe <= '1';
            uartbus_out.uart_write  <= '0';
        else
            uartbus_out.uart_strobe <= '0';
            uartbus_out.uart_write  <= '0';
        end if;
    end if;
end process drive_uart_bus_process;

get_uart_rdata_process: process(reset, clk)
begin
    if(reset = '1') then
        data_to_uart_tx     <= (others => '0');
        data_to_uart_valid  <= '0';
    elsif(rising_edge(clk)) then
        if(uartbus_in.uart_ack = '1') then
            data_to_uart_tx     <= uartbus_in.uart_rdata;
            data_to_uart_valid  <= '1';
        else
            data_to_uart_valid  <= '0';
        end if;
    end if;
end process get_uart_rdata_process;

uart_tx_data_process: process(reset, clk)
begin
    if(reset = '1') then
        state_tx_data       <= TX_IDLE;
        data_out_i          <= (others => '0');
        tx_valid_i          <= '0';
    elsif(rising_edge(clk)) then
        if(state_tx_data = TX_IDLE) then
            if(data_to_uart_valid = '1') then
                state_tx_data   <= TX_SEND_BYTE0;
            else
                state_tx_data   <= TX_IDLE;
            end if;
            tx_valid_i       <= '0';
        elsif(state_tx_data = TX_SEND_BYTE0) then
            if(tx_busy = '0') then
                data_out_i      <= data_to_uart_tx(31 downto 24);
                tx_valid_i      <= '1';
                state_tx_data   <= TX_SEND_BYTE0_WAIT;
            else
                tx_valid_i      <= '0';
                state_tx_data   <= TX_SEND_BYTE0;
            end if;
        elsif(state_tx_data = TX_SEND_BYTE0_WAIT) then
            tx_valid_i      <= '0';
            state_tx_data   <= TX_SEND_BYTE1;
        elsif(state_tx_data = TX_SEND_BYTE1) then
            if(tx_busy = '0') then
                data_out_i      <= data_to_uart_tx(23 downto 16);
                tx_valid_i      <= '1';
                state_tx_data   <= TX_SEND_BYTE1_WAIT;
            else
                tx_valid_i      <= '0';
                state_tx_data   <= TX_SEND_BYTE1;
            end if;
        elsif(state_tx_data = TX_SEND_BYTE1_WAIT) then
            tx_valid_i      <= '0';
            state_tx_data   <= TX_SEND_BYTE2;
        elsif(state_tx_data = TX_SEND_BYTE2) then
            if(tx_busy = '0') then
                data_out_i      <= data_to_uart_tx(15 downto 8);
                tx_valid_i      <= '1';
                state_tx_data   <= TX_SEND_BYTE2_WAIT;
            else
                tx_valid_i      <= '0';
                state_tx_data   <= TX_SEND_BYTE2;
            end if;
         elsif(state_tx_data = TX_SEND_BYTE2_WAIT) then
            tx_valid_i      <= '0';
            state_tx_data   <= TX_SEND_BYTE3;
         elsif(state_tx_data = TX_SEND_BYTE3) then
            if(tx_busy = '0') then
                data_out_i      <= data_to_uart_tx(7 downto 0);
                tx_valid_i      <= '1';
                state_tx_data   <= TX_IDLE;
            else
                tx_valid_i      <= '0';
                state_tx_data   <= TX_SEND_BYTE3;
            end if;
          end if;
      end if;
end process;

end behavioral;
