-------------------------------------------------------------------------
-- Somador completo de 1 bit
-------------------------------------------------------------------------

library IEEE;                       -- Biblioteca básica
use IEEE.std_logic_1164.all;        -- Pacote com tipos e funções lógicas básicos


-- Declaração da interface do componente (pinos de entrada/saída)
entity FullAdder is
    port(
        A, B, Ci    : in std_logic;    -- Entradas
        S, Co       : out std_logic    -- Saídas
    );
end FullAdder;


-- Descrição da funcionalidade do componente (implementação)
architecture arch1 of FullAdder is

    signal a_xor_b, a_and_b, a_xor_b_e_Ci: std_logic;

begin    
    
    -- Gera a soma (S)
    a_xor_b <= A xor B;
    S <= a_xor_b xor Ci;    
    
    -- Gera carry out (Co)
    a_and_b <= A and B;
    a_xor_b_e_Ci <= a_xor_b and Ci;    
    Co <= a_and_b or a_xor_b_e_Ci;    
    
end arch1;


-- Descrição da funcionalidade do componente (implementação)
architecture arch2 of FullAdder is

begin    
    
    -- Gera a soma (S)
    S <= (A xor B) xor Ci;
    
    -- Gera carry out (Co)
    Co <= (A and B) or ((A xor B) and Ci);    
    
end arch2;


-- Descrição da funcionalidade do componente (implementação)
architecture arch3 of FullAdder is

begin    
    
    process (A, B, Ci)
    begin
            
        -- Gera a soma (S)
        S <= (A xor B) xor Ci;
          
        -- Gera carry out (Co)
        Co <= (A and B) or ((A xor B) and Ci);
        
    end process;
    
end arch3;


-- Descrição da funcionalidade do componente (implementação)
architecture arch4 of FullAdder is
begin    
    
    -- Gera a soma (S)
    Sum: process (A, B, Ci)
    begin
                    
        S <= (A xor B) xor Ci;
        
    end process;
    
    
    -- Gera carry out (Co)
    CarryOut: process (A,B,Ci)
    begin
                    
        Co <= (A and B) or ((A xor B) and Ci);
            
    end process;
    
end arch4;
