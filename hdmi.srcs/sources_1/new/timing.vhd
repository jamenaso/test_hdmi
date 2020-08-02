----------------------------------------------------------------------------------
-- Company: GEO Tecnologies SAS
-- Engineer: Jairo Mena Muñoz
-- 
-- Create Date: 17.05.2020 08:30:05
-- Design Name: HDMI Prueba unitaria - Módulo Timing
-- Module Name: timing - Behavioral
-- Project Name: Prueba Unitaria HDMI 
-- Target Devices: GEO-HCAL-1.0.0
-- Tool Versions: 1.0.0
-- Description: Módulo encargado de generar las señales de sincronismo, 
--              lee la imagen virtual RGB (memoria ram RGB) y sincroniza los tiempos activos vertical y horizontal               
--              Éste módulo tiene tres instancias del componente RAM, uno para cada color. 
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

entity timing_memory is

    generic (
        hRez       : natural := 800;    
        hStartSync : natural := 816;
        hEndSync   : natural := 952;
        hMaxCount  : natural := 1000;
        hsyncActive : std_logic := '1';
        
        vRez       : natural := 480;
        vStartSync : natural := 490;
        
        vEndSync   : natural := 492;
        vMaxCount  : natural := 525;
        vsyncActive : std_logic := '1';
        
        data_lenght : natural := 6;
        addr_lenght : natural := 19
        );
Port (    
        clk_pixel   : in STD_LOGIC;
        rst         : in STD_LOGIC;
        
        ram_en      : in STD_LOGIC;
        ram_addr    : in STD_LOGIC_VECTOR (addr_lenght-1 downto 0);
        
        ram_Red     : in STD_LOGIC_VECTOR (data_lenght-1 downto 0);
        ram_Green   : in STD_LOGIC_VECTOR (data_lenght-1 downto 0);
        ram_Blue    : in STD_LOGIC_VECTOR (data_lenght-1 downto 0);
        
        Red_out     : out STD_LOGIC_VECTOR (data_lenght-1 downto 0);
        Green_out   : out STD_LOGIC_VECTOR (data_lenght-1 downto 0);
        Blue_out    : out STD_LOGIC_VECTOR (data_lenght-1 downto 0);
        
        hSync       : out STD_LOGIC;
        vSync       : out STD_LOGIC;
        blank       : out STD_LOGIC
        );
end timing_memory;

architecture Behavioral of timing_memory is

    constant ram_size : natural := hRez * vRez;
    
    type reg is record
        hCounter : integer range 0 to hMaxCount-1;
        vCounter : integer range 0 to vMaxCount-1;
        address  : integer range 0 to hRez * vRez;	
        
        hSync    : std_logic;
        vSync    : std_logic;
        blank    : std_logic;
        ram_rd   : std_logic;
    end record;

    COMPONENT ram
    generic (
        ram_size : natural;
        data_lenght : natural;
        addr_lenght : natural
    );	
    PORT(
        clk : IN std_logic;
        en_wr : IN std_logic;
        en_rd : IN std_logic;
        addr_wr : IN std_logic_vector(addr_lenght-1 downto 0);
        addr_rd : IN std_logic_vector(addr_lenght-1 downto 0);
        di : IN std_logic_vector(data_lenght-1 downto 0);          
        do : OUT std_logic_vector(data_lenght-1 downto 0)
    );
    END COMPONENT;
    
    signal r : reg := (0, 0, 0, '0', '0', '0', '0');							 
    signal n : reg; 	
    signal rd_enable : STD_LOGIC; 
    
    signal address_sig : STD_LOGIC_VECTOR (addr_lenght-1 downto 0);
       
begin

    hSync <= r.hSync;
    vSync <= r.vSync;
    blank <= r.blank;
    address_sig <= CONV_STD_LOGIC_VECTOR(n.address,addr_lenght);
    rd_enable <= (not r.blank)and(not ram_en);
	
    Inst_ram_R : ram  
    GENERIC MAP (
        ram_size =>  ram_size,
        data_lenght =>  data_lenght,
        addr_lenght => addr_lenght
    )PORT MAP(
        clk => clk_pixel,
        en_wr => ram_en,
        en_rd => rd_enable,
        addr_wr => ram_addr,
        addr_rd => address_sig,
        di => ram_Red,
        do => Red_out
    );
    
    Inst_ram_G : ram  
    GENERIC MAP (
        ram_size =>  ram_size,
        data_lenght =>  data_lenght,
        addr_lenght => addr_lenght
    )PORT MAP(
        clk => clk_pixel,
        en_wr => ram_en,
        en_rd => rd_enable,
        addr_wr => ram_addr,
        addr_rd => address_sig,
        di => ram_Green,
        do => Green_out
    );
    
    Inst_ram_B : ram  
    GENERIC MAP (
        ram_size =>  ram_size,
        data_lenght =>  data_lenght,
        addr_lenght => addr_lenght
    )PORT MAP(
    clk => clk_pixel,
        en_wr => ram_en,
        en_rd => rd_enable,
        addr_wr => ram_addr,
        addr_rd => address_sig,
        di => ram_Blue,
        do => Blue_out
    );

    process(r,n)
    begin
        n <= r;
        n.hSync <= not hSyncActive;      
        n.vSync <= not vSyncActive;      
        
        if r.hCounter = hMaxCount-1 then
            n.hCounter <= 0;
            if r.vCounter = vMaxCount-1 then
                n.vCounter <= 0;
            else
                n.vCounter <= r.vCounter+1;
            end if;
        else
            n.hCounter <= r.hCounter+1;
        end if;
        
        if r.hCounter  < hRez and r.vCounter  < vRez then
            n.blank <= '0';
        else
            n.blank <= '1';
        end if;
        
        if r.blank = '0' then
            n.address <= (hRez * CONV_INTEGER(r.vCounter)) + CONV_INTEGER(r.hCounter-1);
        else
            n.address <= 0;
        end if;
        
        if r.hCounter >= hStartSync and r.hCounter < hEndSync then
            n.hSync <= hSyncActive;
        end if;
        
        if r.vCounter >= vStartSync and r.vCounter < vEndSync then
            n.vSync <= vSyncActive; 
        end if;
    end process;

    process(rst,clk_pixel,n)
    begin
        if rst = '0' then
            r <= (0, 0, 0, '0', '0', '0', '0');
        elsif rising_edge(clk_pixel) then
            r <= n;
        end if;
    end process;
   
end Behavioral;
