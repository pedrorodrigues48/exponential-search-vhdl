-------------------------------------------------------------------------
-- Design unit: Test bench do ExponentialSearch
-- Description: Teste das duas architectures juntas
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Test bench nao tem portas
entity ExponentialSearch_tb  is
end ExponentialSearch_tb;


-- Instancias e estimulos
architecture behavioral of ExponentialSearch_tb is

    signal clk              : std_logic := '0';
    signal rst              : std_logic;
    signal data_av          : std_logic;
    signal data             : std_logic_vector(7 downto 0);

    signal pos1, pos2       : std_logic_vector(7 downto 0);
    signal done1, done2     : std_logic;

    signal wr1, wr2         : std_logic;
    signal ce1, ce2         : std_logic;
    signal address1, address2       : std_logic_vector(7 downto 0);
    signal es1_data_in, es2_data_in : std_logic_vector(7 downto 0);

begin

    -- Unidade em teste
    PROCESSOR_STR: entity work.ExponentialSearch(structural)
        port map (
            clk         => clk,
            rst         => rst,
            data        => data,
            data_av     => data_av,
            pos         => pos1,
            done        => done1,

            -- Memoria
            ce          => ce1,
            wr          => wr1,
            data_in     => es1_data_in,
            address     => address1
        );

    RAM1: entity work.Memory
        generic map (
            DATA_WIDTH      => 8,
            ADDR_WIDTH      => 8,
            imageFileName   => "image.txt"
        )
        port map (
            clk         => clk,
            ce          => ce1,
            wr          => wr1,
            data_in     => (others=>'0'),
            data_out    => es1_data_in,
            address     => address1
        );

    -- Unidade em teste
    PROCESSOR_BEH: entity work.ExponentialSearch(behavioral)
        port map (
            clk         => clk,
            rst         => rst,
            data        => data,
            data_av     => data_av,
            pos         => pos2,
            done        => done2,

            -- Memoria
            ce          => ce2,
            wr          => wr2,
            data_in     => es2_data_in,
            address     => address2
        );

    RAM2: entity work.Memory
        generic map (
            DATA_WIDTH      => 8,
            ADDR_WIDTH      => 8,
            imageFileName   => "image.txt"
        )
        port map (
            clk         => clk,
            ce          => ce2,
            wr          => wr2,
            data_in     => (others=>'0'),
            data_out    => es2_data_in,
            address     => address2
        );

    -- Estimulos
    rst <= '0', '1' after 10 ns, '0' after 15 ns;
    clk <= not clk after 20 ns;    -- 25 MHz

    -- image.txt: vetor 1 nos enderecos 0 a 9, vetor 2 nos enderecos 10 a 14

    process
    begin
        data_av <= '0';
        data <= (others=>'0');

        wait until rising_edge(clk);

        -- Busca 1: key = 20, pos = 6
        wait until rising_edge(clk);
            data_av <= '1';
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(0,8));    -- base

        wait until rising_edge(clk);
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(10,8));    -- len

        wait until rising_edge(clk);
            data <= x"14";                                     -- key

        wait until rising_edge(clk);
            data_av <= '0';
            data <= (others=>'0');

        wait until done1 = '1';
        wait until rising_edge(clk);

        -- Busca 2: key = -10, pos = 0 (primeiro)
        wait until rising_edge(clk);
            data_av <= '1';
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(0,8));    -- base

        wait until rising_edge(clk);
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(10,8));    -- len

        wait until rising_edge(clk);
            data <= x"F6";                                     -- key

        wait until rising_edge(clk);
            data_av <= '0';
            data <= (others=>'0');

        wait until done1 = '1';
        wait until rising_edge(clk);

        -- Busca 3: key = 50, pos = 9 (ultimo)
        wait until rising_edge(clk);
            data_av <= '1';
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(0,8));    -- base

        wait until rising_edge(clk);
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(10,8));    -- len

        wait until rising_edge(clk);
            data <= x"32";                                     -- key

        wait until rising_edge(clk);
            data_av <= '0';
            data <= (others=>'0');

        wait until done1 = '1';
        wait until rising_edge(clk);

        -- Busca 4: key = 4, pos = -1 (nao encontrado)
        wait until rising_edge(clk);
            data_av <= '1';
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(0,8));    -- base

        wait until rising_edge(clk);
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(10,8));    -- len

        wait until rising_edge(clk);
            data <= x"04";                                     -- key

        wait until rising_edge(clk);
            data_av <= '0';
            data <= (others=>'0');

        wait until done1 = '1';
        wait until rising_edge(clk);

        -- Busca 5: key = -20, pos = -1 (menor que todos, mid = 0)
        wait until rising_edge(clk);
            data_av <= '1';
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(0,8));    -- base

        wait until rising_edge(clk);
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(10,8));    -- len

        wait until rising_edge(clk);
            data <= x"EC";                                     -- key

        wait until rising_edge(clk);
            data_av <= '0';
            data <= (others=>'0');

        wait until done1 = '1';
        wait until rising_edge(clk);

        -- Busca 6: key = 60, pos = -1 (maior que todos)
        wait until rising_edge(clk);
            data_av <= '1';
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(0,8));    -- base

        wait until rising_edge(clk);
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(10,8));    -- len

        wait until rising_edge(clk);
            data <= x"3C";                                     -- key

        wait until rising_edge(clk);
            data_av <= '0';
            data <= (others=>'0');

        wait until done1 = '1';
        wait until rising_edge(clk);

        -- Busca 7: len = 0, pos = -1
        wait until rising_edge(clk);
            data_av <= '1';
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(0,8));    -- base

        wait until rising_edge(clk);
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(0,8));    -- len

        wait until rising_edge(clk);
            data <= x"14";                                     -- key

        wait until rising_edge(clk);
            data_av <= '0';
            data <= (others=>'0');

        wait until done1 = '1';
        wait until rising_edge(clk);

        -- Busca 8: base = 10, len = 5, key = 15, pos = 2
        wait until rising_edge(clk);
            data_av <= '1';
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(10,8));    -- base

        wait until rising_edge(clk);
            data <= STD_LOGIC_VECTOR(TO_UNSIGNED(5,8));    -- len

        wait until rising_edge(clk);
            data <= x"0F";                                     -- key

        wait until rising_edge(clk);
            data_av <= '0';
            data <= (others=>'0');

        wait until done1 = '1';
        wait until rising_edge(clk);

        wait;    -- fim

    end process;


end behavioral;
