# Load RUCKUS environment and library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Load common ruckus.tcl files
loadRuckusTcl $::env(TOP_DIR)/shared

# Load module ruckus.tcl files
loadRuckusTcl $::env(TOP_DIR)/modules/LcdDriver
loadRuckusTcl $::env(TOP_DIR)/modules/Neorv32 

# Load custom IP libraries
set_property ip_repo_paths $::env(MODULES)/customIpLib [current_project]

# Load local source Code and constraints
loadSource      -dir "$::DIR_PATH/hdl"
loadConstraints -dir "$::DIR_PATH/hdl"
