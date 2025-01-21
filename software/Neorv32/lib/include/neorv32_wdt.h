// ================================================================================ //
// The NEORV32 RISC-V Processor - https://github.com/stnolting/neorv32              //
// Copyright (c) NEORV32 contributors.                                              //
// Copyright (c) 2020 - 2024 Stephan Nolting. All rights reserved.                  //
// Licensed under the BSD-3-Clause license, see LICENSE for details.                //
// SPDX-License-Identifier: BSD-3-Clause                                            //
// ================================================================================ //

/**
 * @file neorv32_wdt.h
 * @brief Watchdog Timer (WDT) HW driver header file.
 *
 * @note These functions should only be used if the WDT unit was synthesized (IO_WDT_EN = true).
 *
 * @see https://stnolting.github.io/neorv32/sw/files.html
 */

#ifndef neorv32_wdt_h
#define neorv32_wdt_h

#include <stdint.h>


/**********************************************************************//**
 * @name IO Device: Watchdog Timer (WDT)
 **************************************************************************/
/**@{*/
/** WDT module prototype */
typedef volatile struct __attribute__((packed,aligned(4))) {
  uint32_t CTRL;  /**< offset 0: control register (#NEORV32_WDT_CTRL_enum) */
  uint32_t RESET; /**< offset 4: WDT reset trigger (write password to "feed" watchdog) */
} neorv32_wdt_t;

/** WDT module hardware access (#neorv32_wdt_t) */
#define NEORV32_WDT ((neorv32_wdt_t*) (NEORV32_WDT_BASE))

/** WDT control register bits */
enum NEORV32_WDT_CTRL_enum {
  WDT_CTRL_EN          =  0, /**< WDT control register(0) (r/w): Watchdog enable */
  WDT_CTRL_LOCK        =  1, /**< WDT control register(1) (r/w): Lock write access to control register, clears on reset only */
  WDT_CTRL_DBEN        =  2, /**< WDT control register(2) (r/w): Allow WDT to continue operation even when CPU is in debug mode */
  WDT_CTRL_SEN         =  3, /**< WDT control register(3) (r/w): Allow WDT to continue operation even when CPU is in sleep mode */
  WDT_CTRL_STRICT      =  4, /**< WDT control register(4) (r/w): Force hardware reset if reset password is incorrect or if write attempt to locked CTRL register */
  WDT_CTRL_RCAUSE_LO   =  5, /**< WDT control register(5) (r/-): Cause of last system reset - low */
  WDT_CTRL_RCAUSE_HI   =  6, /**< WDT control register(5) (r/-): Cause of last system reset - high */

  WDT_CTRL_TIMEOUT_LSB =  8, /**< WDT control register(8)  (r/w): Timeout value, LSB */
  WDT_CTRL_TIMEOUT_MSB = 31  /**< WDT control register(31) (r/w): Timeout value, MSB */
};
/**@}*/


/**********************************************************************//**
 * Reset Password
 **************************************************************************/
#define WDT_PASSWORD (0x709D1AB3)


/**********************************************************************//**
 * Reset Cause
 **************************************************************************/
enum NEORV32_WDT_RCAUSE_enum {
  WDT_RCAUSE_EXT = 0b00, /**< Reset caused by external signal/pin */
  WDT_RCAUSE_OCD = 0b01, /**< Reset caused by on-chip debugger */
  WDT_RCAUSE_TMO = 0b10, /**< Reset caused by watchdog timer timeout */
  WDT_RCAUSE_ACC = 0b11  /**< Reset caused by watchdog timer invalid access */
};


/**********************************************************************//**
 * @name Prototypes
 **************************************************************************/
/**@{*/
int  neorv32_wdt_available(void);
void neorv32_wdt_setup(uint32_t timeout, int lock, int debug_en, int sleep_en, int strict);
int  neorv32_wdt_disable(void);
void neorv32_wdt_feed(uint32_t password);
int  neorv32_wdt_get_cause(void);
/**@}*/


#endif // neorv32_wdt_h
