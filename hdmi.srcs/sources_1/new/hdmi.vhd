----------------------------------------------------------------------------------
-- Company: GEO Tecnologies SAS
-- Engineer: Jairo Mena Muñoz
-- 
-- Create Date: 20.05.2020 10:12:14
-- Design Name: HDMI Prueba unitaria - Módulo HDMI
-- Module Name: HDMI - Behavioral
-- Project Name: Prueba Unitaria HDMI 
-- Target Devices: GEO-HCAL-1.0.0
-- Tool Versions: 1.0.0
-- Description: Módulo HDMI que contiene una instancia de DVI y otra TIMING 
--              este modulo tiene cuatro buffers de salidas diferenciales una para cada color y otra para la señal de reloj.              
--              Éste módulo tiene las entradas (Datos y dirreción) para la escritura de la imagen virtual. 
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
Library UNISIM;
use UNISIM.vcomponents.all;

entity hdmi is
    Port (  
        clk_dvi     : in STD_LOGIC;
        clk_pixel   : in STD_LOGIC;
        rst         : in  STD_LOGIC;
        ram_en      : in   STD_LOGIC;
        ram_addr    : in   STD_LOGIC_VECTOR(18 downto 0);
        ram_red     : in   STD_LOGIC_VECTOR(5 downto 0);
        ram_green   : in   STD_LOGIC_VECTOR(5 downto 0);
        ram_blue    : in   STD_LOGIC_VECTOR(5 downto 0);  
        tmds        : out  STD_LOGIC_VECTOR(3 downto 0);
        tmdsb       : out  STD_LOGIC_VECTOR(3 downto 0)
        );
end hdmi;

architecture Behavioral of hdmi is

    COMPONENT dvi
    PORT(
        clk_dvi   : in STD_LOGIC;
        clk_pixel : in STD_LOGIC;
        red_p     : in STD_LOGIC_VECTOR(7 downto 0);
        green_p   : in STD_LOGIC_VECTOR(7 downto 0);
        blue_p    : in STD_LOGIC_VECTOR(7 downto 0);
        blank     : in STD_LOGIC;
        hsync     : in STD_LOGIC;
        vsync     : in STD_LOGIC;          
        red_s     : out STD_LOGIC;
        green_s   : out STD_LOGIC;
        blue_s    : out STD_LOGIC;
        clock_s   : out STD_LOGIC
        );
    END COMPONENT;

    COMPONENT timing_memory
    PORT(
        clk_pixel : IN std_logic;
        rst : IN std_logic;
        ram_en : IN std_logic;
        ram_addr : IN std_logic_vector(18 downto 0);
        ram_Red : IN std_logic_vector(5 downto 0);
        ram_Green : IN std_logic_vector(5 downto 0);
        ram_Blue : IN std_logic_vector(5 downto 0);          
        Red_out : OUT std_logic_vector(5 downto 0);
        Green_out : OUT std_logic_vector(5 downto 0);
        Blue_out : OUT std_logic_vector(5 downto 0);
        hSync : OUT std_logic;
        vSync : OUT std_logic;
        blank : OUT std_logic
    );
    END COMPONENT;

   signal red     : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
   signal green   : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
   signal blue    : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
   signal hsync   : STD_LOGIC := '0';
   signal vsync   : STD_LOGIC := '0';
   signal blank   : STD_LOGIC := '0';
   signal red_s   : STD_LOGIC;
   signal green_s : STD_LOGIC;
   signal blue_s  : STD_LOGIC;
   signal clock_s : STD_LOGIC;
   
   signal red_p     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
   signal green_p   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
   signal blue_p    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
   
begin

   red_p <= red & "11";
   green_p <= green & "11";  
   blue_p <= blue & "11";
   
    Inst_dvi: dvi PORT MAP(
        clk_dvi   => clk_dvi,
        clk_pixel => clk_pixel,
        red_p     => red_p,
        green_p   => green_p,
        blue_p    => blue_p,
        blank     => blank,
        hsync     => hsync,
        vsync     => vsync,
        -- outputs to TMDS drivers
        red_s     => red_s,
        green_s   => green_s,
        blue_s    => blue_s,
        clock_s   => clock_s
    );   
    
    Inst_timing_memory: timing_memory 
    PORT MAP(
        clk_pixel => clk_pixel,
        rst       => rst,
        ram_en    => ram_en,
        ram_addr  => ram_addr,
        ram_Red   => ram_Red,
        ram_Green => ram_Green,
        ram_Blue  => ram_Blue,        
        Red_out   => red,
        Green_out => green,
        Blue_out  => blue,
        hSync     => hSync,
        vSync     => vSync,
        blank     => blank
    );    
    
    OBUFDS_blue     : OBUFDS port map ( O  => tmds(0), OB => tmdsb(0), I  => blue_s  );
    OBUFDS_green    : OBUFDS port map ( O  => tmds(1), OB => tmdsb(1), I  => green_s );
    OBUFDS_red      : OBUFDS port map ( O  => tmds(2), OB => tmdsb(2), I  => red_s   );
    OBUFDS_clock    : OBUFDS port map ( O  => tmds(3), OB => tmdsb(3), I  => clock_s );
    
end Behavioral;
