library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;

library unisim;


entity Neorv32Wrapper is
   port (
      clk_i             : in sl;
      rst_i             : in sl;
      gpio_i            : in slv(7 downto 0);
      gpio_o            : out slv(7 downto 0);
      uart0_rxd_i       : in sl;
      uart0_txd_o       : out sl;
      axilReadMaster_o  : out AxiLiteReadMasterType;
      axilReadSlave_i   : in AxiLiteReadSlaveType;
      axilWriteMaster_o : out AxiLiteReadMasterType;
      axilWriteSlave_i  : in AxiLiteWriteSlaveType;        
   );
end entity Neorv32Wrapper;

architecture rtl of Neorv32Wrapper is
begin

   U_CPU : entity work.neorv32_vivado_ip_0
      port map(
         
      );

   U_AxiConverter : work.axi_protocol_converter_0
      port map(
      
      );
   
end architecture rtl;