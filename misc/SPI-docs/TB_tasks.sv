
integer file_spi;

`define LOG_SPI(x)     $fdisplay(file_spi, x)

initial begin
        file_spi = $fopen("spi_accesses.txt","w"); 		// opening the SPI accesses file
        if(!file_spi) begin
                $display("Couldn't open spi_accesses.txt. Aborting");
                $stop;
        end
end

/*
* SPI handling
*/

logic [23:0] spi_cmd_queue[$];
task automatic spi_cmd;
        input [3:0] cmd;
        input [11:0] data;
begin
        spi_cmd_queue.push_front( {cmd, 4'b0000, data} );
end
endtask


task automatic spi_auto_send;

string spi_string_tx;
string spi_string_rx;

begin fork
while (1) begin
        while (spi_cmd_queue.size == 0 || spi_busy == 1'b1)
                @(posedge CLK40);

        #1000;
        @(posedge CLK40);
        @(posedge CLK40);
        @(posedge CLK40);
        @(posedge CLK40);

        spi_tx = spi_cmd_queue.pop_back();
        spi_enable = 1'b1;

	//`LOG_SPI(($sformatf("%7d - Sending SPI command: 0x%h", $time, spi_tx)));

        case (spi_tx[19:16])
        4'b0000:
                spi_string_tx = "SPI_WRITE_POINTER";
        4'b0001:
                spi_string_tx = "SPI_WRITE_DATA";
        4'b0010:
                spi_string_tx = "SPI_WRITE_INJ1";
        4'b0011:
                spi_string_tx = "SPI_WRITE_INJ2";
	4'b0110:
                spi_string_tx = "SPI_WRITE_PADS";
        4'b1000:
                spi_string_tx = "SPI_READ_POINTER";
        4'b1001:
                spi_string_tx = "SPI_READ_DATA";
        4'b1010:
                spi_string_tx = "SPI_READ_INJ1";
        4'b1011:
                spi_string_tx = "SPI_READ_INJ2";
	4'b1100:
                spi_string_tx = "TOT_READ";
	4'b1101:
                spi_string_tx = "TOA_READ";
        4'b1110:
                spi_string_tx = "SPI_READ_PADS";
        endcase


        `LOG_SPI($sformatf("Sending SPI command: %s 0x%h 0x%h", spi_string_tx, spi_tx[19:16], spi_tx[11:0]));

	
        @(posedge CLK40);
        spi_enable = 1'b0;

        @(negedge spi_busy);
        @(posedge CLK40);

	case (spi_rx[19:16])
        4'b0000:
                spi_string_rx = "SPI_WRITE_POINTER";
        4'b0001:
                spi_string_rx = "SPI_WRITE_DATA";
        4'b0010:
                spi_string_rx = "SPI_WRITE_INJ1";
        4'b0011:
                spi_string_rx = "SPI_WRITE_INJ2";
        4'b0110:
                spi_string_rx = "SPI_WRITE_PADS";
        4'b1000:
                spi_string_rx = "SPI_READ_POINTER";
        4'b1001:
                spi_string_rx = "SPI_READ_DATA";
        4'b1010:
                spi_string_rx = "SPI_READ_INJ1";
        4'b1011:
                spi_string_rx = "SPI_READ_INJ2";
        4'b1100:
                spi_string_rx = "TOT_READ";
        4'b1101:
                spi_string_rx = "TOA_READ";
        4'b1110:
                spi_string_rx = "SPI_READ_PADS";
        endcase

        `LOG_SPI($sformatf("Receiving SPI data: %s 0x%h 0x%h", spi_string_rx, spi_rx[19:16], spi_rx[11:0]));

        //if(spi_string_rx == "SPI_WRITE_POINTER") 
	if(!spi_rx[19])
	begin
		if(spi_tx == spi_rx) 
			begin
				`LOG_SPI($sformatf("Check OK\n"));
			end
        	else 
			begin
				`LOG_SPI($sformatf("Error\n"));
			end
	end
	else
		begin
			`LOG_SPI($sformatf("\n"));
		end

        @(posedge CLK40);

end join_none end
endtask


