# Desafio Wellbe — ETL, Modelagem e Queries

## Contexto

Desafio de dados da Wellbe: extrair um CSV de atestados médicos (`data/dados.csv`),
tratar e carregar em MySQL, e responder via SQL a perguntas sobre gasto por
departamento, liderança e distribuição temporal de ocorrências. Escopo pequeno e
deliberadamente simples — o objetivo é fazer o mínimo correto (ETL + schema
normalizado + queries), sem construir uma ferramenta de BI ou infraestrutura
desnecessária.

Entregáveis exigidos pelo PDF do desafio: código Python/Jupyter, dump da tabela
carregada no banco, e os SQLs das perguntas respondidas.

## Dado de origem

`data/dados.csv`: 13 linhas de preâmbulo (nome da empresa etc.), header real na
linha 14, ~91 linhas de dados. Colunas: Código, Custo do afastamento, Identificação
(sempre vazia), Funcionário, Departamento, Data do Atestado, Especialidade, Motivo,
Líder.

### Achado importante sobre a hierarquia

O PDF define: "o líder está na linha acima de seus liderados". Inspecionando o CSV
inteiro, confirmou-se que **o mesmo funcionário pode aparecer em blocos diferentes
do arquivo sob líderes e departamentos diferentes** — exemplos:

- `Anonimo 8`: departamento predominante `ANALISTA INFORMACOES GERENCIAIS II`, mas
  uma linha com `TECNICO SEGUROS I`.
- `Anonimo 12`: aparece nas linhas 47–58 sob o líder `Anonimo 108`
  (departamentos `ASSISTENTE DE IMPLANTACAO` / `ASSISTENTE CONTROLE OPERACIONAL`)
  e novamente nas linhas 70–72 sob o líder `Anonimo 111`
  (departamento `TECNICO DE SEGUROS I` / vazio).

Conclusão: departamento e "líder vigente" não são atributos fixos do funcionário —
são atributos de cada ocorrência (atestado). Modelar como atributo fixo do
funcionário exigiria descartar informação do CSV sem justificativa. Por isso essas
FKs ficam na tabela `Atestado`, não em `Funcionario`.

Confirmado também: nenhum dos 8 nomes que aparecem como líder (`Líder = Sim`)
aparece como liderado em nenhuma outra linha — então `Funcionario.eh_lider` pode
ser um atributo fixo e seguro.

## Modelagem (3FN)

```sql
CREATE DATABASE IF NOT EXISTS wellbe_desafio
    DEFAULT CHARACTER SET utf8mb4;
USE wellbe_desafio;

CREATE TABLE Departamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Funcionario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL UNIQUE,
    identificacao VARCHAR(100) NOT NULL DEFAULT '',
    eh_lider BOOLEAN NOT NULL DEFAULT FALSE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Atestado (
    id INT PRIMARY KEY,                 -- "Código" do CSV, já único por linha
    funcionario_id INT NOT NULL,
    departamento_id INT NULL,           -- NULL = departamento vazio na linha original
    lider_funcionario_id INT NULL,      -- líder vigente na posição da linha no CSV
    data_atestado DATE NOT NULL,
    especialidade VARCHAR(150) NOT NULL DEFAULT '',
    motivo VARCHAR(150) NOT NULL DEFAULT '',
    custo_afastamento DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    FOREIGN KEY (funcionario_id) REFERENCES Funcionario(id),
    FOREIGN KEY (departamento_id) REFERENCES Departamento(id),
    FOREIGN KEY (lider_funcionario_id) REFERENCES Funcionario(id),
    INDEX idx_data_atestado (data_atestado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Decisões de tipo/constraint:
- `utf8mb4` para suportar acentuação dos dados (Odontológica, Otorrinolaringologia etc.).
- `InnoDB` por ser o único engine MySQL que aplica `FOREIGN KEY` de fato.
- Campos que já têm regra de "vazio vira valor padrão" (identificação, especialidade,
  motivo, custo) são `NOT NULL DEFAULT`, para a regra de negócio ser garantida pelo
  schema e não só pelo Python.
- `Atestado.id` reaproveita o "Código" do CSV como chave primária natural — evita
  uma coluna surrogate redundante.
- **O `schema.sql` deve incluir o `CREATE DATABASE IF NOT EXISTS` e assumir uma
  instância MySQL local vazia (sem banco/tabelas pré-existentes)** — é o ponto de
  partida documentado em `docs/EXECUCAO.md`, para qualquer avaliador conseguir
  rodar do zero.

## Regras de transformação (ETL)

- Pular as 13 linhas de preâmbulo; header real é a linha 14.
- `custo_afastamento`: vírgula decimal → ponto; `"--"` ou vazio → `0.00`.
- `data_atestado`: parse `dd/mm/yyyy`; linha sem data válida é **descartada** (não
  vira registro em `Atestado`).
- `departamento`: string vazia/só espaço → `departamento_id = NULL` na linha
  (a linha do atestado é mantida, só não conta na agregação por departamento).
- `funcionario`: dedup por nome (`Funcionário` do CSV); `eh_lider = True` se a
  pessoa aparece em algum momento com `Líder = Sim`.
- `identificacao`: sempre vazio nos dados atuais → string vazia.
- **Líder vigente por linha**: varredura sequencial do CSV na ordem original,
  mantendo uma variável "líder atual" atualizada a cada linha com `Líder = Sim`;
  cada `Atestado` grava esse líder atual em `lider_funcionario_id` no momento em
  que a linha é processada.

## Queries (`sql/queries/*.sql`)

1. **Departamento que mais gastou**: `SUM(custo_afastamento)` agrupado por
   `departamento_id` (excluindo `NULL`), `ORDER BY DESC LIMIT 1`.
2. **Líder do departamento que mais gastou**: dentro do departamento vencedor da
   query 1, `SUM(custo_afastamento)` agrupado por `lider_funcionario_id`,
   `ORDER BY DESC LIMIT 1` (critério de desempate: líder com mais gasto acumulado
   nesse departamento).
3. **Ocorrências por dia da semana**: `GROUP BY DAYOFWEEK(data_atestado)`, todos os
   7 dias representados (0 quando não houver ocorrência).
4. **Atestados acumulados por mês**: contagem mensal com soma corrida
   (`SUM(...) OVER (ORDER BY mes)`), formato `MM/AA` como no exemplo do PDF.

## Notebook (`notebooks/etl.ipynb`)

Células, em ordem: extração (leitura bruta do CSV) → transformação (regras acima,
com inspeção intermediária) → carga (SQLAlchemy + PyMySQL, credenciais via `.env`)
→ execução das 4 queries acima direto no MySQL, com resultado renderizado →
2 gráficos simples em matplotlib (ocorrências por dia da semana em barras;
atestados acumulados por mês em linha) cobrindo a menção a "dashboard" do PDF sem
construir uma ferramenta de BI completa.

Validações pontuais no próprio notebook (não é suíte de testes formal, dado o
escopo do desafio): nenhuma linha sem data em `Atestado`; soma de custo bate com o
CSV bruto menos as linhas descartadas por falta de data; contagem de funcionários
únicos bate com os nomes únicos do CSV.

## Estrutura de entrega

```
notebooks/etl.ipynb
sql/schema.sql              -- inclui CREATE DATABASE IF NOT EXISTS, assume MySQL local vazio
sql/queries/01_departamento_maior_gasto.sql
sql/queries/02_lider_departamento.sql
sql/queries/03_ocorrencias_dia_semana.sql
sql/queries/04_atestados_acumulados_mes.sql
sql/dump.sql                -- gerado via mysqldump após a carga (entregável do PDF)
.env.example
requirements.txt
docs/EXECUCAO.md            -- passo a passo: subir MySQL local vazio, configurar .env, rodar schema.sql, rodar notebook
```

`src/main.py` é removido (substituído pelo notebook).

## Fora de escopo

- Ferramenta de BI/dashboard real — só os 2 gráficos no notebook.
- Suíte de testes automatizados (pytest) — fora do pedido do desafio para este escopo.
- Migrations/ORM — DDL puro é suficiente para 3 tabelas fixas.
