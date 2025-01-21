----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.07.2024 18:20:17
-- Design Name: 
-- Module Name: LCDDriverTop - structure
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.vcomponents.ALL;


entity LCDDriverTop is
  Generic(
    TPROP: time := 1ns
  );
 
  Port (
     rstn_i:           in      std_logic;                             --reset
     dataLCD_io:      inout   std_logic_vector(7 downto 0);          --podatki na LCD data vodilu         najvi�ja linija nosi informacije o LCDbusy flag-u, mora biti tipa inout
     --data_i:          in      std_logic_vector(7 downto 0);        --podatki iz pc
     clk_in:          in      std_logic;                             --1MHz ura
     busy_o:          out     std_logic;                             --kontrolni signal -> kdaj driver lahko zapi�e nove podatke na LCD: 0->pripravljen, 1->ne
     RW_o:            out     std_logic;                             --r/w za LCD -- 0 pisanje na LCD, 1 branje iz LCD
     RS_o:            out     std_logic;                             --register select 0-> instruction 1-> data
     E_o:             out     std_logic;                             --write enable za lcd (1->read,fallign_edge 0 -> write)
     start_i:         in      std_logic;                            --pulz iz CPU, signalni bit za za�etek pisanja
     led_o :          out     std_logic_vector(11 downto 0)
   );
end LCDDriverTop;

architecture structure of LCDDriverTop is

   signal clock: std_logic;
   signal data: std_logic_vector(7 downto 0);
   signal dataAdress: std_logic_vector(4 downto 0);
   signal rst: std_logic;
   signal LCD_io: std_logic_vector(7 downto 0);
   signal busyLCDsig : std_logic;
   signal RW : std_logic;
   constant zero : std_logic := '0';
   constant zeroVector4to0: std_logic_vector(4 downto 0) := (others => '0');
   constant zeroVector7to0: std_logic_vector(7 downto 0) := (others => '0');
   
   component ila_0
      port(
         clk : IN STD_LOGIC;
         probe0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
         probe2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
         probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
         probe4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
         probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
         probe6 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
         probe7 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)      
      );
   end component ila_0;
   
begin

   rst <= not(rstn_i);

   U_LCDDriverMain: entity work.LCD_Driver_Main
      generic map(
         TPROP => TPROP
      )
      port map(
         clk_i => clock,
         rst_i => rst,
         busyLCD => busyLCDsig,
         dataLCD_o => LCD_io,
         data_i => data,
         busy_o => busy_o,
         dAdress_o => dataAdress,
         RW_o => RW,
         RS_o => RS_o,
         E_o => E_o,
         start_i => start_i,
         led_o => led_o
      );

   U_Clkdevider: entity work.CLKdevider
      generic map(
         TPD_G => TPROP
      )
      port map(
         clk_i => clk_in,
         clk_o => clock
      );

   U_RAM: entity work.Registri
      port map(
        WAddress => zeroVector4to0,
        RAddress => dataAdress,
        Din => zeroVector7to0,
        Dout => data,
        Write_en => zero,
        clk  => clk_in,
        reset => rst
      );

   U_ila_0 : component ila_0
      port map(
         clk => clk_in,
         probe0 => LCD_io,
         probe1(0) => busy_o,
         probe2(0) => RW_o,
         probe3(0) => RS_o,
         probe4(0) => E_o,
         probe5(0) => busyLCDsig,
         probe6 => dataAdress,
         probe7 => data
      );

   U_BuffIO : entity work.BuffIO
      port map(
         data_i => LCD_io,
         data_io => dataLCD_io,
         data_o => busyLCDsig ,
         toggle_i => RW
      );

   RW_o <= RW;
 

end structure;
