----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.07.2024 17:07:54
-- Design Name: 
-- Module Name: LCDDriverTb - Behavioral
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

entity LCDDriverTb is

end LCDDriverTb;

architecture Behavioral of LCDDriverTb is

   signal clk_i : std_logic;
   signal rstn_i : std_logic;
   signal start_i : std_logic;
   signal RW_O : std_logic;
   signal RS_o : std_logic;
   signal E_o : std_logic;
   signal dataLCD_io : std_logic_vector(7 downto 0);
   signal busy : std_logic;
   
    -- Clock period definitions 
   constant T_C : time := 10.0 ns; --! Clock period constant  
   
   constant TPD_G : time := 1ns;


begin

--! Entity initialization

u_LCDDriver: entity work.LCDDriverTop
    generic map(
       TPROP => TPD_G
    )
    port map(
       rstn_i => rstn_i,
       clk_in => clk_i,
       start_i => start_i,
       RW_o => RW_o,
       RS_o => RS_o,
       E_o => E_o,
       busy_o => busy,
       dataLCD_io => dataLCD_io      
    );

  --! Clk gen process
   Process_CLK_gen :process
   begin
      clk_i <= '0';
      wait for T_C/2;
      clk_i <= '1';
      wait for T_C/2;
   end process;


   Process_sim:process 
   begin
      start_i <= '0';
      rstn_i <= '0';
      wait for T_C * 100;
  
      
      --! State machine comes to idle stage
      wait until busy = '0';
      
      start_i <= '1';
      wait for T_C * 100;
      
      wait until busy = '0';
      

   -- Stop simulation
   assert false report "SIMULATION COMPLETED" severity failure;


   end process;


end Behavioral;
