-------------------------------------------------------------------------
-- Design unit: Test bench do ControlPath
-- Description: Teste do ControlPath
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.ExponentialSearch_pkg.all;

-- Test bench nao tem portas
entity ControlPath_tb  is
end ControlPath_tb;


-- Instancias e estimulos
architecture behavioral of ControlPath_tb is

    signal clk          : std_logic := '0';
    signal rst          : std_logic;
    signal data_av      : std_logic;
    signal done         : std_logic;
    signal ce, wr       : std_logic;
    signal sts          : Status;
    signal cmd          : Command;

begin

    -- Unidade em teste
    DUV: entity work.ControlPath(behavioral)
        port map (
            clk         => clk,
            rst         => rst,
            data_av     => data_av,
            done        => done,
            sts         => sts,
            cmd         => cmd,
            ce          => ce,
            wr          => wr
        );

    -- Estimulos
    rst <= '0', '1' after 10 ns, '0' after 15 ns;
    clk <= not clk after 20 ns;    -- 25 MHz

    process
    begin
        data_av <= '0';
        sts.lenZero <= '0';
        sts.midZero <= '0';
        sts.EQ <= '0';
        sts.GE <= '0';

        -- Busca 1
        wait until rising_edge(clk);
        wait until rising_edge(clk);
            data_av <= '1';     -- S0

        wait until rising_edge(clk);
            data_av <= '1';     -- S1

        wait until rising_edge(clk);
            data_av <= '1';     -- S2

        wait until rising_edge(clk);
            data_av <= '0';
            sts.lenZero <= '0'; -- S3

        wait until rising_edge(clk);
            sts.GE <= '0';      -- S4

        wait until rising_edge(clk);
            sts.GE <= '0';      -- S5

        wait until rising_edge(clk);
            sts.GE <= '1';      -- S4

        wait until rising_edge(clk);
            sts.GE <= '0';      -- S6

        wait until rising_edge(clk);
                                -- S7
        wait until rising_edge(clk);
            sts.GE <= '1';      -- S9

        wait until rising_edge(clk);
                                -- S10
        wait until rising_edge(clk);
                                -- S11
        wait until rising_edge(clk);
            sts.EQ <= '0';
            sts.GE <= '0';      -- S12

        wait until rising_edge(clk);
            sts.GE <= '1';      -- S9

        wait until rising_edge(clk);
                                -- S10
        wait until rising_edge(clk);
                                -- S11
        wait until rising_edge(clk);
            sts.EQ <= '1';      -- S12

        wait until rising_edge(clk);
            sts.EQ <= '0';
            sts.GE <= '0';      -- S13

        -- Busca 2
        wait until rising_edge(clk);
            data_av <= '1';     -- S0

        wait until rising_edge(clk);
            data_av <= '1';     -- S1

        wait until rising_edge(clk);
            data_av <= '1';     -- S2

        wait until rising_edge(clk);
            data_av <= '0';
            sts.lenZero <= '1'; -- S3

        wait until rising_edge(clk);
            sts.lenZero <= '0'; -- S13

        -- Busca 3
        wait until rising_edge(clk);
        wait until rising_edge(clk);
            data_av <= '1';     -- S0

        wait until rising_edge(clk);
            data_av <= '0';     -- S1

        wait until rising_edge(clk);
            data_av <= '1';     -- S1

        wait until rising_edge(clk);
            data_av <= '0';     -- S2

        wait until rising_edge(clk);
            data_av <= '1';     -- S2

        wait until rising_edge(clk);
            data_av <= '0';     -- S3

        wait until rising_edge(clk);
            sts.GE <= '1';      -- S4

        wait until rising_edge(clk);
            sts.GE <= '1';      -- S6

        wait until rising_edge(clk);
                                -- S8
        wait until rising_edge(clk);
            sts.GE <= '1';      -- S9

        wait until rising_edge(clk);
                                -- S10
        wait until rising_edge(clk);
                                -- S11
        wait until rising_edge(clk);
            sts.EQ <= '0';
            sts.GE <= '1';
            sts.midZero <= '0'; -- S12

        wait until rising_edge(clk);
            sts.GE <= '0';      -- S9

        wait until rising_edge(clk);
                                -- S13

        -- Busca 4
        wait until rising_edge(clk);
            data_av <= '1';     -- S0

        wait until rising_edge(clk);
            data_av <= '1';     -- S1

        wait until rising_edge(clk);
            data_av <= '1';     -- S2

        wait until rising_edge(clk);
            data_av <= '0';     -- S3

        wait until rising_edge(clk);
            sts.GE <= '0';      -- S4

        wait until rising_edge(clk);
            sts.GE <= '1';      -- S5

        wait until rising_edge(clk);
            sts.GE <= '0';      -- S6

        wait until rising_edge(clk);
                                -- S7
        wait until rising_edge(clk);
            sts.GE <= '1';      -- S9

        wait until rising_edge(clk);
                                -- S10
        wait until rising_edge(clk);
                                -- S11
        wait until rising_edge(clk);
            sts.EQ <= '0';
            sts.GE <= '1';
            sts.midZero <= '1'; -- S12

        wait until rising_edge(clk);
            sts.GE <= '0';
            sts.midZero <= '0'; -- S13

        wait;    -- fim

    end process;


end behavioral;
