// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
// Date        : Mon Oct 22 16:18:21 2018
// Host        : jamm-HP-ENVY-m7-Notebook running 64-bit Ubuntu 18.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/jamm/Documentos/pruebas_unitarias_TFC/hdmi/hdmi.srcs/sources_1/ip/clock_manager/clock_manager_stub.v
// Design      : clock_manager
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a200tfbg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clock_manager(clk_dvi, clk_pixel, clk)
/* synthesis syn_black_box black_box_pad_pin="clk_dvi,clk_pixel,clk" */;
  output clk_dvi;
  output clk_pixel;
  input clk;
endmodule
