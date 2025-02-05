----------------------------------------------------------------------------------
-- Engineer: Vid Balant
-- 
-- Create Date: 14.07.2024 08:46:25
-- Design Name: 
-- Module Name: LcdDriverMain - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;


entity LcdDriverMain is
   generic(
      TPD_G: time := 1ns
   );
   Port(

      --! Clock and reset
      clk_i     : in  sl;
      rst_i     : in  sl;

      --! Axi Read channel
      lcdReadMaster : out AxiLiteReadMasterType;
      lcdReadSlave  : in  AxiLiteReadSlaveType;      

      busyLCD   : in  sl;                --! LCD busy signal
      dataLCD_o : out slv(7 downto 0);   --! Data for LCD
      busy_o    : out sl;                --! Driver busy signal
      RW_o      : out sl;                --! r/w za LCD -- 0 pisanje na LCD, 1 branje iz LCD
      RS_o      : out sl;                --! register select 0-> instruction, 1-> data
      E_o       : out sl;                --! write enable za lcd (1->read,fallign_edge 0 -> write)
      start_i   : in  sl;                --! signalni bit za zacetek izpisa
      led_o     : out slv(11 downto 0)   --! testni signali za dolocitev stanja            
   );
        
end LcdDriverMain;


architecture Behavioral of LcdDriverMain is

    constant FUNCTION_SET_C  :  slv(7 downto 0)  := X"3C";  --! Function set komanda za LCD bus inicializacijo (set_function state)
    constant DISPLAY_SET_C   :  slv(7 downto 0)  := X"0C";  --! Display set komanda za LCD display inicializacijo
    constant DISPLAY_CLEAT_C :  slv(7 downto 0)  := X"01";  --! Display clear komanda pred pisanjem na LCD

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
       START_WAIT_S,
       SET_FUNCT_S,
       FUNCT_WAIT_S,
       SET_DISPLAY_S,
       DISPLAY_WAIT_S,
       DISPLAY_CLEAR_S,
       CLEAR_WAIT_S,
       IDLE_S,
       CLEAR_S,
       SET_DATA_ADDR_S,
       GET_DATA_S,
       SEND_DATA_S,
       SET_ADDR_S
   );

   type recordType is record
      count     : slv(14 downto 0);
      s1        : sl;
      s2        : sl;
      state     : stateType;
      data      : slv(7 downto 0);
      RW        : sl;
      RS        : sl;
      enable    : sl;
      busy      : sl;
      LCDbusy   : sl;
      index     : slv(4 downto 0);
      dataLoad  : slv(7 downto 0);
      nextState : sl;
      lcdReadMaster : AxiLiteReadMasterType;
   end record recordType;
   
   constant RECORDTYPE_INIT_c : recordType := (
      count     => (others => '0'),
      s1        => '0',
      s2        => '0',
      state     => START_WAIT_S,
      data      => (others => '0'),
      RW        => '0',
      RS        => '0',
      enable    => '1',
      busy      => '1',
      index     => (others => '0'),
      nextState => '0',
      LCDbusy   => '0',     
      dataLoad  => (others => '0'),
      lcdReadMaster => AXI_LITE_READ_MASTER_INIT_C
   );

--!   Synchronous input into registers
   signal r : recordType := RECORDTYPE_INIT_C;
   
   
--!   Synchronous output out of registers
   signal rin : recordType := RECORDTYPE_INIT_C;
   
   --!  Testni signal za dolocitev stanja
   signal led: std_logic_vector(11 downto 0):= (others => '0');


begin

p_asinh: process(r, lcdReadSlave, rst_i, busyLCD, start_i, led)
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

   --! Axi-lite reset
   if(r.lcdReadMaster.arvalid = '1' or r.lcdReadMaster.rready = '1') then
      v.lcdReadMaster := AXI_LITE_READ_MASTER_INIT_C;
   end if;

   if(r.state /= IDLE_S) then
      if(r.count < "111111111111111") then -- overflow protection
         v.count := slv(unsigned(r.count) + 1);   
      end if;
   end if;
   
   case r.state is 
----------------------------------------------------------------------------        
      when START_WAIT_S =>
         led(0) <= '1';      
         if(r.count = "100111000100000") then
            v.state := SET_FUNCT_S;
            v.count := (others => '0');
            v.busy := '1';
         end if;
----------------------------------------------------------------------------              
      when SET_FUNCT_S =>
         led(1) <= '1';     
         v.data := FUNCTION_SET_C;
         v.RS := '0';
         if(r.count(0) = '1') then
            v.enable := '0';
            v.state := FUNCT_WAIT_S;
            v.count := (others => '0');
         end if;
 ----------------------------------------------------------------------------          
      when FUNCT_WAIT_S =>
         led(2) <= '1';
         if(r.count = "000000000100101") then
            v.state := SET_DISPLAY_S;
            v.count := (others => '0');
         end if;
----------------------------------------------------------------------------           
      when SET_DISPLAY_S =>
         led(3) <= '1';
         v.data := DISPLAY_SET_C;
         v.RS := '0';
         if(r.count(0) = '1') then
            v.enable := '0';
            v.state := DISPLAY_WAIT_S;
            v.count := (others => '0');
         end if;      
 ----------------------------------------------------------------------------          
      when DISPLAY_WAIT_S =>
         led(4) <= '1';
         if(r.count = "000000000100101") then
            v.state := DISPLAY_CLEAR_S;
            v.count := (others => '0');
         end if;     
 ----------------------------------------------------------------------------          
      when DISPLAY_CLEAR_S =>
         led(5) <= '1';
         v.data := DISPLAY_CLEAT_C;
         v.RS := '0';
         if(r.count(0) = '1') then
            v.enable := '0';
            v.state := CLEAR_WAIT_S;
            v.count := (others => '0');
         end if;      
 ----------------------------------------------------------------------------               
      when CLEAR_WAIT_S =>
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
            v.data := DISPLAY_CLEAT_C;
         end if;
         if(r.RW = '0') then
            v.enable := '0';
            v.nextState := '1';
            v.RW := '0';
         end if;            
         if(r.nextState = '1') then
            v.state := SET_ADDR_S;
            v.nextState := '0';
            v.RW := '1';        

         end if;
----------------------------------------------------------------------------           
      when SET_ADDR_S =>
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
            v.state := GET_DATA_S; 
            v.RW := '1';                           
         end if;
----------------------------------------------------------------------------           
      when SET_DATA_ADDR_S =>
         led(10) <= '1';
         v.lcdReadMaster.araddr(4 downto 0) := r.index;
         v.lcdReadMaster.arvalid := '1';
         if (lcdReadSlave.arready = '1') then
            v.state := GET_DATA_S;
         end if; 
       
----------------------------------------------------------------------------           
      when GET_DATA_S =>
         led(10) <= '1';
         v.lcdReadMaster.rready := '1';
         if(lcdReadSlave.rvalid = '1') then
            v.dataLoad := lcdReadSlave.rdata(7 downto 0);
            v.state := SEND_DATA_S;
            v.RW := '1';            
         end if;
 ----------------------------------------------------------------------------          
      when SEND_DATA_S=>
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
            v.state := SET_ADDR_S; 
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
      
      lcdReadMaster <= v.lcdReadMaster;

      dataLCD_o  <= r.data(7 downto 0);
      led_o <= led;
      -- 
      rin <= v;
   
   end process p_asinh;

p_sinh: process(clk_i)
   begin
      if(rising_edge(clk_i)) then
         r <= rin after TPD_G;
      end if;
   end process p_sinh;


end Behavioral;
