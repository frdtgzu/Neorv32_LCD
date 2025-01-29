-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------
-- Description: Reference of what the final result will be this lab
-------------------------------------------------------------------------------
-- This file is part of 'surf-tutorial'.
-- It is subject to the license terms in the LICENSE.txt file found in the
-- top-level directory of this distribution and at:
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
-- No part of 'surf-tutorial', including this file,
-- may be copied, modified, propagated, or distributed except according to
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;

use work.LcdPkg.all;

entity LcdReg is
   generic (
      TPD_G          : time := 1 ns
   );
   port (
      --! Lcd signals
      lcdStat         : out LcdStatType;
      -- AXI-Lite Bus
      axilClk         : in  sl;
      axilRst         : in  sl;
      axilReadMaster  : in  AxiLiteReadMasterType;
      axilReadSlave   : out AxiLiteReadSlaveType;
      axilWriteMaster : in  AxiLiteWriteMasterType;
      axilWriteSlave  : out AxiLiteWriteSlaveType
   );
end LcdReg;

architecture behavioral of LcdReg is

   type RegType is record
      axilReadSlave  : AxiLiteReadSlaveType;
      axilWriteSlave : AxiLiteWriteSlaveType;
      lcdStat        : LcdStatType;
   end record RegType;

   constant REG_INIT_C : RegType := (
      axilReadSlave  => AXI_LITE_READ_SLAVE_INIT_C,
      axilWriteSlave => AXI_LITE_WRITE_SLAVE_INIT_C,
      lcdStat        => LCD_STAT_INIT_C
      );

   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;

begin

   ------------------------
   -- combinatorial process
   ------------------------
   comb : process (axilReadMaster, axilRst, axilWriteMaster, r) is
      variable v      : RegType;
      variable axilEp : AxiLiteEndpointType;
   begin
      -- Latch the current value
      v := r;

      ---------------------------------
      -- Determine the transaction type
      ---------------------------------
      axiSlaveWaitTxn(axilEp, axilWriteMaster, axilReadMaster, v.axilWriteSlave, v.axilReadSlave);

      -------------------------------
      -- Mapping read/write registers
      -------------------------------
      axiSlaveRegister(axilEp, x"000", 0, v.lcdStat.start);

      ---------------------------
      -- Closeout the transaction
      ---------------------------
      axiSlaveDefault(axilEp, v.axilWriteSlave, v.axilReadSlave, AXI_RESP_DECERR_C);

      ----------
      -- Outputs
      ----------
      axilReadSlave  <= r.axilReadSlave;
      axilWriteSlave <= r.axilWriteSlave;

      --------------------
      -- Synchronous Reset
      --------------------
      if (axilRst = '1') then
         v := REG_INIT_C;
      end if;

      -- Register the variable for next clock cycle
      rin <= v;

   end process comb;

   -------------------
   -- Register process
   -------------------
   seq : process (axilClk) is
   begin
      if rising_edge(axilClk) then
         r <= rin after TPD_G;
      end if;
   end process seq;

end behavioral;