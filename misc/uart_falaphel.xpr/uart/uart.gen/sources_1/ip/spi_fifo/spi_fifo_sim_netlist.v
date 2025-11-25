// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Mon Jun 23 17:33:03 2025
// Host        : pcfalchieri running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim {e:/esperimenti/ignite/projects/test
//               board/firmware/uart/uart.gen/sources_1/ip/spi_fifo/spi_fifo_sim_netlist.v}
// Design      : spi_fifo
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "spi_fifo,fifo_generator_v13_2_8,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_8,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module spi_fifo
   (wr_clk,
    rd_clk,
    din,
    wr_en,
    rd_en,
    dout,
    full,
    empty,
    valid);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 write_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME write_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input wr_clk;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 read_clk CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME read_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0" *) input rd_clk;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_DATA" *) input [37:0]din;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE WR_EN" *) input wr_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_EN" *) input rd_en;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ RD_DATA" *) output [37:0]dout;
  (* x_interface_info = "xilinx.com:interface:fifo_write:1.0 FIFO_WRITE FULL" *) output full;
  (* x_interface_info = "xilinx.com:interface:fifo_read:1.0 FIFO_READ EMPTY" *) output empty;
  output valid;

  wire [37:0]din;
  wire [37:0]dout;
  wire empty;
  wire full;
  wire rd_clk;
  wire rd_en;
  wire valid;
  wire wr_clk;
  wire wr_en;
  wire NLW_U0_almost_empty_UNCONNECTED;
  wire NLW_U0_almost_full_UNCONNECTED;
  wire NLW_U0_axi_ar_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_overflow_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_ar_prog_full_UNCONNECTED;
  wire NLW_U0_axi_ar_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_ar_underflow_UNCONNECTED;
  wire NLW_U0_axi_aw_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_overflow_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_aw_prog_full_UNCONNECTED;
  wire NLW_U0_axi_aw_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_aw_underflow_UNCONNECTED;
  wire NLW_U0_axi_b_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_overflow_UNCONNECTED;
  wire NLW_U0_axi_b_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_b_prog_full_UNCONNECTED;
  wire NLW_U0_axi_b_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_b_underflow_UNCONNECTED;
  wire NLW_U0_axi_r_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_overflow_UNCONNECTED;
  wire NLW_U0_axi_r_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_r_prog_full_UNCONNECTED;
  wire NLW_U0_axi_r_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_r_underflow_UNCONNECTED;
  wire NLW_U0_axi_w_dbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_overflow_UNCONNECTED;
  wire NLW_U0_axi_w_prog_empty_UNCONNECTED;
  wire NLW_U0_axi_w_prog_full_UNCONNECTED;
  wire NLW_U0_axi_w_sbiterr_UNCONNECTED;
  wire NLW_U0_axi_w_underflow_UNCONNECTED;
  wire NLW_U0_axis_dbiterr_UNCONNECTED;
  wire NLW_U0_axis_overflow_UNCONNECTED;
  wire NLW_U0_axis_prog_empty_UNCONNECTED;
  wire NLW_U0_axis_prog_full_UNCONNECTED;
  wire NLW_U0_axis_sbiterr_UNCONNECTED;
  wire NLW_U0_axis_underflow_UNCONNECTED;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_m_axi_arvalid_UNCONNECTED;
  wire NLW_U0_m_axi_awvalid_UNCONNECTED;
  wire NLW_U0_m_axi_bready_UNCONNECTED;
  wire NLW_U0_m_axi_rready_UNCONNECTED;
  wire NLW_U0_m_axi_wlast_UNCONNECTED;
  wire NLW_U0_m_axi_wvalid_UNCONNECTED;
  wire NLW_U0_m_axis_tlast_UNCONNECTED;
  wire NLW_U0_m_axis_tvalid_UNCONNECTED;
  wire NLW_U0_overflow_UNCONNECTED;
  wire NLW_U0_prog_empty_UNCONNECTED;
  wire NLW_U0_prog_full_UNCONNECTED;
  wire NLW_U0_rd_rst_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_s_axis_tready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire NLW_U0_underflow_UNCONNECTED;
  wire NLW_U0_wr_ack_UNCONNECTED;
  wire NLW_U0_wr_rst_busy_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_ar_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_aw_wr_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_rd_data_count_UNCONNECTED;
  wire [4:0]NLW_U0_axi_b_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_r_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axi_w_wr_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_rd_data_count_UNCONNECTED;
  wire [10:0]NLW_U0_axis_wr_data_count_UNCONNECTED;
  wire [5:0]NLW_U0_data_count_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_araddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_arburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_arlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_arlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_arregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_arsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_aruser_UNCONNECTED;
  wire [31:0]NLW_U0_m_axi_awaddr_UNCONNECTED;
  wire [1:0]NLW_U0_m_axi_awburst_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awcache_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_awlen_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awlock_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awprot_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awqos_UNCONNECTED;
  wire [3:0]NLW_U0_m_axi_awregion_UNCONNECTED;
  wire [2:0]NLW_U0_m_axi_awsize_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_awuser_UNCONNECTED;
  wire [63:0]NLW_U0_m_axi_wdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wid_UNCONNECTED;
  wire [7:0]NLW_U0_m_axi_wstrb_UNCONNECTED;
  wire [0:0]NLW_U0_m_axi_wuser_UNCONNECTED;
  wire [7:0]NLW_U0_m_axis_tdata_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tdest_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tid_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tkeep_UNCONNECTED;
  wire [0:0]NLW_U0_m_axis_tstrb_UNCONNECTED;
  wire [3:0]NLW_U0_m_axis_tuser_UNCONNECTED;
  wire [5:0]NLW_U0_rd_data_count_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_buser_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;
  wire [0:0]NLW_U0_s_axi_ruser_UNCONNECTED;
  wire [5:0]NLW_U0_wr_data_count_UNCONNECTED;

  (* C_ADD_NGC_CONSTRAINT = "0" *) 
  (* C_APPLICATION_TYPE_AXIS = "0" *) 
  (* C_APPLICATION_TYPE_RACH = "0" *) 
  (* C_APPLICATION_TYPE_RDCH = "0" *) 
  (* C_APPLICATION_TYPE_WACH = "0" *) 
  (* C_APPLICATION_TYPE_WDCH = "0" *) 
  (* C_APPLICATION_TYPE_WRCH = "0" *) 
  (* C_AXIS_TDATA_WIDTH = "8" *) 
  (* C_AXIS_TDEST_WIDTH = "1" *) 
  (* C_AXIS_TID_WIDTH = "1" *) 
  (* C_AXIS_TKEEP_WIDTH = "1" *) 
  (* C_AXIS_TSTRB_WIDTH = "1" *) 
  (* C_AXIS_TUSER_WIDTH = "4" *) 
  (* C_AXIS_TYPE = "0" *) 
  (* C_AXI_ADDR_WIDTH = "32" *) 
  (* C_AXI_ARUSER_WIDTH = "1" *) 
  (* C_AXI_AWUSER_WIDTH = "1" *) 
  (* C_AXI_BUSER_WIDTH = "1" *) 
  (* C_AXI_DATA_WIDTH = "64" *) 
  (* C_AXI_ID_WIDTH = "1" *) 
  (* C_AXI_LEN_WIDTH = "8" *) 
  (* C_AXI_LOCK_WIDTH = "1" *) 
  (* C_AXI_RUSER_WIDTH = "1" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_AXI_WUSER_WIDTH = "1" *) 
  (* C_COMMON_CLOCK = "0" *) 
  (* C_COUNT_TYPE = "0" *) 
  (* C_DATA_COUNT_WIDTH = "6" *) 
  (* C_DEFAULT_VALUE = "BlankString" *) 
  (* C_DIN_WIDTH = "38" *) 
  (* C_DIN_WIDTH_AXIS = "1" *) 
  (* C_DIN_WIDTH_RACH = "32" *) 
  (* C_DIN_WIDTH_RDCH = "64" *) 
  (* C_DIN_WIDTH_WACH = "1" *) 
  (* C_DIN_WIDTH_WDCH = "64" *) 
  (* C_DIN_WIDTH_WRCH = "2" *) 
  (* C_DOUT_RST_VAL = "0" *) 
  (* C_DOUT_WIDTH = "38" *) 
  (* C_ENABLE_RLOCS = "0" *) 
  (* C_ENABLE_RST_SYNC = "1" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_ERROR_INJECTION_TYPE = "0" *) 
  (* C_ERROR_INJECTION_TYPE_AXIS = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_RDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WACH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WDCH = "0" *) 
  (* C_ERROR_INJECTION_TYPE_WRCH = "0" *) 
  (* C_FAMILY = "kintex7" *) 
  (* C_FULL_FLAGS_RST_VAL = "0" *) 
  (* C_HAS_ALMOST_EMPTY = "0" *) 
  (* C_HAS_ALMOST_FULL = "0" *) 
  (* C_HAS_AXIS_TDATA = "1" *) 
  (* C_HAS_AXIS_TDEST = "0" *) 
  (* C_HAS_AXIS_TID = "0" *) 
  (* C_HAS_AXIS_TKEEP = "0" *) 
  (* C_HAS_AXIS_TLAST = "0" *) 
  (* C_HAS_AXIS_TREADY = "1" *) 
  (* C_HAS_AXIS_TSTRB = "0" *) 
  (* C_HAS_AXIS_TUSER = "1" *) 
  (* C_HAS_AXI_ARUSER = "0" *) 
  (* C_HAS_AXI_AWUSER = "0" *) 
  (* C_HAS_AXI_BUSER = "0" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_AXI_RD_CHANNEL = "1" *) 
  (* C_HAS_AXI_RUSER = "0" *) 
  (* C_HAS_AXI_WR_CHANNEL = "1" *) 
  (* C_HAS_AXI_WUSER = "0" *) 
  (* C_HAS_BACKUP = "0" *) 
  (* C_HAS_DATA_COUNT = "0" *) 
  (* C_HAS_DATA_COUNTS_AXIS = "0" *) 
  (* C_HAS_DATA_COUNTS_RACH = "0" *) 
  (* C_HAS_DATA_COUNTS_RDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WACH = "0" *) 
  (* C_HAS_DATA_COUNTS_WDCH = "0" *) 
  (* C_HAS_DATA_COUNTS_WRCH = "0" *) 
  (* C_HAS_INT_CLK = "0" *) 
  (* C_HAS_MASTER_CE = "0" *) 
  (* C_HAS_MEMINIT_FILE = "0" *) 
  (* C_HAS_OVERFLOW = "0" *) 
  (* C_HAS_PROG_FLAGS_AXIS = "0" *) 
  (* C_HAS_PROG_FLAGS_RACH = "0" *) 
  (* C_HAS_PROG_FLAGS_RDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WACH = "0" *) 
  (* C_HAS_PROG_FLAGS_WDCH = "0" *) 
  (* C_HAS_PROG_FLAGS_WRCH = "0" *) 
  (* C_HAS_RD_DATA_COUNT = "0" *) 
  (* C_HAS_RD_RST = "0" *) 
  (* C_HAS_RST = "0" *) 
  (* C_HAS_SLAVE_CE = "0" *) 
  (* C_HAS_SRST = "0" *) 
  (* C_HAS_UNDERFLOW = "0" *) 
  (* C_HAS_VALID = "1" *) 
  (* C_HAS_WR_ACK = "0" *) 
  (* C_HAS_WR_DATA_COUNT = "0" *) 
  (* C_HAS_WR_RST = "0" *) 
  (* C_IMPLEMENTATION_TYPE = "2" *) 
  (* C_IMPLEMENTATION_TYPE_AXIS = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_RDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WACH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WDCH = "1" *) 
  (* C_IMPLEMENTATION_TYPE_WRCH = "1" *) 
  (* C_INIT_WR_PNTR_VAL = "0" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_MEMORY_TYPE = "1" *) 
  (* C_MIF_FILE_NAME = "BlankString" *) 
  (* C_MSGON_VAL = "1" *) 
  (* C_OPTIMIZATION_MODE = "0" *) 
  (* C_OVERFLOW_LOW = "0" *) 
  (* C_POWER_SAVING_MODE = "0" *) 
  (* C_PRELOAD_LATENCY = "1" *) 
  (* C_PRELOAD_REGS = "0" *) 
  (* C_PRIM_FIFO_TYPE = "512x72" *) 
  (* C_PRIM_FIFO_TYPE_AXIS = "1kx18" *) 
  (* C_PRIM_FIFO_TYPE_RACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_RDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WACH = "512x36" *) 
  (* C_PRIM_FIFO_TYPE_WDCH = "1kx36" *) 
  (* C_PRIM_FIFO_TYPE_WRCH = "512x36" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL = "2" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH = "1022" *) 
  (* C_PROG_EMPTY_THRESH_NEGATE_VAL = "3" *) 
  (* C_PROG_EMPTY_TYPE = "0" *) 
  (* C_PROG_EMPTY_TYPE_AXIS = "0" *) 
  (* C_PROG_EMPTY_TYPE_RACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_RDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WACH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WDCH = "0" *) 
  (* C_PROG_EMPTY_TYPE_WRCH = "0" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL = "61" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_AXIS = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_RDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WACH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WDCH = "1023" *) 
  (* C_PROG_FULL_THRESH_ASSERT_VAL_WRCH = "1023" *) 
  (* C_PROG_FULL_THRESH_NEGATE_VAL = "60" *) 
  (* C_PROG_FULL_TYPE = "0" *) 
  (* C_PROG_FULL_TYPE_AXIS = "0" *) 
  (* C_PROG_FULL_TYPE_RACH = "0" *) 
  (* C_PROG_FULL_TYPE_RDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WACH = "0" *) 
  (* C_PROG_FULL_TYPE_WDCH = "0" *) 
  (* C_PROG_FULL_TYPE_WRCH = "0" *) 
  (* C_RACH_TYPE = "0" *) 
  (* C_RDCH_TYPE = "0" *) 
  (* C_RD_DATA_COUNT_WIDTH = "6" *) 
  (* C_RD_DEPTH = "64" *) 
  (* C_RD_FREQ = "1" *) 
  (* C_RD_PNTR_WIDTH = "6" *) 
  (* C_REG_SLICE_MODE_AXIS = "0" *) 
  (* C_REG_SLICE_MODE_RACH = "0" *) 
  (* C_REG_SLICE_MODE_RDCH = "0" *) 
  (* C_REG_SLICE_MODE_WACH = "0" *) 
  (* C_REG_SLICE_MODE_WDCH = "0" *) 
  (* C_REG_SLICE_MODE_WRCH = "0" *) 
  (* C_SELECT_XPM = "0" *) 
  (* C_SYNCHRONIZER_STAGE = "2" *) 
  (* C_UNDERFLOW_LOW = "0" *) 
  (* C_USE_COMMON_OVERFLOW = "0" *) 
  (* C_USE_COMMON_UNDERFLOW = "0" *) 
  (* C_USE_DEFAULT_SETTINGS = "0" *) 
  (* C_USE_DOUT_RST = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_ECC_AXIS = "0" *) 
  (* C_USE_ECC_RACH = "0" *) 
  (* C_USE_ECC_RDCH = "0" *) 
  (* C_USE_ECC_WACH = "0" *) 
  (* C_USE_ECC_WDCH = "0" *) 
  (* C_USE_ECC_WRCH = "0" *) 
  (* C_USE_EMBEDDED_REG = "0" *) 
  (* C_USE_FIFO16_FLAGS = "0" *) 
  (* C_USE_FWFT_DATA_COUNT = "0" *) 
  (* C_USE_PIPELINE_REG = "0" *) 
  (* C_VALID_LOW = "0" *) 
  (* C_WACH_TYPE = "0" *) 
  (* C_WDCH_TYPE = "0" *) 
  (* C_WRCH_TYPE = "0" *) 
  (* C_WR_ACK_LOW = "0" *) 
  (* C_WR_DATA_COUNT_WIDTH = "6" *) 
  (* C_WR_DEPTH = "64" *) 
  (* C_WR_DEPTH_AXIS = "1024" *) 
  (* C_WR_DEPTH_RACH = "16" *) 
  (* C_WR_DEPTH_RDCH = "1024" *) 
  (* C_WR_DEPTH_WACH = "16" *) 
  (* C_WR_DEPTH_WDCH = "1024" *) 
  (* C_WR_DEPTH_WRCH = "16" *) 
  (* C_WR_FREQ = "1" *) 
  (* C_WR_PNTR_WIDTH = "6" *) 
  (* C_WR_PNTR_WIDTH_AXIS = "10" *) 
  (* C_WR_PNTR_WIDTH_RACH = "4" *) 
  (* C_WR_PNTR_WIDTH_RDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WACH = "4" *) 
  (* C_WR_PNTR_WIDTH_WDCH = "10" *) 
  (* C_WR_PNTR_WIDTH_WRCH = "4" *) 
  (* C_WR_RESPONSE_LATENCY = "1" *) 
  (* is_du_within_envelope = "true" *) 
  spi_fifo_fifo_generator_v13_2_8 U0
       (.almost_empty(NLW_U0_almost_empty_UNCONNECTED),
        .almost_full(NLW_U0_almost_full_UNCONNECTED),
        .axi_ar_data_count(NLW_U0_axi_ar_data_count_UNCONNECTED[4:0]),
        .axi_ar_dbiterr(NLW_U0_axi_ar_dbiterr_UNCONNECTED),
        .axi_ar_injectdbiterr(1'b0),
        .axi_ar_injectsbiterr(1'b0),
        .axi_ar_overflow(NLW_U0_axi_ar_overflow_UNCONNECTED),
        .axi_ar_prog_empty(NLW_U0_axi_ar_prog_empty_UNCONNECTED),
        .axi_ar_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_prog_full(NLW_U0_axi_ar_prog_full_UNCONNECTED),
        .axi_ar_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_ar_rd_data_count(NLW_U0_axi_ar_rd_data_count_UNCONNECTED[4:0]),
        .axi_ar_sbiterr(NLW_U0_axi_ar_sbiterr_UNCONNECTED),
        .axi_ar_underflow(NLW_U0_axi_ar_underflow_UNCONNECTED),
        .axi_ar_wr_data_count(NLW_U0_axi_ar_wr_data_count_UNCONNECTED[4:0]),
        .axi_aw_data_count(NLW_U0_axi_aw_data_count_UNCONNECTED[4:0]),
        .axi_aw_dbiterr(NLW_U0_axi_aw_dbiterr_UNCONNECTED),
        .axi_aw_injectdbiterr(1'b0),
        .axi_aw_injectsbiterr(1'b0),
        .axi_aw_overflow(NLW_U0_axi_aw_overflow_UNCONNECTED),
        .axi_aw_prog_empty(NLW_U0_axi_aw_prog_empty_UNCONNECTED),
        .axi_aw_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_prog_full(NLW_U0_axi_aw_prog_full_UNCONNECTED),
        .axi_aw_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_aw_rd_data_count(NLW_U0_axi_aw_rd_data_count_UNCONNECTED[4:0]),
        .axi_aw_sbiterr(NLW_U0_axi_aw_sbiterr_UNCONNECTED),
        .axi_aw_underflow(NLW_U0_axi_aw_underflow_UNCONNECTED),
        .axi_aw_wr_data_count(NLW_U0_axi_aw_wr_data_count_UNCONNECTED[4:0]),
        .axi_b_data_count(NLW_U0_axi_b_data_count_UNCONNECTED[4:0]),
        .axi_b_dbiterr(NLW_U0_axi_b_dbiterr_UNCONNECTED),
        .axi_b_injectdbiterr(1'b0),
        .axi_b_injectsbiterr(1'b0),
        .axi_b_overflow(NLW_U0_axi_b_overflow_UNCONNECTED),
        .axi_b_prog_empty(NLW_U0_axi_b_prog_empty_UNCONNECTED),
        .axi_b_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_prog_full(NLW_U0_axi_b_prog_full_UNCONNECTED),
        .axi_b_prog_full_thresh({1'b0,1'b0,1'b0,1'b0}),
        .axi_b_rd_data_count(NLW_U0_axi_b_rd_data_count_UNCONNECTED[4:0]),
        .axi_b_sbiterr(NLW_U0_axi_b_sbiterr_UNCONNECTED),
        .axi_b_underflow(NLW_U0_axi_b_underflow_UNCONNECTED),
        .axi_b_wr_data_count(NLW_U0_axi_b_wr_data_count_UNCONNECTED[4:0]),
        .axi_r_data_count(NLW_U0_axi_r_data_count_UNCONNECTED[10:0]),
        .axi_r_dbiterr(NLW_U0_axi_r_dbiterr_UNCONNECTED),
        .axi_r_injectdbiterr(1'b0),
        .axi_r_injectsbiterr(1'b0),
        .axi_r_overflow(NLW_U0_axi_r_overflow_UNCONNECTED),
        .axi_r_prog_empty(NLW_U0_axi_r_prog_empty_UNCONNECTED),
        .axi_r_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_prog_full(NLW_U0_axi_r_prog_full_UNCONNECTED),
        .axi_r_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_r_rd_data_count(NLW_U0_axi_r_rd_data_count_UNCONNECTED[10:0]),
        .axi_r_sbiterr(NLW_U0_axi_r_sbiterr_UNCONNECTED),
        .axi_r_underflow(NLW_U0_axi_r_underflow_UNCONNECTED),
        .axi_r_wr_data_count(NLW_U0_axi_r_wr_data_count_UNCONNECTED[10:0]),
        .axi_w_data_count(NLW_U0_axi_w_data_count_UNCONNECTED[10:0]),
        .axi_w_dbiterr(NLW_U0_axi_w_dbiterr_UNCONNECTED),
        .axi_w_injectdbiterr(1'b0),
        .axi_w_injectsbiterr(1'b0),
        .axi_w_overflow(NLW_U0_axi_w_overflow_UNCONNECTED),
        .axi_w_prog_empty(NLW_U0_axi_w_prog_empty_UNCONNECTED),
        .axi_w_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_prog_full(NLW_U0_axi_w_prog_full_UNCONNECTED),
        .axi_w_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axi_w_rd_data_count(NLW_U0_axi_w_rd_data_count_UNCONNECTED[10:0]),
        .axi_w_sbiterr(NLW_U0_axi_w_sbiterr_UNCONNECTED),
        .axi_w_underflow(NLW_U0_axi_w_underflow_UNCONNECTED),
        .axi_w_wr_data_count(NLW_U0_axi_w_wr_data_count_UNCONNECTED[10:0]),
        .axis_data_count(NLW_U0_axis_data_count_UNCONNECTED[10:0]),
        .axis_dbiterr(NLW_U0_axis_dbiterr_UNCONNECTED),
        .axis_injectdbiterr(1'b0),
        .axis_injectsbiterr(1'b0),
        .axis_overflow(NLW_U0_axis_overflow_UNCONNECTED),
        .axis_prog_empty(NLW_U0_axis_prog_empty_UNCONNECTED),
        .axis_prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_prog_full(NLW_U0_axis_prog_full_UNCONNECTED),
        .axis_prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .axis_rd_data_count(NLW_U0_axis_rd_data_count_UNCONNECTED[10:0]),
        .axis_sbiterr(NLW_U0_axis_sbiterr_UNCONNECTED),
        .axis_underflow(NLW_U0_axis_underflow_UNCONNECTED),
        .axis_wr_data_count(NLW_U0_axis_wr_data_count_UNCONNECTED[10:0]),
        .backup(1'b0),
        .backup_marker(1'b0),
        .clk(1'b0),
        .data_count(NLW_U0_data_count_UNCONNECTED[5:0]),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .din(din),
        .dout(dout),
        .empty(empty),
        .full(full),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .int_clk(1'b0),
        .m_aclk(1'b0),
        .m_aclk_en(1'b0),
        .m_axi_araddr(NLW_U0_m_axi_araddr_UNCONNECTED[31:0]),
        .m_axi_arburst(NLW_U0_m_axi_arburst_UNCONNECTED[1:0]),
        .m_axi_arcache(NLW_U0_m_axi_arcache_UNCONNECTED[3:0]),
        .m_axi_arid(NLW_U0_m_axi_arid_UNCONNECTED[0]),
        .m_axi_arlen(NLW_U0_m_axi_arlen_UNCONNECTED[7:0]),
        .m_axi_arlock(NLW_U0_m_axi_arlock_UNCONNECTED[0]),
        .m_axi_arprot(NLW_U0_m_axi_arprot_UNCONNECTED[2:0]),
        .m_axi_arqos(NLW_U0_m_axi_arqos_UNCONNECTED[3:0]),
        .m_axi_arready(1'b0),
        .m_axi_arregion(NLW_U0_m_axi_arregion_UNCONNECTED[3:0]),
        .m_axi_arsize(NLW_U0_m_axi_arsize_UNCONNECTED[2:0]),
        .m_axi_aruser(NLW_U0_m_axi_aruser_UNCONNECTED[0]),
        .m_axi_arvalid(NLW_U0_m_axi_arvalid_UNCONNECTED),
        .m_axi_awaddr(NLW_U0_m_axi_awaddr_UNCONNECTED[31:0]),
        .m_axi_awburst(NLW_U0_m_axi_awburst_UNCONNECTED[1:0]),
        .m_axi_awcache(NLW_U0_m_axi_awcache_UNCONNECTED[3:0]),
        .m_axi_awid(NLW_U0_m_axi_awid_UNCONNECTED[0]),
        .m_axi_awlen(NLW_U0_m_axi_awlen_UNCONNECTED[7:0]),
        .m_axi_awlock(NLW_U0_m_axi_awlock_UNCONNECTED[0]),
        .m_axi_awprot(NLW_U0_m_axi_awprot_UNCONNECTED[2:0]),
        .m_axi_awqos(NLW_U0_m_axi_awqos_UNCONNECTED[3:0]),
        .m_axi_awready(1'b0),
        .m_axi_awregion(NLW_U0_m_axi_awregion_UNCONNECTED[3:0]),
        .m_axi_awsize(NLW_U0_m_axi_awsize_UNCONNECTED[2:0]),
        .m_axi_awuser(NLW_U0_m_axi_awuser_UNCONNECTED[0]),
        .m_axi_awvalid(NLW_U0_m_axi_awvalid_UNCONNECTED),
        .m_axi_bid(1'b0),
        .m_axi_bready(NLW_U0_m_axi_bready_UNCONNECTED),
        .m_axi_bresp({1'b0,1'b0}),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(1'b0),
        .m_axi_rdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .m_axi_rid(1'b0),
        .m_axi_rlast(1'b0),
        .m_axi_rready(NLW_U0_m_axi_rready_UNCONNECTED),
        .m_axi_rresp({1'b0,1'b0}),
        .m_axi_ruser(1'b0),
        .m_axi_rvalid(1'b0),
        .m_axi_wdata(NLW_U0_m_axi_wdata_UNCONNECTED[63:0]),
        .m_axi_wid(NLW_U0_m_axi_wid_UNCONNECTED[0]),
        .m_axi_wlast(NLW_U0_m_axi_wlast_UNCONNECTED),
        .m_axi_wready(1'b0),
        .m_axi_wstrb(NLW_U0_m_axi_wstrb_UNCONNECTED[7:0]),
        .m_axi_wuser(NLW_U0_m_axi_wuser_UNCONNECTED[0]),
        .m_axi_wvalid(NLW_U0_m_axi_wvalid_UNCONNECTED),
        .m_axis_tdata(NLW_U0_m_axis_tdata_UNCONNECTED[7:0]),
        .m_axis_tdest(NLW_U0_m_axis_tdest_UNCONNECTED[0]),
        .m_axis_tid(NLW_U0_m_axis_tid_UNCONNECTED[0]),
        .m_axis_tkeep(NLW_U0_m_axis_tkeep_UNCONNECTED[0]),
        .m_axis_tlast(NLW_U0_m_axis_tlast_UNCONNECTED),
        .m_axis_tready(1'b0),
        .m_axis_tstrb(NLW_U0_m_axis_tstrb_UNCONNECTED[0]),
        .m_axis_tuser(NLW_U0_m_axis_tuser_UNCONNECTED[3:0]),
        .m_axis_tvalid(NLW_U0_m_axis_tvalid_UNCONNECTED),
        .overflow(NLW_U0_overflow_UNCONNECTED),
        .prog_empty(NLW_U0_prog_empty_UNCONNECTED),
        .prog_empty_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_empty_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full(NLW_U0_prog_full_UNCONNECTED),
        .prog_full_thresh({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_assert({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .prog_full_thresh_negate({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .rd_clk(rd_clk),
        .rd_data_count(NLW_U0_rd_data_count_UNCONNECTED[5:0]),
        .rd_en(rd_en),
        .rd_rst(1'b0),
        .rd_rst_busy(NLW_U0_rd_rst_busy_UNCONNECTED),
        .rst(1'b0),
        .s_aclk(1'b0),
        .s_aclk_en(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid(1'b0),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock(1'b0),
        .s_axi_arprot({1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_aruser(1'b0),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awcache({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awid(1'b0),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlock(1'b0),
        .s_axi_awprot({1'b0,1'b0,1'b0}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awregion({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awuser(1'b0),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_buser(NLW_U0_s_axi_buser_UNCONNECTED[0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_ruser(NLW_U0_s_axi_ruser_UNCONNECTED[0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wid(1'b0),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wuser(1'b0),
        .s_axi_wvalid(1'b0),
        .s_axis_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tdest(1'b0),
        .s_axis_tid(1'b0),
        .s_axis_tkeep(1'b0),
        .s_axis_tlast(1'b0),
        .s_axis_tready(NLW_U0_s_axis_tready_UNCONNECTED),
        .s_axis_tstrb(1'b0),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0}),
        .s_axis_tvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .sleep(1'b0),
        .srst(1'b0),
        .underflow(NLW_U0_underflow_UNCONNECTED),
        .valid(valid),
        .wr_ack(NLW_U0_wr_ack_UNCONNECTED),
        .wr_clk(wr_clk),
        .wr_data_count(NLW_U0_wr_data_count_UNCONNECTED[5:0]),
        .wr_en(wr_en),
        .wr_rst(1'b0),
        .wr_rst_busy(NLW_U0_wr_rst_busy_UNCONNECTED));
endmodule

(* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_gray" *) 
(* REG_OUTPUT = "1" *) (* SIM_ASSERT_CHK = "0" *) (* SIM_LOSSLESS_GRAY_CHK = "0" *) 
(* VERSION = "0" *) (* WIDTH = "6" *) (* XPM_MODULE = "TRUE" *) 
(* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) (* xpm_cdc = "GRAY" *) 
module spi_fifo_xpm_cdc_gray
   (src_clk,
    src_in_bin,
    dest_clk,
    dest_out_bin);
  input src_clk;
  input [5:0]src_in_bin;
  input dest_clk;
  output [5:0]dest_out_bin;

  wire [5:0]async_path;
  wire [4:0]binval;
  wire dest_clk;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [5:0]\dest_graysync_ff[0] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [5:0]\dest_graysync_ff[1] ;
  wire [5:0]dest_out_bin;
  wire [4:0]gray_enc;
  wire src_clk;
  wire [5:0]src_in_bin;

  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[0]),
        .Q(\dest_graysync_ff[0] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[1]),
        .Q(\dest_graysync_ff[0] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[2]),
        .Q(\dest_graysync_ff[0] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[3]),
        .Q(\dest_graysync_ff[0] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[4]),
        .Q(\dest_graysync_ff[0] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[5]),
        .Q(\dest_graysync_ff[0] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [0]),
        .Q(\dest_graysync_ff[1] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [1]),
        .Q(\dest_graysync_ff[1] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [2]),
        .Q(\dest_graysync_ff[1] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [3]),
        .Q(\dest_graysync_ff[1] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [4]),
        .Q(\dest_graysync_ff[1] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [5]),
        .Q(\dest_graysync_ff[1] [5]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \dest_out_bin_ff[0]_i_1 
       (.I0(\dest_graysync_ff[1] [0]),
        .I1(\dest_graysync_ff[1] [2]),
        .I2(\dest_graysync_ff[1] [4]),
        .I3(\dest_graysync_ff[1] [5]),
        .I4(\dest_graysync_ff[1] [3]),
        .I5(\dest_graysync_ff[1] [1]),
        .O(binval[0]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \dest_out_bin_ff[1]_i_1 
       (.I0(\dest_graysync_ff[1] [1]),
        .I1(\dest_graysync_ff[1] [3]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [4]),
        .I4(\dest_graysync_ff[1] [2]),
        .O(binval[1]));
  LUT4 #(
    .INIT(16'h6996)) 
    \dest_out_bin_ff[2]_i_1 
       (.I0(\dest_graysync_ff[1] [2]),
        .I1(\dest_graysync_ff[1] [4]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [3]),
        .O(binval[2]));
  LUT3 #(
    .INIT(8'h96)) 
    \dest_out_bin_ff[3]_i_1 
       (.I0(\dest_graysync_ff[1] [3]),
        .I1(\dest_graysync_ff[1] [5]),
        .I2(\dest_graysync_ff[1] [4]),
        .O(binval[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[4]_i_1 
       (.I0(\dest_graysync_ff[1] [4]),
        .I1(\dest_graysync_ff[1] [5]),
        .O(binval[4]));
  FDRE \dest_out_bin_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[0]),
        .Q(dest_out_bin[0]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[1]),
        .Q(dest_out_bin[1]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[2]),
        .Q(dest_out_bin[2]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[3]),
        .Q(dest_out_bin[3]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[4]),
        .Q(dest_out_bin[4]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[1] [5]),
        .Q(dest_out_bin[5]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[0]_i_1 
       (.I0(src_in_bin[1]),
        .I1(src_in_bin[0]),
        .O(gray_enc[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[1]_i_1 
       (.I0(src_in_bin[2]),
        .I1(src_in_bin[1]),
        .O(gray_enc[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[2]_i_1 
       (.I0(src_in_bin[3]),
        .I1(src_in_bin[2]),
        .O(gray_enc[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[3]_i_1 
       (.I0(src_in_bin[4]),
        .I1(src_in_bin[3]),
        .O(gray_enc[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[4]_i_1 
       (.I0(src_in_bin[5]),
        .I1(src_in_bin[4]),
        .O(gray_enc[4]));
  FDRE \src_gray_ff_reg[0] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[0]),
        .Q(async_path[0]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[1] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[1]),
        .Q(async_path[1]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[2] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[2]),
        .Q(async_path[2]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[3] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[3]),
        .Q(async_path[3]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[4] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[4]),
        .Q(async_path[4]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[5] 
       (.C(src_clk),
        .CE(1'b1),
        .D(src_in_bin[5]),
        .Q(async_path[5]),
        .R(1'b0));
endmodule

(* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_gray" *) 
(* REG_OUTPUT = "1" *) (* SIM_ASSERT_CHK = "0" *) (* SIM_LOSSLESS_GRAY_CHK = "0" *) 
(* VERSION = "0" *) (* WIDTH = "6" *) (* XPM_MODULE = "TRUE" *) 
(* is_du_within_envelope = "true" *) (* keep_hierarchy = "true" *) (* xpm_cdc = "GRAY" *) 
module spi_fifo_xpm_cdc_gray__2
   (src_clk,
    src_in_bin,
    dest_clk,
    dest_out_bin);
  input src_clk;
  input [5:0]src_in_bin;
  input dest_clk;
  output [5:0]dest_out_bin;

  wire [5:0]async_path;
  wire [4:0]binval;
  wire dest_clk;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [5:0]\dest_graysync_ff[0] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "GRAY" *) wire [5:0]\dest_graysync_ff[1] ;
  wire [5:0]dest_out_bin;
  wire [4:0]gray_enc;
  wire src_clk;
  wire [5:0]src_in_bin;

  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[0]),
        .Q(\dest_graysync_ff[0] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[1]),
        .Q(\dest_graysync_ff[0] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[2]),
        .Q(\dest_graysync_ff[0] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[3]),
        .Q(\dest_graysync_ff[0] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[4]),
        .Q(\dest_graysync_ff[0] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[0][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path[5]),
        .Q(\dest_graysync_ff[0] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [0]),
        .Q(\dest_graysync_ff[1] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [1]),
        .Q(\dest_graysync_ff[1] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [2]),
        .Q(\dest_graysync_ff[1] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [3]),
        .Q(\dest_graysync_ff[1] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [4]),
        .Q(\dest_graysync_ff[1] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "GRAY" *) 
  FDRE \dest_graysync_ff_reg[1][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[0] [5]),
        .Q(\dest_graysync_ff[1] [5]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \dest_out_bin_ff[0]_i_1 
       (.I0(\dest_graysync_ff[1] [0]),
        .I1(\dest_graysync_ff[1] [2]),
        .I2(\dest_graysync_ff[1] [4]),
        .I3(\dest_graysync_ff[1] [5]),
        .I4(\dest_graysync_ff[1] [3]),
        .I5(\dest_graysync_ff[1] [1]),
        .O(binval[0]));
  LUT5 #(
    .INIT(32'h96696996)) 
    \dest_out_bin_ff[1]_i_1 
       (.I0(\dest_graysync_ff[1] [1]),
        .I1(\dest_graysync_ff[1] [3]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [4]),
        .I4(\dest_graysync_ff[1] [2]),
        .O(binval[1]));
  LUT4 #(
    .INIT(16'h6996)) 
    \dest_out_bin_ff[2]_i_1 
       (.I0(\dest_graysync_ff[1] [2]),
        .I1(\dest_graysync_ff[1] [4]),
        .I2(\dest_graysync_ff[1] [5]),
        .I3(\dest_graysync_ff[1] [3]),
        .O(binval[2]));
  LUT3 #(
    .INIT(8'h96)) 
    \dest_out_bin_ff[3]_i_1 
       (.I0(\dest_graysync_ff[1] [3]),
        .I1(\dest_graysync_ff[1] [5]),
        .I2(\dest_graysync_ff[1] [4]),
        .O(binval[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \dest_out_bin_ff[4]_i_1 
       (.I0(\dest_graysync_ff[1] [4]),
        .I1(\dest_graysync_ff[1] [5]),
        .O(binval[4]));
  FDRE \dest_out_bin_ff_reg[0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[0]),
        .Q(dest_out_bin[0]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[1]),
        .Q(dest_out_bin[1]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[2]),
        .Q(dest_out_bin[2]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[3]),
        .Q(dest_out_bin[3]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(binval[4]),
        .Q(dest_out_bin[4]),
        .R(1'b0));
  FDRE \dest_out_bin_ff_reg[5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\dest_graysync_ff[1] [5]),
        .Q(dest_out_bin[5]),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[0]_i_1 
       (.I0(src_in_bin[1]),
        .I1(src_in_bin[0]),
        .O(gray_enc[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[1]_i_1 
       (.I0(src_in_bin[2]),
        .I1(src_in_bin[1]),
        .O(gray_enc[1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[2]_i_1 
       (.I0(src_in_bin[3]),
        .I1(src_in_bin[2]),
        .O(gray_enc[2]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[3]_i_1 
       (.I0(src_in_bin[4]),
        .I1(src_in_bin[3]),
        .O(gray_enc[3]));
  LUT2 #(
    .INIT(4'h6)) 
    \src_gray_ff[4]_i_1 
       (.I0(src_in_bin[5]),
        .I1(src_in_bin[4]),
        .O(gray_enc[4]));
  FDRE \src_gray_ff_reg[0] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[0]),
        .Q(async_path[0]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[1] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[1]),
        .Q(async_path[1]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[2] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[2]),
        .Q(async_path[2]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[3] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[3]),
        .Q(async_path[3]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[4] 
       (.C(src_clk),
        .CE(1'b1),
        .D(gray_enc[4]),
        .Q(async_path[4]),
        .R(1'b0));
  FDRE \src_gray_ff_reg[5] 
       (.C(src_clk),
        .CE(1'b1),
        .D(src_in_bin[5]),
        .Q(async_path[5]),
        .R(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2023.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
aMT3usC6uizzcwnzOCX4OsS16Ob+YxFcsGovFpFklbnaIaD1S0lVdxenTwHPp6ByIEi+ehwr6Rgg
z/3AlTheI5NFTM8ihiMA18/wmUxI7EbaftJACA1LykUKCuj5myy0T+DACuv3sGYIZS38TZTZnnBC
FGAlvTZmRWs+JzneH3o=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lR9ZerhYSAb39nzEkeYvhnwEs5t9y/+yTDf8KuoUtR1BGeHZq8pA/YxtjzQLtaOW1R1IQUb0FtSI
e3CYAb7WHYbIjcpw3vKHvW1SqcGn9CMGa556CYKmD2oF12Kow8xRaFvMSBUVxX7HsHxNWnRd+PU1
+C0YayU2KFIY/7Yl6cZ5luAzhw/6SW3PFYUIyyqWy5MCIXweHOwQR2IpQEdlDur5nluN7i7BeB+i
fxwwHh8TU/g7T4mhZFkiTuBKdLAtQOjxWxzqTMxgcuAjlTylY16FgMFOASdvvSbqBZJjbxMdVloU
rYjS8O/8rWktv8GXcaIdBJ2BRj01q7jsChsbwA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
Qvl63GHz9mq2xOB7elt/vAQ7URLGdD1Lkcz7f3Wtw31dwjjjbP62Ny/Jr6OmBIheWlgejx38qxAT
TrHiiEyjKmGcnPn1Tn2n+cH4RAxCbOFnCI9n6+YsYMTe9JkplGhGGr39SkFgJz0I2IKpPsuqTjCj
rhf49TAryNMQeRpREJA=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
MA+9Ro+dh339m0iZrkKbqTKN8gQ5xkxN/SPCfhkOn+5jjgCTS5IOKLHil+HsZDjX333ebxnornwG
MOBxyEdFfLM8SA+bs2r41J/j0af2VVMmCM3hOh8JmZxB4X9Jg/glegNCbvwzqxMbOQNEy+zt7j5t
TFVD82RtPFmYVVYZZyll/WvAA+0aVpyjzLCIM1GznFky0RWLv65Wp4MJJnNRRrtG3muMznVO/u2s
tACsJ9jzv9M0IlMYjYH9BixhG6cZX02I4LEXXaPkhdOINlMMhsbArXtc9NphzmS4bY1/1yF1D6YD
EKLyS2Sr3HDl0O/lefN+jvfG8iKuVl55PNNrVQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
wpMTg7STjFkUDhOqdNPa0FHXTnHQgKmhvqDv+rRVBvMiQ8O7u8oj7ibITq3o+jugJsMJ60B410gQ
JFTcqCJKYmYJvqi8rPLLOYDmFG6ZLP/Ixr3n62IyIaCeDltBahi3yV009QN0X+iuzuFCL+Y7g9ff
IvAgyBly+Z3Itv2H9EJMZPMl17Sa7IkgjmWqzVXIKNMKn0iDVYsQw6ZgzQDYQ8N8IvTIEggU3/lh
6Nf0hV0ev3qOv/2P+4w0U766Ux3yLuzPJSI7bKm3/ip9NjhOytxOiKKqVXhKG8dzbbuS5u3EE/eq
q6YxkL7gpvNltVqqBnJB6vHSyWrD6+MqsCtR9A==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2022_10", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q7Q4SSp70lxFryaopuic9VVP/Ire0pSsPEIMYdURBAczC7ShkuYeV02U7L3BlAiyBE4vBKcwYSQd
cWiaj8sVP7q4kxoRHKxLV1R5PIO6l4DsLWE2E+1MLyUPME0w5KTular/oX8EPCJ5n/8VCtW7x4Vf
dpeyki1/IAPJkAyi3zVZKHzgKhEwnZaZZtZYuMWoPZMt4V38sAcE42Raf+7yfFWG5HO74JY6iEnW
gJeRk58K+avB/XLF2/j2RQZfjTYizrprT2tUMBK6e7DRWZZtk8AOcsMhUikev44IFGNbNXjP8BXC
0J3y3P7pCFT6l+saU83nRwi/H25fSA34diJtNw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
a/8ooC+s+6nfvfa1+oBhsvYWLJjFgp83DI1kNyOi5Am+ugPbGRmgGZudfyo6yw6Yd5gGbLm5aToQ
5G4cGF5HaXD5TU6A0ZZFMTIbzFLE76JMjjIxX8JcaJIZpSmrXqlru8l5gDINUEAmwUY3mRQnjcGJ
0Z+kMRH8iAEF+gEviPiFZSBbJeOPqivIS217kimQJX3BeNbNPQTP+GUidcRywpGMh5avxtA0kDRO
F9SoCSyTm9hr2v9hsK1IUAYQLb7n2/R+z5YNKNzt1oN4qgJH1wZfdI8if2K8+ohyOdnxrrgJOWdj
cOqr7cGqEOYfBMTIQeHVZzb7NGWVN+9B8XSUaQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
FLPvOUNRWNW2GU+FEGmt2XWthOT5bY/31DRbol2cUmEGNF6b2XzpCosNKGx/o2n6sQvGP39KRFCs
nJu0ihe2dUGee9nEZZUcpwPjnEfXVI3yJaRVYy8iL+rm59lXq0jX4sjAPieDvv8shgAnoXLTZGlq
K+2c1JhaHt+nFi27TDrYar/+P8nP1MhocOS7BjzCvSs0foEXj92/qD+71Sm/LqGr8cjlH2qTJJ8B
ynxoH6iT+bksVA2VbtPT9o6h1kJ/zwP4wcsL9l+qSlJhd4GI11JPux26DlNyIi41WmufQcfiT0PB
r6O9+0E9lV9ODwKdjaxfZRK29rjKeq2yr0jWhMV38XKKqHAJli7MIypGRXcCo+u89H87KgYt+ebw
s3foIqCe0JKR57WzI8VD6XdNtOL8eBxK539oemx4vkE0cGYECZKYru6A2hPeZOYDD5eyWSUlQl1R
EciK49WM8HnssyRVcmE6di6bISMbVi0TZG/v98bz+9UZa8DtqMVYH0tz

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fphquQOeFuqByo36Gh2C1zEC1J6u9swSMbMzsKldIvLm+SZ6/hr/N8KJ/G2vBABzX6UtbVuP1ZXx
AxdftP4Aqis1B3Bs6989aQG9eo0SOHA7r6aFLtFb3qoD5Pvqw4aVNU4z4EtTpFpn/jCWD21lKROf
q5X32HRfFq1jwqod+9vIbUNRRzz5y9VHvXfacZlxDazSPmcCF4hxB1KqWqT44KmYVkDedgkgnYgb
ZGidHnTb3W7C8tSqC9ac4kNJCL429QndtddweESJNlpX+65pt9Irok9pkOodwoj0QScswOIFjhBZ
/GrzZLQcFWiD3gXRU4DazzxQnGdRH4qEIRWziw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
1lUYYHPCt1BUJOvcBbgMU2GSQiqfxItz4ntieMaenjrtsE9SLwaU6xB0tBl8Atw5yP/RRNww1kX/
9uZbTz5He3r9mPVt+mGxB4N3f9BbCrQRb4USVPgKO/+vWUfMQERGklScy0+fz75WuxH74CjRUoDI
8iyssb2cUNnfDe13jIoI8gM1w4w/Pkxkmb6Mef53QMxacHAWEZeytcH3fuL/adO263D8P90U3XJv
vBXJmbjkRVi9qzjBzfMxuOy2KbZaZgR3BLzaffIfFnMwg/Rb8sGls5pQsZv5jL2wk3+Bj3OXBYdd
pDyjGoalJBzObKzd/t15kNHwY4FXYFcZLQPncw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YRmSEzaa2WFVvMH1BwWc1TIUpVbzSEIP0VbI6n0sEgct/X4PiTfMQmK1jBVCaISIzwBxscKQwZOt
mb/nmINGg6I7ih39LSbBMtx6cdCUiyaLkPeRbqfyPpKhvnUIFmdKVvTd1dYzxeOeuDnhSVaBaAcN
3lngSg7lIbmhLIGjC29yQrBTiLArbVZi6IRGronMK51e3UrYa6GspsznhiuRcXjEb4bHKrJ2CM5Z
BUwA+E9949sQgyOagFZbLVle2ESbwBaoxcAPn2gxfRHlT0leqyLgUGDZLsfArzGzw9BTGzyEG2TR
XOrKFNYRfMXMrnGsBM7acIelY4LdAMgsKgDH/A==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 93856)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
