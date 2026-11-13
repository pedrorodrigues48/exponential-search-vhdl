-------------------------------------------------------------------------
-- Design unit: Package do ExponentialSearch
-- Description: Records com os sinais entre
--                  ControlPath e DataPath
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package ExponentialSearch_pkg is

    type Command is record
        ldBase      : std_logic;
        ldLen       : std_logic;
        ldKey       : std_logic;
        ldI         : std_logic;
        selI        : std_logic;
        ldLeft      : std_logic;
        selLeft     : std_logic;
        ldRight     : std_logic;
        selRight    : std_logic;
        ldMid       : std_logic;
        selIdx      : std_logic;
        ldMem       : std_logic;
        ldPos       : std_logic;
        selPos      : std_logic;
        aluOp       : std_logic_vector(2 downto 0);
        cmpSel      : std_logic_vector(2 downto 0);
    end record;

    type Status is record
        lenZero     : std_logic;
        midZero     : std_logic;
        EQ          : std_logic;
        GE          : std_logic;
    end record;

end ExponentialSearch_pkg;
