-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
-- Date        : Mon Oct 22 16:18:22 2018
-- Host        : jamm-HP-ENVY-m7-Notebook running 64-bit Ubuntu 18.04.1 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/jamm/Documentos/pruebas_unitarias_TFC/hdmi/hdmi.srcs/sources_1/ip/clock_manager/clock_manager_stub.vhdl
-- Design      : clock_manager
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a200tfbg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_manager is
  Port ( 
    clk_dvi : out STD_LOGIC;
    clk_pixel : out STD_LOGIC;
    clk : in STD_LOGIC
  );

end clock_manager;

architecture stub of clock_manager is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_dvi,clk_pixel,clk";
begin
end;
