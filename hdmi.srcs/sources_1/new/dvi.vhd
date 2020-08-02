----------------------------------------------------------------------------------
-- Company: GEO Tecnologies SAS
-- Engineer: Jairo Mena Muñoz
-- 
-- Create Date: 18.05.2020 16:18:45
-- Design Name: HDMI Prueba unitaria - Módulo DVI
-- Module Name: dvi - Behavioral
-- Project Name: Prueba Unitaria HDMI 
-- Target Devices: GEO-HCAL-1.0.0
-- Tool Versions: 1.0.0
-- Description: Interfaz Visual Digital DVI que contiene tres codificadores TDMS uno para cada color 
--              que genera las señales RGB y clock de video.
--
-- Dependencies: Departamento de Investigación y Desarrollo - GEO Tecnologies SAS
-- 
-- Revision: 1.0 
-- Revision 0.01 - File Created
-- Additional Comments:
-- copyright, © - Jairo Mena
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

entity dvi is
    Port ( clk_dvi   : in  STD_LOGIC;
       clk_pixel : in  STD_LOGIC;
       red_p     : in  STD_LOGIC_VECTOR (7 downto 0);
       green_p   : in  STD_LOGIC_VECTOR (7 downto 0);
       blue_p    : in  STD_LOGIC_VECTOR (7 downto 0);
       blank     : in  STD_LOGIC;
       hsync     : in  STD_LOGIC;
       vsync     : in  STD_LOGIC;
       red_s     : out STD_LOGIC;
       green_s   : out STD_LOGIC;
       blue_s    : out STD_LOGIC;
       clock_s   : out STD_LOGIC);
end dvi;

architecture Behavioral of dvi is
   COMPONENT tmds
    PORT(
       clk     : IN  std_logic;
       data    : IN  std_logic_vector(7 downto 0);
       c       : IN  std_logic_vector(1 downto 0);
       blank   : IN  std_logic;          
       encoded : OUT std_logic_vector(9 downto 0)
       );
    END COMPONENT;

   signal encoded_red, encoded_green, encoded_blue : std_logic_vector(9 downto 0) := (others => '0');
   signal latched_red, latched_green, latched_blue : std_logic_vector(9 downto 0) := (others => '0');
   signal shift_red,   shift_green,   shift_blue   : std_logic_vector(9 downto 0) := (others => '0');
   
   signal shift_clock   : std_logic_vector(9 downto 0) := "0000011111";

   
   constant c_red       : std_logic_vector(1 downto 0) := (others => '0');
   constant c_green     : std_logic_vector(1 downto 0) := (others => '0');
   signal   c_blue      : std_logic_vector(1 downto 0);
   
begin

   c_blue <= vsync & hsync;
   
   Ints_tmds_R: tmds PORT MAP(clk => clk_pixel, data => red_p,   c => c_red,   blank => blank, encoded => encoded_red);
   Ints_tmds_G: tmds PORT MAP(clk => clk_pixel, data => green_p, c => c_green, blank => blank, encoded => encoded_green);
   Ints_tmds_B: tmds PORT MAP(clk => clk_pixel, data => blue_p,  c => c_blue,  blank => blank, encoded => encoded_blue);

   ODDR_red   : ODDR generic map( DDR_CLK_EDGE => "SAME_EDGE", INIT => '0', SRTYPE => "ASYNC") 
      port map (Q => red_s,   C => clk_dvi, CE => '1', D1 => shift_red(0),   D2 => shift_red(1),   R => '0', S => '0');
   
   ODDR_green : ODDR generic map( DDR_CLK_EDGE => "SAME_EDGE", INIT => '0', SRTYPE => "ASYNC") 
      port map (Q => green_s, C => clk_dvi, CE => '1', D1 => shift_green(0), D2 => shift_green(1), R => '0', S => '0');

   ODDR_blue  : ODDR generic map( DDR_CLK_EDGE => "SAME_EDGE", INIT => '0', SRTYPE => "ASYNC") 
      port map (Q => blue_s,  C => clk_dvi, CE => '1', D1 => shift_blue(0),  D2 => shift_blue(1),  R => '0', S => '0');

   ODDR_clock : ODDR generic map( DDR_CLK_EDGE => "SAME_EDGE", INIT => '0', SRTYPE => "ASYNC") 
      port map (Q => clock_s, C => clk_dvi, CE => '1', D1 => shift_clock(0), D2 => shift_clock(1), R => '0', S => '0');


   process(clk_pixel)
   begin
      if rising_edge(clk_pixel) then 
            latched_red   <= encoded_red;
            latched_green <= encoded_green;
            latched_blue  <= encoded_blue;
      end if;
   end process;

   process(clk_dvi)
   begin
      if rising_edge(clk_dvi) then 
         if shift_clock = "0001111100" then --0000011111
            shift_red   <= latched_red;
            shift_green <= latched_green;
            shift_blue  <= latched_blue;
         else
            shift_red   <= "00" & shift_red  (9 downto 2);
            shift_green <= "00" & shift_green(9 downto 2);
            shift_blue  <= "00" & shift_blue (9 downto 2);
         end if;
         shift_clock <= shift_clock(1 downto 0) & shift_clock(9 downto 2);
      end if;
   end process;

end Behavioral;
