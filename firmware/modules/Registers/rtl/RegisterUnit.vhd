library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;

entity RegisterUnit is
   Generic(
    TPD_G             : time := 1ns
   );
   Port (
      -- AXI-Lite Interface (axilClk domain)
      axilClk         : in  sl;
      axilRst         : in  sl;
      axilWriteMaster : in  AxiLiteWriteMasterType;
      axilWriteSlave  : out AxiLiteWriteSlaveType;
      axilReadMaster  : in  AxiLiteReadMasterType;
      axilReadSlave   : out AxiLiteReadSlaveType;

      --! User Axi-Lite interface
      userReadMaster  : in  AxiLiteReadMasterType;
      userReadSlave   : out AxiLiteReadSlaveType 
   );
end RegisterUnit;


architecture Behavioral of RegisterUnit is

   signal ramWriteMaster : AxiLiteWriteMasterType;
   signal ramWriteSlave  : AxiLiteWriteSlaveType;
   signal ramReadMaster  : AxiLiteReadMasterType;
   signal ramReadSlave   : AxiLiteReadSlaveType;

begin

   U_XBAR : entity work.axi_crossbar_0
      port map(
      
         --! Clock and Reset
         s_aclk => axilClk,
         s_arstn => not(axilRst),
               
         --! Slave port one asignment
         s_axi_awaddr(31 downto 16) => (others =>'0'),
         s_axi_awaddr(15 downto 0)  => AxiWriteMaster.awaddr(15 downto 0),
         s_axi_awprot(2 downto 0)   => AxiWriteMaster.awprot(2 downto 0),
         s_axi_awvalid(0)           => AxiWriteMaster.awvalid,
         s_axi_awready(0)           => AxiWriteSlave.awready,
         s_axi_wdata(31 downto 0)   => AxiWriteMaster.wdata(31 downto 0),
         s_axi_wstrb(3 downto 0)    => AxiWriteMaster.wstrb(3 downto 0),
         s_axi_wvalid(0)            => AxiWriteMaster.wvalid,
         s_axi_wready(0)            => AxiWriteSlave.wready,
         s_axi_bresp(1 downto 0)    => AxiWriteSlave.bresp(1 downto 0),
         s_axi_bvalid(0)            => AxiWriteSlave.bvalid,
         s_axi_bready(0)            => AxiWriteMaster.bready,
         s_axi_araddr(15 downto 0)  => AxiReadMaster.araddr(15 downto 0),
         s_axi_arprot(2 downto 0)   => AxiReadMaster.arprot(2 downto 0),
         s_axi_arvalid(0)           => AxiReadMaster.arvalid,
         s_axi_arready(0)           => AxiReadSlave.arready,
         s_axi_rdata(31 downto 0)   => AxiReadSlave.rdata(31 downto 0),
         s_axi_rresp(1 downto 0)    => AxiReadSlave.rresp(1 downto 0),
         s_axi_rvalid(0)            => AxiReadSlave.rvalid,
         s_axi_rready(0)            => AxiReadMaster.rready,
         
         --! Slave port two asignment     
         s_axi_awaddr(63 downto 48) => (others =>'0'),
         s_axi_araddr(47 downto 32) => userReadMaster.araddr(31 downto 0),
         s_axi_arprot(5 downto 3)   => userReadMaster.arprot(2 downto 0),
         s_axi_arvalid(1)           => userReadMaster.arvalid,
         s_axi_arready(1)           => userReadSlave.arready,
         s_axi_rdata(63 downto 32)  => userReadSlave.rdata(31 downto 0),
         s_axi_rresp(3 downto 2)    => userReadSlave.rresp(1 downto 0),
         s_axi_rvalid(1)            => userReadSlave.rvalid,
         s_axi_rready(1)            => userReadMaster.rready,         
         
         --! Master port asignment
         m_axi_awaddr  => ramWriteMaster.awaddr(31 downto 0),
         m_axi_awprot  => ramWriteMaster.awprot(2 downto 0),
         m_axi_awvalid => ramWriteMaster.awvalid,
         m_axi_awready => ramWriteSlave.awready,
         m_axi_wdata   => ramWriteMaster.wdata(31 downto 0),
         m_axi_wstrb   => ramWriteMaster.wstrb(3 downto 0),
         m_axi_wvalid  => ramWriteMaster.wvalid,
         m_axi_wready  => ramWriteSlave.wready,
         m_axi_bresp   => ramWriteSlave.bresp(1 downto 0),
         m_axi_bvalid  => ramWriteSlave.bvalid,
         m_axi_bready  => ramWriteMaster.bready,
         m_axi_araddr  => ramReadMaster.araddr(31 downto 0),
         m_axi_arprot  => ramReadMaster.arprot(2 downto 0),
         m_axi_arvalid => ramReadMaster.arvalid,
         m_axi_arready => ramReadSlave.arready,
         m_axi_rdata   => ramReadSlave.rdata(31 downto 0),
         m_axi_rresp   => ramReadSlave.rresp(1 downto 0),
         m_axi_rvalid  => ramReadSlave.rvalid,
         m_axi_rready  => ramReadMaster.rready         
      );
      
   U_RAM : entity work.blk_mem_gen_0
      port map(
         --! Clock and Reset
         s_aclk => axilClk,
         s_arstn => not(axilRst),
         
         --! Slave port asignmnet
         s_axi_awaddr  => ramWriteMaster.awaddr(31 downto 0),
         s_axi_awprot  => ramWriteMaster.awprot(2 downto 0),
         s_axi_awvalid => ramWriteMaster.awvalid,
         s_axi_awready => ramWriteSlave.awready,
         s_axi_wdata   => ramWriteMaster.wdata(31 downto 0),
         s_axi_wstrb   => ramWriteMaster.wstrb(3 downto 0),
         s_axi_wvalid  => ramWriteMaster.wvalid,
         s_axi_wready  => ramWriteSlave.wready,
         s_axi_bresp   => ramWriteSlave.bresp(1 downto 0),
         s_axi_bvalid  => ramWriteSlave.bvalid,
         s_axi_bready  => ramWriteMaster.bready,
         s_axi_araddr  => ramReadMaster.araddr(31 downto 0),
         s_axi_arprot  => ramReadMaster.arprot(2 downto 0),
         s_axi_arvalid => ramReadMaster.arvalid,
         s_axi_arready => ramReadSlave.arready,
         s_axi_rdata   => ramReadSlave.rdata(31 downto 0),
         s_axi_rresp   => ramReadSlave.rresp(1 downto 0),
         s_axi_rvalid  => ramReadSlave.rvalid,
         s_axi_rready  => ramReadMaster.rready      
      );
      
end Behavioral;