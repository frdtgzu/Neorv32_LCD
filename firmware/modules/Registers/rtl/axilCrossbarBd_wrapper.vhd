--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
--Date        : Wed Jan 29 20:59:26 2025
--Host        : DESKTOP-8ICF5QB running 64-bit Ubuntu 22.04.5 LTS
--Command     : generate_target axilCrossbarBd_wrapper.bd
--Design      : axilCrossbarBd_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity axilCrossbarBd_wrapper is
  port (
    M00_AXI_0_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_0_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_0_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_0_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_0_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_0_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_0_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_0_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S01_AXI_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S01_AXI_0_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S01_AXI_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S01_AXI_0_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S01_AXI_0_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S01_AXI_0_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S01_AXI_0_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S01_AXI_0_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S01_AXI_0_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    aclk_0 : in STD_LOGIC;
    aresetn_0 : in STD_LOGIC
  );
end axilCrossbarBd_wrapper;

architecture STRUCTURE of axilCrossbarBd_wrapper is
  component axilCrossbarBd is
  port (
    S00_AXI_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_0_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_0_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S00_AXI_0_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_0_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S00_AXI_0_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S00_AXI_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S00_AXI_0_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S00_AXI_0_rready : in STD_LOGIC_VECTOR ( 0 to 0 );
    aclk_0 : in STD_LOGIC;
    aresetn_0 : in STD_LOGIC;
    M00_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S01_AXI_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S01_AXI_0_awvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_awready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S01_AXI_0_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S01_AXI_0_wvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_wready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S01_AXI_0_bvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_bready : in STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S01_AXI_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S01_AXI_0_arvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_arready : out STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S01_AXI_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S01_AXI_0_rvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    S01_AXI_0_rready : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component axilCrossbarBd;
begin
axilCrossbarBd_i: component axilCrossbarBd
     port map (
      M00_AXI_0_araddr(31 downto 0) => M00_AXI_0_araddr(31 downto 0),
      M00_AXI_0_arprot(2 downto 0) => M00_AXI_0_arprot(2 downto 0),
      M00_AXI_0_arready(0) => M00_AXI_0_arready(0),
      M00_AXI_0_arvalid(0) => M00_AXI_0_arvalid(0),
      M00_AXI_0_awaddr(31 downto 0) => M00_AXI_0_awaddr(31 downto 0),
      M00_AXI_0_awprot(2 downto 0) => M00_AXI_0_awprot(2 downto 0),
      M00_AXI_0_awready(0) => M00_AXI_0_awready(0),
      M00_AXI_0_awvalid(0) => M00_AXI_0_awvalid(0),
      M00_AXI_0_bready(0) => M00_AXI_0_bready(0),
      M00_AXI_0_bresp(1 downto 0) => M00_AXI_0_bresp(1 downto 0),
      M00_AXI_0_bvalid(0) => M00_AXI_0_bvalid(0),
      M00_AXI_0_rdata(31 downto 0) => M00_AXI_0_rdata(31 downto 0),
      M00_AXI_0_rready(0) => M00_AXI_0_rready(0),
      M00_AXI_0_rresp(1 downto 0) => M00_AXI_0_rresp(1 downto 0),
      M00_AXI_0_rvalid(0) => M00_AXI_0_rvalid(0),
      M00_AXI_0_wdata(31 downto 0) => M00_AXI_0_wdata(31 downto 0),
      M00_AXI_0_wready(0) => M00_AXI_0_wready(0),
      M00_AXI_0_wstrb(3 downto 0) => M00_AXI_0_wstrb(3 downto 0),
      M00_AXI_0_wvalid(0) => M00_AXI_0_wvalid(0),
      S00_AXI_0_araddr(31 downto 0) => S00_AXI_0_araddr(31 downto 0),
      S00_AXI_0_arprot(2 downto 0) => S00_AXI_0_arprot(2 downto 0),
      S00_AXI_0_arready(0) => S00_AXI_0_arready(0),
      S00_AXI_0_arvalid(0) => S00_AXI_0_arvalid(0),
      S00_AXI_0_awaddr(31 downto 0) => S00_AXI_0_awaddr(31 downto 0),
      S00_AXI_0_awprot(2 downto 0) => S00_AXI_0_awprot(2 downto 0),
      S00_AXI_0_awready(0) => S00_AXI_0_awready(0),
      S00_AXI_0_awvalid(0) => S00_AXI_0_awvalid(0),
      S00_AXI_0_bready(0) => S00_AXI_0_bready(0),
      S00_AXI_0_bresp(1 downto 0) => S00_AXI_0_bresp(1 downto 0),
      S00_AXI_0_bvalid(0) => S00_AXI_0_bvalid(0),
      S00_AXI_0_rdata(31 downto 0) => S00_AXI_0_rdata(31 downto 0),
      S00_AXI_0_rready(0) => S00_AXI_0_rready(0),
      S00_AXI_0_rresp(1 downto 0) => S00_AXI_0_rresp(1 downto 0),
      S00_AXI_0_rvalid(0) => S00_AXI_0_rvalid(0),
      S00_AXI_0_wdata(31 downto 0) => S00_AXI_0_wdata(31 downto 0),
      S00_AXI_0_wready(0) => S00_AXI_0_wready(0),
      S00_AXI_0_wstrb(3 downto 0) => S00_AXI_0_wstrb(3 downto 0),
      S00_AXI_0_wvalid(0) => S00_AXI_0_wvalid(0),
      S01_AXI_0_araddr(31 downto 0) => S01_AXI_0_araddr(31 downto 0),
      S01_AXI_0_arprot(2 downto 0) => S01_AXI_0_arprot(2 downto 0),
      S01_AXI_0_arready(0) => S01_AXI_0_arready(0),
      S01_AXI_0_arvalid(0) => S01_AXI_0_arvalid(0),
      S01_AXI_0_awaddr(31 downto 0) => S01_AXI_0_awaddr(31 downto 0),
      S01_AXI_0_awprot(2 downto 0) => S01_AXI_0_awprot(2 downto 0),
      S01_AXI_0_awready(0) => S01_AXI_0_awready(0),
      S01_AXI_0_awvalid(0) => S01_AXI_0_awvalid(0),
      S01_AXI_0_bready(0) => S01_AXI_0_bready(0),
      S01_AXI_0_bresp(1 downto 0) => S01_AXI_0_bresp(1 downto 0),
      S01_AXI_0_bvalid(0) => S01_AXI_0_bvalid(0),
      S01_AXI_0_rdata(31 downto 0) => S01_AXI_0_rdata(31 downto 0),
      S01_AXI_0_rready(0) => S01_AXI_0_rready(0),
      S01_AXI_0_rresp(1 downto 0) => S01_AXI_0_rresp(1 downto 0),
      S01_AXI_0_rvalid(0) => S01_AXI_0_rvalid(0),
      S01_AXI_0_wdata(31 downto 0) => S01_AXI_0_wdata(31 downto 0),
      S01_AXI_0_wready(0) => S01_AXI_0_wready(0),
      S01_AXI_0_wstrb(3 downto 0) => S01_AXI_0_wstrb(3 downto 0),
      S01_AXI_0_wvalid(0) => S01_AXI_0_wvalid(0),
      aclk_0 => aclk_0,
      aresetn_0 => aresetn_0
    );
end STRUCTURE;
