// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.1 (win64) Build 3865809 Sun May  7 15:05:29 MDT 2023
// Date        : Mon Jun 23 17:33:02 2025
// Host        : pcfalchieri running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ spi_fifo_sim_netlist.v
// Design      : spi_fifo
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "spi_fifo,fifo_generator_v13_2_8,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "fifo_generator_v13_2_8,Vivado 2023.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_fifo_generator_v13_2_8 U0
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

(* DEST_SYNC_FF = "2" *) (* INIT_SYNC_FF = "0" *) (* REG_OUTPUT = "1" *) 
(* SIM_ASSERT_CHK = "0" *) (* SIM_LOSSLESS_GRAY_CHK = "0" *) (* VERSION = "0" *) 
(* WIDTH = "6" *) (* XPM_MODULE = "TRUE" *) (* is_du_within_envelope = "true" *) 
(* keep_hierarchy = "true" *) (* xpm_cdc = "GRAY" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_xpm_cdc_gray
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
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_xpm_cdc_gray__2
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 94304)
`pragma protect data_block
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
h9iNzHzLnbFNGFZD03o3VoJUTm2547IGUFQ=
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
