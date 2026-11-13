-------------------------------------------------------------------------
-- Design unit: DataPath
-- Description: DataPath do ExponentialSearch
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.ExponentialSearch_pkg.all;

entity DataPath is
    generic (
        WIDTH       : integer := 8
    );
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        data        : in std_logic_vector (WIDTH - 1 downto 0);
        pos         : out std_logic_vector (WIDTH - 1 downto 0);

        -- Sinais do ControlPath
        sts         : out Status;
        cmd         : in Command;

        -- Memoria
        address     : out std_logic_vector (WIDTH - 1 downto 0);
        data_in     : in std_logic_vector (WIDTH - 1 downto 0)
    );
end DataPath;


architecture structural of DataPath is

    signal base, len, key, i, left, right, mid, memData, pos_q : std_logic_vector(WIDTH - 1 downto 0);

    signal inI, inLeft, inRight, inMid, inPos : std_logic_vector(WIDTH - 1 downto 0);

    signal idx, adder1A, adder1B, adder1Out : std_logic_vector(WIDTH - 1 downto 0);

    signal cmpX, cmpY, notCmpY, adder2Out : std_logic_vector(WIDTH - 1 downto 0);

    signal carryOut1, carryOut2 : std_logic;

    constant ONE        : std_logic_vector(WIDTH - 1 downto 0) := STD_LOGIC_VECTOR(TO_UNSIGNED(1, WIDTH));
    constant NOT_ONE    : std_logic_vector(WIDTH - 1 downto 0) := not ONE;    -- 0xFE
    constant MINUS_ONE  : std_logic_vector(WIDTH - 1 downto 0) := (others=>'1');    -- -1

begin

    -- Registradores

    REG_BASE: entity work.RegisterNbits
        generic map (
            WIDTH   => WIDTH
        )
        port map (
            clock   => clk,
            reset   => rst,
            ce      => cmd.ldBase,
            d       => data,
            q       => base
        );

    REG_LEN: entity work.RegisterNbits
        generic map (
            WIDTH   => WIDTH
        )
        port map (
            clock   => clk,
            reset   => rst,
            ce      => cmd.ldLen,
            d       => data,
            q       => len
        );

    REG_KEY: entity work.RegisterNbits
        generic map (
            WIDTH   => WIDTH
        )
        port map (
            clock   => clk,
            reset   => rst,
            ce      => cmd.ldKey,
            d       => data,
            q       => key
        );

    REG_I: entity work.RegisterNbits
        generic map (
            WIDTH   => WIDTH
        )
        port map (
            clock   => clk,
            reset   => rst,
            ce      => cmd.ldI,
            d       => inI,
            q       => i
        );

    REG_LEFT: entity work.RegisterNbits
        generic map (
            WIDTH   => WIDTH
        )
        port map (
            clock   => clk,
            reset   => rst,
            ce      => cmd.ldLeft,
            d       => inLeft,
            q       => left
        );

    REG_RIGHT: entity work.RegisterNbits
        generic map (
            WIDTH   => WIDTH
        )
        port map (
            clock   => clk,
            reset   => rst,
            ce      => cmd.ldRight,
            d       => inRight,
            q       => right
        );

    REG_MID: entity work.RegisterNbits
        generic map (
            WIDTH   => WIDTH
        )
        port map (
            clock   => clk,
            reset   => rst,
            ce      => cmd.ldMid,
            d       => inMid,
            q       => mid
        );

    REG_MEMDATA: entity work.RegisterNbits
        generic map (
            WIDTH   => WIDTH
        )
        port map (
            clock   => clk,
            reset   => rst,
            ce      => cmd.ldMem,
            d       => data_in,
            q       => memData
        );

    REG_POS: entity work.RegisterNbits
        generic map (
            WIDTH   => WIDTH
        )
        port map (
            clock   => clk,
            reset   => rst,
            ce      => cmd.ldPos,
            d       => inPos,
            q       => pos_q
        );


    -- MUX das entradas dos registradores

    -- i * 2
    inI     <= ONE when cmd.selI = '0' else
               i(WIDTH - 2 downto 0) & '0';

    -- i / 2
    inLeft  <= '0' & i(WIDTH - 1 downto 1) when cmd.selLeft = '0' else
               adder1Out;

    inRight <= i when cmd.selRight = '0' else
               adder1Out;

    -- (left + right) / 2
    inMid   <= '0' & adder1Out(WIDTH - 1 downto 1);

    inPos   <= MINUS_ONE when cmd.selPos = '0' else
               mid;


    -- Somador 1

    idx     <= i when cmd.selIdx = '0' else
               mid;

    adder1A <= base when cmd.aluOp = "000" else
               mid  when cmd.aluOp = "001" else
               mid  when cmd.aluOp = "010" else
               len  when cmd.aluOp = "011" else
               left;

    adder1B <= idx      when cmd.aluOp = "000" else
               ONE      when cmd.aluOp = "001" else
               NOT_ONE  when cmd.aluOp = "010" else
               NOT_ONE  when cmd.aluOp = "011" else
               right;

    ADDER_1: entity work.Adder_nbits(structural_generic)
        generic map (
            n           => WIDTH
        )
        port map (
            A           => adder1A,
            B           => adder1B,
            CarryIn     => cmd.aluOp(1),
            Sum         => adder1Out,
            CarryOut    => carryOut1
        );


    -- Somador 2 (comparador)

    cmpX    <= i        when cmd.cmpSel = "000" else
               i        when cmd.cmpSel = "001" else
               right    when cmd.cmpSel = "010" else
               data_in  when cmd.cmpSel = "011" else
               memData;

    cmpY    <= len          when cmd.cmpSel = "000" else
               adder1Out    when cmd.cmpSel = "001" else
               left         when cmd.cmpSel = "010" else
               key;

    notCmpY <= not cmpY;

    ADDER_2: entity work.Adder_nbits(structural_generic)
        generic map (
            n           => WIDTH
        )
        port map (
            A           => cmpX,
            B           => notCmpY,
            CarryIn     => '1',             -- X - Y
            Sum         => adder2Out,
            CarryOut    => carryOut2
        );


    -- Status

    sts.EQ      <= '1' when UNSIGNED(adder2Out) = 0 else '0';
    sts.GE      <= not adder2Out(WIDTH - 1);
    sts.lenZero <= '1' when UNSIGNED(len) = 0 else '0';
    sts.midZero <= '1' when UNSIGNED(mid) = 0 else '0';


    -- Endereco da memoria
    address <= adder1Out;

    pos <= pos_q;

end structural;
