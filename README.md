# 🔎 ExponentialSearch em VHDL

Processador dedicado que faz **busca exponencial** em um vetor ordenado guardado na memória, descrito em VHDL.
Trabalho da disciplina **Sistemas Digitais II** (Parte 2): tradução para VHDL do circuito feito no Logisim na Parte 1.

**Grupo:** Pedro Rodrigues · Marina Loro · Douglas Wink

---

## 📌 O que o circuito faz

Equivalente em hardware desta função em C:

```c
int8_t exponential_search(int8_t array[], uint8_t len, int8_t key);
```

1. Recebe pela entrada `data` (com `data_av = 1`), um por ciclo: **base** (endereço do vetor), **len** (tamanho) e **key** (valor buscado).
2. **Fase exponencial:** dobra `i` (1, 2, 4, 8...) até passar do fim do vetor ou achar `mem[base + i] >= key`.
3. **Fase binária:** faz busca binária entre `left = i/2` e `right = min(i, len - 1)`.
4. Devolve em `pos` a posição da chave, ou **-1 (`0xFF`)** se não achar, e sobe `done` por um ciclo.

### Interface

| Porta | Direção | Função |
|---|---|---|
| `clk`, `rst` | entrada | clock e reset assíncrono |
| `data`, `data_av` | entrada | dado de entrada e aviso de dado disponível |
| `pos` | saída | posição encontrada (ou `0xFF`) |
| `done` | saída | fim da busca |
| `address`, `data_in`, `ce`, `wr` | memória | endereço, dado lido, habilita e escrita (sempre `0`, só lemos) |

---

## 🧱 As duas arquiteturas

| Arquitetura | Como é feita | Arquivos |
|---|---|---|
| `structural` | Bloco de controle (FSM) + bloco de dados ligados por records | `ControlPath.vhd`, `DataPath.vhd`, `ExponentialSearch_pkg.vhd` |
| `behavioral` | Um único `process` com `case` por estado, direto da FSMD | `ExponentialSearch.vhd` |

As duas têm **o mesmo comportamento ciclo a ciclo**, e o test bench roda as duas lado a lado para mostrar isso.

### Bloco de dados (resumo)

- **Registradores (8 bits):** `base`, `len`, `key`, `i`, `left`, `right`, `mid`, `memData`, `pos` (instâncias de `RegisterNbits`).
- **Somador 1 (`aluOp`):** `base + i` / `base + mid`, `mid + 1`, `mid - 1`, `len - 1`, `left + right`.
- **Somador 2 (comparador, `cmpSel`):** faz `X - Y` e gera `EQ` (resultado = 0) e `GE` (bit de sinal = 0).
- **Por fios:** `i × 2 = i(6 downto 0) & '0'` e `i / 2 = '0' & i(7 downto 1)`.

### Máquina de estados (14 estados)

| Estado | O que faz |
|---|---|
| S0, S1, S2 | lê `base`, `len` e `key` (espera `data_av`) |
| S3 | se `len = 0` → `pos ← -1`; senão `i ← 1` |
| S4, S5 | fase exponencial: compara `i` com `len`, lê `mem[base + i]`, dobra `i` |
| S6, S7, S8 | prepara a busca binária: `left ← i/2`, `right ← i` ou `len - 1` |
| S9 | se `right < left` → não achou |
| S10, S11 | `mid ← (left + right)/2` e lê `mem[base + mid]` |
| S12 | compara com `key`: achou, vai para a esquerda ou para a direita |
| S13 | `done ← 1` e volta para S0 |

📈 Grafo completo da FSMD: [`FSMD_ExponentialSearch.pdf`](FSMD_ExponentialSearch.pdf)

---

## 📂 Arquivos

| Arquivo | O que é |
|---|---|
| `Util_pkg.vhd` | Funções auxiliares (do professor) |
| `Memory.vhd` | Memória do test bench, carregada de `image.txt` (do professor) |
| `RegisterNbits.vhd` | Registrador genérico de N bits (do professor) |
| `FullAdder.vhd`, `Adder_nbits.vhd` | Somador completo e somador de N bits (estrutural, com `for generate`) |
| `ExponentialSearch_pkg.vhd` | Records `Command` e `Status` entre controle e dados |
| `DataPath.vhd` | Bloco de dados |
| `ControlPath.vhd` | Bloco de controle (FSM) |
| `ExponentialSearch.vhd` | Topo: arquiteturas `structural` e `behavioral` |
| `ExponentialSearch_tb.vhd` | Test bench com as duas arquiteturas e duas memórias |
| `image.txt` | Conteúdo da memória (um valor hexa por linha) |
| `compile.tcl`, `wave.do` | Scripts do ModelSim |
| `FSMD_ExponentialSearch.pdf` | Grafo da FSMD para imprimir |

---

## ▶️ Como rodar no ModelSim

No console do ModelSim:

```tcl
cd caminho/para/esta/pasta
do compile.tcl
vsim work.ExponentialSearch_tb
do wave.do
run 6 us
```

> A ordem de compilação importa (de baixo para cima), por isso use sempre o `compile.tcl`.

---

## 📚 Ordem sugerida para estudar

1. `ExponentialSearch_pkg` (o que passa entre controle e dados)
2. `ControlPath` (estado por estado, olhando o grafo)
3. `DataPath` + `Adder_nbits` + `RegisterNbits`
4. `ExponentialSearch` estrutural (só a ligação)
5. `ExponentialSearch` comportamental
6. Test bench, memória e as ondas no `wave.do`

Para cada estado, tente responder: **qual linha do C ele faz → qual caminho do hardware é usado → onde isso está no VHDL**.
