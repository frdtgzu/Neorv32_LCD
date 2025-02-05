# Load RTL code
loadSource -dir "$::DIR_PATH/rtl"

# Load Testbench code
# loadSource -sim_only -dir "$::DIR_PATH/tb"

# Load IP cores
loadIpCore -dir "$::DIR_PATH/ip"

# Load Bd
loadBlockDesign -dir "$::DIR_PATH/bd"
