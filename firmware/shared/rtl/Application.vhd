-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------
-- Description: Application Module
-------------------------------------------------------------------------------
-- This file is part of 'Simple-ZCU216-Example'.
-- It is subject to the license terms in the LICENSE.txt file found in the
-- top-level directory of this distribution and at:
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
-- No part of 'Simple-ZCU216-Example', including this file,
-- may be copied, modified, propagated, or distributed except according to
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;

library work;
use work.AppPkg.all;

entity Application is
   generic (
      TPD_G            : time := 1 ns;
      AXIL_BASE_ADDR_G : slv(31 downto 0)
   );
   port (
      -- AXI-Lite Interface (axilClk domain)
      axilClk         : in  sl;
      axilRst         : in  sl;
      axilWriteMaster : in  AxiLiteWriteMasterType;
      axilWriteSlave  : out AxiLiteWriteSlaveType;
      axilReadMaster  : in  AxiLiteReadMasterType;
      axilReadSlave   : out AxiLiteReadSlaveType;
      -- Lcd signals
      lcdClk      : in sl;
      dataLCD_io  : inout slv(7 downto 0);                                                           
      busy_o      : out sl;                       
      RW_o        : out sl;                      
      RS_o        : out sl;                   
      E_o         : out sl;                     
      --btnStart_i  : in sl;
      --useBtnStart : in sl;
      led_o       : out slv(11 downto 0)
   );
      
end Application;

architecture mapping of Application is

   constant LCD_INDEX_C        : natural := 0;
   constant REGISTERS_INDEX_C  : natural := 1;
   constant NUM_AXIL_MASTERS_C : natural := 2;
   
   constant AXIL_CONFIG_C : AxiLiteCrossbarMasterConfigArray(NUM_AXIL_MASTERS_C-1 downto 0) := genAxiLiteConfig(NUM_AXIL_MASTERS_C, AXIL_BASE_ADDR_G, 28, 24);

   signal axilReadMasters  : AxiLiteReadMasterArray(NUM_AXIL_MASTERS_C-1 downto 0);
   signal axilReadSlaves   : AxiLiteReadSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0)  := (others => AXI_LITE_READ_SLAVE_EMPTY_DECERR_C);
   signal axilWriteMasters : AxiLiteWriteMasterArray(NUM_AXIL_MASTERS_C-1 downto 0);
   signal axilWriteSlaves  : AxiLiteWriteSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0) := (others => AXI_LITE_WRITE_SLAVE_EMPTY_DECERR_C);

   signal lcdReadMaster : AxiLiteReadMasterType;
   signal lcdReadSlave  : AxiLiteReadSlaveType;

begin

   U_XBAR : entity surf.AxiLiteCrossbar
      generic map (
         TPD_G              => TPD_G,
         NUM_SLAVE_SLOTS_G  => 1,
         NUM_MASTER_SLOTS_G => NUM_AXIL_MASTERS_C,
         MASTERS_CONFIG_G   => AXIL_CONFIG_C
      )
      port map (
         axiClk              => axilClk,
         axiClkRst           => axilRst,
         sAxiWriteMasters(0) => axilWriteMaster,
         sAxiWriteSlaves(0)  => axilWriteSlave,
         sAxiReadMasters(0)  => axilReadMaster,
         sAxiReadSlaves(0)   => axilReadSlave,
         mAxiWriteMasters    => axilWriteMasters,
         mAxiWriteSlaves     => axilWriteSlaves,
         mAxiReadMasters     => axilReadMasters,
         mAxiReadSlaves      => axilReadSlaves
      );
         
   U_Registers : entity work.RegisterUnit
      generic map(
         TPD_G => TPD_G
      )
      port map(
         --! Clock and reset
         axilClk => axilClk,
         axilRst => axilRst,
         
         axilWriteMaster => axilWriteMasters(REGISTERS_INDEX_C),
         axilWriteSlave  => axilWriteSlaves(REGISTERS_INDEX_C),
         axilReadMaster  => axilReadMasters(REGISTERS_INDEX_C),
         axilReadSlave   => axilReadSlaves(REGISTERS_INDEX_C),         

         --! Lcd read channel
         lcdReadMaster => lcdReadMaster,
         lcdReadSlave  => lcdReadSlave,
         lcdClk        => lcdClk,
         lcdRst        => axilRst       
      );   
         
   U_LCD : entity work.LcdDriverUnit
      generic map(
         TPD_G => TPD_G
      )
      port map(

         --! Reset
         rst_i => axilRst,
         
         axilClk => axilClk,
         axilRst => axilRst,         
         axilWriteMaster => axilWriteMasters(LCD_INDEX_C),
         axilWriteSlave  => axilWriteSlaves(LCD_INDEX_C),
         axilReadMaster  => axilReadMasters(LCD_INDEX_C),
         axilReadSlave   => axilReadSlaves(LCD_INDEX_C),         

         --! Lcd read channel
         lcdReadMaster => lcdReadMaster,
         lcdReadSlave  => lcdReadSlave,
         lcdClk        => lcdClk,
         lcdRst        => axilRst,

         --! Lcd signals
         dataLCD_io  => dataLCD_io,
         --useBtnStart => useBtnStart,
         --btnStart_i  => btnStart_i,
         busy_o      => busy_o,
         RW_o        => RW_o,
         RS_o        => RS_o,
         E_o         => E_o,
         led_o       => led_o
      );   

end mapping;
