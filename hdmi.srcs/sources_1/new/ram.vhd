----------------------------------------------------------------------------------
-- Company: GEO Tecnologies SAS
-- Engineer: Jairo Mena Muñoz
-- 
-- Create Date: 16.05.2020 11:41:26
-- Design Name: HDMI Prueba unitaria - Módulo RAM
-- Module Name: ram - Behavioral
-- Project Name: Prueba Unitaria HDMI 
-- Target Devices: GEO-HCAL-1.0.0
-- Tool Versions: 1.0.0
-- Description: Módulo de memoria RAM que sirve como imagen virtual digital 
--              El módulo es llamado como instancia del módulo de timing_memory
--
-- Dependencies: Departamento de Investigación y Desarrollo - GEO Tecnologies SAS
-- 
-- Revision: 1.0 
-- Revision 0.01 - File Created
-- Additional Comments:
-- copyright, © - Jairo Mena - jamenaso@gmail.com
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram is
    generic (
        ram_size : natural := 800 * 480;
        data_lenght : natural := 6;
        addr_lenght : natural := 19);
    Port ( 
        clk : in  STD_LOGIC;
        en_wr : in  STD_LOGIC;
        en_rd : in  STD_LOGIC;
        addr_wr : in  STD_LOGIC_VECTOR (addr_lenght-1 downto 0);
        addr_rd : in  STD_LOGIC_VECTOR (addr_lenght-1 downto 0);
        di : in  STD_LOGIC_VECTOR (data_lenght-1 downto 0);     
        do : out  STD_LOGIC_VECTOR (data_lenght-1 downto 0));  
end ram;

architecture Behavioral of ram is

    type ram_type is array (0 to ram_size-1) of std_logic_vector (data_lenght-1 downto 0);
    signal RAM: ram_type;
    
begin

    process (clk)
    begin 
        if clk'event and clk = '1' then
            if en_rd = '1' then
				do <= RAM(conv_integer(addr_rd));
            end if;
        end if;
    end process;
	 
    process (clk)
    begin
        if clk'event and clk = '1' then
            if en_wr = '1' then
				RAM(conv_integer(addr_wr)) <= di;
            end if;
        end if;
    end process;
    
end Behavioral;
