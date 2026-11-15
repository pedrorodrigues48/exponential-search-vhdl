------------------------------------------------------------------------------
-- Design unit: ExponentialSearch
-- Description: Architecture structural (ControlPath + DataPath)
--              Architecture behavioral (FSMD)
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ExponentialSearch_pkg.all;

entity ExponentialSearch  is
    port (
        clk         : in std_logic;
        rst         : in std_logic;

        data        : in std_logic_vector (7 downto 0);
        data_av     : in std_logic;
        pos         : out std_logic_vector (7 downto 0);
        done        : out std_logic;

        -- Memoria
        address     : out std_logic_vector (7 downto 0);
        data_in     : in std_logic_vector (7 downto 0);
        ce          : out std_logic;
        wr          : out std_logic
    );

end ExponentialSearch;

architecture structural of ExponentialSearch is

    signal cmd: Command;
    signal sts: Status;

begin

    CONTROL_PATH: entity work.ControlPath
        port map (
            clk         => clk,
            rst         => rst,
            data_av     => data_av,
            done        => done,
            wr          => wr,
            ce          => ce,
            cmd         => cmd,
            sts         => sts
        );

    DATA_PATH: entity work.DataPath
        port map (
            clk         => clk,
            rst         => rst,
            data        => data,
            pos         => pos,
            cmd         => cmd,
            sts         => sts,
            data_in     => data_in,
            address     => address
        );

end structural;


architecture behavioral of ExponentialSearch is

    type State is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13);
    signal currentState: State;

    signal base, len, i, left, right, mid, regPos : UNSIGNED(7 downto 0);
    signal key, memData : SIGNED(7 downto 0);
    signal sum : UNSIGNED(7 downto 0);

begin

    process(clk, rst)
    begin

        if rst = '1' then
            base    <= (others=>'0');
            len     <= (others=>'0');
            key     <= (others=>'0');
            i       <= (others=>'0');
            left    <= (others=>'0');
            right   <= (others=>'0');
            mid     <= (others=>'0');
            memData <= (others=>'0');
            regPos  <= (others=>'0');
            currentState <= S0;

        elsif rising_edge(clk) then

            case currentState is
                when S0 =>
                    if data_av = '1' then
                        base <= UNSIGNED(data);
                        currentState <= S1;
                    else
                        currentState <= S0;
                    end if;

                when S1 =>
                    if data_av = '1' then
                        len <= UNSIGNED(data);
                        currentState <= S2;
                    else
                        currentState <= S1;
                    end if;

                when S2 =>
                    if data_av = '1' then
                        key <= SIGNED(data);
                        currentState <= S3;
                    else
                        currentState <= S2;
                    end if;

                when S3 =>
                    if len = 0 then
                        regPos <= (others=>'1');    -- pos <= -1
                        currentState <= S13;
                    else
                        i <= TO_UNSIGNED(1, 8);
                        currentState <= S4;
                    end if;

                when S4 =>
                    if SIGNED(i - len) >= 0 then
                        currentState <= S6;
                    else
                        currentState <= S5;
                    end if;

                when S5 =>
                    if (SIGNED(data_in) - key) >= 0 then    -- mem[base + i] >= key
                        currentState <= S6;
                    else
                        i <= i(6 downto 0) & '0';   -- i * 2
                        currentState <= S4;
                    end if;

                when S6 =>
                    left <= '0' & i(7 downto 1);    -- i / 2

                    if SIGNED(i - (len - 1)) >= 0 then
                        currentState <= S8;
                    else
                        currentState <= S7;
                    end if;

                when S7 =>
                    right <= i;
                    currentState <= S9;

                when S8 =>
                    right <= len - 1;
                    currentState <= S9;

                when S9 =>
                    if SIGNED(right - left) >= 0 then
                        currentState <= S10;
                    else
                        regPos <= (others=>'1');    -- pos <= -1
                        currentState <= S13;
                    end if;

                when S10 =>
                    mid <= '0' & sum(7 downto 1);    -- (left + right) / 2
                    currentState <= S11;

                when S11 =>
                    memData <= SIGNED(data_in);
                    currentState <= S12;

                when S12 =>
                    if memData = key then
                        regPos <= mid;
                        currentState <= S13;

                    elsif (memData - key) < 0 then
                        left <= mid + 1;
                        currentState <= S9;

                    elsif mid /= 0 then
                        right <= mid - 1;
                        currentState <= S9;

                    else
                        regPos <= (others=>'1');    -- pos <= -1
                        currentState <= S13;
                    end if;

                when S13 =>
                    currentState <= S0;

                when others =>
                    currentState <= S0;

            end case;
        end if;
    end process;

    pos <= STD_LOGIC_VECTOR(regPos);

    sum <= left + right;

    -- Memoria (fora do process, nao gera registrador)
    address <= STD_LOGIC_VECTOR(base + mid) when currentState = S11 else
               STD_LOGIC_VECTOR(base + i);

    ce <= '1' when currentState = S5 or currentState = S11 else '0';
    wr <= '0';  -- so leitura

    -- done (fora do process, nao gera registrador)
    done <= '1' when currentState = S13 else '0';

end behavioral;
