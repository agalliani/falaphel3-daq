
task automatic configure_default;
int i, j, k;

// pads configuration
bit [3:0] slvs_drv_strg;
bit [3:0] slvs_cmm_mode;

// pixel addressing
bit [4:0] row_address;
bit [2:0] col_address;
bit [10:0] pixel_test_value;
bit out_en;

// injector block parameters
bit inj_bypass;
bit [7:0] inj_period;
bit [7:0] inj_burst;
bit [3:0] inj_duty;
bit inj_start;

begin

	/////////////////////////////////////////////////////
	// configuring pads
	/////////////////////////////////////////////////////

	slvs_drv_strg = 4'b1010;	//   4 mA max current
	slvs_cmm_mode = 4'b0000;	// 400 mV common mode
	spi_cmd(`PAD_CONFIG_WRITE, {4'b0000, slvs_cmm_mode, slvs_drv_strg});
	spi_cmd(`PAD_CONFIG_READ, {12'h000});

	slvs_drv_strg = 4'b0111;        //   ?? mA max current
        slvs_cmm_mode = 4'b1100;        //   ?? mV common mode
        spi_cmd(`PAD_CONFIG_WRITE, {4'b0000, slvs_cmm_mode, slvs_drv_strg});
        spi_cmd(`PAD_CONFIG_READ, {12'h000});

	/////////////////////////////////////////////////////
	// testing pixel write/read capabilities
	/////////////////////////////////////////////////////

	row_address = 5'b00000;
        col_address = 3'b000;
	pixel_test_value = 11'h000;
	out_en = 1'b0;

        for(int k = 0; k <= 7; k++) begin
                for(int i = 0; i <= 31; i++) begin
                        spi_cmd(`SPI_WRITE_POINTER, {1'b0, 1'b0, 2'b11, col_address, row_address});
                        // 1'b0 - 1-b cap_25 - 5'b threshold - 1'b test_en - 1'b cap_50 - 1'b cap_csa_load - 1'b t_up - 1'b out_en
                        00010000000000010001
                        spi_cmd(`SPI_WRITE_DATA, {pixel_test_value, out_en});
			pixel_test_value = pixel_test_value + 1;
                        row_address = row_address + 1;
                end;
                col_address = col_address + 1;
        end;

	row_address = 5'b00000;
        col_address = 3'b000;

	for(int k = 0; k <= 7; k++) begin
                for(int i = 0; i <= 31; i++) begin
                        spi_cmd(`SPI_WRITE_POINTER, {1'b0, 1'b0, 2'b11, col_address, row_address});
                        // 1'b0 - 1-b cap_25 - 5'b threshold - 1'b test_en - 1'b cap_50 - 1'b cap_csa_load - 1'b t_up - 1'b out_en
                        spi_cmd(`SPI_READ_DATA,    {12'h000});
                        row_address = row_address + 1;
                end;
                col_address = col_address + 1;
        end;
	/////////////////////////////////////////////////////


	// configuring all pixels disabling them

	row_address = 5'b00000;
	col_address = 3'b000;

	for(int k = 0; k <= 7; k++) begin
		for(int i = 0; i <= 31; i++) begin
        		spi_cmd(`SPI_WRITE_POINTER, {1'b0, 1'b0, 2'b11, col_address, row_address});
			// 1'b0 - 1-b cap_25 - 5'b threshold - 1'b test_en - 1'b cap_50 - 1'b cap_csa_load - 1'b t_up - 1'b out_en
			spi_cmd(`SPI_WRITE_DATA,    {1'b0, 1'b0, 5'b00000, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0});
			row_address = row_address + 1;
		end;
		col_address = col_address + 1;
	end; 
	//

	// pixel 0: the first !
	row_address = 5'b00000;
        col_address = 3'b000;
        spi_cmd(`SPI_WRITE_POINTER, {1'b0, 1'b0, 2'b11, col_address, row_address});
        // 1'b0 - 1-b cap_25 - 5'b threshold - 1'b test_en - 1'b cap_50 - 1'b cap_csa_load - 1'b t_up - 1'b out_en
        spi_cmd(`SPI_WRITE_DATA,    {1'b0, 1'b0, 5'b00000, 1'b0, 1'b0, 1'b0, 1'b0, out_en});

	// pixel read
        spi_cmd(`SPI_READ_POINTER,  {12'h000});
        spi_cmd(`SPI_READ_DATA,     {12'h000});
	//

	// pixel 1
	row_address = 5'b00001;
        col_address = 3'b000;
        spi_cmd(`SPI_WRITE_POINTER, {1'b0, 1'b0, 2'b11, col_address, row_address});
        // 1'b0 - 1-b cap_25 - 5'b threshold - 1'b test_en - 1'b cap_50 - 1'b cap_csa_load - 1'b t_up - 1'b out_en
        spi_cmd(`SPI_WRITE_DATA,    {1'b0, 1'b0, 5'b11111, 1'b0, 1'b1, 1'b0, 1'b1, out_en});
	//

	// pixel 2
        row_address = 5'b00010;
        col_address = 3'b000;
        spi_cmd(`SPI_WRITE_POINTER, {1'b0, 1'b0, 2'b11, col_address, row_address});
        // 1'b0 - 1-b cap_25 - 5'b threshold - 1'b test_en - 1'b cap_50 - 1'b cap_csa_load - 1'b t_up - 1'b out_en
        spi_cmd(`SPI_WRITE_DATA,    {1'b0, 1'b0, 5'b00011, 1'b0, 1'b0, 1'b1, 1'b1, out_en});
        //

	// pixel 3
        row_address = 5'b00011;
        col_address = 3'b000;
        spi_cmd(`SPI_WRITE_POINTER, {1'b0, 1'b0, 2'b11, col_address, row_address});
        // 1'b0 - 1-b cap_25 - 5'b threshold - 1'b test_en - 1'b cap_50 - 1'b cap_csa_load - 1'b t_up - 1'b out_en
        spi_cmd(`SPI_WRITE_DATA,    {1'b0, 1'b0, 5'b00011, 1'b0, 1'b1, 1'b0, 1'b0, out_en});
        //

	// pixel 16
        row_address = 5'b00000;
        col_address = 3'b001;
        spi_cmd(`SPI_WRITE_POINTER, {1'b0, 1'b0, 2'b11, col_address, row_address});
        // 1'b0 - 1-b cap_25 - 5'b threshold - 1'b test_en - 1'b cap_50 - 1'b cap_csa_load - 1'b t_up - 1'b out_en
        spi_cmd(`SPI_WRITE_DATA,    {1'b0, 1'b0, 5'b00011, 1'b0, 1'b1, 1'b0, 1'b0, out_en});
        //

	// pixel 32
        row_address = 5'b00000;
        col_address = 3'b010;
        spi_cmd(`SPI_WRITE_POINTER, {1'b0, 1'b0, 2'b11, col_address, row_address});
        // 1'b0 - 1-b cap_25 - 5'b threshold - 1'b test_en - 1'b cap_50 - 1'b cap_csa_load - 1'b t_up - 1'b out_en
        spi_cmd(`SPI_WRITE_DATA,    {1'b0, 1'b0, 5'b00011, 1'b0, 1'b1, 1'b0, 1'b0, out_en});
        //

	// pixel 255: the last !
        row_address = 5'b11111;
        col_address = 3'b111;
        spi_cmd(`SPI_WRITE_POINTER, {1'b0, 1'b0, 2'b11, col_address, row_address});
        // 1'b0 - 1-b cap_25 - 5'b threshold - 1'b test_en - 1'b cap_50 - 1'b cap_csa_load - 1'b t_up - 1'b out_en
        spi_cmd(`SPI_WRITE_DATA,    {1'b0, 1'b1, 5'b11011, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1});
        //


	// configure injector_block
	inj_bypass = 1'b0;
	inj_period = 8'b00111111;
	inj_burst  = 8'b00111111;
	inj_duty   = 4'b0011;
	inj_start  = 1'b1;

        spi_cmd(`SPI_WRITE_INJ2, {inj_duty, inj_burst});               		// 4'b duty cycle - 8'b burst
        spi_cmd(`SPI_READ_INJ2,  {12'h000});

        spi_cmd(`SPI_WRITE_INJ1, {2'b00, inj_start, inj_bypass, inj_period});   // 2'b00 - 1'b start - 1'b bypass - 8'b period
        spi_cmd(`SPI_READ_INJ1,  {12'h000});	

	spi_cmd(`SPI_WRITE_INJ1, {2'b00, 1'b0, inj_bypass, inj_period});   	// 2'b00 - 1'b start - 1'b bypass - 8'b period

        wait(spi_cmd_queue.size == 0);

        $display("Falaphel chip configuration COMPLETED at time %d ns", $time);

        #500000;
	// read TOT and TOA
	for(int j=0; j< 200; j++) begin
		spi_cmd(`TOT_READ, {12'h000});
        	spi_cmd(`TOA_READ, {12'h000});
		#1000000;
        end;

end
endtask

