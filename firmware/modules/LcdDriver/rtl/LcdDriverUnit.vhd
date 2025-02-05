library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.ALL;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;

use work.LcdPkg.all;

entity LcdDriverUnit is
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
      
      --! rst  
      rst_i      : in sl;   
 
      --! Lcd read channel
      lcdReadMaster  : out AxiLiteReadMasterType;
      lcdReadSlave   : in  AxiLiteReadSlaveType;
      lcdClk         : in sl;
      lcdRst         : in sl;

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

end LcdDriverUnit;

architecture structure of LcdDriverUnit is

   signal rst        : sl;
   signal LCD_io     : slv(7 downto 0);
   signal busyLCDsig : sl;
   signal RW         : sl;
   signal LcdCtrl    : LcdCtrlType := LCD_CTRL_INIT_C;
   signal start      : sl;
   signal startSync  : sl;
   
   
begin

   start <= btnStart_i when (useBtnStart = '1') else lcdCtrl.start;
   
   U_Sync : entity surf.Synchronizer
      generic map(
         TPD_G       => TPD_G,
         RST_ASYNC_G => true
      )
      port map(
         clk     => lcdClk,
         rst     => lcdRst,
         dataIn  => start,
         dataOut => startSync
      );
   
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
         LcdCtrl         => LcdCtrl    
      );

   U_LcdDriver: entity work.LcdDriverMain
      generic map(
         TPD_G => TPD_G
      )
      port map(
         --! Clock and reset
         clk_i     => lcdClk,
         rst_i     => rst_i,

         --! Lcd I/O
         busyLCD   => busyLCDsig,
         dataLCD_o => LCD_io,
         busy_o    => busy_o,
         RW_o      => RW,
         RS_o      => RS_o,
         E_o       => E_o,
         start_i   => startSync,

         --! Axi-read
         lcdReadMaster => lcdReadMaster,
         lcdReadSlave  => lcdReadSlave,

         --! Status LED's
         led_o     => led_o
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
