library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.uartbus.all;
use work.daq_package.all;

entity spi_master is
	generic(
		N_SS: positive;
		ID: integer
	);
	port(
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
end spi_master;

architecture rtl of spi_master is

    signal falaphel_spi_wr_en:                    std_logic;
	signal falaphel_spi_data_in:                  std_logic_vector(37 downto 0);
	signal falaphel_spi_reply_empty:              std_logic;
	signal falaphel_spi_reply_rd_en:              std_logic;
	signal falaphel_spi_in_rd_en_i:               std_logic;
	signal falaphel_spi_reply_rd_en_i:            std_logic;
	signal falaphel_spi_reply:                    std_logic_vector(37 downto 0);
	signal falaphel_spi_reply_valid:              std_logic;
    signal falaphel_spi_in_rd_en:                 std_logic;
	signal falaphel_spi_in_dout:                  std_logic_vector(37 downto 0);
	signal falaphel_spi_in_empty:                 std_logic;
	signal falaphel_spi_in_valid:                 std_logic;
	
	signal falaphel_spi_out_data_in:              std_logic_vector(37 downto 0) := (others => '0');
	signal falaphel_spi_out_wr_en:                std_logic;

	signal ack, onebit, miso_sig: std_logic;
	signal ss_i:       std_logic_vector(7 downto 0);
	signal sclk_i:     std_logic;
	signal mosi_i:     std_logic;
	signal rdata_i:    std_logic_vector(31 downto 0);
	signal wdata_i:    std_logic_vector(37 downto 0);
	signal do_write_spi_fifo_in:               std_logic;
	
	type   write_spi_fifo_type is (spi_fifo_idle_state, spi_fifo_write_state);
	signal state_write_spi_fifo_in:        write_spi_fifo_type := spi_fifo_idle_state; 
	
	signal spi_core_wdata:     std_logic_vector(37 downto 0);
	signal spi_core_rdata:     std_logic_vector(31 downto 0);
	signal spi_core_ack:       std_logic;
	signal spi_core_err:       std_logic;
	signal spi_core_stb:       std_logic;
	
	component spi_top
		port(
			wb_clk_i: IN std_logic;
			wb_rst_i: IN std_logic;	
			wb_adr_i : IN std_logic_vector(4 downto 0);
			wb_dat_i : IN std_logic_vector(31 downto 0);
			wb_dat_o : OUT std_logic_vector(31 downto 0);
			wb_sel_i : IN std_logic_vector(3 downto 0);
			wb_we_i  : IN std_logic;
			wb_stb_i : IN std_logic;
			wb_cyc_i : IN std_logic;
			wb_ack_o : OUT std_logic;
			wb_err_o : OUT std_logic;
			wb_int_o : OUT std_logic;
			ss_pad_o : OUT std_logic_vector(7 downto 0);
			sclk_pad_o: OUT std_logic;
			mosi_pad_o: OUT std_logic;
			miso_pad_i: IN std_logic
		);
	end component;
	
	component spi_fifo is
      port 
      (
        wr_clk : IN STD_LOGIC;
        rd_clk : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(37 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(37 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC;
        valid : OUT STD_LOGIC
      );
    end component spi_fifo;
	
	component ila_spi IS
    PORT (
    clk : IN STD_LOGIC;
    probe0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        probe1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        probe2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
    END component ila_spi;
    
    ----------------------------------------------------------------
    signal probe0:      std_logic_vector(31 downto 0);
    signal probe1:      std_logic_vector(31 downto 0);
    signal probe2:      std_logic_vector(15 downto 0);
    ----------------------------------------------------------------

	
begin

--g_SPI_DEBUG : if ID = 2 generate

----------------------------------------------------------------
---- debug -----------------------------------------------------
--probe0      <= spi_core_wdata(31 downto 0);
--probe1      <= spi_core_rdata(31 downto 0);
--probe2(0)   <= ss_i(0);
--probe2(1)   <= sclk_i;
--probe2(2)   <= mosi_i;
--probe2(3)   <= miso;
--probe2(4)   <= spi_core_ack;
--probe2(5)   <= spi_core_stb;
--probe2(6)   <= falaphel_spi_out_wr_en;
--probe2(7)   <= '0';
--probe2(15 downto 8) <= (others => '0');

--ila_spi_instance: ila_spi
--    port map 
--    (
--    clk     => falaphel_clk,
--    probe0  => probe0,
--    probe1  => probe1,
--    probe2  => probe2
--    );
    
-- end generate;
--------------------------------------------------------------

----------------------------------------------------------------
spi_fifo_in : spi_fifo
	port map 
	(
		wr_clk	    => uartbus_clk,
		rd_clk	    => falaphel_clk,
		din		    => falaphel_spi_data_in,
		wr_en	    => falaphel_spi_wr_en,
		rd_en	    => falaphel_spi_in_rd_en,
		dout	    => falaphel_spi_in_dout,
		full	    => open,
		empty	    => falaphel_spi_in_empty,
		valid	    => falaphel_spi_in_valid
	);
	
	spi_fifo_out : spi_fifo
	port map 
	(
		wr_clk	    => falaphel_clk,
		rd_clk	    => uartbus_clk,
		din		    => falaphel_spi_out_data_in,
		wr_en		=> falaphel_spi_out_wr_en,
		rd_en		=> falaphel_spi_reply_rd_en,
		dout		=> falaphel_spi_reply,
		full		=> open,
		empty		=> falaphel_spi_reply_empty,
		valid		=> falaphel_spi_reply_valid
	);
----------------------------------------------------------------	

    process(uartbus_clk)
	begin
		if(rising_edge(uartbus_clk)) then
		    if(rst = '1') then
		        ack   <= '0';
			elsif(uartbus_in.uart_strobe = '1') then
			     wdata_i(31 downto 0)    <= uartbus_in.uart_wdata;
			     wdata_i(36 downto 32)   <= uartbus_in.uart_addr(4 downto 0);
			     wdata_i(37)             <= uartbus_in.uart_write;
			     do_write_spi_fifo_in    <= '1';
			else
			     do_write_spi_fifo_in    <= '0';
			end if;
			rdata_i  <= falaphel_spi_reply(31 downto 0);
			ack      <= falaphel_spi_reply_valid;	
		end if;
	end process;
	
	uartbus_out.uart_rdata  <= rdata_i;	
	uartbus_out.uart_ack    <= ack;
	uartbus_out.uart_err    <= '0';
	
	-- write SPI FIFO IN process
	process(uartbus_clk)
	begin
		if(rising_edge(uartbus_clk)) then
		  if(state_write_spi_fifo_in = spi_fifo_idle_state) then
              if(do_write_spi_fifo_in = '1') then
                  falaphel_spi_data_in         <= wdata_i;
                  falaphel_spi_wr_en           <= '1';
                  state_write_spi_fifo_in   <= spi_fifo_write_state;
              else
                  falaphel_spi_wr_en           <= '0';
                  state_write_spi_fifo_in   <= spi_fifo_idle_state;
              end if;
           elsif(state_write_spi_fifo_in = spi_fifo_write_state) then
              falaphel_spi_wr_en           <= '0';
              if(do_write_spi_fifo_in = '0') then
                    state_write_spi_fifo_in   <= spi_fifo_idle_state;
               end if;
           end if;
        end if;
    end process;     
    
    falaphel_spi_in_rd_en    <=  falaphel_spi_in_rd_en_i and not(falaphel_spi_in_empty);
    
    -- read SPI FIFO IN process
	process(falaphel_clk)
	begin
		if(rising_edge(falaphel_clk)) then
		  if(falaphel_spi_in_empty = '0') then
		      falaphel_spi_in_rd_en_i  <= '1';
		  else
		      falaphel_spi_in_rd_en_i  <= '0';
		  end if;
		end if;
    end process;  
    
    -- preparation for spi_top process
	process(falaphel_clk)
	begin
		if(rising_edge(falaphel_clk)) then
		  if(falaphel_spi_in_valid = '1') then
              spi_core_wdata  <= falaphel_spi_in_dout;
              spi_core_stb    <= '1';
          else
              spi_core_wdata  <= (others => '0');
              spi_core_stb    <= '0';
          end if;
        end if;
    end process;           

	spi: spi_top
		port map(
			wb_clk_i     => falaphel_clk,
			wb_rst_i     => '0',
			wb_adr_i     => spi_core_wdata(36 downto 32),
			wb_dat_i     => spi_core_wdata(31 downto 0),
			wb_dat_o     => spi_core_rdata,
			wb_sel_i     => std_logic_vector'("1111"),
			wb_we_i      => spi_core_wdata(37),
			wb_stb_i     => spi_core_stb,
			wb_cyc_i     => std_logic'('1'),
			wb_ack_o     => spi_core_ack,
			wb_err_o     => spi_core_err,
			wb_int_o     => open,
			----------------------------------------------------
			ss_pad_o     => ss_i,
			sclk_pad_o   => sclk_i,
			mosi_pad_o   => mosi_i,
			miso_pad_i   => miso_sig
		);
	
	ss                 <= ss_i(0);
	sclk               <= sclk_i;
	mosi               <= mosi_i;
	miso_sig           <= miso;
	
	-- write SPI FIFO OUT process
	process(falaphel_clk)
	begin
		if(rising_edge(falaphel_clk)) then
		  if(spi_core_ack = '1') then
		      falaphel_spi_out_data_in(31 downto 0)  <= spi_core_rdata;
		      falaphel_spi_out_data_in(37 downto 32) <= (others => '0');
		      falaphel_spi_out_wr_en                 <= '1';
		  else
		      falaphel_spi_out_wr_en  <= '0';
		  end if;
		end if;
    end process;
    
    falaphel_spi_reply_rd_en    <=  falaphel_spi_reply_rd_en_i and not(falaphel_spi_reply_empty);
    
    -- read SPI FIFO OUT process
	process(uartbus_clk)
	begin
		if(rising_edge(uartbus_clk)) then
		  if(falaphel_spi_reply_empty = '0') then
		      falaphel_spi_reply_rd_en_i  <= '1';
		  else
		      falaphel_spi_reply_rd_en_i  <= '0';
		  end if;
		end if;
    end process;
	
end rtl;