
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/neorv32_vivado_ip_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set General [ipgui::add_page $IPINST -name "General"]
  ipgui::add_static_text $IPINST -name "About" -parent ${General} -text {NEORV32 is a small, customizable and extensible MCU-class 32-bit RISC-V soft-core CPU and microcontroller-like SoC.}
  ipgui::add_static_text $IPINST -name "Documentation" -parent ${General} -text {Find more information online at github.com/stnolting/neorv32}
  #Adding Group
  set Clock_input [ipgui::add_group $IPINST -name "Clock input" -parent ${General}]
  set CLOCK_FREQUENCY [ipgui::add_param $IPINST -name "CLOCK_FREQUENCY" -parent ${Clock_input}]
  set_property tooltip {Frequency of the clk input signal in Hz} ${CLOCK_FREQUENCY}

  #Adding Group
  set Core_Complex [ipgui::add_group $IPINST -name "Core Complex" -parent ${General}]
  ipgui::add_param $IPINST -name "DUAL_CORE_EN" -parent ${Core_Complex} -widget comboBox

  #Adding Group
  set Boot_Configuration [ipgui::add_group $IPINST -name "Boot Configuration" -parent ${General}]
  set BOOT_MODE_SELECT [ipgui::add_param $IPINST -name "BOOT_MODE_SELECT" -parent ${Boot_Configuration} -widget comboBox]
  set_property tooltip {Processor boot configuration} ${BOOT_MODE_SELECT}
  set BOOT_ADDR_CUSTOM [ipgui::add_param $IPINST -name "BOOT_ADDR_CUSTOM" -parent ${Boot_Configuration}]
  set_property tooltip {Available if BOOT_MODE_SELECT = 1; has to be 4-byte aligned} ${BOOT_ADDR_CUSTOM}

  #Adding Group
  set Core_Identification [ipgui::add_group $IPINST -name "Core Identification" -parent ${General}]
  set JEDEC_ID [ipgui::add_param $IPINST -name "JEDEC_ID" -parent ${Core_Identification}]
  set_property tooltip {For JTAG tap identification and mvendorid CSR} ${JEDEC_ID}

  #Adding Group
  set On-Chip_Debugger_(OCD) [ipgui::add_group $IPINST -name "On-Chip Debugger (OCD)" -parent ${General}]
  set OCD_EN [ipgui::add_param $IPINST -name "OCD_EN" -parent ${On-Chip_Debugger_(OCD)}]
  set_property tooltip {Implement the on-chip debugger, the CPU debug mode and the JTAG port} ${OCD_EN}
  set OCD_AUTHENTICATION [ipgui::add_param $IPINST -name "OCD_AUTHENTICATION" -parent ${On-Chip_Debugger_(OCD)}]
  set_property tooltip {Implement Debug Authentication module} ${OCD_AUTHENTICATION}

  #Adding Group
  set External_Bus_Interface_(XBUS_/_AXI4-Lite-MM_Host) [ipgui::add_group $IPINST -name "External Bus Interface (XBUS / AXI4-Lite-MM Host)" -parent ${General}]
  ipgui::add_param $IPINST -name "XBUS_EN" -parent ${External_Bus_Interface_(XBUS_/_AXI4-Lite-MM_Host)}
  set XBUS_TIMEOUT [ipgui::add_param $IPINST -name "XBUS_TIMEOUT" -parent ${External_Bus_Interface_(XBUS_/_AXI4-Lite-MM_Host)}]
  set_property tooltip {Max number of clock cycles before AXI access times out} ${XBUS_TIMEOUT}
  set XBUS_REGSTAGE_EN [ipgui::add_param $IPINST -name "XBUS_REGSTAGE_EN" -parent ${External_Bus_Interface_(XBUS_/_AXI4-Lite-MM_Host)}]
  set_property tooltip {Relaxes timing, but will increase latency} ${XBUS_REGSTAGE_EN}
  #Adding Group
  set XBUS_Cache [ipgui::add_group $IPINST -name "XBUS Cache" -parent ${External_Bus_Interface_(XBUS_/_AXI4-Lite-MM_Host)}]
  ipgui::add_param $IPINST -name "XBUS_CACHE_EN" -parent ${XBUS_Cache}
  ipgui::add_param $IPINST -name "XBUS_CACHE_NUM_BLOCKS" -parent ${XBUS_Cache}
  set XBUS_CACHE_BLOCK_SIZE [ipgui::add_param $IPINST -name "XBUS_CACHE_BLOCK_SIZE" -parent ${XBUS_Cache}]
  set_property tooltip {In bytes (use a power of two)} ${XBUS_CACHE_BLOCK_SIZE}


  #Adding Group
  set Stream_Link_Interface_(SLINK_/_AXI4-Stream_Source_&_Sink) [ipgui::add_group $IPINST -name "Stream Link Interface (SLINK / AXI4-Stream Source & Sink)" -parent ${General}]
  ipgui::add_param $IPINST -name "IO_SLINK_EN" -parent ${Stream_Link_Interface_(SLINK_/_AXI4-Stream_Source_&_Sink)}
  set IO_SLINK_RX_FIFO [ipgui::add_param $IPINST -name "IO_SLINK_RX_FIFO" -parent ${Stream_Link_Interface_(SLINK_/_AXI4-Stream_Source_&_Sink)}]
  set_property tooltip {Number of entries (use a power of two)} ${IO_SLINK_RX_FIFO}
  set IO_SLINK_TX_FIFO [ipgui::add_param $IPINST -name "IO_SLINK_TX_FIFO" -parent ${Stream_Link_Interface_(SLINK_/_AXI4-Stream_Source_&_Sink)}]
  set_property tooltip {Number of entries (use a power of two)} ${IO_SLINK_TX_FIFO}


  #Adding Page
  set CPU_Configuration [ipgui::add_page $IPINST -name "CPU Configuration"]
  ipgui::add_static_text $IPINST -name "ISA note" -parent ${CPU_Configuration} -text {Make sure to set the same ISA configuration for the RISC-V GCC ISA string.}
  #Adding Group
  set RISC-V_ISA_Extensions [ipgui::add_group $IPINST -name "RISC-V ISA Extensions" -parent ${CPU_Configuration}]
  set RISCV_ISA_C [ipgui::add_param $IPINST -name "RISCV_ISA_C" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {16-bit compressed instructions} ${RISCV_ISA_C}
  set RISCV_ISA_E [ipgui::add_param $IPINST -name "RISCV_ISA_E" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Reduced register file size (16 registers only)} ${RISCV_ISA_E}
  set RISCV_ISA_M [ipgui::add_param $IPINST -name "RISCV_ISA_M" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Integer multiplication and division hardware} ${RISCV_ISA_M}
  set RISCV_ISA_U [ipgui::add_param $IPINST -name "RISCV_ISA_U" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Less-privileged user-mode} ${RISCV_ISA_U}
  set RISCV_ISA_Zaamo [ipgui::add_param $IPINST -name "RISCV_ISA_Zaamo" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Atomic memory operations (read-modify-write)} ${RISCV_ISA_Zaamo}
  set RISCV_ISA_Zba [ipgui::add_param $IPINST -name "RISCV_ISA_Zba" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Shifted-add bit-manipulation instructions} ${RISCV_ISA_Zba}
  set RISCV_ISA_Zbb [ipgui::add_param $IPINST -name "RISCV_ISA_Zbb" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Basic bit-manipulation instructions} ${RISCV_ISA_Zbb}
  set RISCV_ISA_Zbkb [ipgui::add_param $IPINST -name "RISCV_ISA_Zbkb" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Bit manipulation instructions for cryptography} ${RISCV_ISA_Zbkb}
  set RISCV_ISA_Zbkc [ipgui::add_param $IPINST -name "RISCV_ISA_Zbkc" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Carry-less multiply instructions for cryptography} ${RISCV_ISA_Zbkc}
  set RISCV_ISA_Zbkx [ipgui::add_param $IPINST -name "RISCV_ISA_Zbkx" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Scalar cryptographic - crossbar permutations} ${RISCV_ISA_Zbkx}
  set RISCV_ISA_Zbs [ipgui::add_param $IPINST -name "RISCV_ISA_Zbs" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Single-bit bit-manipulation instructions} ${RISCV_ISA_Zbs}
  set RISCV_ISA_Zfinx [ipgui::add_param $IPINST -name "RISCV_ISA_Zfinx" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Embedded FPU (using integer registers)} ${RISCV_ISA_Zfinx}
  set RISCV_ISA_Zicntr [ipgui::add_param $IPINST -name "RISCV_ISA_Zicntr" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Base counters (cycles and instructions)} ${RISCV_ISA_Zicntr}
  set RISCV_ISA_Zicond [ipgui::add_param $IPINST -name "RISCV_ISA_Zicond" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Conditional-move instructions} ${RISCV_ISA_Zicond}
  set RISCV_ISA_Zihpm [ipgui::add_param $IPINST -name "RISCV_ISA_Zihpm" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Hardware performance monitors (HPMs)} ${RISCV_ISA_Zihpm}
  set HPM_CNT_WIDTH [ipgui::add_param $IPINST -name "HPM_CNT_WIDTH" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Counter width in bits} ${HPM_CNT_WIDTH}
  set HPM_NUM_CNTS [ipgui::add_param $IPINST -name "HPM_NUM_CNTS" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Numer of hardware performance monitor counters} ${HPM_NUM_CNTS}
  set RISCV_ISA_Zknd [ipgui::add_param $IPINST -name "RISCV_ISA_Zknd" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Scalar cryptographic - NIST AES decryption} ${RISCV_ISA_Zknd}
  set RISCV_ISA_Zkne [ipgui::add_param $IPINST -name "RISCV_ISA_Zkne" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Scalar cryptographic - NIST AES encryption} ${RISCV_ISA_Zkne}
  set RISCV_ISA_Zknh [ipgui::add_param $IPINST -name "RISCV_ISA_Zknh" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Scalar cryptographic - NIST hash functions} ${RISCV_ISA_Zknh}
  set RISCV_ISA_Zksed [ipgui::add_param $IPINST -name "RISCV_ISA_Zksed" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Scalar cryptographic - ShangMi block cyphers} ${RISCV_ISA_Zksed}
  set RISCV_ISA_Zksh [ipgui::add_param $IPINST -name "RISCV_ISA_Zksh" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Scalar cryptographic - ShangMi hash functions} ${RISCV_ISA_Zksh}
  set RISCV_ISA_Zmmul [ipgui::add_param $IPINST -name "RISCV_ISA_Zmmul" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {Integer multiplication-only hardware} ${RISCV_ISA_Zmmul}
  set RISCV_ISA_Zxcfu [ipgui::add_param $IPINST -name "RISCV_ISA_Zxcfu" -parent ${RISC-V_ISA_Extensions}]
  set_property tooltip {NEORV32-specifc custom-instructions unit (user-defined)} ${RISCV_ISA_Zxcfu}

  #Adding Group
  set Physical_Memory_Protection_(PMP) [ipgui::add_group $IPINST -name "Physical Memory Protection (PMP)" -parent ${CPU_Configuration}]
  set PMP_NUM_REGIONS [ipgui::add_param $IPINST -name "PMP_NUM_REGIONS" -parent ${Physical_Memory_Protection_(PMP)}]
  set_property tooltip {Number of physical memory protection regions} ${PMP_NUM_REGIONS}
  set PMP_MIN_GRANULARITY [ipgui::add_param $IPINST -name "PMP_MIN_GRANULARITY" -parent ${Physical_Memory_Protection_(PMP)}]
  set_property tooltip {Minimal region granularity in bytes. Has to be a power of two.} ${PMP_MIN_GRANULARITY}
  set PMP_TOR_MODE_EN [ipgui::add_param $IPINST -name "PMP_TOR_MODE_EN" -parent ${Physical_Memory_Protection_(PMP)}]
  set_property tooltip {Implement support for top-of-region (TOR) mode} ${PMP_TOR_MODE_EN}
  set PMP_NAP_MODE_EN [ipgui::add_param $IPINST -name "PMP_NAP_MODE_EN" -parent ${Physical_Memory_Protection_(PMP)}]
  set_property tooltip {Implement support for naturally-aligned power-of-two (NAPOT & NA4) modes} ${PMP_NAP_MODE_EN}

  #Adding Group
  set Tuning_Options [ipgui::add_group $IPINST -name "Tuning Options" -parent ${CPU_Configuration}]
  ipgui::add_param $IPINST -name "CPU_FAST_MUL_EN" -parent ${Tuning_Options}
  ipgui::add_param $IPINST -name "CPU_FAST_SHIFT_EN" -parent ${Tuning_Options}
  set CPU_RF_HW_RST_EN [ipgui::add_param $IPINST -name "CPU_RF_HW_RST_EN" -parent ${Tuning_Options}]
  set_property tooltip {Implement register file with FFs instead of BRAM to allow full hardware reset} ${CPU_RF_HW_RST_EN}


  #Adding Page
  set Memory_System [ipgui::add_page $IPINST -name "Memory System"]
  ipgui::add_static_text $IPINST -name "MEM note" -parent ${Memory_System} -text {The memory sizes need to be exported to the linker via dedicated symbols.}
  ipgui::add_static_text $IPINST -name "IMEM note" -parent ${Memory_System} -text {IMEM size (32kB): -Wl,--defsym,__neorv32_rom_size=32k}
  ipgui::add_static_text $IPINST -name "DMEM note" -parent ${Memory_System} -text {DMEM size (16kB): -Wl,--defsym,__neorv32_ram_size=16k}
  #Adding Group
  set Internal_Instruction_Memory_(IMEM) [ipgui::add_group $IPINST -name "Internal Instruction Memory (IMEM)" -parent ${Memory_System}]
  ipgui::add_param $IPINST -name "MEM_INT_IMEM_EN" -parent ${Internal_Instruction_Memory_(IMEM)}
  set MEM_INT_IMEM_SIZE [ipgui::add_param $IPINST -name "MEM_INT_IMEM_SIZE" -parent ${Internal_Instruction_Memory_(IMEM)}]
  set_property tooltip {In bytes (use a power of two)} ${MEM_INT_IMEM_SIZE}

  #Adding Group
  set Internal_Data_Memory_(DMEM) [ipgui::add_group $IPINST -name "Internal Data Memory (DMEM)" -parent ${Memory_System}]
  ipgui::add_param $IPINST -name "MEM_INT_DMEM_EN" -parent ${Internal_Data_Memory_(DMEM)}
  set MEM_INT_DMEM_SIZE [ipgui::add_param $IPINST -name "MEM_INT_DMEM_SIZE" -parent ${Internal_Data_Memory_(DMEM)}]
  set_property tooltip {In bytes (use a power of two)} ${MEM_INT_DMEM_SIZE}

  #Adding Group
  set CPU_Instruction_Cache_(ICACHE) [ipgui::add_group $IPINST -name "CPU Instruction Cache (ICACHE)" -parent ${Memory_System}]
  ipgui::add_param $IPINST -name "ICACHE_EN" -parent ${CPU_Instruction_Cache_(ICACHE)}
  ipgui::add_param $IPINST -name "ICACHE_NUM_BLOCKS" -parent ${CPU_Instruction_Cache_(ICACHE)}
  set ICACHE_BLOCK_SIZE [ipgui::add_param $IPINST -name "ICACHE_BLOCK_SIZE" -parent ${CPU_Instruction_Cache_(ICACHE)}]
  set_property tooltip {In bytes (use a power of two)} ${ICACHE_BLOCK_SIZE}

  #Adding Group
  set CPU_Data_Cache_(DCACHE) [ipgui::add_group $IPINST -name "CPU Data Cache (DCACHE)" -parent ${Memory_System}]
  ipgui::add_param $IPINST -name "DCACHE_EN" -parent ${CPU_Data_Cache_(DCACHE)}
  ipgui::add_param $IPINST -name "DCACHE_NUM_BLOCKS" -parent ${CPU_Data_Cache_(DCACHE)}
  set DCACHE_BLOCK_SIZE [ipgui::add_param $IPINST -name "DCACHE_BLOCK_SIZE" -parent ${CPU_Data_Cache_(DCACHE)}]
  set_property tooltip {In bytes (use a power of two)} ${DCACHE_BLOCK_SIZE}

  #Adding Group
  set Execute_In-Place_Module_(XIP) [ipgui::add_group $IPINST -name "Execute In-Place Module (XIP)" -parent ${Memory_System}]
  ipgui::add_param $IPINST -name "XIP_EN" -parent ${Execute_In-Place_Module_(XIP)}
  ipgui::add_param $IPINST -name "XIP_CACHE_EN" -parent ${Execute_In-Place_Module_(XIP)}
  ipgui::add_param $IPINST -name "XIP_CACHE_NUM_BLOCKS" -parent ${Execute_In-Place_Module_(XIP)}
  set XIP_CACHE_BLOCK_SIZE [ipgui::add_param $IPINST -name "XIP_CACHE_BLOCK_SIZE" -parent ${Execute_In-Place_Module_(XIP)}]
  set_property tooltip {In bytes (use a power of two)} ${XIP_CACHE_BLOCK_SIZE}


  #Adding Page
  set Peripherals [ipgui::add_page $IPINST -name "Peripherals"]
  #Adding Group
  set General-Purpose_Input/Output_Controller_(GPIO) [ipgui::add_group $IPINST -name "General-Purpose Input/Output Controller (GPIO)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_GPIO_EN" -parent ${General-Purpose_Input/Output_Controller_(GPIO)}
  set IO_GPIO_IN_NUM [ipgui::add_param $IPINST -name "IO_GPIO_IN_NUM" -parent ${General-Purpose_Input/Output_Controller_(GPIO)}]
  set_property tooltip {Interrupt-capable} ${IO_GPIO_IN_NUM}
  ipgui::add_param $IPINST -name "IO_GPIO_OUT_NUM" -parent ${General-Purpose_Input/Output_Controller_(GPIO)}

  #Adding Group
  set Core_Local_Interruptor_(CLINT) [ipgui::add_group $IPINST -name "Core Local Interruptor (CLINT)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_CLINT_EN" -parent ${Core_Local_Interruptor_(CLINT)}

  #Adding Group
  set Primary_UART_(UART0) [ipgui::add_group $IPINST -name "Primary UART (UART0)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_UART0_EN" -parent ${Primary_UART_(UART0)}
  set IO_UART0_RX_FIFO [ipgui::add_param $IPINST -name "IO_UART0_RX_FIFO" -parent ${Primary_UART_(UART0)}]
  set_property tooltip {Number of entries (use a power of two)} ${IO_UART0_RX_FIFO}
  set IO_UART0_TX_FIFO [ipgui::add_param $IPINST -name "IO_UART0_TX_FIFO" -parent ${Primary_UART_(UART0)}]
  set_property tooltip {Number of entries (use a power of two)} ${IO_UART0_TX_FIFO}

  #Adding Group
  set Secondary_UART_(UART1) [ipgui::add_group $IPINST -name "Secondary UART (UART1)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_UART1_EN" -parent ${Secondary_UART_(UART1)}
  set IO_UART1_RX_FIFO [ipgui::add_param $IPINST -name "IO_UART1_RX_FIFO" -parent ${Secondary_UART_(UART1)}]
  set_property tooltip {Number of entries (use a power of two)} ${IO_UART1_RX_FIFO}
  set IO_UART1_TX_FIFO [ipgui::add_param $IPINST -name "IO_UART1_TX_FIFO" -parent ${Secondary_UART_(UART1)}]
  set_property tooltip {Number of entries (use a power of two)} ${IO_UART1_TX_FIFO}

  #Adding Group
  set SPI_Host_Controller_(SPI) [ipgui::add_group $IPINST -name "SPI Host Controller (SPI)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_SPI_EN" -parent ${SPI_Host_Controller_(SPI)}
  set IO_SPI_FIFO [ipgui::add_param $IPINST -name "IO_SPI_FIFO" -parent ${SPI_Host_Controller_(SPI)}]
  set_property tooltip {Number of entries (use a power of two)} ${IO_SPI_FIFO}

  #Adding Group
  set SPI_Device_Controller_(SDI) [ipgui::add_group $IPINST -name "SPI Device Controller (SDI)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_SDI_EN" -parent ${SPI_Device_Controller_(SDI)}
  set IO_SDI_FIFO [ipgui::add_param $IPINST -name "IO_SDI_FIFO" -parent ${SPI_Device_Controller_(SDI)}]
  set_property tooltip {Number of entries (use a power of two)} ${IO_SDI_FIFO}

  #Adding Group
  set Two-Wire/I2C_Host_(TWI) [ipgui::add_group $IPINST -name "Two-Wire/I2C Host (TWI)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_TWI_EN" -parent ${Two-Wire/I2C_Host_(TWI)}
  set IO_TWI_FIFO [ipgui::add_param $IPINST -name "IO_TWI_FIFO" -parent ${Two-Wire/I2C_Host_(TWI)}]
  set_property tooltip {Number of entries (use a power of two)} ${IO_TWI_FIFO}

  #Adding Group
  set Two-Wire/I2C_Device_(TWD) [ipgui::add_group $IPINST -name "Two-Wire/I2C Device (TWD)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_TWD_EN" -parent ${Two-Wire/I2C_Device_(TWD)}
  set IO_TWD_FIFO [ipgui::add_param $IPINST -name "IO_TWD_FIFO" -parent ${Two-Wire/I2C_Device_(TWD)}]
  set_property tooltip {Number of entries (use a power of two)} ${IO_TWD_FIFO}

  #Adding Group
  set Pulse-Width_Modulation_Controller_(PWM) [ipgui::add_group $IPINST -name "Pulse-Width Modulation Controller (PWM)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_PWM_EN" -parent ${Pulse-Width_Modulation_Controller_(PWM)}
  ipgui::add_param $IPINST -name "IO_PWM_NUM_CH" -parent ${Pulse-Width_Modulation_Controller_(PWM)}

  #Adding Group
  set Watchdog_Timer_(WDT) [ipgui::add_group $IPINST -name "Watchdog Timer (WDT)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_WDT_EN" -parent ${Watchdog_Timer_(WDT)}

  #Adding Group
  set True_Random-Number_Generator_(TRNG) [ipgui::add_group $IPINST -name "True Random-Number Generator (TRNG)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_TRNG_EN" -parent ${True_Random-Number_Generator_(TRNG)}
  set IO_TRNG_FIFO [ipgui::add_param $IPINST -name "IO_TRNG_FIFO" -parent ${True_Random-Number_Generator_(TRNG)}]
  set_property tooltip {Number of entries (use a power of two)} ${IO_TRNG_FIFO}

  #Adding Group
  set Custom_Functions_Subsystem_(CFS) [ipgui::add_group $IPINST -name "Custom Functions Subsystem (CFS)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_CFS_EN" -parent ${Custom_Functions_Subsystem_(CFS)}
  ipgui::add_param $IPINST -name "IO_CFS_CONFIG" -parent ${Custom_Functions_Subsystem_(CFS)}
  ipgui::add_param $IPINST -name "IO_CFS_IN_SIZE" -parent ${Custom_Functions_Subsystem_(CFS)}
  ipgui::add_param $IPINST -name "IO_CFS_OUT_SIZE" -parent ${Custom_Functions_Subsystem_(CFS)}

  #Adding Group
  set Smart_LED_Interface_(NEOLED) [ipgui::add_group $IPINST -name "Smart LED Interface (NEOLED)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_NEOLED_EN" -parent ${Smart_LED_Interface_(NEOLED)}
  set IO_NEOLED_TX_FIFO [ipgui::add_param $IPINST -name "IO_NEOLED_TX_FIFO" -parent ${Smart_LED_Interface_(NEOLED)}]
  set_property tooltip {Number of entries (use a power of two)} ${IO_NEOLED_TX_FIFO}

  #Adding Group
  set General_Purpose_Timer_(GPTMR) [ipgui::add_group $IPINST -name "General Purpose Timer (GPTMR)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_GPTMR_EN" -parent ${General_Purpose_Timer_(GPTMR)}

  #Adding Group
  set One-Wire_Interface_Controller_(ONEWIRE) [ipgui::add_group $IPINST -name "One-Wire Interface Controller (ONEWIRE)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_ONEWIRE_EN" -parent ${One-Wire_Interface_Controller_(ONEWIRE)}

  #Adding Group
  set Direct_Memory_Access_Controller_(DMA) [ipgui::add_group $IPINST -name "Direct Memory Access Controller (DMA)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_DMA_EN" -parent ${Direct_Memory_Access_Controller_(DMA)}

  #Adding Group
  set Cyclic_Redundancy_Check_(CRC) [ipgui::add_group $IPINST -name "Cyclic Redundancy Check (CRC)" -parent ${Peripherals}]
  ipgui::add_param $IPINST -name "IO_CRC_EN" -parent ${Cyclic_Redundancy_Check_(CRC)}



}

proc update_PARAM_VALUE.BOOT_ADDR_CUSTOM { PARAM_VALUE.BOOT_ADDR_CUSTOM PARAM_VALUE.BOOT_MODE_SELECT } {
	# Procedure called to update BOOT_ADDR_CUSTOM when any of the dependent parameters in the arguments change
	
	set BOOT_ADDR_CUSTOM ${PARAM_VALUE.BOOT_ADDR_CUSTOM}
	set BOOT_MODE_SELECT ${PARAM_VALUE.BOOT_MODE_SELECT}
	set values(BOOT_MODE_SELECT) [get_property value $BOOT_MODE_SELECT]
	if { [gen_USERPARAMETER_BOOT_ADDR_CUSTOM_ENABLEMENT $values(BOOT_MODE_SELECT)] } {
		set_property enabled true $BOOT_ADDR_CUSTOM
	} else {
		set_property enabled false $BOOT_ADDR_CUSTOM
	}
}

proc validate_PARAM_VALUE.BOOT_ADDR_CUSTOM { PARAM_VALUE.BOOT_ADDR_CUSTOM } {
	# Procedure called to validate BOOT_ADDR_CUSTOM
	return true
}

proc update_PARAM_VALUE.DCACHE_BLOCK_SIZE { PARAM_VALUE.DCACHE_BLOCK_SIZE PARAM_VALUE.DCACHE_EN } {
	# Procedure called to update DCACHE_BLOCK_SIZE when any of the dependent parameters in the arguments change
	
	set DCACHE_BLOCK_SIZE ${PARAM_VALUE.DCACHE_BLOCK_SIZE}
	set DCACHE_EN ${PARAM_VALUE.DCACHE_EN}
	set values(DCACHE_EN) [get_property value $DCACHE_EN]
	if { [gen_USERPARAMETER_DCACHE_BLOCK_SIZE_ENABLEMENT $values(DCACHE_EN)] } {
		set_property enabled true $DCACHE_BLOCK_SIZE
	} else {
		set_property enabled false $DCACHE_BLOCK_SIZE
	}
}

proc validate_PARAM_VALUE.DCACHE_BLOCK_SIZE { PARAM_VALUE.DCACHE_BLOCK_SIZE } {
	# Procedure called to validate DCACHE_BLOCK_SIZE
	return true
}

proc update_PARAM_VALUE.DCACHE_NUM_BLOCKS { PARAM_VALUE.DCACHE_NUM_BLOCKS PARAM_VALUE.DCACHE_EN } {
	# Procedure called to update DCACHE_NUM_BLOCKS when any of the dependent parameters in the arguments change
	
	set DCACHE_NUM_BLOCKS ${PARAM_VALUE.DCACHE_NUM_BLOCKS}
	set DCACHE_EN ${PARAM_VALUE.DCACHE_EN}
	set values(DCACHE_EN) [get_property value $DCACHE_EN]
	if { [gen_USERPARAMETER_DCACHE_NUM_BLOCKS_ENABLEMENT $values(DCACHE_EN)] } {
		set_property enabled true $DCACHE_NUM_BLOCKS
	} else {
		set_property enabled false $DCACHE_NUM_BLOCKS
	}
}

proc validate_PARAM_VALUE.DCACHE_NUM_BLOCKS { PARAM_VALUE.DCACHE_NUM_BLOCKS } {
	# Procedure called to validate DCACHE_NUM_BLOCKS
	return true
}

proc update_PARAM_VALUE.HPM_CNT_WIDTH { PARAM_VALUE.HPM_CNT_WIDTH PARAM_VALUE.RISCV_ISA_Zihpm } {
	# Procedure called to update HPM_CNT_WIDTH when any of the dependent parameters in the arguments change
	
	set HPM_CNT_WIDTH ${PARAM_VALUE.HPM_CNT_WIDTH}
	set RISCV_ISA_Zihpm ${PARAM_VALUE.RISCV_ISA_Zihpm}
	set values(RISCV_ISA_Zihpm) [get_property value $RISCV_ISA_Zihpm]
	if { [gen_USERPARAMETER_HPM_CNT_WIDTH_ENABLEMENT $values(RISCV_ISA_Zihpm)] } {
		set_property enabled true $HPM_CNT_WIDTH
	} else {
		set_property enabled false $HPM_CNT_WIDTH
	}
}

proc validate_PARAM_VALUE.HPM_CNT_WIDTH { PARAM_VALUE.HPM_CNT_WIDTH } {
	# Procedure called to validate HPM_CNT_WIDTH
	return true
}

proc update_PARAM_VALUE.HPM_NUM_CNTS { PARAM_VALUE.HPM_NUM_CNTS PARAM_VALUE.RISCV_ISA_Zihpm } {
	# Procedure called to update HPM_NUM_CNTS when any of the dependent parameters in the arguments change
	
	set HPM_NUM_CNTS ${PARAM_VALUE.HPM_NUM_CNTS}
	set RISCV_ISA_Zihpm ${PARAM_VALUE.RISCV_ISA_Zihpm}
	set values(RISCV_ISA_Zihpm) [get_property value $RISCV_ISA_Zihpm]
	if { [gen_USERPARAMETER_HPM_NUM_CNTS_ENABLEMENT $values(RISCV_ISA_Zihpm)] } {
		set_property enabled true $HPM_NUM_CNTS
	} else {
		set_property enabled false $HPM_NUM_CNTS
	}
}

proc validate_PARAM_VALUE.HPM_NUM_CNTS { PARAM_VALUE.HPM_NUM_CNTS } {
	# Procedure called to validate HPM_NUM_CNTS
	return true
}

proc update_PARAM_VALUE.ICACHE_BLOCK_SIZE { PARAM_VALUE.ICACHE_BLOCK_SIZE PARAM_VALUE.ICACHE_EN } {
	# Procedure called to update ICACHE_BLOCK_SIZE when any of the dependent parameters in the arguments change
	
	set ICACHE_BLOCK_SIZE ${PARAM_VALUE.ICACHE_BLOCK_SIZE}
	set ICACHE_EN ${PARAM_VALUE.ICACHE_EN}
	set values(ICACHE_EN) [get_property value $ICACHE_EN]
	if { [gen_USERPARAMETER_ICACHE_BLOCK_SIZE_ENABLEMENT $values(ICACHE_EN)] } {
		set_property enabled true $ICACHE_BLOCK_SIZE
	} else {
		set_property enabled false $ICACHE_BLOCK_SIZE
	}
}

proc validate_PARAM_VALUE.ICACHE_BLOCK_SIZE { PARAM_VALUE.ICACHE_BLOCK_SIZE } {
	# Procedure called to validate ICACHE_BLOCK_SIZE
	return true
}

proc update_PARAM_VALUE.ICACHE_NUM_BLOCKS { PARAM_VALUE.ICACHE_NUM_BLOCKS PARAM_VALUE.ICACHE_EN } {
	# Procedure called to update ICACHE_NUM_BLOCKS when any of the dependent parameters in the arguments change
	
	set ICACHE_NUM_BLOCKS ${PARAM_VALUE.ICACHE_NUM_BLOCKS}
	set ICACHE_EN ${PARAM_VALUE.ICACHE_EN}
	set values(ICACHE_EN) [get_property value $ICACHE_EN]
	if { [gen_USERPARAMETER_ICACHE_NUM_BLOCKS_ENABLEMENT $values(ICACHE_EN)] } {
		set_property enabled true $ICACHE_NUM_BLOCKS
	} else {
		set_property enabled false $ICACHE_NUM_BLOCKS
	}
}

proc validate_PARAM_VALUE.ICACHE_NUM_BLOCKS { PARAM_VALUE.ICACHE_NUM_BLOCKS } {
	# Procedure called to validate ICACHE_NUM_BLOCKS
	return true
}

proc update_PARAM_VALUE.IO_CFS_CONFIG { PARAM_VALUE.IO_CFS_CONFIG PARAM_VALUE.IO_CFS_EN } {
	# Procedure called to update IO_CFS_CONFIG when any of the dependent parameters in the arguments change
	
	set IO_CFS_CONFIG ${PARAM_VALUE.IO_CFS_CONFIG}
	set IO_CFS_EN ${PARAM_VALUE.IO_CFS_EN}
	set values(IO_CFS_EN) [get_property value $IO_CFS_EN]
	if { [gen_USERPARAMETER_IO_CFS_CONFIG_ENABLEMENT $values(IO_CFS_EN)] } {
		set_property enabled true $IO_CFS_CONFIG
	} else {
		set_property enabled false $IO_CFS_CONFIG
	}
}

proc validate_PARAM_VALUE.IO_CFS_CONFIG { PARAM_VALUE.IO_CFS_CONFIG } {
	# Procedure called to validate IO_CFS_CONFIG
	return true
}

proc update_PARAM_VALUE.IO_CFS_IN_SIZE { PARAM_VALUE.IO_CFS_IN_SIZE PARAM_VALUE.IO_CFS_EN } {
	# Procedure called to update IO_CFS_IN_SIZE when any of the dependent parameters in the arguments change
	
	set IO_CFS_IN_SIZE ${PARAM_VALUE.IO_CFS_IN_SIZE}
	set IO_CFS_EN ${PARAM_VALUE.IO_CFS_EN}
	set values(IO_CFS_EN) [get_property value $IO_CFS_EN]
	if { [gen_USERPARAMETER_IO_CFS_IN_SIZE_ENABLEMENT $values(IO_CFS_EN)] } {
		set_property enabled true $IO_CFS_IN_SIZE
	} else {
		set_property enabled false $IO_CFS_IN_SIZE
	}
}

proc validate_PARAM_VALUE.IO_CFS_IN_SIZE { PARAM_VALUE.IO_CFS_IN_SIZE } {
	# Procedure called to validate IO_CFS_IN_SIZE
	return true
}

proc update_PARAM_VALUE.IO_CFS_OUT_SIZE { PARAM_VALUE.IO_CFS_OUT_SIZE PARAM_VALUE.IO_CFS_EN } {
	# Procedure called to update IO_CFS_OUT_SIZE when any of the dependent parameters in the arguments change
	
	set IO_CFS_OUT_SIZE ${PARAM_VALUE.IO_CFS_OUT_SIZE}
	set IO_CFS_EN ${PARAM_VALUE.IO_CFS_EN}
	set values(IO_CFS_EN) [get_property value $IO_CFS_EN]
	if { [gen_USERPARAMETER_IO_CFS_OUT_SIZE_ENABLEMENT $values(IO_CFS_EN)] } {
		set_property enabled true $IO_CFS_OUT_SIZE
	} else {
		set_property enabled false $IO_CFS_OUT_SIZE
	}
}

proc validate_PARAM_VALUE.IO_CFS_OUT_SIZE { PARAM_VALUE.IO_CFS_OUT_SIZE } {
	# Procedure called to validate IO_CFS_OUT_SIZE
	return true
}

proc update_PARAM_VALUE.IO_GPIO_IN_NUM { PARAM_VALUE.IO_GPIO_IN_NUM PARAM_VALUE.IO_GPIO_EN } {
	# Procedure called to update IO_GPIO_IN_NUM when any of the dependent parameters in the arguments change
	
	set IO_GPIO_IN_NUM ${PARAM_VALUE.IO_GPIO_IN_NUM}
	set IO_GPIO_EN ${PARAM_VALUE.IO_GPIO_EN}
	set values(IO_GPIO_EN) [get_property value $IO_GPIO_EN]
	if { [gen_USERPARAMETER_IO_GPIO_IN_NUM_ENABLEMENT $values(IO_GPIO_EN)] } {
		set_property enabled true $IO_GPIO_IN_NUM
	} else {
		set_property enabled false $IO_GPIO_IN_NUM
	}
}

proc validate_PARAM_VALUE.IO_GPIO_IN_NUM { PARAM_VALUE.IO_GPIO_IN_NUM } {
	# Procedure called to validate IO_GPIO_IN_NUM
	return true
}

proc update_PARAM_VALUE.IO_GPIO_OUT_NUM { PARAM_VALUE.IO_GPIO_OUT_NUM PARAM_VALUE.IO_GPIO_EN } {
	# Procedure called to update IO_GPIO_OUT_NUM when any of the dependent parameters in the arguments change
	
	set IO_GPIO_OUT_NUM ${PARAM_VALUE.IO_GPIO_OUT_NUM}
	set IO_GPIO_EN ${PARAM_VALUE.IO_GPIO_EN}
	set values(IO_GPIO_EN) [get_property value $IO_GPIO_EN]
	if { [gen_USERPARAMETER_IO_GPIO_OUT_NUM_ENABLEMENT $values(IO_GPIO_EN)] } {
		set_property enabled true $IO_GPIO_OUT_NUM
	} else {
		set_property enabled false $IO_GPIO_OUT_NUM
	}
}

proc validate_PARAM_VALUE.IO_GPIO_OUT_NUM { PARAM_VALUE.IO_GPIO_OUT_NUM } {
	# Procedure called to validate IO_GPIO_OUT_NUM
	return true
}

proc update_PARAM_VALUE.IO_NEOLED_TX_FIFO { PARAM_VALUE.IO_NEOLED_TX_FIFO PARAM_VALUE.IO_NEOLED_EN } {
	# Procedure called to update IO_NEOLED_TX_FIFO when any of the dependent parameters in the arguments change
	
	set IO_NEOLED_TX_FIFO ${PARAM_VALUE.IO_NEOLED_TX_FIFO}
	set IO_NEOLED_EN ${PARAM_VALUE.IO_NEOLED_EN}
	set values(IO_NEOLED_EN) [get_property value $IO_NEOLED_EN]
	if { [gen_USERPARAMETER_IO_NEOLED_TX_FIFO_ENABLEMENT $values(IO_NEOLED_EN)] } {
		set_property enabled true $IO_NEOLED_TX_FIFO
	} else {
		set_property enabled false $IO_NEOLED_TX_FIFO
	}
}

proc validate_PARAM_VALUE.IO_NEOLED_TX_FIFO { PARAM_VALUE.IO_NEOLED_TX_FIFO } {
	# Procedure called to validate IO_NEOLED_TX_FIFO
	return true
}

proc update_PARAM_VALUE.IO_PWM_NUM_CH { PARAM_VALUE.IO_PWM_NUM_CH PARAM_VALUE.IO_PWM_EN } {
	# Procedure called to update IO_PWM_NUM_CH when any of the dependent parameters in the arguments change
	
	set IO_PWM_NUM_CH ${PARAM_VALUE.IO_PWM_NUM_CH}
	set IO_PWM_EN ${PARAM_VALUE.IO_PWM_EN}
	set values(IO_PWM_EN) [get_property value $IO_PWM_EN]
	if { [gen_USERPARAMETER_IO_PWM_NUM_CH_ENABLEMENT $values(IO_PWM_EN)] } {
		set_property enabled true $IO_PWM_NUM_CH
	} else {
		set_property enabled false $IO_PWM_NUM_CH
	}
}

proc validate_PARAM_VALUE.IO_PWM_NUM_CH { PARAM_VALUE.IO_PWM_NUM_CH } {
	# Procedure called to validate IO_PWM_NUM_CH
	return true
}

proc update_PARAM_VALUE.IO_SDI_FIFO { PARAM_VALUE.IO_SDI_FIFO PARAM_VALUE.IO_SDI_EN } {
	# Procedure called to update IO_SDI_FIFO when any of the dependent parameters in the arguments change
	
	set IO_SDI_FIFO ${PARAM_VALUE.IO_SDI_FIFO}
	set IO_SDI_EN ${PARAM_VALUE.IO_SDI_EN}
	set values(IO_SDI_EN) [get_property value $IO_SDI_EN]
	if { [gen_USERPARAMETER_IO_SDI_FIFO_ENABLEMENT $values(IO_SDI_EN)] } {
		set_property enabled true $IO_SDI_FIFO
	} else {
		set_property enabled false $IO_SDI_FIFO
	}
}

proc validate_PARAM_VALUE.IO_SDI_FIFO { PARAM_VALUE.IO_SDI_FIFO } {
	# Procedure called to validate IO_SDI_FIFO
	return true
}

proc update_PARAM_VALUE.IO_SLINK_RX_FIFO { PARAM_VALUE.IO_SLINK_RX_FIFO PARAM_VALUE.IO_SLINK_EN } {
	# Procedure called to update IO_SLINK_RX_FIFO when any of the dependent parameters in the arguments change
	
	set IO_SLINK_RX_FIFO ${PARAM_VALUE.IO_SLINK_RX_FIFO}
	set IO_SLINK_EN ${PARAM_VALUE.IO_SLINK_EN}
	set values(IO_SLINK_EN) [get_property value $IO_SLINK_EN]
	if { [gen_USERPARAMETER_IO_SLINK_RX_FIFO_ENABLEMENT $values(IO_SLINK_EN)] } {
		set_property enabled true $IO_SLINK_RX_FIFO
	} else {
		set_property enabled false $IO_SLINK_RX_FIFO
	}
}

proc validate_PARAM_VALUE.IO_SLINK_RX_FIFO { PARAM_VALUE.IO_SLINK_RX_FIFO } {
	# Procedure called to validate IO_SLINK_RX_FIFO
	return true
}

proc update_PARAM_VALUE.IO_SLINK_TX_FIFO { PARAM_VALUE.IO_SLINK_TX_FIFO PARAM_VALUE.IO_SLINK_EN } {
	# Procedure called to update IO_SLINK_TX_FIFO when any of the dependent parameters in the arguments change
	
	set IO_SLINK_TX_FIFO ${PARAM_VALUE.IO_SLINK_TX_FIFO}
	set IO_SLINK_EN ${PARAM_VALUE.IO_SLINK_EN}
	set values(IO_SLINK_EN) [get_property value $IO_SLINK_EN]
	if { [gen_USERPARAMETER_IO_SLINK_TX_FIFO_ENABLEMENT $values(IO_SLINK_EN)] } {
		set_property enabled true $IO_SLINK_TX_FIFO
	} else {
		set_property enabled false $IO_SLINK_TX_FIFO
	}
}

proc validate_PARAM_VALUE.IO_SLINK_TX_FIFO { PARAM_VALUE.IO_SLINK_TX_FIFO } {
	# Procedure called to validate IO_SLINK_TX_FIFO
	return true
}

proc update_PARAM_VALUE.IO_SPI_FIFO { PARAM_VALUE.IO_SPI_FIFO PARAM_VALUE.IO_SPI_EN } {
	# Procedure called to update IO_SPI_FIFO when any of the dependent parameters in the arguments change
	
	set IO_SPI_FIFO ${PARAM_VALUE.IO_SPI_FIFO}
	set IO_SPI_EN ${PARAM_VALUE.IO_SPI_EN}
	set values(IO_SPI_EN) [get_property value $IO_SPI_EN]
	if { [gen_USERPARAMETER_IO_SPI_FIFO_ENABLEMENT $values(IO_SPI_EN)] } {
		set_property enabled true $IO_SPI_FIFO
	} else {
		set_property enabled false $IO_SPI_FIFO
	}
}

proc validate_PARAM_VALUE.IO_SPI_FIFO { PARAM_VALUE.IO_SPI_FIFO } {
	# Procedure called to validate IO_SPI_FIFO
	return true
}

proc update_PARAM_VALUE.IO_TRNG_FIFO { PARAM_VALUE.IO_TRNG_FIFO PARAM_VALUE.IO_TRNG_EN } {
	# Procedure called to update IO_TRNG_FIFO when any of the dependent parameters in the arguments change
	
	set IO_TRNG_FIFO ${PARAM_VALUE.IO_TRNG_FIFO}
	set IO_TRNG_EN ${PARAM_VALUE.IO_TRNG_EN}
	set values(IO_TRNG_EN) [get_property value $IO_TRNG_EN]
	if { [gen_USERPARAMETER_IO_TRNG_FIFO_ENABLEMENT $values(IO_TRNG_EN)] } {
		set_property enabled true $IO_TRNG_FIFO
	} else {
		set_property enabled false $IO_TRNG_FIFO
	}
}

proc validate_PARAM_VALUE.IO_TRNG_FIFO { PARAM_VALUE.IO_TRNG_FIFO } {
	# Procedure called to validate IO_TRNG_FIFO
	return true
}

proc update_PARAM_VALUE.IO_TWD_FIFO { PARAM_VALUE.IO_TWD_FIFO PARAM_VALUE.IO_TWD_EN } {
	# Procedure called to update IO_TWD_FIFO when any of the dependent parameters in the arguments change
	
	set IO_TWD_FIFO ${PARAM_VALUE.IO_TWD_FIFO}
	set IO_TWD_EN ${PARAM_VALUE.IO_TWD_EN}
	set values(IO_TWD_EN) [get_property value $IO_TWD_EN]
	if { [gen_USERPARAMETER_IO_TWD_FIFO_ENABLEMENT $values(IO_TWD_EN)] } {
		set_property enabled true $IO_TWD_FIFO
	} else {
		set_property enabled false $IO_TWD_FIFO
	}
}

proc validate_PARAM_VALUE.IO_TWD_FIFO { PARAM_VALUE.IO_TWD_FIFO } {
	# Procedure called to validate IO_TWD_FIFO
	return true
}

proc update_PARAM_VALUE.IO_TWI_FIFO { PARAM_VALUE.IO_TWI_FIFO PARAM_VALUE.IO_TWI_EN } {
	# Procedure called to update IO_TWI_FIFO when any of the dependent parameters in the arguments change
	
	set IO_TWI_FIFO ${PARAM_VALUE.IO_TWI_FIFO}
	set IO_TWI_EN ${PARAM_VALUE.IO_TWI_EN}
	set values(IO_TWI_EN) [get_property value $IO_TWI_EN]
	if { [gen_USERPARAMETER_IO_TWI_FIFO_ENABLEMENT $values(IO_TWI_EN)] } {
		set_property enabled true $IO_TWI_FIFO
	} else {
		set_property enabled false $IO_TWI_FIFO
	}
}

proc validate_PARAM_VALUE.IO_TWI_FIFO { PARAM_VALUE.IO_TWI_FIFO } {
	# Procedure called to validate IO_TWI_FIFO
	return true
}

proc update_PARAM_VALUE.IO_UART0_RX_FIFO { PARAM_VALUE.IO_UART0_RX_FIFO PARAM_VALUE.IO_UART0_EN } {
	# Procedure called to update IO_UART0_RX_FIFO when any of the dependent parameters in the arguments change
	
	set IO_UART0_RX_FIFO ${PARAM_VALUE.IO_UART0_RX_FIFO}
	set IO_UART0_EN ${PARAM_VALUE.IO_UART0_EN}
	set values(IO_UART0_EN) [get_property value $IO_UART0_EN]
	if { [gen_USERPARAMETER_IO_UART0_RX_FIFO_ENABLEMENT $values(IO_UART0_EN)] } {
		set_property enabled true $IO_UART0_RX_FIFO
	} else {
		set_property enabled false $IO_UART0_RX_FIFO
	}
}

proc validate_PARAM_VALUE.IO_UART0_RX_FIFO { PARAM_VALUE.IO_UART0_RX_FIFO } {
	# Procedure called to validate IO_UART0_RX_FIFO
	return true
}

proc update_PARAM_VALUE.IO_UART0_TX_FIFO { PARAM_VALUE.IO_UART0_TX_FIFO PARAM_VALUE.IO_UART0_EN } {
	# Procedure called to update IO_UART0_TX_FIFO when any of the dependent parameters in the arguments change
	
	set IO_UART0_TX_FIFO ${PARAM_VALUE.IO_UART0_TX_FIFO}
	set IO_UART0_EN ${PARAM_VALUE.IO_UART0_EN}
	set values(IO_UART0_EN) [get_property value $IO_UART0_EN]
	if { [gen_USERPARAMETER_IO_UART0_TX_FIFO_ENABLEMENT $values(IO_UART0_EN)] } {
		set_property enabled true $IO_UART0_TX_FIFO
	} else {
		set_property enabled false $IO_UART0_TX_FIFO
	}
}

proc validate_PARAM_VALUE.IO_UART0_TX_FIFO { PARAM_VALUE.IO_UART0_TX_FIFO } {
	# Procedure called to validate IO_UART0_TX_FIFO
	return true
}

proc update_PARAM_VALUE.IO_UART1_RX_FIFO { PARAM_VALUE.IO_UART1_RX_FIFO PARAM_VALUE.IO_UART1_EN } {
	# Procedure called to update IO_UART1_RX_FIFO when any of the dependent parameters in the arguments change
	
	set IO_UART1_RX_FIFO ${PARAM_VALUE.IO_UART1_RX_FIFO}
	set IO_UART1_EN ${PARAM_VALUE.IO_UART1_EN}
	set values(IO_UART1_EN) [get_property value $IO_UART1_EN]
	if { [gen_USERPARAMETER_IO_UART1_RX_FIFO_ENABLEMENT $values(IO_UART1_EN)] } {
		set_property enabled true $IO_UART1_RX_FIFO
	} else {
		set_property enabled false $IO_UART1_RX_FIFO
	}
}

proc validate_PARAM_VALUE.IO_UART1_RX_FIFO { PARAM_VALUE.IO_UART1_RX_FIFO } {
	# Procedure called to validate IO_UART1_RX_FIFO
	return true
}

proc update_PARAM_VALUE.IO_UART1_TX_FIFO { PARAM_VALUE.IO_UART1_TX_FIFO PARAM_VALUE.IO_UART1_EN } {
	# Procedure called to update IO_UART1_TX_FIFO when any of the dependent parameters in the arguments change
	
	set IO_UART1_TX_FIFO ${PARAM_VALUE.IO_UART1_TX_FIFO}
	set IO_UART1_EN ${PARAM_VALUE.IO_UART1_EN}
	set values(IO_UART1_EN) [get_property value $IO_UART1_EN]
	if { [gen_USERPARAMETER_IO_UART1_TX_FIFO_ENABLEMENT $values(IO_UART1_EN)] } {
		set_property enabled true $IO_UART1_TX_FIFO
	} else {
		set_property enabled false $IO_UART1_TX_FIFO
	}
}

proc validate_PARAM_VALUE.IO_UART1_TX_FIFO { PARAM_VALUE.IO_UART1_TX_FIFO } {
	# Procedure called to validate IO_UART1_TX_FIFO
	return true
}

proc update_PARAM_VALUE.MEM_INT_DMEM_SIZE { PARAM_VALUE.MEM_INT_DMEM_SIZE PARAM_VALUE.MEM_INT_DMEM_EN } {
	# Procedure called to update MEM_INT_DMEM_SIZE when any of the dependent parameters in the arguments change
	
	set MEM_INT_DMEM_SIZE ${PARAM_VALUE.MEM_INT_DMEM_SIZE}
	set MEM_INT_DMEM_EN ${PARAM_VALUE.MEM_INT_DMEM_EN}
	set values(MEM_INT_DMEM_EN) [get_property value $MEM_INT_DMEM_EN]
	if { [gen_USERPARAMETER_MEM_INT_DMEM_SIZE_ENABLEMENT $values(MEM_INT_DMEM_EN)] } {
		set_property enabled true $MEM_INT_DMEM_SIZE
	} else {
		set_property enabled false $MEM_INT_DMEM_SIZE
	}
}

proc validate_PARAM_VALUE.MEM_INT_DMEM_SIZE { PARAM_VALUE.MEM_INT_DMEM_SIZE } {
	# Procedure called to validate MEM_INT_DMEM_SIZE
	return true
}

proc update_PARAM_VALUE.MEM_INT_IMEM_SIZE { PARAM_VALUE.MEM_INT_IMEM_SIZE PARAM_VALUE.MEM_INT_IMEM_EN } {
	# Procedure called to update MEM_INT_IMEM_SIZE when any of the dependent parameters in the arguments change
	
	set MEM_INT_IMEM_SIZE ${PARAM_VALUE.MEM_INT_IMEM_SIZE}
	set MEM_INT_IMEM_EN ${PARAM_VALUE.MEM_INT_IMEM_EN}
	set values(MEM_INT_IMEM_EN) [get_property value $MEM_INT_IMEM_EN]
	if { [gen_USERPARAMETER_MEM_INT_IMEM_SIZE_ENABLEMENT $values(MEM_INT_IMEM_EN)] } {
		set_property enabled true $MEM_INT_IMEM_SIZE
	} else {
		set_property enabled false $MEM_INT_IMEM_SIZE
	}
}

proc validate_PARAM_VALUE.MEM_INT_IMEM_SIZE { PARAM_VALUE.MEM_INT_IMEM_SIZE } {
	# Procedure called to validate MEM_INT_IMEM_SIZE
	return true
}

proc update_PARAM_VALUE.OCD_AUTHENTICATION { PARAM_VALUE.OCD_AUTHENTICATION PARAM_VALUE.OCD_EN PARAM_VALUE.OCD_AUTHENTICATION } {
	# Procedure called to update OCD_AUTHENTICATION when any of the dependent parameters in the arguments change
	
	set OCD_AUTHENTICATION ${PARAM_VALUE.OCD_AUTHENTICATION}
	set OCD_EN ${PARAM_VALUE.OCD_EN}
	set values(OCD_EN) [get_property value $OCD_EN]
	set values(OCD_AUTHENTICATION) [get_property value $OCD_AUTHENTICATION]
	if { [gen_USERPARAMETER_OCD_AUTHENTICATION_ENABLEMENT $values(OCD_EN)] } {
		set_property enabled true $OCD_AUTHENTICATION
	} else {
		set_property enabled false $OCD_AUTHENTICATION
		set_property value [gen_USERPARAMETER_OCD_AUTHENTICATION_VALUE $values(OCD_EN) $values(OCD_AUTHENTICATION)] $OCD_AUTHENTICATION
	}
}

proc validate_PARAM_VALUE.OCD_AUTHENTICATION { PARAM_VALUE.OCD_AUTHENTICATION } {
	# Procedure called to validate OCD_AUTHENTICATION
	return true
}

proc update_PARAM_VALUE.PMP_MIN_GRANULARITY { PARAM_VALUE.PMP_MIN_GRANULARITY PARAM_VALUE.PMP_NUM_REGIONS } {
	# Procedure called to update PMP_MIN_GRANULARITY when any of the dependent parameters in the arguments change
	
	set PMP_MIN_GRANULARITY ${PARAM_VALUE.PMP_MIN_GRANULARITY}
	set PMP_NUM_REGIONS ${PARAM_VALUE.PMP_NUM_REGIONS}
	set values(PMP_NUM_REGIONS) [get_property value $PMP_NUM_REGIONS]
	if { [gen_USERPARAMETER_PMP_MIN_GRANULARITY_ENABLEMENT $values(PMP_NUM_REGIONS)] } {
		set_property enabled true $PMP_MIN_GRANULARITY
	} else {
		set_property enabled false $PMP_MIN_GRANULARITY
	}
}

proc validate_PARAM_VALUE.PMP_MIN_GRANULARITY { PARAM_VALUE.PMP_MIN_GRANULARITY } {
	# Procedure called to validate PMP_MIN_GRANULARITY
	return true
}

proc update_PARAM_VALUE.PMP_NAP_MODE_EN { PARAM_VALUE.PMP_NAP_MODE_EN PARAM_VALUE.PMP_NUM_REGIONS } {
	# Procedure called to update PMP_NAP_MODE_EN when any of the dependent parameters in the arguments change
	
	set PMP_NAP_MODE_EN ${PARAM_VALUE.PMP_NAP_MODE_EN}
	set PMP_NUM_REGIONS ${PARAM_VALUE.PMP_NUM_REGIONS}
	set values(PMP_NUM_REGIONS) [get_property value $PMP_NUM_REGIONS]
	if { [gen_USERPARAMETER_PMP_NAP_MODE_EN_ENABLEMENT $values(PMP_NUM_REGIONS)] } {
		set_property enabled true $PMP_NAP_MODE_EN
	} else {
		set_property enabled false $PMP_NAP_MODE_EN
	}
}

proc validate_PARAM_VALUE.PMP_NAP_MODE_EN { PARAM_VALUE.PMP_NAP_MODE_EN } {
	# Procedure called to validate PMP_NAP_MODE_EN
	return true
}

proc update_PARAM_VALUE.PMP_TOR_MODE_EN { PARAM_VALUE.PMP_TOR_MODE_EN PARAM_VALUE.PMP_NUM_REGIONS } {
	# Procedure called to update PMP_TOR_MODE_EN when any of the dependent parameters in the arguments change
	
	set PMP_TOR_MODE_EN ${PARAM_VALUE.PMP_TOR_MODE_EN}
	set PMP_NUM_REGIONS ${PARAM_VALUE.PMP_NUM_REGIONS}
	set values(PMP_NUM_REGIONS) [get_property value $PMP_NUM_REGIONS]
	if { [gen_USERPARAMETER_PMP_TOR_MODE_EN_ENABLEMENT $values(PMP_NUM_REGIONS)] } {
		set_property enabled true $PMP_TOR_MODE_EN
	} else {
		set_property enabled false $PMP_TOR_MODE_EN
	}
}

proc validate_PARAM_VALUE.PMP_TOR_MODE_EN { PARAM_VALUE.PMP_TOR_MODE_EN } {
	# Procedure called to validate PMP_TOR_MODE_EN
	return true
}

proc update_PARAM_VALUE.XBUS_CACHE_BLOCK_SIZE { PARAM_VALUE.XBUS_CACHE_BLOCK_SIZE PARAM_VALUE.XBUS_CACHE_EN } {
	# Procedure called to update XBUS_CACHE_BLOCK_SIZE when any of the dependent parameters in the arguments change
	
	set XBUS_CACHE_BLOCK_SIZE ${PARAM_VALUE.XBUS_CACHE_BLOCK_SIZE}
	set XBUS_CACHE_EN ${PARAM_VALUE.XBUS_CACHE_EN}
	set values(XBUS_CACHE_EN) [get_property value $XBUS_CACHE_EN]
	if { [gen_USERPARAMETER_XBUS_CACHE_BLOCK_SIZE_ENABLEMENT $values(XBUS_CACHE_EN)] } {
		set_property enabled true $XBUS_CACHE_BLOCK_SIZE
	} else {
		set_property enabled false $XBUS_CACHE_BLOCK_SIZE
	}
}

proc validate_PARAM_VALUE.XBUS_CACHE_BLOCK_SIZE { PARAM_VALUE.XBUS_CACHE_BLOCK_SIZE } {
	# Procedure called to validate XBUS_CACHE_BLOCK_SIZE
	return true
}

proc update_PARAM_VALUE.XBUS_CACHE_EN { PARAM_VALUE.XBUS_CACHE_EN PARAM_VALUE.XBUS_EN PARAM_VALUE.XBUS_CACHE_EN } {
	# Procedure called to update XBUS_CACHE_EN when any of the dependent parameters in the arguments change
	
	set XBUS_CACHE_EN ${PARAM_VALUE.XBUS_CACHE_EN}
	set XBUS_EN ${PARAM_VALUE.XBUS_EN}
	set values(XBUS_EN) [get_property value $XBUS_EN]
	set values(XBUS_CACHE_EN) [get_property value $XBUS_CACHE_EN]
	if { [gen_USERPARAMETER_XBUS_CACHE_EN_ENABLEMENT $values(XBUS_EN)] } {
		set_property enabled true $XBUS_CACHE_EN
	} else {
		set_property enabled false $XBUS_CACHE_EN
		set_property value [gen_USERPARAMETER_XBUS_CACHE_EN_VALUE $values(XBUS_EN) $values(XBUS_CACHE_EN)] $XBUS_CACHE_EN
	}
}

proc validate_PARAM_VALUE.XBUS_CACHE_EN { PARAM_VALUE.XBUS_CACHE_EN } {
	# Procedure called to validate XBUS_CACHE_EN
	return true
}

proc update_PARAM_VALUE.XBUS_CACHE_NUM_BLOCKS { PARAM_VALUE.XBUS_CACHE_NUM_BLOCKS PARAM_VALUE.XBUS_CACHE_EN } {
	# Procedure called to update XBUS_CACHE_NUM_BLOCKS when any of the dependent parameters in the arguments change
	
	set XBUS_CACHE_NUM_BLOCKS ${PARAM_VALUE.XBUS_CACHE_NUM_BLOCKS}
	set XBUS_CACHE_EN ${PARAM_VALUE.XBUS_CACHE_EN}
	set values(XBUS_CACHE_EN) [get_property value $XBUS_CACHE_EN]
	if { [gen_USERPARAMETER_XBUS_CACHE_NUM_BLOCKS_ENABLEMENT $values(XBUS_CACHE_EN)] } {
		set_property enabled true $XBUS_CACHE_NUM_BLOCKS
	} else {
		set_property enabled false $XBUS_CACHE_NUM_BLOCKS
	}
}

proc validate_PARAM_VALUE.XBUS_CACHE_NUM_BLOCKS { PARAM_VALUE.XBUS_CACHE_NUM_BLOCKS } {
	# Procedure called to validate XBUS_CACHE_NUM_BLOCKS
	return true
}

proc update_PARAM_VALUE.XBUS_REGSTAGE_EN { PARAM_VALUE.XBUS_REGSTAGE_EN PARAM_VALUE.XBUS_EN } {
	# Procedure called to update XBUS_REGSTAGE_EN when any of the dependent parameters in the arguments change
	
	set XBUS_REGSTAGE_EN ${PARAM_VALUE.XBUS_REGSTAGE_EN}
	set XBUS_EN ${PARAM_VALUE.XBUS_EN}
	set values(XBUS_EN) [get_property value $XBUS_EN]
	if { [gen_USERPARAMETER_XBUS_REGSTAGE_EN_ENABLEMENT $values(XBUS_EN)] } {
		set_property enabled true $XBUS_REGSTAGE_EN
	} else {
		set_property enabled false $XBUS_REGSTAGE_EN
	}
}

proc validate_PARAM_VALUE.XBUS_REGSTAGE_EN { PARAM_VALUE.XBUS_REGSTAGE_EN } {
	# Procedure called to validate XBUS_REGSTAGE_EN
	return true
}

proc update_PARAM_VALUE.XBUS_TIMEOUT { PARAM_VALUE.XBUS_TIMEOUT PARAM_VALUE.XBUS_EN } {
	# Procedure called to update XBUS_TIMEOUT when any of the dependent parameters in the arguments change
	
	set XBUS_TIMEOUT ${PARAM_VALUE.XBUS_TIMEOUT}
	set XBUS_EN ${PARAM_VALUE.XBUS_EN}
	set values(XBUS_EN) [get_property value $XBUS_EN]
	if { [gen_USERPARAMETER_XBUS_TIMEOUT_ENABLEMENT $values(XBUS_EN)] } {
		set_property enabled true $XBUS_TIMEOUT
	} else {
		set_property enabled false $XBUS_TIMEOUT
	}
}

proc validate_PARAM_VALUE.XBUS_TIMEOUT { PARAM_VALUE.XBUS_TIMEOUT } {
	# Procedure called to validate XBUS_TIMEOUT
	return true
}

proc update_PARAM_VALUE.XIP_CACHE_BLOCK_SIZE { PARAM_VALUE.XIP_CACHE_BLOCK_SIZE PARAM_VALUE.XIP_CACHE_EN } {
	# Procedure called to update XIP_CACHE_BLOCK_SIZE when any of the dependent parameters in the arguments change
	
	set XIP_CACHE_BLOCK_SIZE ${PARAM_VALUE.XIP_CACHE_BLOCK_SIZE}
	set XIP_CACHE_EN ${PARAM_VALUE.XIP_CACHE_EN}
	set values(XIP_CACHE_EN) [get_property value $XIP_CACHE_EN]
	if { [gen_USERPARAMETER_XIP_CACHE_BLOCK_SIZE_ENABLEMENT $values(XIP_CACHE_EN)] } {
		set_property enabled true $XIP_CACHE_BLOCK_SIZE
	} else {
		set_property enabled false $XIP_CACHE_BLOCK_SIZE
	}
}

proc validate_PARAM_VALUE.XIP_CACHE_BLOCK_SIZE { PARAM_VALUE.XIP_CACHE_BLOCK_SIZE } {
	# Procedure called to validate XIP_CACHE_BLOCK_SIZE
	return true
}

proc update_PARAM_VALUE.XIP_CACHE_EN { PARAM_VALUE.XIP_CACHE_EN PARAM_VALUE.XIP_EN PARAM_VALUE.XIP_CACHE_EN } {
	# Procedure called to update XIP_CACHE_EN when any of the dependent parameters in the arguments change
	
	set XIP_CACHE_EN ${PARAM_VALUE.XIP_CACHE_EN}
	set XIP_EN ${PARAM_VALUE.XIP_EN}
	set values(XIP_EN) [get_property value $XIP_EN]
	set values(XIP_CACHE_EN) [get_property value $XIP_CACHE_EN]
	if { [gen_USERPARAMETER_XIP_CACHE_EN_ENABLEMENT $values(XIP_EN)] } {
		set_property enabled true $XIP_CACHE_EN
	} else {
		set_property enabled false $XIP_CACHE_EN
		set_property value [gen_USERPARAMETER_XIP_CACHE_EN_VALUE $values(XIP_EN) $values(XIP_CACHE_EN)] $XIP_CACHE_EN
	}
}

proc validate_PARAM_VALUE.XIP_CACHE_EN { PARAM_VALUE.XIP_CACHE_EN } {
	# Procedure called to validate XIP_CACHE_EN
	return true
}

proc update_PARAM_VALUE.XIP_CACHE_NUM_BLOCKS { PARAM_VALUE.XIP_CACHE_NUM_BLOCKS PARAM_VALUE.XIP_CACHE_EN } {
	# Procedure called to update XIP_CACHE_NUM_BLOCKS when any of the dependent parameters in the arguments change
	
	set XIP_CACHE_NUM_BLOCKS ${PARAM_VALUE.XIP_CACHE_NUM_BLOCKS}
	set XIP_CACHE_EN ${PARAM_VALUE.XIP_CACHE_EN}
	set values(XIP_CACHE_EN) [get_property value $XIP_CACHE_EN]
	if { [gen_USERPARAMETER_XIP_CACHE_NUM_BLOCKS_ENABLEMENT $values(XIP_CACHE_EN)] } {
		set_property enabled true $XIP_CACHE_NUM_BLOCKS
	} else {
		set_property enabled false $XIP_CACHE_NUM_BLOCKS
	}
}

proc validate_PARAM_VALUE.XIP_CACHE_NUM_BLOCKS { PARAM_VALUE.XIP_CACHE_NUM_BLOCKS } {
	# Procedure called to validate XIP_CACHE_NUM_BLOCKS
	return true
}

proc update_PARAM_VALUE.BOOT_MODE_SELECT { PARAM_VALUE.BOOT_MODE_SELECT } {
	# Procedure called to update BOOT_MODE_SELECT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BOOT_MODE_SELECT { PARAM_VALUE.BOOT_MODE_SELECT } {
	# Procedure called to validate BOOT_MODE_SELECT
	return true
}

proc update_PARAM_VALUE.CLOCK_FREQUENCY { PARAM_VALUE.CLOCK_FREQUENCY } {
	# Procedure called to update CLOCK_FREQUENCY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLOCK_FREQUENCY { PARAM_VALUE.CLOCK_FREQUENCY } {
	# Procedure called to validate CLOCK_FREQUENCY
	return true
}

proc update_PARAM_VALUE.CPU_FAST_MUL_EN { PARAM_VALUE.CPU_FAST_MUL_EN } {
	# Procedure called to update CPU_FAST_MUL_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CPU_FAST_MUL_EN { PARAM_VALUE.CPU_FAST_MUL_EN } {
	# Procedure called to validate CPU_FAST_MUL_EN
	return true
}

proc update_PARAM_VALUE.CPU_FAST_SHIFT_EN { PARAM_VALUE.CPU_FAST_SHIFT_EN } {
	# Procedure called to update CPU_FAST_SHIFT_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CPU_FAST_SHIFT_EN { PARAM_VALUE.CPU_FAST_SHIFT_EN } {
	# Procedure called to validate CPU_FAST_SHIFT_EN
	return true
}

proc update_PARAM_VALUE.CPU_RF_HW_RST_EN { PARAM_VALUE.CPU_RF_HW_RST_EN } {
	# Procedure called to update CPU_RF_HW_RST_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CPU_RF_HW_RST_EN { PARAM_VALUE.CPU_RF_HW_RST_EN } {
	# Procedure called to validate CPU_RF_HW_RST_EN
	return true
}

proc update_PARAM_VALUE.DCACHE_EN { PARAM_VALUE.DCACHE_EN } {
	# Procedure called to update DCACHE_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DCACHE_EN { PARAM_VALUE.DCACHE_EN } {
	# Procedure called to validate DCACHE_EN
	return true
}

proc update_PARAM_VALUE.DUAL_CORE_EN { PARAM_VALUE.DUAL_CORE_EN } {
	# Procedure called to update DUAL_CORE_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DUAL_CORE_EN { PARAM_VALUE.DUAL_CORE_EN } {
	# Procedure called to validate DUAL_CORE_EN
	return true
}

proc update_PARAM_VALUE.ICACHE_EN { PARAM_VALUE.ICACHE_EN } {
	# Procedure called to update ICACHE_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ICACHE_EN { PARAM_VALUE.ICACHE_EN } {
	# Procedure called to validate ICACHE_EN
	return true
}

proc update_PARAM_VALUE.IO_CFS_EN { PARAM_VALUE.IO_CFS_EN } {
	# Procedure called to update IO_CFS_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_CFS_EN { PARAM_VALUE.IO_CFS_EN } {
	# Procedure called to validate IO_CFS_EN
	return true
}

proc update_PARAM_VALUE.IO_CLINT_EN { PARAM_VALUE.IO_CLINT_EN } {
	# Procedure called to update IO_CLINT_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_CLINT_EN { PARAM_VALUE.IO_CLINT_EN } {
	# Procedure called to validate IO_CLINT_EN
	return true
}

proc update_PARAM_VALUE.IO_CRC_EN { PARAM_VALUE.IO_CRC_EN } {
	# Procedure called to update IO_CRC_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_CRC_EN { PARAM_VALUE.IO_CRC_EN } {
	# Procedure called to validate IO_CRC_EN
	return true
}

proc update_PARAM_VALUE.IO_DMA_EN { PARAM_VALUE.IO_DMA_EN } {
	# Procedure called to update IO_DMA_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_DMA_EN { PARAM_VALUE.IO_DMA_EN } {
	# Procedure called to validate IO_DMA_EN
	return true
}

proc update_PARAM_VALUE.IO_GPIO_EN { PARAM_VALUE.IO_GPIO_EN } {
	# Procedure called to update IO_GPIO_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_GPIO_EN { PARAM_VALUE.IO_GPIO_EN } {
	# Procedure called to validate IO_GPIO_EN
	return true
}

proc update_PARAM_VALUE.IO_GPTMR_EN { PARAM_VALUE.IO_GPTMR_EN } {
	# Procedure called to update IO_GPTMR_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_GPTMR_EN { PARAM_VALUE.IO_GPTMR_EN } {
	# Procedure called to validate IO_GPTMR_EN
	return true
}

proc update_PARAM_VALUE.IO_NEOLED_EN { PARAM_VALUE.IO_NEOLED_EN } {
	# Procedure called to update IO_NEOLED_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_NEOLED_EN { PARAM_VALUE.IO_NEOLED_EN } {
	# Procedure called to validate IO_NEOLED_EN
	return true
}

proc update_PARAM_VALUE.IO_ONEWIRE_EN { PARAM_VALUE.IO_ONEWIRE_EN } {
	# Procedure called to update IO_ONEWIRE_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_ONEWIRE_EN { PARAM_VALUE.IO_ONEWIRE_EN } {
	# Procedure called to validate IO_ONEWIRE_EN
	return true
}

proc update_PARAM_VALUE.IO_PWM_EN { PARAM_VALUE.IO_PWM_EN } {
	# Procedure called to update IO_PWM_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_PWM_EN { PARAM_VALUE.IO_PWM_EN } {
	# Procedure called to validate IO_PWM_EN
	return true
}

proc update_PARAM_VALUE.IO_SDI_EN { PARAM_VALUE.IO_SDI_EN } {
	# Procedure called to update IO_SDI_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_SDI_EN { PARAM_VALUE.IO_SDI_EN } {
	# Procedure called to validate IO_SDI_EN
	return true
}

proc update_PARAM_VALUE.IO_SLINK_EN { PARAM_VALUE.IO_SLINK_EN } {
	# Procedure called to update IO_SLINK_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_SLINK_EN { PARAM_VALUE.IO_SLINK_EN } {
	# Procedure called to validate IO_SLINK_EN
	return true
}

proc update_PARAM_VALUE.IO_SPI_EN { PARAM_VALUE.IO_SPI_EN } {
	# Procedure called to update IO_SPI_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_SPI_EN { PARAM_VALUE.IO_SPI_EN } {
	# Procedure called to validate IO_SPI_EN
	return true
}

proc update_PARAM_VALUE.IO_TRNG_EN { PARAM_VALUE.IO_TRNG_EN } {
	# Procedure called to update IO_TRNG_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_TRNG_EN { PARAM_VALUE.IO_TRNG_EN } {
	# Procedure called to validate IO_TRNG_EN
	return true
}

proc update_PARAM_VALUE.IO_TWD_EN { PARAM_VALUE.IO_TWD_EN } {
	# Procedure called to update IO_TWD_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_TWD_EN { PARAM_VALUE.IO_TWD_EN } {
	# Procedure called to validate IO_TWD_EN
	return true
}

proc update_PARAM_VALUE.IO_TWI_EN { PARAM_VALUE.IO_TWI_EN } {
	# Procedure called to update IO_TWI_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_TWI_EN { PARAM_VALUE.IO_TWI_EN } {
	# Procedure called to validate IO_TWI_EN
	return true
}

proc update_PARAM_VALUE.IO_UART0_EN { PARAM_VALUE.IO_UART0_EN } {
	# Procedure called to update IO_UART0_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_UART0_EN { PARAM_VALUE.IO_UART0_EN } {
	# Procedure called to validate IO_UART0_EN
	return true
}

proc update_PARAM_VALUE.IO_UART1_EN { PARAM_VALUE.IO_UART1_EN } {
	# Procedure called to update IO_UART1_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_UART1_EN { PARAM_VALUE.IO_UART1_EN } {
	# Procedure called to validate IO_UART1_EN
	return true
}

proc update_PARAM_VALUE.IO_WDT_EN { PARAM_VALUE.IO_WDT_EN } {
	# Procedure called to update IO_WDT_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IO_WDT_EN { PARAM_VALUE.IO_WDT_EN } {
	# Procedure called to validate IO_WDT_EN
	return true
}

proc update_PARAM_VALUE.JEDEC_ID { PARAM_VALUE.JEDEC_ID } {
	# Procedure called to update JEDEC_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.JEDEC_ID { PARAM_VALUE.JEDEC_ID } {
	# Procedure called to validate JEDEC_ID
	return true
}

proc update_PARAM_VALUE.MEM_INT_DMEM_EN { PARAM_VALUE.MEM_INT_DMEM_EN } {
	# Procedure called to update MEM_INT_DMEM_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_INT_DMEM_EN { PARAM_VALUE.MEM_INT_DMEM_EN } {
	# Procedure called to validate MEM_INT_DMEM_EN
	return true
}

proc update_PARAM_VALUE.MEM_INT_IMEM_EN { PARAM_VALUE.MEM_INT_IMEM_EN } {
	# Procedure called to update MEM_INT_IMEM_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_INT_IMEM_EN { PARAM_VALUE.MEM_INT_IMEM_EN } {
	# Procedure called to validate MEM_INT_IMEM_EN
	return true
}

proc update_PARAM_VALUE.OCD_EN { PARAM_VALUE.OCD_EN } {
	# Procedure called to update OCD_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OCD_EN { PARAM_VALUE.OCD_EN } {
	# Procedure called to validate OCD_EN
	return true
}

proc update_PARAM_VALUE.PMP_NUM_REGIONS { PARAM_VALUE.PMP_NUM_REGIONS } {
	# Procedure called to update PMP_NUM_REGIONS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PMP_NUM_REGIONS { PARAM_VALUE.PMP_NUM_REGIONS } {
	# Procedure called to validate PMP_NUM_REGIONS
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_C { PARAM_VALUE.RISCV_ISA_C } {
	# Procedure called to update RISCV_ISA_C when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_C { PARAM_VALUE.RISCV_ISA_C } {
	# Procedure called to validate RISCV_ISA_C
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_E { PARAM_VALUE.RISCV_ISA_E } {
	# Procedure called to update RISCV_ISA_E when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_E { PARAM_VALUE.RISCV_ISA_E } {
	# Procedure called to validate RISCV_ISA_E
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_M { PARAM_VALUE.RISCV_ISA_M } {
	# Procedure called to update RISCV_ISA_M when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_M { PARAM_VALUE.RISCV_ISA_M } {
	# Procedure called to validate RISCV_ISA_M
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_U { PARAM_VALUE.RISCV_ISA_U } {
	# Procedure called to update RISCV_ISA_U when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_U { PARAM_VALUE.RISCV_ISA_U } {
	# Procedure called to validate RISCV_ISA_U
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zaamo { PARAM_VALUE.RISCV_ISA_Zaamo } {
	# Procedure called to update RISCV_ISA_Zaamo when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zaamo { PARAM_VALUE.RISCV_ISA_Zaamo } {
	# Procedure called to validate RISCV_ISA_Zaamo
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zba { PARAM_VALUE.RISCV_ISA_Zba } {
	# Procedure called to update RISCV_ISA_Zba when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zba { PARAM_VALUE.RISCV_ISA_Zba } {
	# Procedure called to validate RISCV_ISA_Zba
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zbb { PARAM_VALUE.RISCV_ISA_Zbb } {
	# Procedure called to update RISCV_ISA_Zbb when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zbb { PARAM_VALUE.RISCV_ISA_Zbb } {
	# Procedure called to validate RISCV_ISA_Zbb
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zbkb { PARAM_VALUE.RISCV_ISA_Zbkb } {
	# Procedure called to update RISCV_ISA_Zbkb when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zbkb { PARAM_VALUE.RISCV_ISA_Zbkb } {
	# Procedure called to validate RISCV_ISA_Zbkb
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zbkc { PARAM_VALUE.RISCV_ISA_Zbkc } {
	# Procedure called to update RISCV_ISA_Zbkc when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zbkc { PARAM_VALUE.RISCV_ISA_Zbkc } {
	# Procedure called to validate RISCV_ISA_Zbkc
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zbkx { PARAM_VALUE.RISCV_ISA_Zbkx } {
	# Procedure called to update RISCV_ISA_Zbkx when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zbkx { PARAM_VALUE.RISCV_ISA_Zbkx } {
	# Procedure called to validate RISCV_ISA_Zbkx
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zbs { PARAM_VALUE.RISCV_ISA_Zbs } {
	# Procedure called to update RISCV_ISA_Zbs when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zbs { PARAM_VALUE.RISCV_ISA_Zbs } {
	# Procedure called to validate RISCV_ISA_Zbs
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zfinx { PARAM_VALUE.RISCV_ISA_Zfinx } {
	# Procedure called to update RISCV_ISA_Zfinx when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zfinx { PARAM_VALUE.RISCV_ISA_Zfinx } {
	# Procedure called to validate RISCV_ISA_Zfinx
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zicntr { PARAM_VALUE.RISCV_ISA_Zicntr } {
	# Procedure called to update RISCV_ISA_Zicntr when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zicntr { PARAM_VALUE.RISCV_ISA_Zicntr } {
	# Procedure called to validate RISCV_ISA_Zicntr
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zicond { PARAM_VALUE.RISCV_ISA_Zicond } {
	# Procedure called to update RISCV_ISA_Zicond when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zicond { PARAM_VALUE.RISCV_ISA_Zicond } {
	# Procedure called to validate RISCV_ISA_Zicond
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zihpm { PARAM_VALUE.RISCV_ISA_Zihpm } {
	# Procedure called to update RISCV_ISA_Zihpm when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zihpm { PARAM_VALUE.RISCV_ISA_Zihpm } {
	# Procedure called to validate RISCV_ISA_Zihpm
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zknd { PARAM_VALUE.RISCV_ISA_Zknd } {
	# Procedure called to update RISCV_ISA_Zknd when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zknd { PARAM_VALUE.RISCV_ISA_Zknd } {
	# Procedure called to validate RISCV_ISA_Zknd
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zkne { PARAM_VALUE.RISCV_ISA_Zkne } {
	# Procedure called to update RISCV_ISA_Zkne when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zkne { PARAM_VALUE.RISCV_ISA_Zkne } {
	# Procedure called to validate RISCV_ISA_Zkne
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zknh { PARAM_VALUE.RISCV_ISA_Zknh } {
	# Procedure called to update RISCV_ISA_Zknh when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zknh { PARAM_VALUE.RISCV_ISA_Zknh } {
	# Procedure called to validate RISCV_ISA_Zknh
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zksed { PARAM_VALUE.RISCV_ISA_Zksed } {
	# Procedure called to update RISCV_ISA_Zksed when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zksed { PARAM_VALUE.RISCV_ISA_Zksed } {
	# Procedure called to validate RISCV_ISA_Zksed
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zksh { PARAM_VALUE.RISCV_ISA_Zksh } {
	# Procedure called to update RISCV_ISA_Zksh when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zksh { PARAM_VALUE.RISCV_ISA_Zksh } {
	# Procedure called to validate RISCV_ISA_Zksh
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zmmul { PARAM_VALUE.RISCV_ISA_Zmmul } {
	# Procedure called to update RISCV_ISA_Zmmul when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zmmul { PARAM_VALUE.RISCV_ISA_Zmmul } {
	# Procedure called to validate RISCV_ISA_Zmmul
	return true
}

proc update_PARAM_VALUE.RISCV_ISA_Zxcfu { PARAM_VALUE.RISCV_ISA_Zxcfu } {
	# Procedure called to update RISCV_ISA_Zxcfu when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_ISA_Zxcfu { PARAM_VALUE.RISCV_ISA_Zxcfu } {
	# Procedure called to validate RISCV_ISA_Zxcfu
	return true
}

proc update_PARAM_VALUE.XBUS_EN { PARAM_VALUE.XBUS_EN } {
	# Procedure called to update XBUS_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.XBUS_EN { PARAM_VALUE.XBUS_EN } {
	# Procedure called to validate XBUS_EN
	return true
}

proc update_PARAM_VALUE.XIP_EN { PARAM_VALUE.XIP_EN } {
	# Procedure called to update XIP_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.XIP_EN { PARAM_VALUE.XIP_EN } {
	# Procedure called to validate XIP_EN
	return true
}


proc update_MODELPARAM_VALUE.CLOCK_FREQUENCY { MODELPARAM_VALUE.CLOCK_FREQUENCY PARAM_VALUE.CLOCK_FREQUENCY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLOCK_FREQUENCY}] ${MODELPARAM_VALUE.CLOCK_FREQUENCY}
}

proc update_MODELPARAM_VALUE.DUAL_CORE_EN { MODELPARAM_VALUE.DUAL_CORE_EN PARAM_VALUE.DUAL_CORE_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DUAL_CORE_EN}] ${MODELPARAM_VALUE.DUAL_CORE_EN}
}

proc update_MODELPARAM_VALUE.JEDEC_ID { MODELPARAM_VALUE.JEDEC_ID PARAM_VALUE.JEDEC_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.JEDEC_ID}] ${MODELPARAM_VALUE.JEDEC_ID}
}

proc update_MODELPARAM_VALUE.BOOT_MODE_SELECT { MODELPARAM_VALUE.BOOT_MODE_SELECT PARAM_VALUE.BOOT_MODE_SELECT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BOOT_MODE_SELECT}] ${MODELPARAM_VALUE.BOOT_MODE_SELECT}
}

proc update_MODELPARAM_VALUE.BOOT_ADDR_CUSTOM { MODELPARAM_VALUE.BOOT_ADDR_CUSTOM PARAM_VALUE.BOOT_ADDR_CUSTOM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BOOT_ADDR_CUSTOM}] ${MODELPARAM_VALUE.BOOT_ADDR_CUSTOM}
}

proc update_MODELPARAM_VALUE.OCD_EN { MODELPARAM_VALUE.OCD_EN PARAM_VALUE.OCD_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OCD_EN}] ${MODELPARAM_VALUE.OCD_EN}
}

proc update_MODELPARAM_VALUE.OCD_AUTHENTICATION { MODELPARAM_VALUE.OCD_AUTHENTICATION PARAM_VALUE.OCD_AUTHENTICATION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OCD_AUTHENTICATION}] ${MODELPARAM_VALUE.OCD_AUTHENTICATION}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_C { MODELPARAM_VALUE.RISCV_ISA_C PARAM_VALUE.RISCV_ISA_C } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_C}] ${MODELPARAM_VALUE.RISCV_ISA_C}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_E { MODELPARAM_VALUE.RISCV_ISA_E PARAM_VALUE.RISCV_ISA_E } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_E}] ${MODELPARAM_VALUE.RISCV_ISA_E}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_M { MODELPARAM_VALUE.RISCV_ISA_M PARAM_VALUE.RISCV_ISA_M } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_M}] ${MODELPARAM_VALUE.RISCV_ISA_M}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_U { MODELPARAM_VALUE.RISCV_ISA_U PARAM_VALUE.RISCV_ISA_U } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_U}] ${MODELPARAM_VALUE.RISCV_ISA_U}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zaamo { MODELPARAM_VALUE.RISCV_ISA_Zaamo PARAM_VALUE.RISCV_ISA_Zaamo } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zaamo}] ${MODELPARAM_VALUE.RISCV_ISA_Zaamo}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zba { MODELPARAM_VALUE.RISCV_ISA_Zba PARAM_VALUE.RISCV_ISA_Zba } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zba}] ${MODELPARAM_VALUE.RISCV_ISA_Zba}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zbb { MODELPARAM_VALUE.RISCV_ISA_Zbb PARAM_VALUE.RISCV_ISA_Zbb } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zbb}] ${MODELPARAM_VALUE.RISCV_ISA_Zbb}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zbkb { MODELPARAM_VALUE.RISCV_ISA_Zbkb PARAM_VALUE.RISCV_ISA_Zbkb } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zbkb}] ${MODELPARAM_VALUE.RISCV_ISA_Zbkb}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zbkc { MODELPARAM_VALUE.RISCV_ISA_Zbkc PARAM_VALUE.RISCV_ISA_Zbkc } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zbkc}] ${MODELPARAM_VALUE.RISCV_ISA_Zbkc}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zbkx { MODELPARAM_VALUE.RISCV_ISA_Zbkx PARAM_VALUE.RISCV_ISA_Zbkx } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zbkx}] ${MODELPARAM_VALUE.RISCV_ISA_Zbkx}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zbs { MODELPARAM_VALUE.RISCV_ISA_Zbs PARAM_VALUE.RISCV_ISA_Zbs } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zbs}] ${MODELPARAM_VALUE.RISCV_ISA_Zbs}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zfinx { MODELPARAM_VALUE.RISCV_ISA_Zfinx PARAM_VALUE.RISCV_ISA_Zfinx } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zfinx}] ${MODELPARAM_VALUE.RISCV_ISA_Zfinx}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zicntr { MODELPARAM_VALUE.RISCV_ISA_Zicntr PARAM_VALUE.RISCV_ISA_Zicntr } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zicntr}] ${MODELPARAM_VALUE.RISCV_ISA_Zicntr}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zicond { MODELPARAM_VALUE.RISCV_ISA_Zicond PARAM_VALUE.RISCV_ISA_Zicond } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zicond}] ${MODELPARAM_VALUE.RISCV_ISA_Zicond}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zihpm { MODELPARAM_VALUE.RISCV_ISA_Zihpm PARAM_VALUE.RISCV_ISA_Zihpm } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zihpm}] ${MODELPARAM_VALUE.RISCV_ISA_Zihpm}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zmmul { MODELPARAM_VALUE.RISCV_ISA_Zmmul PARAM_VALUE.RISCV_ISA_Zmmul } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zmmul}] ${MODELPARAM_VALUE.RISCV_ISA_Zmmul}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zknd { MODELPARAM_VALUE.RISCV_ISA_Zknd PARAM_VALUE.RISCV_ISA_Zknd } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zknd}] ${MODELPARAM_VALUE.RISCV_ISA_Zknd}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zkne { MODELPARAM_VALUE.RISCV_ISA_Zkne PARAM_VALUE.RISCV_ISA_Zkne } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zkne}] ${MODELPARAM_VALUE.RISCV_ISA_Zkne}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zknh { MODELPARAM_VALUE.RISCV_ISA_Zknh PARAM_VALUE.RISCV_ISA_Zknh } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zknh}] ${MODELPARAM_VALUE.RISCV_ISA_Zknh}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zksed { MODELPARAM_VALUE.RISCV_ISA_Zksed PARAM_VALUE.RISCV_ISA_Zksed } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zksed}] ${MODELPARAM_VALUE.RISCV_ISA_Zksed}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zksh { MODELPARAM_VALUE.RISCV_ISA_Zksh PARAM_VALUE.RISCV_ISA_Zksh } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zksh}] ${MODELPARAM_VALUE.RISCV_ISA_Zksh}
}

proc update_MODELPARAM_VALUE.RISCV_ISA_Zxcfu { MODELPARAM_VALUE.RISCV_ISA_Zxcfu PARAM_VALUE.RISCV_ISA_Zxcfu } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_ISA_Zxcfu}] ${MODELPARAM_VALUE.RISCV_ISA_Zxcfu}
}

proc update_MODELPARAM_VALUE.CPU_FAST_MUL_EN { MODELPARAM_VALUE.CPU_FAST_MUL_EN PARAM_VALUE.CPU_FAST_MUL_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CPU_FAST_MUL_EN}] ${MODELPARAM_VALUE.CPU_FAST_MUL_EN}
}

proc update_MODELPARAM_VALUE.CPU_FAST_SHIFT_EN { MODELPARAM_VALUE.CPU_FAST_SHIFT_EN PARAM_VALUE.CPU_FAST_SHIFT_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CPU_FAST_SHIFT_EN}] ${MODELPARAM_VALUE.CPU_FAST_SHIFT_EN}
}

proc update_MODELPARAM_VALUE.CPU_RF_HW_RST_EN { MODELPARAM_VALUE.CPU_RF_HW_RST_EN PARAM_VALUE.CPU_RF_HW_RST_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CPU_RF_HW_RST_EN}] ${MODELPARAM_VALUE.CPU_RF_HW_RST_EN}
}

proc update_MODELPARAM_VALUE.PMP_NUM_REGIONS { MODELPARAM_VALUE.PMP_NUM_REGIONS PARAM_VALUE.PMP_NUM_REGIONS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PMP_NUM_REGIONS}] ${MODELPARAM_VALUE.PMP_NUM_REGIONS}
}

proc update_MODELPARAM_VALUE.PMP_MIN_GRANULARITY { MODELPARAM_VALUE.PMP_MIN_GRANULARITY PARAM_VALUE.PMP_MIN_GRANULARITY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PMP_MIN_GRANULARITY}] ${MODELPARAM_VALUE.PMP_MIN_GRANULARITY}
}

proc update_MODELPARAM_VALUE.PMP_TOR_MODE_EN { MODELPARAM_VALUE.PMP_TOR_MODE_EN PARAM_VALUE.PMP_TOR_MODE_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PMP_TOR_MODE_EN}] ${MODELPARAM_VALUE.PMP_TOR_MODE_EN}
}

proc update_MODELPARAM_VALUE.PMP_NAP_MODE_EN { MODELPARAM_VALUE.PMP_NAP_MODE_EN PARAM_VALUE.PMP_NAP_MODE_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PMP_NAP_MODE_EN}] ${MODELPARAM_VALUE.PMP_NAP_MODE_EN}
}

proc update_MODELPARAM_VALUE.HPM_NUM_CNTS { MODELPARAM_VALUE.HPM_NUM_CNTS PARAM_VALUE.HPM_NUM_CNTS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HPM_NUM_CNTS}] ${MODELPARAM_VALUE.HPM_NUM_CNTS}
}

proc update_MODELPARAM_VALUE.HPM_CNT_WIDTH { MODELPARAM_VALUE.HPM_CNT_WIDTH PARAM_VALUE.HPM_CNT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HPM_CNT_WIDTH}] ${MODELPARAM_VALUE.HPM_CNT_WIDTH}
}

proc update_MODELPARAM_VALUE.MEM_INT_IMEM_EN { MODELPARAM_VALUE.MEM_INT_IMEM_EN PARAM_VALUE.MEM_INT_IMEM_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_INT_IMEM_EN}] ${MODELPARAM_VALUE.MEM_INT_IMEM_EN}
}

proc update_MODELPARAM_VALUE.MEM_INT_IMEM_SIZE { MODELPARAM_VALUE.MEM_INT_IMEM_SIZE PARAM_VALUE.MEM_INT_IMEM_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_INT_IMEM_SIZE}] ${MODELPARAM_VALUE.MEM_INT_IMEM_SIZE}
}

proc update_MODELPARAM_VALUE.MEM_INT_DMEM_EN { MODELPARAM_VALUE.MEM_INT_DMEM_EN PARAM_VALUE.MEM_INT_DMEM_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_INT_DMEM_EN}] ${MODELPARAM_VALUE.MEM_INT_DMEM_EN}
}

proc update_MODELPARAM_VALUE.MEM_INT_DMEM_SIZE { MODELPARAM_VALUE.MEM_INT_DMEM_SIZE PARAM_VALUE.MEM_INT_DMEM_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_INT_DMEM_SIZE}] ${MODELPARAM_VALUE.MEM_INT_DMEM_SIZE}
}

proc update_MODELPARAM_VALUE.ICACHE_EN { MODELPARAM_VALUE.ICACHE_EN PARAM_VALUE.ICACHE_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ICACHE_EN}] ${MODELPARAM_VALUE.ICACHE_EN}
}

proc update_MODELPARAM_VALUE.ICACHE_NUM_BLOCKS { MODELPARAM_VALUE.ICACHE_NUM_BLOCKS PARAM_VALUE.ICACHE_NUM_BLOCKS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ICACHE_NUM_BLOCKS}] ${MODELPARAM_VALUE.ICACHE_NUM_BLOCKS}
}

proc update_MODELPARAM_VALUE.ICACHE_BLOCK_SIZE { MODELPARAM_VALUE.ICACHE_BLOCK_SIZE PARAM_VALUE.ICACHE_BLOCK_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ICACHE_BLOCK_SIZE}] ${MODELPARAM_VALUE.ICACHE_BLOCK_SIZE}
}

proc update_MODELPARAM_VALUE.DCACHE_EN { MODELPARAM_VALUE.DCACHE_EN PARAM_VALUE.DCACHE_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DCACHE_EN}] ${MODELPARAM_VALUE.DCACHE_EN}
}

proc update_MODELPARAM_VALUE.DCACHE_NUM_BLOCKS { MODELPARAM_VALUE.DCACHE_NUM_BLOCKS PARAM_VALUE.DCACHE_NUM_BLOCKS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DCACHE_NUM_BLOCKS}] ${MODELPARAM_VALUE.DCACHE_NUM_BLOCKS}
}

proc update_MODELPARAM_VALUE.DCACHE_BLOCK_SIZE { MODELPARAM_VALUE.DCACHE_BLOCK_SIZE PARAM_VALUE.DCACHE_BLOCK_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DCACHE_BLOCK_SIZE}] ${MODELPARAM_VALUE.DCACHE_BLOCK_SIZE}
}

proc update_MODELPARAM_VALUE.XBUS_EN { MODELPARAM_VALUE.XBUS_EN PARAM_VALUE.XBUS_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.XBUS_EN}] ${MODELPARAM_VALUE.XBUS_EN}
}

proc update_MODELPARAM_VALUE.XBUS_TIMEOUT { MODELPARAM_VALUE.XBUS_TIMEOUT PARAM_VALUE.XBUS_TIMEOUT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.XBUS_TIMEOUT}] ${MODELPARAM_VALUE.XBUS_TIMEOUT}
}

proc update_MODELPARAM_VALUE.XBUS_REGSTAGE_EN { MODELPARAM_VALUE.XBUS_REGSTAGE_EN PARAM_VALUE.XBUS_REGSTAGE_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.XBUS_REGSTAGE_EN}] ${MODELPARAM_VALUE.XBUS_REGSTAGE_EN}
}

proc update_MODELPARAM_VALUE.XBUS_CACHE_EN { MODELPARAM_VALUE.XBUS_CACHE_EN PARAM_VALUE.XBUS_CACHE_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.XBUS_CACHE_EN}] ${MODELPARAM_VALUE.XBUS_CACHE_EN}
}

proc update_MODELPARAM_VALUE.XBUS_CACHE_NUM_BLOCKS { MODELPARAM_VALUE.XBUS_CACHE_NUM_BLOCKS PARAM_VALUE.XBUS_CACHE_NUM_BLOCKS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.XBUS_CACHE_NUM_BLOCKS}] ${MODELPARAM_VALUE.XBUS_CACHE_NUM_BLOCKS}
}

proc update_MODELPARAM_VALUE.XBUS_CACHE_BLOCK_SIZE { MODELPARAM_VALUE.XBUS_CACHE_BLOCK_SIZE PARAM_VALUE.XBUS_CACHE_BLOCK_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.XBUS_CACHE_BLOCK_SIZE}] ${MODELPARAM_VALUE.XBUS_CACHE_BLOCK_SIZE}
}

proc update_MODELPARAM_VALUE.XIP_EN { MODELPARAM_VALUE.XIP_EN PARAM_VALUE.XIP_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.XIP_EN}] ${MODELPARAM_VALUE.XIP_EN}
}

proc update_MODELPARAM_VALUE.XIP_CACHE_EN { MODELPARAM_VALUE.XIP_CACHE_EN PARAM_VALUE.XIP_CACHE_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.XIP_CACHE_EN}] ${MODELPARAM_VALUE.XIP_CACHE_EN}
}

proc update_MODELPARAM_VALUE.XIP_CACHE_NUM_BLOCKS { MODELPARAM_VALUE.XIP_CACHE_NUM_BLOCKS PARAM_VALUE.XIP_CACHE_NUM_BLOCKS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.XIP_CACHE_NUM_BLOCKS}] ${MODELPARAM_VALUE.XIP_CACHE_NUM_BLOCKS}
}

proc update_MODELPARAM_VALUE.XIP_CACHE_BLOCK_SIZE { MODELPARAM_VALUE.XIP_CACHE_BLOCK_SIZE PARAM_VALUE.XIP_CACHE_BLOCK_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.XIP_CACHE_BLOCK_SIZE}] ${MODELPARAM_VALUE.XIP_CACHE_BLOCK_SIZE}
}

proc update_MODELPARAM_VALUE.IO_GPIO_EN { MODELPARAM_VALUE.IO_GPIO_EN PARAM_VALUE.IO_GPIO_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_GPIO_EN}] ${MODELPARAM_VALUE.IO_GPIO_EN}
}

proc update_MODELPARAM_VALUE.IO_GPIO_IN_NUM { MODELPARAM_VALUE.IO_GPIO_IN_NUM PARAM_VALUE.IO_GPIO_IN_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_GPIO_IN_NUM}] ${MODELPARAM_VALUE.IO_GPIO_IN_NUM}
}

proc update_MODELPARAM_VALUE.IO_GPIO_OUT_NUM { MODELPARAM_VALUE.IO_GPIO_OUT_NUM PARAM_VALUE.IO_GPIO_OUT_NUM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_GPIO_OUT_NUM}] ${MODELPARAM_VALUE.IO_GPIO_OUT_NUM}
}

proc update_MODELPARAM_VALUE.IO_CLINT_EN { MODELPARAM_VALUE.IO_CLINT_EN PARAM_VALUE.IO_CLINT_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_CLINT_EN}] ${MODELPARAM_VALUE.IO_CLINT_EN}
}

proc update_MODELPARAM_VALUE.IO_UART0_EN { MODELPARAM_VALUE.IO_UART0_EN PARAM_VALUE.IO_UART0_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_UART0_EN}] ${MODELPARAM_VALUE.IO_UART0_EN}
}

proc update_MODELPARAM_VALUE.IO_UART0_RX_FIFO { MODELPARAM_VALUE.IO_UART0_RX_FIFO PARAM_VALUE.IO_UART0_RX_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_UART0_RX_FIFO}] ${MODELPARAM_VALUE.IO_UART0_RX_FIFO}
}

proc update_MODELPARAM_VALUE.IO_UART0_TX_FIFO { MODELPARAM_VALUE.IO_UART0_TX_FIFO PARAM_VALUE.IO_UART0_TX_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_UART0_TX_FIFO}] ${MODELPARAM_VALUE.IO_UART0_TX_FIFO}
}

proc update_MODELPARAM_VALUE.IO_UART1_EN { MODELPARAM_VALUE.IO_UART1_EN PARAM_VALUE.IO_UART1_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_UART1_EN}] ${MODELPARAM_VALUE.IO_UART1_EN}
}

proc update_MODELPARAM_VALUE.IO_UART1_RX_FIFO { MODELPARAM_VALUE.IO_UART1_RX_FIFO PARAM_VALUE.IO_UART1_RX_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_UART1_RX_FIFO}] ${MODELPARAM_VALUE.IO_UART1_RX_FIFO}
}

proc update_MODELPARAM_VALUE.IO_UART1_TX_FIFO { MODELPARAM_VALUE.IO_UART1_TX_FIFO PARAM_VALUE.IO_UART1_TX_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_UART1_TX_FIFO}] ${MODELPARAM_VALUE.IO_UART1_TX_FIFO}
}

proc update_MODELPARAM_VALUE.IO_SPI_EN { MODELPARAM_VALUE.IO_SPI_EN PARAM_VALUE.IO_SPI_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_SPI_EN}] ${MODELPARAM_VALUE.IO_SPI_EN}
}

proc update_MODELPARAM_VALUE.IO_SPI_FIFO { MODELPARAM_VALUE.IO_SPI_FIFO PARAM_VALUE.IO_SPI_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_SPI_FIFO}] ${MODELPARAM_VALUE.IO_SPI_FIFO}
}

proc update_MODELPARAM_VALUE.IO_SDI_EN { MODELPARAM_VALUE.IO_SDI_EN PARAM_VALUE.IO_SDI_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_SDI_EN}] ${MODELPARAM_VALUE.IO_SDI_EN}
}

proc update_MODELPARAM_VALUE.IO_SDI_FIFO { MODELPARAM_VALUE.IO_SDI_FIFO PARAM_VALUE.IO_SDI_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_SDI_FIFO}] ${MODELPARAM_VALUE.IO_SDI_FIFO}
}

proc update_MODELPARAM_VALUE.IO_TWI_EN { MODELPARAM_VALUE.IO_TWI_EN PARAM_VALUE.IO_TWI_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_TWI_EN}] ${MODELPARAM_VALUE.IO_TWI_EN}
}

proc update_MODELPARAM_VALUE.IO_TWI_FIFO { MODELPARAM_VALUE.IO_TWI_FIFO PARAM_VALUE.IO_TWI_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_TWI_FIFO}] ${MODELPARAM_VALUE.IO_TWI_FIFO}
}

proc update_MODELPARAM_VALUE.IO_TWD_EN { MODELPARAM_VALUE.IO_TWD_EN PARAM_VALUE.IO_TWD_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_TWD_EN}] ${MODELPARAM_VALUE.IO_TWD_EN}
}

proc update_MODELPARAM_VALUE.IO_TWD_FIFO { MODELPARAM_VALUE.IO_TWD_FIFO PARAM_VALUE.IO_TWD_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_TWD_FIFO}] ${MODELPARAM_VALUE.IO_TWD_FIFO}
}

proc update_MODELPARAM_VALUE.IO_PWM_EN { MODELPARAM_VALUE.IO_PWM_EN PARAM_VALUE.IO_PWM_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_PWM_EN}] ${MODELPARAM_VALUE.IO_PWM_EN}
}

proc update_MODELPARAM_VALUE.IO_PWM_NUM_CH { MODELPARAM_VALUE.IO_PWM_NUM_CH PARAM_VALUE.IO_PWM_NUM_CH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_PWM_NUM_CH}] ${MODELPARAM_VALUE.IO_PWM_NUM_CH}
}

proc update_MODELPARAM_VALUE.IO_WDT_EN { MODELPARAM_VALUE.IO_WDT_EN PARAM_VALUE.IO_WDT_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_WDT_EN}] ${MODELPARAM_VALUE.IO_WDT_EN}
}

proc update_MODELPARAM_VALUE.IO_TRNG_EN { MODELPARAM_VALUE.IO_TRNG_EN PARAM_VALUE.IO_TRNG_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_TRNG_EN}] ${MODELPARAM_VALUE.IO_TRNG_EN}
}

proc update_MODELPARAM_VALUE.IO_TRNG_FIFO { MODELPARAM_VALUE.IO_TRNG_FIFO PARAM_VALUE.IO_TRNG_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_TRNG_FIFO}] ${MODELPARAM_VALUE.IO_TRNG_FIFO}
}

proc update_MODELPARAM_VALUE.IO_CFS_EN { MODELPARAM_VALUE.IO_CFS_EN PARAM_VALUE.IO_CFS_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_CFS_EN}] ${MODELPARAM_VALUE.IO_CFS_EN}
}

proc update_MODELPARAM_VALUE.IO_CFS_CONFIG { MODELPARAM_VALUE.IO_CFS_CONFIG PARAM_VALUE.IO_CFS_CONFIG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_CFS_CONFIG}] ${MODELPARAM_VALUE.IO_CFS_CONFIG}
}

proc update_MODELPARAM_VALUE.IO_CFS_IN_SIZE { MODELPARAM_VALUE.IO_CFS_IN_SIZE PARAM_VALUE.IO_CFS_IN_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_CFS_IN_SIZE}] ${MODELPARAM_VALUE.IO_CFS_IN_SIZE}
}

proc update_MODELPARAM_VALUE.IO_CFS_OUT_SIZE { MODELPARAM_VALUE.IO_CFS_OUT_SIZE PARAM_VALUE.IO_CFS_OUT_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_CFS_OUT_SIZE}] ${MODELPARAM_VALUE.IO_CFS_OUT_SIZE}
}

proc update_MODELPARAM_VALUE.IO_NEOLED_EN { MODELPARAM_VALUE.IO_NEOLED_EN PARAM_VALUE.IO_NEOLED_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_NEOLED_EN}] ${MODELPARAM_VALUE.IO_NEOLED_EN}
}

proc update_MODELPARAM_VALUE.IO_NEOLED_TX_FIFO { MODELPARAM_VALUE.IO_NEOLED_TX_FIFO PARAM_VALUE.IO_NEOLED_TX_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_NEOLED_TX_FIFO}] ${MODELPARAM_VALUE.IO_NEOLED_TX_FIFO}
}

proc update_MODELPARAM_VALUE.IO_GPTMR_EN { MODELPARAM_VALUE.IO_GPTMR_EN PARAM_VALUE.IO_GPTMR_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_GPTMR_EN}] ${MODELPARAM_VALUE.IO_GPTMR_EN}
}

proc update_MODELPARAM_VALUE.IO_ONEWIRE_EN { MODELPARAM_VALUE.IO_ONEWIRE_EN PARAM_VALUE.IO_ONEWIRE_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_ONEWIRE_EN}] ${MODELPARAM_VALUE.IO_ONEWIRE_EN}
}

proc update_MODELPARAM_VALUE.IO_DMA_EN { MODELPARAM_VALUE.IO_DMA_EN PARAM_VALUE.IO_DMA_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_DMA_EN}] ${MODELPARAM_VALUE.IO_DMA_EN}
}

proc update_MODELPARAM_VALUE.IO_SLINK_EN { MODELPARAM_VALUE.IO_SLINK_EN PARAM_VALUE.IO_SLINK_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_SLINK_EN}] ${MODELPARAM_VALUE.IO_SLINK_EN}
}

proc update_MODELPARAM_VALUE.IO_SLINK_RX_FIFO { MODELPARAM_VALUE.IO_SLINK_RX_FIFO PARAM_VALUE.IO_SLINK_RX_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_SLINK_RX_FIFO}] ${MODELPARAM_VALUE.IO_SLINK_RX_FIFO}
}

proc update_MODELPARAM_VALUE.IO_SLINK_TX_FIFO { MODELPARAM_VALUE.IO_SLINK_TX_FIFO PARAM_VALUE.IO_SLINK_TX_FIFO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_SLINK_TX_FIFO}] ${MODELPARAM_VALUE.IO_SLINK_TX_FIFO}
}

proc update_MODELPARAM_VALUE.IO_CRC_EN { MODELPARAM_VALUE.IO_CRC_EN PARAM_VALUE.IO_CRC_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IO_CRC_EN}] ${MODELPARAM_VALUE.IO_CRC_EN}
}

