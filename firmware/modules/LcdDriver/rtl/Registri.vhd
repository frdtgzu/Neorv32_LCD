library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Registri is
   Port (
      WAddress : in STD_LOGIC_VECTOR (4 downto 0);
      RAddress : in STD_LOGIC_VECTOR (4 downto 0);
      Din : in STD_LOGIC_VECTOR (7 downto 0);
      Dout : out STD_LOGIC_VECTOR (7 downto 0);
      Write_en : in STD_LOGIC;
      clk : in STD_LOGIC;
      reset: in STD_LOGIC
   );

end Registri;

architecture rtl of Registri is

   type Array_Registrov is array(0 to 31) of STD_LOGIC_VECTOR(7 downto 0);
   
   constant Reg : Array_Registrov := (
           0=> X"48",      --H
           1=> X"65",      --e
           2=> X"6C",      --l
           3=> X"6C",      --l
           4=> X"6F",      --o
           5=> X"20",      --' '
           6=> X"66",      --f      
           7=> X"72",      --r
           8=> X"6F",      --o
           9=> X"6D",      --m
           10=> X"20",      --' '
           11=> X"20",      --' '
           12=> X"20",      --' '
           13=> X"20",      --' '
           14=> X"20",      --' '
           15=> X"20",      --' '
           
           16=> X"55",      --U
           17=> X"4C",      --L
           18=> X"20",      --' '
           19=> X"46",      --F
           20=> X"45",      --E
           21=> X"20",      --' '
           22=> X"4C",      --L
           23=> X"4E",      --N
           24=> X"49",      --I
           25=> X"56",      --V
           26=> X"20",      --' '
           27=> X"20",      --' '
           28=> X"20",      --' '
           29=> X"20",      --' '
           30=> X"20",      --' '
           31=> X"20"       --' '
   
   );
   
   signal registri : Array_Registrov := Reg;

begin


process(clk, reset)

    begin
    
    if rising_edge(clk) then
       if (write_en = '1' and unsigned(WAddress) < 32) then             
          registri(to_integer(unsigned(WAddress))) <= Din;
       end if;
    end if; 
      
    if (reset = '1') then
       registri <= Reg;
    end if;             
  
end process;

   Dout <= registri(to_integer(unsigned(RAddress)));

end rtl;
