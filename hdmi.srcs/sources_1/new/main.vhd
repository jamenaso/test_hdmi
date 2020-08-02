----------------------------------------------------------------------------------
-- Company: GEO Tecnologies SAS
-- Engineer: Jairo Mena Muñoz
-- 
-- Create Date: 22.05.2020 18:35:44
-- Design Name: HDMI Prueba unitaria - Módulo Principal
-- Module Name: main - Behavioral
-- Project Name: Prueba Unitaria HDMI 
-- Target Devices: GEO-HCAL-1.0.0
-- Tool Versions: 1.0.0
-- Description: Módulo principal que tiene una instancia del módulo HDMI 
--              Éste módulo escribe en la imagen virtual del HDMI para ser poder realizar la prueba unitaria.                
--              Éste módulo tiene un manejador de clock con dos salidas clk_dvi y clk_pixel de 200Mhz y 40MHz respectivamente.
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
    Port ( 
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        tmds    : out STD_LOGIC_VECTOR (3 downto 0);
        tmdsb   : out STD_LOGIC_VECTOR (3 downto 0)
        );
end main;

architecture Behavioral of main is

    constant tMax : natural := 10000;     
    constant vRez : natural := 480; 
    constant hRez : natural := 800; 
    constant rez : natural := hRez * vRez;  
    constant frm : natural := 480 / 10; 
    constant stripe : natural := frm * hRez;
    
	component clock_manager
    port(
        clk        : in  STD_LOGIC;
        clk_dvi    : out STD_LOGIC;
        clk_pixel  : out STD_LOGIC
        );
    end component;
    
    component hdmi
    port(
        clk_dvi     : in  STD_LOGIC;
        clk_pixel   : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        ram_en      : in  STD_LOGIC;
        ram_addr    : in  STD_LOGIC_VECTOR(18 downto 0);
        ram_red     : in  STD_LOGIC_VECTOR(5 downto 0);
        ram_green   : in  STD_LOGIC_VECTOR(5 downto 0);
        ram_blue    : in  STD_LOGIC_VECTOR(5 downto 0);  
        tmds        : out STD_LOGIC_VECTOR(3 downto 0);
        tmdsb       : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
        
	signal clk_dvi    : STD_LOGIC := '0';    
    signal clk_pixel  : STD_LOGIC := '0';
    
    signal ram_en_sig    : STD_LOGIC := '1';
    signal ram_addr_sig  : STD_LOGIC_VECTOR(18 downto 0) := (others => '0');    
    signal ram_red_sig   : STD_LOGIC_VECTOR(5 downto 0) := (others => '1');
    signal ram_green_sig : STD_LOGIC_VECTOR(5 downto 0) := (others => '1');
    signal ram_blue_sig  : STD_LOGIC_VECTOR(5 downto 0) := (others => '1');    
    
    signal addr : integer range 0 to rez;
    
    type states is (
        START,     
        WRITE_IMG,
        SHOW
    );
    signal state : states; 
    
begin

    Inst_clock_manager : clock_manager 
    PORT MAP
    (
        clk       => clk,      -- 100MHz 
        clk_dvi   => clk_dvi,  -- for 800x480@60Hz : 200MHZ
        clk_pixel => clk_pixel -- for 800x480@60Hz : 40MHZ
    ); 

	Inst_hdmi: hdmi 
	PORT MAP
	(
        clk_dvi       => clk_dvi,
        clk_pixel     => clk_pixel,
		rst           => rst,
		ram_en        => ram_en_sig,
		ram_addr      => ram_addr_sig,
		ram_red       => ram_red_sig,
		ram_green     => ram_green_sig,
		ram_blue      => ram_blue_sig,		
		tmds          => tmds,
		tmdsb         => tmdsb
	);
		
	process (rst,clk)	   
	   variable tCount : integer range 0 to tMax;
    begin
        if rst = '0' then
            addr <= 0;
            tCount := 0;
            state <= START;
        elsif clk'event and clk = '1' then 
            case state is            
                when START =>   
                    if tCount = tMax then                                                      
                        state <= WRITE_IMG; 
                        tCount := 0;   
                    end if;
                    tCount := tCount + 1;
                when WRITE_IMG =>
                    if tCount = 3 then                                                      
                        addr <= addr + 1;
                        tCount := 0;   
                    end if;
                    tCount := tCount + 1;                   
                    if addr = rez then
                        state <= SHOW;              
                    end if;                                 
                when SHOW =>
                    addr <= 0;                            
            end case;                 
        end if;        
    end process;
    
    process (rst,clk)
    begin
        if rst = '0' then
            ram_en_sig <= '1';
        elsif clk'event and clk = '1' then 
            if state = WRITE_IMG then
                if addr >= 0 and addr < stripe * 1  - 1 then 
                    ram_red_sig <= (others => '1');        
                    ram_green_sig <= (others => '0');
                    ram_blue_sig <= (others => '0');
                elsif addr >= stripe * 1 - 1 and addr < stripe * 2 - 1 then 
                    ram_red_sig <= (others => '0');        
                    ram_green_sig <= (others => '1');
                    ram_blue_sig <= (others => '0');
                elsif addr >= stripe * 2 - 1 and addr < stripe * 3 - 1 then 
                    ram_red_sig <= (others => '0');        
                    ram_green_sig <= (others => '0');
                    ram_blue_sig <= (others => '1'); 
                elsif addr >= stripe * 3 - 1 and addr < stripe * 4 - 1 then 
                    ram_red_sig <= (others => '1');        
                    ram_green_sig <= (others => '1');
                    ram_blue_sig <= (others => '0');  
                elsif addr >= stripe * 4 - 1 and addr < stripe * 5 - 1 then 
                    ram_red_sig <= (others => '1');        
                    ram_green_sig <= (others => '0');
                    ram_blue_sig <= (others => '1'); 
                elsif addr >= stripe * 5 - 1 and addr < stripe * 6 - 1 then 
                    ram_red_sig <= (others => '0');        
                    ram_green_sig <= (others => '1');
                    ram_blue_sig <= (others => '1');  
                elsif addr >= stripe * 6 - 1 and addr < stripe * 7 - 1 then 
                    ram_red_sig <= (others => '0');        
                    ram_green_sig <= (others => '0');
                    ram_blue_sig <= (others => '0');                                                   
                else
                    ram_red_sig <= (others => '1');        
                    ram_green_sig <= (others => '1');
                    ram_blue_sig <= (others => '1');                                        
                end if; 
                ram_en_sig <= '1';
            else 
                ram_en_sig <= '0';
            end if;                                                        
        end if;
        ram_addr_sig <= CONV_STD_LOGIC_VECTOR(addr,19);
    end process;
        
end Behavioral;
