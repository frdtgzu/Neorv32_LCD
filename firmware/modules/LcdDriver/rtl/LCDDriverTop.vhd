library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.ALL;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;

use work.LcdPkg.all;

entity LCDDriverTop is
   Generic(
      TPD_G      : time := 1ns
   );
   Port(
      -- AXI-Lite Interface (axilClk domain)
      axilClk         : in  sl;
      axilRst         : in  sl;
      axilWriteMaster : in  AxiLiteWriteMasterType;
      axilWriteSlave  : out AxiLiteWriteSlaveType;
      axilReadMaster  : in  AxiLiteReadMasterType;
      axilReadSlave   : out AxiLiteReadSlaveType;
      
      --! Clk and rst
      clk_i      : in sl;     
      rst_i      : in sl;   
 
      --! Lcd read channel
      lcdReadMaster  : out AxiLiteReadMasterType;
      lcdReadSlave   : in  AxiLiteReadSlaveType;

      --! Lcd Ctrl Signal  
      useBtnStart : in sl;

      --! Lcd I/O
      dataLCD_io : inout slv(7 downto 0);       
      busy_o     : out   sl;                 
      RW_o       : out   sl;                
      RS_o       : out   sl;                 
      E_o        : out   sl;                 
      btnStart_i : in    sl;                 
      led_o      : out   slv(11 downto 0)
   );

end LCDDriverTop;

architecture structure of LCDDriverTop is

   signal clock      : sl;
   signal data       : slv(7 downto 0);
   signal dataAdress : slv(4 downto 0);
   signal rst        : sl;
   signal LCD_io     : slv(7 downto 0);
   signal busyLCDsig : sl;
   signal RW         : sl;
   signal start      : sl;
   signal LcdStat    : LcdStatType := LCD_STAT_INIT_C;
   
begin

   start <= btnStart_i when (useBtnStart = '1') else lcdStat.start;
   
   U_LcdReg : entity work.LcdReg
      generic map(
         TPD_G => TPD_G
      )
      port map(
         axilClk         => axilClk,
         axilRst         => axilRst,
         axilWriteMaster => axilWriteMaster,
         axilWriteSlave  => axilWriteSlave,
         axilReadMaster  => axilReadMaster,
         axilReadSlave   => axilReadSlave,  
         lcdStat         => lcdStat    
      );

   U_LcdDriver: entity work.LcdDriverMain
      generic map(
         TPD_G => TPD_G
      )
      port map(
         clk_i     => clock,
         rst_i     => rst,
         busyLCD   => busyLCDsig,
         dataLCD_o => LCD_io,
         data_i    => data,
         busy_o    => busy_o,
         dAdress_o => dataAdress,
         RW_o      => RW,
         RS_o      => RS_o,
         E_o       => E_o,
         start_i   => start,
         led_o     => led_o
      );

   U_Clkdevider: entity work.CLKdevider
      generic map(
         TPD_G => TPD_G
      )
      port map(
         clk_i => clk_i,
         clk_o => clock
      );

   U_BuffIO : entity work.BuffIO
      port map(
         data_i   => LCD_io,
         data_io  => dataLCD_io,
         data_o   => busyLCDsig,
         toggle_i => RW
      );

   RW_o <= RW;
 

end structure;
