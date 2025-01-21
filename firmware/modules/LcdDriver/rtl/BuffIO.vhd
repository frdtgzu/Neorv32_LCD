----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.07.2024 09:49:59
-- Design Name: 
-- Module Name: BuffIO - Behavioral
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
use UNISIM.Vcomponents.ALL;


entity BuffIO is
   Port (
      data_i : in std_logic_vector(7 downto 0);
      data_o : out std_logic;
      data_io: inout std_logic_vector(7 downto 0);
      toggle_i : in std_logic
   );
end BuffIO;

architecture Behavioral of BuffIO is

begin


IOBUF_0 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (
      O => data_o, -- Buffer output
      IO => data_io(7), -- Buffer inout port (connect directly to top-level port)
      I => data_i(7), -- Buffer input
      T => toggle_i -- 3-state enable input, high=input, low=output
   );

IOBUF_1 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (

      IO => data_io(6), -- Buffer inout port (connect directly to top-level port)
      I => data_i(6), -- Buffer input
      T => toggle_i -- 3-state enable input, high=input, low=output
   );
   
IOBUF_2 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (

      IO => data_io(5), -- Buffer inout port (connect directly to top-level port)
      I => data_i(5), -- Buffer input
      T => toggle_i -- 3-state enable input, high=input, low=output
   );

IOBUF_3 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (

      IO => data_io(4), -- Buffer inout port (connect directly to top-level port)
      I => data_i(4), -- Buffer input
      T => toggle_i -- 3-state enable input, high=input, low=output
   );

IOBUF_4 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (

      IO => data_io(3), -- Buffer inout port (connect directly to top-level port)
      I => data_i(3), -- Buffer input
      T => toggle_i -- 3-state enable input, high=input, low=output
   );

IOBUF_5 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (

      IO => data_io(2), -- Buffer inout port (connect directly to top-level port)
      I => data_i(2), -- Buffer input
      T => toggle_i -- 3-state enable input, high=input, low=output
   );

IOBUF_6 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (

      IO => data_io(1), -- Buffer inout port (connect directly to top-level port)
      I => data_i(1), -- Buffer input
      T => toggle_i -- 3-state enable input, high=input, low=output
   );
   
IOBUF_7 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (

      IO => data_io(0), -- Buffer inout port (connect directly to top-level port)
      I => data_i(0), -- Buffer input
      T => toggle_i -- 3-state enable input, high=input, low=output
   );
   
   
end Behavioral;
