library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;

entity Neorv32Wrapper is
   generic(
      TPD_G : time := 1ns
   );
   port (
      clk_i             : in sl;
      rst_i             : in sl;
      gpio_i            : in slv(7 downto 0);
      gpio_o            : out slv(7 downto 0);
      uart0_rxd_i       : in sl;
      uart0_txd_o       : out sl;
      axilReadMaster_o  : out AxiLiteReadMasterType;
      axilReadSlave_i   : in AxiLiteReadSlaveType;
      axilWriteMaster_o : out AxiLiteWriteMasterType;
      axilWriteSlave_i  : in AxiLiteWriteSlaveType        
   );
end entity Neorv32Wrapper;

architecture rtl of Neorv32Wrapper is

   signal AxilReadMaster  : AxiLiteReadMasterType  := AXI_LITE_READ_MASTER_INIT_C;
   signal AxilReadSlave   : AxiLiteReadSlaveType   := AXI_LITE_READ_SLAVE_INIT_C;
   signal AxilWriteMaster : AxiLiteWriteMasterType := AXI_LITE_WRITE_MASTER_INIT_C;
   signal AxilWriteSlave  : AxiLiteWriteSlaveType  := AXI_LITE_WRITE_SLAVE_INIT_C;

begin
      
   axilReadMaster_o   <= AxilReadMaster;
   axilWriteMaster_o  <= AxilWriteMaster;
   AxilReadSlave      <= axilReadSlave_i;
   AxilWriteSlave     <= axilWriteSlave_i;
      
   U_CPU : entity work.neorv32_vivado_ip_0
      port map(

         --! Clock and reset
         clk => clk_i,
         resetn => not(rst_i),

         --! GPIO
         gpio_i => gpio_i,
         gpio_o => gpio_o,

         --! Uart rx/tx
         uart0_rxd_i => uart0_rxd_i,
         uart0_txd_o => uart0_txd_o,

         uart0_cts_i => '0',  --! Optional port
         uart0_rts_o => open, --! Optional port

         --! Master Axi-4
         m_axi_awaddr  => AxiWriteMaster.awaddr(31 downto 0),
         m_axi_awprot  => AxiWriteMaster.awprot(2 downto 0),
         m_axi_awvalid => AxiWriteMaster.awvalid,
         m_axi_awready => AxiWriteSlave.awready,
         m_axi_wdata   => AxiWriteMaster.wdata(31 downto 0),
         m_axi_wstrb   => AxiWriteMaster.wstrb(3 downto 0),
         m_axi_wvalid  => AxiWriteMaster.wvalid,
         m_axi_wready  => AxiWriteSlave.wready,
         m_axi_bresp   => AxiWriteSlave.bresp(1 downto 0),
         m_axi_bvalid  => AxiWriteSlave.bvalid,
         m_axi_bready  => AxiWriteMaster.bready,
         m_axi_araddr  => AxiReadMaster.araddr(31 downto 0),
         m_axi_arprot  => AxiReadMaster.arprot(2 downto 0),
         m_axi_arvalid => AxiReadMaster.arvalid,
         m_axi_arready => AxiReadSlave.arready,
         m_axi_rdata   => AxiReadSlave.rdata(31 downto 0),
         m_axi_rresp   => AxiReadSlave.rresp(1 downto 0),
         m_axi_rvalid  => AxiReadSlave.rvalid,
         m_axi_rready  => AxiReadMaster.rready,

         --! Iqr
         mtime_irw_i => '0',
         msw_irq_i   => '0',
         mext_irq_i  => '0'
      );
   
end architecture rtl;