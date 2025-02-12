library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiLitePkg.all;

entity Neorv32Demo is
   generic (
      TPD_G        : time := 1 ns
      );
   port (

      --! Clk and reset
      rstn_i      : in std_logic;                         
      clk_i       : in std_logic;

      --! Lcd IO   
      dataLCD_io  : inout std_logic_vector(7 downto 0);  
      RW_o        : out std_logic;                      
      RS_o        : out std_logic;                        
      E_o         : out std_logic;                       
      btnStart_i  : in std_logic; 
      useBtnStart_i : in std_logic; 

                                   
      led_o       : out std_logic_vector(11 downto 0);         
      ledbtn      : out std_logic;
      ledsw       : out std_logic;
      gpio_o      : out std_logic;
      
      --! Uart
      uart0_rxd_i : in std_logic;
      uart0_txd_o : out std_logic  
   );
end Neorv32Demo;

architecture top_level of Neorv32Demo is


   signal lcdClk          : sl;
   signal lcdRst          : sl;
   signal axilClk         : sl;
   signal axilRst         : sl;
   signal axilWriteMaster : AxiLiteWriteMasterType;
   signal axilWriteSlave  : AxiLiteWriteSlaveType;
   signal axilReadMaster  : AxiLiteReadMasterType;
   signal axilReadSlave   : AxiLiteReadSlaveType;
   signal btnStartSync    : sl := '0';
   signal useBtnStartSync : sl := '0';
   signal gpo : slv(7 downto 0) := (others => '0');
   signal gpi : slv(7 downto 0) := (others => '0');
   signal busy : sl;

begin
   
   ledbtn <= btnStartSync;
   ledsw  <= useBtnStartSync;
   gpio_o <= gpo(0);
   gpi(2) <= btnStartSync;
   gpi(1) <= useBtnStartSync;
   gpi(0) <= busy;
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
         CLKIN_PERIOD_G    => 10.0,  -- 100 MHz
         CLKFBOUT_MULT_G   => 10,    -- 1.0GHz = 10 x 100 MHz
         CLKOUT0_DIVIDE_G  => 10     -- 100MHz = 1.0GHz/10
         )   
      port map(
         -- Clock Input
         clkIn     => clk_i,
         rstIn     => rstn_i,
         -- Clock Outputs
         clkOut(0) => axilClk,
         -- Reset Outputs
         rstOut(0) => axilRst
         );
         
   U_Clkdevider: entity work.CLKdevider
      generic map(
         TPD_G => TPD_G
      )
      port map(
         clk_i => axilClk,
         clk_o => lcdClk
      );
   
   U_DebounceSyncBtn: entity surf.Debouncer
      generic map(
         INPUT_POLARITY_G  => '1',
         OUTPUT_POLARITY_G => '1',
         CLK_FREQ_G        => 100.00E+6,
         SYNCHRONIZE_G     => true 
      )
      port map(
         clk => axilClk,
         rst => axilRst,
         i   => btnStart_i,
         o   => btnStartSync
      ); 

   U_DebounceSyncSw: entity surf.Debouncer
      generic map(
         INPUT_POLARITY_G  => '1',
         OUTPUT_POLARITY_G => '1',
         CLK_FREQ_G        => 100.00E+6,
         SYNCHRONIZE_G     => true 
      )
      port map(
         clk => axilClk,
         rst => axilRst,
         i   => useBtnStart_i,
         o   => useBtnStartSync
      );    

   -----------------------
   -- Common Platform Core
   -----------------------

   U_Core : entity work.Neorv32Wrapper
      generic map (
         TPD_G => TPD_G
      )
      port map (
         -- Neorv32 interface ports
         gpio_o      => gpo,
         gpio_i      => gpi,
         uart0_rxd_i => uart0_rxd_i,
         uart0_txd_o => uart0_txd_o,

         -- Application AXI-Lite Interfaces [0x90000000:0x9FFF_FFFF]
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
         AXIL_BASE_ADDR_G => X"9000_0000"
      )
      port map (
         -- AXI-Lite Interface (axilClk domain)
         axilClk         => axilClk,
         axilRst         => axilRst,
         axilWriteMaster => axilWriteMaster,
         axilWriteSlave  => axilWriteSlave,
         axilReadMaster  => axilReadMaster,
         axilReadSlave   => axilReadSlave,

         --! Lcd signals
         dataLCD_io  => dataLCD_io,
         lcdClk      => lcdClk,
         --useBtnStart => useBtnStart,
         busy_o      => busy,
         RW_o        => RW_o,
         RS_o        => RS_o,
         E_o         => E_o,
         --btnStart_i  => btnStart_i,
         led_o       => led_o

      );

end top_level;
