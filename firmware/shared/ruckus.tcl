# Load RUCKUS environment and library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Load submodule code
loadRuckusTcl $::env(TOP_DIR)/submodules/surf


# Load RTL code
loadSource -dir "$::DIR_PATH/rtl"

# Load IP cores
# loadIpCore -dir "$::DIR_PATH/ip"

