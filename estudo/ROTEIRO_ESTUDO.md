# Roteiro focado: estudar pelo trabalho (ExponentialSearch, Parte 2)

Meta: dominar os conceitos que o trabalho usa, sempre citando o slide/exemplo do professor, e depois estudar o trabalho arquivo por arquivo. Apresentação: 16/11/2026.

## Etapa 1 — conceitos que o trabalho usa (2 a 3 sessões)

| # | Conceito | Slides | Onde aparece no trabalho |
|---|---|---|---|
| ✅ | entity, architecture, signal, library, std_logic, concorrente | VHDL1, VHDL2 1-3 | todos os arquivos |
| ✅ | test bench básico, port map, after, ModelSim | VHDL2 4-15 | ExponentialSearch_tb, compile.tcl |
| 1 | std_logic_vector: bits, fatias, `&`, atributos | VHDL2 17-20 | i×2 = i(6 downto 0) & '0', i/2, mid |
| 2 | Descrição estrutural: instância, somador de FullAdders, for generate | VHDL2 21-41 | Adder_nbits + FullAdder, DataPath, ligação ExponentialSearch(structural) |
| 3 | Comportamental x estrutural, numeric_std, UNSIGNED/SIGNED, conversões | VHDL3 1-15, 31-35 | architecture behavioral, comparações SIGNED |
| 4 | when/else (MUX), comparador, "não dá para ler saída" | VHDL3 16-19, 29-30, 36-41 | MUXes do DataPath, saídas do ControlPath |
| 5 | Compartilhamento de recursos | VHDL4 1-12 | por que só 2 somadores com MUX na frente |
| 6 | Process, lista de sensitividade, if, case | VHDL4 13-30 | nextState do ControlPath, process da behavioral |
| 7 | Especificação incompleta e latch | VHDL5 1-13 | todo when com else, case com others |
| 8 | Generic e package | VHDL5 14-20, 27-30 | RegisterNbits / Adder_nbits (generic), ExponentialSearch_pkg |
| 9 | Flip-flop, rising_edge, reset assíncrono, registrador | VHDL5 31-58, VHDL6 1-9 | RegisterNbits, registrador de estado |
| 10 | FSM Moore em 3 partes, DataPath, ligação controle+dados | VHDL6 14-33 | ControlPath, DataPath |
| 11 | Mealy e Moore+Mealy | VHDL6 34-36, VHDL7 12 | ldBase, ldI, ldPos... (Mealy) |
| 12 | Divider: FSM, records, ligação | VHDL7 1-18 | ExponentialSearch_pkg (records Command/Status), structural |
| 13 | Descrição totalmente comportamental | VHDL7 19-24 | architecture behavioral |
| 14 | Find / Smaller / MemCopy: memória e FSMD | VHDL8 | Memory, image.txt, test bench |
| 15 | Clock: tudo na mesma borda (visão geral) | clock_e_sincronizacao | pergunta "por que datapath e controle na mesma borda?" |

Fica de fora (só se sobrar tempo): ferramentas Xilinx (VHDL2 16), ULA/Circuito1/2/Decoder/Encoder/tri-state como exercícios, if generate, shift register/contador, detalhes de metaestabilidade.

## Etapa 2 — o trabalho arquivo por arquivo (2 sessões)
Ordem: ExponentialSearch_pkg → ControlPath → DataPath (+ Adder_nbits, RegisterNbits) → ExponentialSearch structural → behavioral → test bench + memória. Perguntas no estilo do professor: linha do C → caminho no hardware → onde está no VHDL; estado do grafo → código → waveform; "e se fosse diferente?".

## Etapa 3 — rodada relâmpago na véspera

## Depois da apresentação: prova
Na semana seguinte tem prova: aí estudamos tudo o que ficou de fora, slide por slide.
