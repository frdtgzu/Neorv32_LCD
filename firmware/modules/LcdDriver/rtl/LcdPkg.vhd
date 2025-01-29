library ieee;
use ieee.std_logic_1164.all;

library surf;
use surf.StdRtlPkg.all;

package LcdPkg is
    
   type LcdStatType is record
      start : sl;
   end record LcdStatType;
      
   constant LCD_STAT_INIT_C : LcdStatType := (
      start => '0'
   );
   
   type LcdCtrlType is record
      
   end record LcdCtrlType;
   
   constant LCD_CTRL_INIT_C : LcdCtrlType := (
      
   );   
   
    
end package LcdPkg;

package body LcdPkg is
    
end package body LcdPkg;