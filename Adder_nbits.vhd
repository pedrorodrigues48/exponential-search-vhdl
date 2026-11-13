-------------------------------------------------------------------------
-- Design unit: Adder_nbits
-- Description: n-bits adder (n full adders)
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity Adder_nbits is
    generic (
        n           : integer := 8      -- n bits
    );
    port (
        -- Inputs
        A, B        : in std_logic_vector(n-1 downto 0);
        CarryIn     : in std_logic;

        -- Outputs
        Sum         : out std_logic_vector(n-1 downto 0);
        CarryOut    : out std_logic
    );
end Adder_nbits;


architecture structural_generic of Adder_nbits is

    signal Carry: std_logic_vector(n downto 0);

begin

    Carry(0) <= CarryIn;
    CarryOut <= Carry(n);

    AdderBit: for i in A'range generate

        FullAdder: Entity work.FullAdder(arch1) port map (
            A       => A(i),
            B       => B(i),
            Ci      => Carry(i),
            S       => Sum(i),
            Co      => Carry(i + 1)
        );
    end generate;

end structural_generic;
