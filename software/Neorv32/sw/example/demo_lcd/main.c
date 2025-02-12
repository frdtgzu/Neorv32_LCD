// ================================================================================ //
// The NEORV32 RISC-V Processor - https://github.com/stnolting/neorv32              //
// Copyright (c) NEORV32 contributors.                                              //
// Copyright (c) 2020 - 2024 Stephan Nolting. All rights reserved.                  //
// Licensed under the BSD-3-Clause license, see LICENSE for details.                //
// SPDX-License-Identifier: BSD-3-Clause                                            //
// ================================================================================ //

/**********************************************************************//**
 * ORIGINAL FILE
 * @file bus_explorer/main.c
 * @author Stephan Nolting
 * @brief Interactive memory inspector.
 **************************************************************************/


/**********************************************************************//**
 * MODIFICATIONS 
 * @file demo_lcd/main.c
 * @author Vid Balant
 * @brief Demo for 16*2 LCD module on AXI memory.
 **************************************************************************/

#include <neorv32.h>
#include <string.h>


/**********************************************************************//**
 * @name User configuration
 **************************************************************************/
/**@{*/
/** UART BAUD rate */
#define BAUD_RATE 19200
/**@}*/

// Global variables
const uint32_t lcdAddr = 0x91000000;

// Prototypes
void read_memory(uint32_t address);
void write_memory(uint32_t address, uint32_t data);
void aux_print_hex_byte(uint8_t byte);
void lcd_write(void);
void lcd_read(void);


/**********************************************************************//**
 * GPIO input pin(s) interrupt handler.
 **************************************************************************/
void gpio_interrupt_handler(void) {

  // get bit mask of all those input pin that caused this interrupt
  uint32_t active = neorv32_gpio_irq_get();

  // clear the active pins that we are "handling" here
  neorv32_gpio_irq_clr(active);

  // "handle" the individual pin interrupts:
  // we just print the pin number of the triggering inputs
  int i;
  neorv32_uart0_printf("\nGPIO interrupt from pin(s): ");
  for (i=0; i<32; i++) {
    if (active & 1) {
      neorv32_uart0_printf("%u ", i);
    }
    active = active >> 1;
  }
  neorv32_uart0_printf("\n");

  neorv32_cpu_store_unsigned_byte(0x90000000, 0);
  neorv32_uart0_printf("Writing data to LCD\n"); 
  neorv32_cpu_store_unsigned_byte(0x90000000, 1);
  neorv32_uart0_printf("Data written\n");  

}



/**********************************************************************//**
 * This program provides an interactive console to read/write memory.
 *
 * @note This program requires the UART to be synthesized.
 *
 * @return 0 if execution was successful
 **************************************************************************/
int main() {

  char buffer[20];
  char strtok_delimiter[] = " ";
  int length = 0;

  // check if UART unit is implemented at all
  if (neorv32_uart0_available() == 0) {
    return 1;
  }

  // check hardware/software configuration
  if (neorv32_gpio_available() == 0) { // GPIO available?
    neorv32_uart0_printf("[ERROR] GPIO module not available!\n");
    return -1;
  }

  // capture all exceptions and give debug info via UART
  neorv32_rte_setup();

  // configure CPU's GPIO controller interrupt
  neorv32_rte_handler_install(GPIO_RTE_ID, gpio_interrupt_handler); // install GPIO trap handler
  neorv32_cpu_csr_set(CSR_MIE, 1 << GPIO_FIRQ_ENABLE); // enable GPIO FIRQ channel
  neorv32_cpu_csr_set(CSR_MSTATUS, 1 << CSR_MSTATUS_MIE); // enable machine-mode interrupts

  // configure GPIO input's IRQ trigger
  neorv32_gpio_irq_setup(2, GPIO_TRIG_EDGE_RISING); // this pin's interrupt fires on a rising edge

  // enable wanted GPIO input pin interrupt 
  neorv32_gpio_irq_enable(0x00000004);  // enable interrupt on pin gpi(2)

  // setup UART at default baud rate, no interrupts
  neorv32_uart0_setup(BAUD_RATE, 0);

  // intro
  neorv32_uart0_printf("\n<<< NEORV32 LCD demo >>>\n\n");

  // info
  neorv32_uart0_printf("This program allows to read/write to memory space by hand.\n"
                       "Modefied to read/write to LCD module on AXI memory.\n"
                       "Type 'help' to see the help menu.\n\n");

  // Main menu
  for (;;) {
    neorv32_uart0_printf("BUS_EXPLORER:> ");
    length = neorv32_uart0_scan(buffer, 32, 1);
    neorv32_uart0_printf("\n");

    if (!length) { // nothing to be done
      continue;
    }

    char* command;
    char* arg0;
    char* arg1;

    command = strtok(buffer, strtok_delimiter);
    arg0 = strtok(NULL, strtok_delimiter);
    arg1 = strtok(NULL, strtok_delimiter);

    // decode input and execute command
    if ((!strcmp(command, "help")) || (command == NULL)) {
      neorv32_uart0_printf("Available commands:\n"
                          " help                   - show this text\n"
                          " read <address>         - read from address (byte)\n"
                          " write <address> <data> - write data to address (byte)\n"
                          " lcdwrite               - write data to LCD\n"
                          " lcdread                - display LCD data\n" 
                          "\n"
                          "NOTE: <address> and <data> are hexadecimal numbers without prefix.\n"
                          "Example: write 80000020 feedcafe\n"
                          );
    }

    else if (!strcmp(command, "read")) {
      if (arg0 == NULL) {
        neorv32_uart0_printf("Insufficient arguments.\n");
      }
      else {
        read_memory((uint32_t)neorv32_aux_hexstr2uint64(arg0, 8));
      }
    }

    else if (!strcmp(command, "write")) {
      if ((arg0 == NULL) || (arg1 == NULL)) {
        neorv32_uart0_printf("Insufficient arguments.\n");
      }
      else {
        write_memory((uint32_t)neorv32_aux_hexstr2uint64(arg0, 8), (uint32_t)neorv32_aux_hexstr2uint64(arg1, 8));
      }
    }

    else if (!strcmp(command, "lcdwrite")) {
      lcd_write();
    }

    else if (!strcmp(command, "lcdread")) {
      lcd_read();
    }

    else {
      neorv32_uart0_printf("Invalid command. Type 'help' to see all commands.\n");
    }
  }

  return 0;
}

/**********************************************************************//**
 * Read from memory address
 **************************************************************************/
void read_memory(uint32_t address) {

  // perform read access

  uint8_t mem_data_b = 0;
  mem_data_b = neorv32_cpu_load_unsigned_byte(address);
  
  neorv32_uart0_printf("[0x%x] => %u\n", address, mem_data_b);
}


/**********************************************************************//**
 * Write to memory address
 **************************************************************************/
void write_memory(uint32_t address, uint32_t data) {

  neorv32_uart0_printf("[0x%x] <= 0x%u", address, (uint8_t)data);

  // perform write access
  neorv32_cpu_store_unsigned_byte(address, (uint8_t)data); 

  neorv32_uart0_printf("\n");
}

/**********************************************************************//**
 * Write to LCD module
 **************************************************************************/
void lcd_write(void) {
  uint8_t busy = 0;
  uint8_t mode = 0;
  uint8_t length = 0;
  char temp[17];  
  char lcd_data[33] = "                                ";
  // Clean the LCD data
  for(int i = 0; i < 32; i++) {
    if (i < 16) {
      neorv32_cpu_store_unsigned_byte(lcdAddr + i, (uint8_t)lcd_data[i]);
    }
    else {
      neorv32_cpu_store_unsigned_byte(lcdAddr + i + 24, (uint8_t)lcd_data[i]);
    }
  }

  // Select write mode
  neorv32_uart0_printf("Enter write mode (0 - both lines, 1 - one line at a time): ");
  while(1) {
    mode = neorv32_uart0_getc();
   
    if (mode == '0' || mode == '1') {
      break;
    }
    else {
      neorv32_uart0_printf("\n");       
      neorv32_uart0_printf("Invalid mode. Enter 0 or 1: ");
    }
  }
  neorv32_uart0_printf("%c", mode);
  // LCD Busy indicator
  while (neorv32_gpio_pin_get(0) == 1) {
    if (busy == 0) {
      neorv32_uart0_printf("\n"); 
      neorv32_uart0_printf("LCD is busy. Please wait.\n");
      busy = 1;
    }
    neorv32_cpu_sleep();
  }

  // Write to LCD
  if (mode == '0') {
    neorv32_uart0_printf("\n");
    neorv32_uart0_printf("Enter data: ");
    length = neorv32_uart0_scan(lcd_data, 33, 1);
    for(int i = 0; i < length; i++) {
      if (i < 16) {
        neorv32_cpu_store_unsigned_byte(lcdAddr + i, (uint8_t)lcd_data[i]);     
      }
      else {
        neorv32_cpu_store_unsigned_byte(lcdAddr + i + 24, (uint8_t)lcd_data[i]);
      }
         
    } 
  }
  else {
    neorv32_uart0_printf("\n");
    neorv32_uart0_printf("Enter data for first line: ");
    length = neorv32_uart0_scan(temp, 17, 1);
    for(int i = 0; i < length; i++) {
      neorv32_cpu_store_unsigned_byte(lcdAddr + i, (uint8_t)temp[i]);      
    } 
    neorv32_uart0_printf("\n");
    neorv32_uart0_printf("Enter data for second line: ");
    length = neorv32_uart0_scan(temp, 17, 1);
    for(int i = 0; i < length; i++) {
      neorv32_cpu_store_unsigned_byte(lcdAddr + 40 + i, (uint8_t)temp[i]);      
    }
  }
  if (neorv32_gpio_pin_get(1) == 0) {
    // Trigger rising edge on LCD
    neorv32_uart0_printf("\n");
    neorv32_cpu_store_unsigned_byte(0x90000000, 0);
    neorv32_uart0_printf("Writing data to LCD\n"); 
    neorv32_cpu_store_unsigned_byte(0x90000000, 1);
    neorv32_uart0_printf("Data written\n");  
  }
  else {
    neorv32_uart0_printf("\n");    
    neorv32_uart0_printf("Waiting for intterupt to send data\n");
  }
}


/**********************************************************************//**
 * Read from LCD module
 **************************************************************************/

void lcd_read(void) {

  char lcd_data[33];

  for (int i = 0; i < 32; i++) {
    if(i < 16) {
      lcd_data[i] = (char)neorv32_cpu_load_unsigned_byte(lcdAddr + i);
    }
    else
      lcd_data[i] = (char)neorv32_cpu_load_unsigned_byte(lcdAddr + i + 24);
  }
  
  neorv32_uart0_printf("LCD data: ");
  
  for (int i = 0; i < 32; i++) {
    neorv32_uart0_printf("%c", lcd_data[i]);
  }
  neorv32_uart0_printf("\n");
}