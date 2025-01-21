----------------------------------------------------------------------------------
-- Engineer: Vid Balant
-- 
-- Create Date: 14.07.2024 08:46:25
-- Design Name: 
-- Module Name: LCD_Driver_Main - Behavioral
-- Project Name: LCD_Driver
-- Target Devices: arty a7-100T
-- Tool Versions: vivado 2024.2
-- Description: LCD driver for digilent pmod lcd display
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LCD_Driver_Main is
   generic(
       TPD_G: time := 1ns
   );

   Port (   rst_i:           in      std_logic;                             --reset
            busyLCD:         in      std_logic;                             --podatki na LCD data vodilu         najvi�ja linija nosi informacije o LCDbusy flag-u, mora biti tipa inout
            dataLCD_o :      out     std_logic_vector(7 downto 0);
            data_i:          in      std_logic_vector(7 downto 0);          --podatki iz registrov
            clk_i:           in      std_logic;                             --1MHz ura
            busy_o:          out     std_logic;                             --kontrolni signal -> kdaj driver lahko zapi�e nove podatke na LCD: 0->pripravljen, 1->ne
            dAdress_o:       out     std_logic_vector(4 downto 0);          --naslovni prostor za pomnilnik, iz kjer beremo podatke
            RW_o:            out     std_logic;                             --r/w za LCD -- 0 pisanje na LCD, 1 branje iz LCD
            RS_o:            out     std_logic;                             --register select 0-> instruction 1-> data
            E_o:             out     std_logic;                             --write enable za lcd (1->read,fallign_edge 0 -> write)
            start_i:         in      std_logic;                              --pulz iz CPU, signalni bit za za�etek pisanja
            led_o:           out     std_logic_vector(11 downto 0)          -- testni signali za dolo�itev stanja            
        );
        
end LCD_Driver_Main;


architecture Behavioral of LCD_Driver_Main is

    constant functionSetFunction :     STD_LOGIC_VECTOR(7 downto 0)  := X"3C";  -- Function set komanda za LCD bus inicializacijo (set_function state)
    constant displaySetFunction :      STD_LOGIC_VECTOR(7 downto 0)  := X"0C";  -- Display set komanda za LCD display inicializacijo
    constant displayClearFunction :    STD_LOGIC_VECTOR(7 downto 0)  := X"01";  -- Display clear komanda pred pisanjem na LCD

    type LCD_ADDR_T is array(31 downto 0) of std_logic_vector(7 downto 0);

    constant LCD_ADDR : LCD_ADDR_T:= (
        0=> X"80",
        1=> X"81",
        2=> X"82",
        3=> X"83",
        4=> X"84",
        5=> X"85",
        6=> X"86",
        7=> X"87",
        8=> X"88",
        9=> X"89",
        10=> X"8A",
        11=> X"8B",
        12=> X"8C",
        13=> X"8D",
        14=> X"8E",
        15=> X"8F",
        16=> X"C0",
        17=> X"C1",
        18=> X"C2",
        19=> X"C3",
        20=> X"C4",
        21=> X"C5",
        22=> X"C6",
        23=> X"C7",
        24=> X"C8",
        25=> X"C9",
        26=> X"CA",
        27=> X"CB",
        28=> X"CC",
        29=> X"CD",
        30=> X"CE",
        31=> X"CF"
    );

   type stateType is (
       STARTWAIT_S,
       SETFUNCT_S,
       FUNCTWAIT_S,
       SETDISPLAY_S,
       DISPLAYWAIT_S,
       DISPLAYCLEAR_S,
       CLEARWAIT_S,
       IDLE_S,
       CLEAR_S,
       GETDATA_S,
       SENDDATA_S,
       SETADDR_S
   );

   type recordType is record
      count : std_logic_vector(14 downto 0);
      s1 : std_logic;
      s2 : std_logic;
      state : stateType;
      data: std_logic_vector(7 downto 0);
      RW: std_logic;
      RS: std_logic;
      enable: std_logic;
      busy: std_logic;
      LCDbusy: std_logic;
      index: std_logic_vector(4 downto 0);
      dataLoad: std_logic_vector(7 downto 0);
      nextState: std_logic;
   end record recordType;
   
   constant RECORDTYPE_INIT_c : recordType := (
      count  => (others => '0'),
      s1     => '0',
      s2     => '0',
      state  => STARTWAIT_S,
      data   => (others => '0'),
      RW     => '0',
      RS     => '0',
      enable => '1',
      busy   => '1',
      index  => (others => '0'),
      nextState => '0',
      LCDbusy   => '0',     
      dataLoad  => (others => '0')
   );

--!   Synchronous input into registers
   signal r : recordType := RECORDTYPE_INIT_C;
   
   
--!   Synchronous output out of registers
   signal rin : recordType := RECORDTYPE_INIT_C;
   
   --!  Testni signal za dolo�itev stanja
   signal led: std_logic_vector(11 downto 0):= (others => '0');


begin

p_asinh: process(all)
      variable v : recordType;
begin 
   
   
   -- Default asignment
   v := r;
   
   -- Reset enable for next data send
   v.enable := '1';
   
   -- Default assesment of RW to write to LCD
   v.RW := '0';
   
   --! LCD busy signal asignment
   v.LCDbusy := busyLCD;
   
   --! Reset led
   led <= (others => '0');
      
   if(r.state /= IDLE_S) then
      if(r.count < "111111111111111") then -- overflow protection
         v.count := std_logic_vector(unsigned(r.count) + 1);   
      end if;
   end if;
   
   case r.state is 
----------------------------------------------------------------------------        
      when STARTWAIT_S =>
         led(0) <= '1';      
         if(r.count = "100111000100000") then
            v.state := SETFUNCT_S;
            v.count := (others => '0');
            v.busy := '1';
         end if;
----------------------------------------------------------------------------              
      when SETFUNCT_S =>
         led(1) <= '1';     
         v.data := functionSetFunction;
         v.RS := '0';
         if(r.count(0) = '1') then
            v.enable := '0';
            v.state := FUNCTWAIT_S;
            v.count := (others => '0');
         end if;
 ----------------------------------------------------------------------------          
      when FUNCTWAIT_S =>
         led(2) <= '1';
         if(r.count = "000000000100101") then
            v.state := SETDISPLAY_S;
            v.count := (others => '0');
         end if;
----------------------------------------------------------------------------           
      when SETDISPLAY_S =>
         led(3) <= '1';
         v.data := displaySetFunction;
         v.RS := '0';
         if(r.count(0) = '1') then
            v.enable := '0';
            v.state := DISPLAYWAIT_S;
            v.count := (others => '0');
         end if;      
 ----------------------------------------------------------------------------          
      when DISPLAYWAIT_S =>
         led(4) <= '1';
         if(r.count = "000000000100101") then
            v.state := DISPLAYCLEAR_S;
            v.count := (others => '0');
         end if;     
 ----------------------------------------------------------------------------          
      when DISPLAYCLEAR_S =>
         led(5) <= '1';
         v.data := displayClearFunction;
         v.RS := '0';
         if(r.count(0) = '1') then
            v.enable := '0';
            v.state := CLEARWAIT_S;
            v.count := (others => '0');
         end if;      
 ----------------------------------------------------------------------------               
      when CLEARWAIT_S =>
         led(6) <= '1';
         if(r.count = "000000000100101") then
            v.state := IDLE_S;
            v.count := (others => '0');
         end if;
----------------------------------------------------------------------------           
      when IDLE_S =>
         led(7) <= '1';
         v.busy := '0';
         v.s1 := start_i;      
         v.s2 := r.s1;
         if(r.s2 = '0' and r.s1 = '1') then
            v.index := (others => '0');         
            v.state := CLEAR_S;
            v.busy := '1';
            v.RW := '1';
            v.count := (others => '0');
         end if;
----------------------------------------------------------------------------           
      when CLEAR_S =>
         led(8) <= '1';
         v.RW := '1';      
         if(r.LCDbusy = '0' and r.RW = '1') then
            v.RW := '0';
            v.RS := '0';
            v.data := displayClearFunction;
         end if;
         if(r.RW = '0') then
            v.enable := '0';
            v.nextState := '1';
            v.RW := '0';
         end if;            
         if(r.nextState = '1') then
            v.state := SETADDR_S;
            v.nextState := '0';
            v.RW := '1';        

         end if;
----------------------------------------------------------------------------           
      when SETADDR_S =>
         led(9) <= '1';
         v.RW := '1';      
         if(r.LCDbusy = '0' and r.RW = '1') then
            v.RW := '0';
            v.RS := '0';
            v.data := LCD_ADDR(TO_INTEGER(unsigned(r.index)));
         end if;
         if(r.RW = '0') then
            v.enable := '0';
            v.nextState := '1';
            v.RW := '0'; 
         end if;                         
         if(r.nextState = '1') then
            v.nextState := '0';
            v.state := GETDATA_S; 
            v.RW := '1';                           
         end if;
----------------------------------------------------------------------------           
      when GETDATA_S =>
         led(10) <= '1';
         dAdress_o <= r.index;
         if(r.RW = '0') then 
            v.dataLoad := data_i;
            v.state := SENDDATA_S;
            v.RW := '1';            
         end if;
 ----------------------------------------------------------------------------          
      when SENDDATA_S=>
         led(11) <= '1';
         v.RW := '1';      
         if(r.LCDbusy = '0' and r.RW = '1') then
            v.RW := '0';
            v.RS := '1';
            v.data := r.dataLoad;
         end if;
         if(r.RW = '0') then
            v.enable := '0';
            v.nextState := '1';
            v.RW := '0';                           
         end if;      
         if(r.nextState = '1') then
            v.nextState := '0';
            v.state := SETADDR_S; 
            v.RW := '1';   
            if(unsigned(r.index) >= 31) then
               v.state := IDLE_S;
            else 
               v.index := std_logic_vector(unsigned(r.index) + 1); 
            end if;                            
         end if;       
    
----------------------------------------------------------------------------          
      when others =>
         v := RECORDTYPE_INIT_c;

      end case;
 ----------------------------------------------------------------------------       
      if(rst_i = '1') then
         v := RECORDTYPE_INIT_c;
      end if;
   
      -- output signals
      RW_o <= r.RW;
      RS_o <= r.RS;
      E_o <= r.enable;     
      busy_o <= r.busy;
      
      dataLCD_o  <= r.data(7 downto 0);
      led_o <= led;
      -- 
      rin <= v;
   
   end process p_asinh;

p_sinh: process(clk_i)
   begin
      if(rising_edge(clk_i)) then
         r <= rin after TPROP;
      end if;
   end process p_sinh;


end Behavioral;
