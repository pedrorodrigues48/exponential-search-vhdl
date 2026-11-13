-------------------------------------------------------------------------
-- Design unit: Controlpath
-- Description: Controle do ExponentialSearch (FSM em 3 partes)
--                  1) Registrador de estado
--                  2) Proximo estado
--                  3) Saidas
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.ExponentialSearch_pkg.all;

entity ControlPath is
    port (
        clk         : in std_logic;
        rst         : in std_logic;

        data_av     : in std_logic;
        done        : out std_logic;

        -- Sinais do DataPath
        sts         : in Status;
        cmd         : out Command;

        -- Memoria
        ce          : out std_logic;
        wr          : out std_logic
    );
end ControlPath;


architecture behavioral of ControlPath is

    type State is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13);
    signal currentState, nextState : State;

begin

    -- Registrador de estado
    process(clk, rst)
    begin

        if rst = '1' then
            currentState <= S0;

        elsif rising_edge(clk) then
            currentState <= nextState;

        end if;
    end process;

    -- Proximo estado
    process(currentState, data_av, sts.lenZero, sts.midZero, sts.EQ, sts.GE)
    begin

        case currentState is
            when S0 =>  -- base <= data
                if data_av = '1' then
                    nextState <= S1;
                else
                    nextState <= S0;
                end if;

            when S1 =>  -- len <= data
                if data_av = '1' then
                    nextState <= S2;
                else
                    nextState <= S1;
                end if;

            when S2 =>  -- key <= data
                if data_av = '1' then
                    nextState <= S3;
                else
                    nextState <= S2;
                end if;

            when S3 =>  -- len = 0 ?
                if sts.lenZero = '1' then
                    nextState <= S13;
                else
                    nextState <= S4;
                end if;

            when S4 =>  -- i >= len ?
                if sts.GE = '1' then
                    nextState <= S6;
                else
                    nextState <= S5;
                end if;

            when S5 =>  -- mem[base + i] >= key ?
                if sts.GE = '1' then
                    nextState <= S6;
                else
                    nextState <= S4;
                end if;

            when S6 =>  -- i >= len - 1 ?
                if sts.GE = '1' then
                    nextState <= S8;
                else
                    nextState <= S7;
                end if;

            when S7 =>  -- right <= i
                nextState <= S9;

            when S8 =>  -- right <= len - 1
                nextState <= S9;

            when S9 =>  -- right >= left ?
                if sts.GE = '1' then
                    nextState <= S10;
                else
                    nextState <= S13;
                end if;

            when S10 => -- mid <= (left + right) / 2
                nextState <= S11;

            when S11 => -- memData <= mem[base + mid]
                nextState <= S12;

            when S12 => -- memData = key ?
                if sts.EQ = '1' then
                    nextState <= S13;
                elsif sts.GE = '0' then
                    nextState <= S9;
                elsif sts.midZero = '0' then
                    nextState <= S9;
                else
                    nextState <= S13;
                end if;

            when S13 => -- done
                nextState <= S0;

            when others =>
                nextState <= S0;

        end case;

    end process;

    -- Saidas
    cmd.ldBase      <= '1' when currentState = S0 and data_av = '1' else '0';                       -- Mealy
    cmd.ldLen       <= '1' when currentState = S1 and data_av = '1' else '0';                       -- Mealy
    cmd.ldKey       <= '1' when currentState = S2 and data_av = '1' else '0';                       -- Mealy

    cmd.ldI         <= '1' when (currentState = S3 and sts.lenZero = '0') or
                                (currentState = S5 and sts.GE = '0') else '0';                      -- Mealy
    cmd.selI        <= '1' when currentState = S5 else '0';                                         -- Moore

    cmd.ldLeft      <= '1' when currentState = S6 or
                                (currentState = S12 and sts.EQ = '0' and sts.GE = '0') else '0';    -- Moore / Mealy
    cmd.selLeft     <= '1' when currentState = S12 else '0';                                        -- Moore

    cmd.ldRight     <= '1' when currentState = S7 or currentState = S8 or
                                (currentState = S12 and sts.EQ = '0' and sts.GE = '1' and sts.midZero = '0') else '0';  -- Moore / Mealy
    cmd.selRight    <= '1' when currentState = S8 or currentState = S12 else '0';                   -- Moore

    cmd.ldMid       <= '1' when currentState = S10 else '0';                                        -- Moore
    cmd.selIdx      <= '1' when currentState = S11 else '0';                                        -- Moore
    cmd.ldMem       <= '1' when currentState = S11 else '0';                                        -- Moore

    cmd.ldPos       <= '1' when (currentState = S3 and sts.lenZero = '1') or
                                (currentState = S9 and sts.GE = '0') or
                                (currentState = S12 and sts.EQ = '1') or
                                (currentState = S12 and sts.EQ = '0' and sts.GE = '1' and sts.midZero = '1') else '0';  -- Mealy
    cmd.selPos      <= '1' when currentState = S12 and sts.EQ = '1' else '0';                       -- Mealy

    -- Somador 1
    --      000: base + idx
    --      001: mid + 1
    --      010: mid - 1
    --      011: len - 1
    --      100: left + right
    cmd.aluOp       <= "011" when currentState = S6 or currentState = S8 else                       -- Moore
                       "100" when currentState = S10 else                                           -- Moore
                       "001" when currentState = S12 and sts.EQ = '0' and sts.GE = '0' else         -- Mealy
                       "010" when currentState = S12 and sts.EQ = '0' and sts.GE = '1' and sts.midZero = '0' else  -- Mealy
                       "000";

    -- Somador 2 (X - Y)
    --      000: i - len
    --      001: i - (len - 1)
    --      010: right - left
    --      011: data_in - key
    --      100: memData - key
    cmd.cmpSel      <= "011" when currentState = S5 else                                            -- Moore
                       "001" when currentState = S6 else                                            -- Moore
                       "010" when currentState = S9 else                                            -- Moore
                       "100" when currentState = S12 else                                           -- Moore
                       "000";                                                                       -- Moore

    -- Memoria
    ce              <= '1' when currentState = S5 or currentState = S11 else '0';                   -- Moore
    wr              <= '0';  -- so leitura

    done            <= '1' when currentState = S13 else '0';                                        -- Moore

end behavioral;
