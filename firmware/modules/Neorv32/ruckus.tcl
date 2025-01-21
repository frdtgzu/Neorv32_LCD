# Load RTL code
loadSource -dir "$::DIR_PATH/rtl"
loadSource -dir "$::DIR_PATH/rtl/core"
loadSource -dir "$::DIR_PATH/rtl/processor_templates"
loadSource -dir "$::DIR_PATH/rtl/system_integration"


# Load Testbench code
loadSource -sim_only -dir "$::DIR_PATH/tb"

# Load IP cores
 loadIpCore -dir "$::DIR_PATH/ip"
