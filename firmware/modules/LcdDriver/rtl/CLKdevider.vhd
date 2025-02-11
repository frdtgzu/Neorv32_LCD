----------------------------------------------------------------------------------
-- Engineer: Vid Balant
-- 
-- Create Date: 14.07.2024 08:46:25
-- Design Name: 
-- Module Name: CLKdevider - Behavioral
-- Project Name: LCD_Driver
-- Target Devices: arty a7-100T
-- Tool Versions: vivado 2023.1
-- Description: ÇLKdevider 100MHz -> 1Mhz
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CLKdevider is
   Generic (
      TPD_G : time := 1ns
   );

   Port ( clk_i : in STD_LOGIC;
           clk_o : out STD_LOGIC);
end CLKdevider;

architecture Behavioral of CLKdevider is

   signal clkUScount : std_logic_vector(7 downto 0);
   signal clk : STD_LOGIC:= '0';
begin

process(clk_i)

begin

   if(rising_edge(clk_i)) then
      if(clkUScount = "11111001") then
         clkUScount <= "00000000" after TPD_G;
		 if(clk = '0') then
		    clk <= '1' after TPD_G;
		 else
		    clk <= '0' after TPD_G;
		 end if;
      else
         clkUScount <= std_logic_vector(unsigned(clkUScount) + 1) after TPD_G;
      end if;
   end if;

end process;

clk_o <= clk;

end Behavioral;

