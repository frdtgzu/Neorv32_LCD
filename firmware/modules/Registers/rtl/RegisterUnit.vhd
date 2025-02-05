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
      lcdReadMaster  : in  AxiLiteReadMasterType;
      lcdReadSlave   : out AxiLiteReadSlaveType;
      lcdClk         : in  sl;
      lcdRst         : in  sl
   );
end RegisterUnit;


architecture Behavioral of RegisterUnit is

   signal ramWriteMaster : AxiLiteWriteMasterType;
   signal ramWriteSlave  : AxiLiteWriteSlaveType;
   signal ramReadMaster  : AxiLiteReadMasterType;
   signal ramReadSlave   : AxiLiteReadSlaveType;
   signal rstn           : sl;

   signal userReadMaster : AxiLiteReadMasterType;
   signal userReadSlave  : AxiLiteReadSlaveType;
   signal lcdRstn        : sl;

begin

   rstn    <= not(axilRst);
   lcdRstn <= not(lcdRst);
   
   U_XBAR : entity work.axilCrossbarBd_wrapper
      port map(
      
         --! Clock and Reset
         aclk_0    => axilClk,
         aresetn_0 => rstn,
               
         --! Slave port one asignment
         s00_axi_0_awaddr(31 downto 16) => (others =>'0'),
         s00_axi_0_awaddr(15 downto 0)  => axilWriteMaster.awaddr(15 downto 0),
         s00_axi_0_awprot(2 downto 0)   => axilWriteMaster.awprot(2 downto 0),
         s00_axi_0_awvalid(0)           => axilWriteMaster.awvalid,
         s00_axi_0_awready(0)           => axilWriteSlave.awready,
         s00_axi_0_wdata(31 downto 0)   => axilWriteMaster.wdata(31 downto 0),
         s00_axi_0_wstrb(3 downto 0)    => axilWriteMaster.wstrb(3 downto 0),
         s00_axi_0_wvalid(0)            => axilWriteMaster.wvalid,
         s00_axi_0_wready(0)            => axilWriteSlave.wready,
         s00_axi_0_bresp(1 downto 0)    => axilWriteSlave.bresp(1 downto 0),
         s00_axi_0_bvalid(0)            => axilWriteSlave.bvalid,
         s00_axi_0_bready(0)            => axilWriteMaster.bready,
         s00_axi_0_araddr(31 downto 16) => (others => '0'),
         s00_axi_0_araddr(15 downto 0)  => axilReadMaster.araddr(15 downto 0),
         s00_axi_0_arprot(2 downto 0)   => axilReadMaster.arprot(2 downto 0),
         s00_axi_0_arvalid(0)           => axilReadMaster.arvalid,
         s00_axi_0_arready(0)           => axilReadSlave.arready,
         s00_axi_0_rdata(31 downto 0)   => axilReadSlave.rdata(31 downto 0),
         s00_axi_0_rresp(1 downto 0)    => axilReadSlave.rresp(1 downto 0),
         s00_axi_0_rvalid(0)            => axilReadSlave.rvalid,
         s00_axi_0_rready(0)            => axilReadMaster.rready,
         
         --! Slave port two asignment  
         s01_axi_0_awaddr(31 downto 0)  => (others =>'0'),
         s01_axi_0_awprot(2 downto 0)   => (others =>'0'),
         s01_axi_0_awvalid(0)           => '0',
         s01_axi_0_awready              => open,
         s01_axi_0_wdata(31 downto 0)   => (others =>'0'),
         s01_axi_0_wstrb(3 downto 0)    => (others =>'0'),
         s01_axi_0_wvalid(0)            => '0',
         s01_axi_0_wready               => open,
         s01_axi_0_bresp                => open,
         s01_axi_0_bvalid               => open,
         s01_axi_0_bready(0)            => '0',         
         
         s01_axi_0_araddr(31 downto 16) => (others =>'0'),
         s01_axi_0_araddr(15 downto 0)  => userReadMaster.araddr(15 downto 0),
         s01_axi_0_arprot(2 downto 0)   => userReadMaster.arprot(2 downto 0),
         s01_axi_0_arvalid(0)           => userReadMaster.arvalid,
         s01_axi_0_arready(0)           => userReadSlave.arready,
         s01_axi_0_rdata(31 downto 0)   => userReadSlave.rdata(31 downto 0),
         s01_axi_0_rresp(1 downto 0)    => userReadSlave.rresp(1 downto 0),
         s01_axi_0_rvalid(0)            => userReadSlave.rvalid,
         s01_axi_0_rready(0)            => userReadMaster.rready,         
         
         --! Master port asignment
         m00_axi_0_awaddr(31 downto 0) => ramWriteMaster.awaddr(31 downto 0),
         m00_axi_0_awprot(2 downto 0)  => ramWriteMaster.awprot(2 downto 0),
         m00_axi_0_awvalid(0)          => ramWriteMaster.awvalid,
         m00_axi_0_awready(0)          => ramWriteSlave.awready,
         m00_axi_0_wdata(31 downto 0)  => ramWriteMaster.wdata(31 downto 0),
         m00_axi_0_wstrb(3 downto 0)   => ramWriteMaster.wstrb(3 downto 0),
         m00_axi_0_wvalid(0)           => ramWriteMaster.wvalid,
         m00_axi_0_wready(0)           => ramWriteSlave.wready,
         m00_axi_0_bresp(1 downto 0)   => ramWriteSlave.bresp(1 downto 0),
         m00_axi_0_bvalid(0)           => ramWriteSlave.bvalid,
         m00_axi_0_bready(0)           => ramWriteMaster.bready,
         m00_axi_0_araddr(31 downto 0) => ramReadMaster.araddr(31 downto 0),
         m00_axi_0_arprot(2 downto 0)  => ramReadMaster.arprot(2 downto 0),
         m00_axi_0_arvalid(0)          => ramReadMaster.arvalid,
         m00_axi_0_arready(0)          => ramReadSlave.arready,
         m00_axi_0_rdata(31 downto 0)  => ramReadSlave.rdata(31 downto 0),
         m00_axi_0_rresp(1 downto 0)   => ramReadSlave.rresp(1 downto 0),
         m00_axi_0_rvalid(0)           => ramReadSlave.rvalid,
         m00_axi_0_rready(0)           => ramReadMaster.rready         
      );
      
   U_RAM : entity work.blk_mem_gen_0
      port map(
         --! Clock and Reset
         s_aclk    => axilClk,
         s_aresetn => rstn,
         
         --! Slave port asignmnet
         s_axi_awaddr  => ramWriteMaster.awaddr(31 downto 0),
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
         s_axi_arvalid => ramReadMaster.arvalid,
         s_axi_arready => ramReadSlave.arready,
         s_axi_rdata   => ramReadSlave.rdata(31 downto 0),
         s_axi_rresp   => ramReadSlave.rresp(1 downto 0),
         s_axi_rvalid  => ramReadSlave.rvalid,
         s_axi_rready  => ramReadMaster.rready      
      );

   U_AxiClockCross : entity work.axi_clock_converter_0
      port map(

         --! Slave AXI asignment
         s_axi_aclk    => lcdClk,
         s_axi_aresetn => lcdRstn,
         s_axi_araddr  => lcdReadMaster.araddr(31 downto 0),
         s_axi_arvalid => lcdReadMaster.arvalid,
         s_axi_arprot  => lcdReadMaster.arprot(2 downto 0),
         s_axi_arready => lcdReadSlave.arready,
         s_axi_rdata   => lcdReadSlave.rdata(31 downto 0),
         s_axi_rresp   => lcdReadSlave.rresp(1 downto 0),
         s_axi_rvalid  => lcdReadSlave.rvalid,
         s_axi_rready  => lcdReadMaster.rready,

         --!Master AXI asignment
         m_axi_aclk    => axilClk,
         m_axi_aresetn => rstn,
         m_axi_araddr  => userReadMaster.araddr(31 downto 0),
         m_axi_arvalid => userReadMaster.arvalid,
         m_axi_arprot  => userReadMaster.arprot(2 downto 0),
         m_axi_arready => userReadSlave.arready,
         m_axi_rdata   => userReadSlave.rdata(31 downto 0),
         m_axi_rresp   => userReadSlave.rresp(1 downto 0),
         m_axi_rvalid  => userReadSlave.rvalid,
         m_axi_rready  => userReadMaster.rready

      );
      
      
end Behavioral;