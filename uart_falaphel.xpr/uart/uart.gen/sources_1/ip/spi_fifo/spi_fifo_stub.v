// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Mon Jun 23 17:33:03 2025
// Host        : pcfalchieri running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub {e:/esperimenti/ignite/projects/test
//               board/firmware/uart/uart.gen/sources_1/ip/spi_fifo/spi_fifo_stub.v}
// Design      : spi_fifo
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_8,Vivado 2023.1" *)
module spi_fifo(wr_clk, rd_clk, din, wr_en, rd_en, dout, full, empty, 
  valid)
/* synthesis syn_black_box black_box_pad_pin="din[37:0],wr_en,rd_en,dout[37:0],full,empty,valid" */
/* synthesis syn_force_seq_prim="wr_clk" */
/* synthesis syn_force_seq_prim="rd_clk" */;
  input wr_clk /* synthesis syn_isclock = 1 */;
  input rd_clk /* synthesis syn_isclock = 1 */;
  input [37:0]din;
  input wr_en;
  input rd_en;
  output [37:0]dout;
  output full;
  output empty;
  output valid;
endmodule
