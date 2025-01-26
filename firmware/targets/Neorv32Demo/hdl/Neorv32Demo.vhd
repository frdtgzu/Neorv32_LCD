library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiStreamPkg.all;
use surf.AxiLitePkg.all;

entity Neorv32Demo is
   generic (
      TPD_G        : time := 1 ns
      );
   port (
     rstn_i      : in std_logic;                         --reset
     dataLCD_io  : inout std_logic_vector(7 downto 0);   --podatki na LCD data vodilu , najvišja linija nosi        
                                                         --informacije o LCDbusy flag-u, mora biti tipa inout
     clk_in      : in std_logic;                         
     busy_o      : out std_logic;                        --kontrolni signal -> kdaj driver lahko zapiše nove podatke na LCD: 0->pripravljen, 1->ne
     RW_o        : out std_logic;                        --r/w za LCD -- 0 pisanje na LCD, 1 branje iz LCD
     RS_o        : out std_logic;                        --register select 0-> instruction 1-> data
     E_o         : out std_logic;                        --write enable za lcd (1->read,fallign_edge 0 -> write)
     start_i     : in std_logic;                         --pulz iz CPU, signalni bit za začetek pisanja
     led_o       : out std_logic_vector(11 downto 0);    
     gpio_o      : out std_logic;
     uart0_rxd_i : in std_logic;
     uart0_txd_o : out std_logic  
   );
end Neorv32Demo;

architecture top_level of Neorv32Demo is

   signal axilClk         : sl;
   signal axilRst         : sl;
   signal axilWriteMaster : AxiLiteWriteMasterType;
   signal axilWriteSlave  : AxiLiteWriteSlaveType;
   signal axilReadMaster  : AxiLiteReadMasterType;
   signal axilReadSlave   : AxiLiteReadSlaveType;

begin

   ------------------------------
   -- User's AXI-Lite Clock/Reset
   ------------------------------
   U_axilClk : entity surf.ClockManager7
      generic map(
         TPD_G             => TPD_G,
         TYPE_G            => "PLL",
         INPUT_BUFG_G      => false,
         FB_BUFG_G         => true,
         RST_IN_POLARITY_G => '0',
         NUM_CLOCKS_G      => 1,
         -- MMCM attributes
         CLKIN_PERIOD_G    => 100,   -- 100 MHz
         CLKFBOUT_MULT_G   => 10,    -- 1.0GHz = 10 x 100 MHz
         CLKOUT0_DIVIDE_G  => 10)    -- 100MHz = 1.0GHz/10
      port map(
         -- Clock Input
         clkIn     => clk_in,
         rstIn     => rstn_i,
         -- Clock Outputs
         clkOut(0) => axilClk,
         -- Reset Outputs
         rstOut(0) => axilRst);

   -----------------------
   -- Common Platform Core
   -----------------------

   U_Core : entity work.Neorv32Wrapper
      generic map (
         TPD_G => TPD_G
      )
      port map (
         -- Neorv32 interface ports
         gpio_o      => gpio_o,
         uart0_rxd_i => uart0_rxd_i,
         uart0_txd_o => uart0_txd_o,

         -- Application AXI-Lite Interfaces [0x80000000:0xFFFFFFFF]
         clk_i             => axilClk,
         rst_i             => axilRst,
         axilReadMaster_o  => axilReadMaster,
         axilReadSlave_i   => axilReadSlave,
         axilWriteMaster_o => axilWriteMaster,
         axilWriteSlave_i  => axilWriteSlave
      );

   --------------
   -- Application
   --------------

   U_App : entity work.Application
      generic map (
         TPD_G => TPD_G,
         AXIL_BASE_ADDR_G => X"8000_0000"
      )
      port map (
         -- AXI-Lite Interface (axilClk domain)
         axilClk         => axilClk,
         axilRst         => axilRst,
         axilWriteMaster => axilWriteMaster,
         axilWriteSlave  => axilWriteSlave,
         axilReadMaster  => axilReadMaster,
         axilReadSlave   => axilReadSlave
      );

end top_level;
