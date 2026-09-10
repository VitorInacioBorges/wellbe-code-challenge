# Arquitetura

## Tabelas

Modelo simples em 3FN, com três tabelas. As perguntas do desafio respondidas
a partir delas:

- Qual departamento gastou mais em afastamentos?
- Quem é o líder do departamento que mais gastou?
- Quais as ocorrências por dia da semana?
- Qual o total de atestados acumulados por mês?

| TABELAS | departamento | funcionario                            | atestado                                                                                                                     |
| ------- | ------------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| COLUNAS | id, nome      | id, nome, identificacao, eh_lider       | id, funcionario_id, departamento_id, lider_funcionario_id, data_atestado, especialidade, motivo, custo_afastamento           |

Nomes de tabela em minúsculas (`departamento`, `funcionario`, `atestado`)
para funcionar de forma consistente em qualquer servidor MySQL/MariaDB,
independente da configuração de `lower_case_table_names` — ver
`docs/EXECUCAO.md`.

## Achado importante sobre a hierarquia

`departamento_id` e `lider_funcionario_id` vivem em `Atestado`, não em
`Funcionario`. O CSV não traz departamento nem líder como atributos fixos do
funcionário: um mesmo funcionário aparece em departamentos diferentes ao
longo do tempo, e "líder" é um papel identificado linha a linha (`Líder =
Sim`), não uma referência fixa gravada no funcionário. A leitura correta do
arquivo é: cada atestado registra o departamento e o líder vigentes
*naquela ocorrência* — o líder vigente é o último funcionário marcado como
líder nas linhas anteriores do arquivo, lido em ordem. Modelar
`departamento`/`lider` como colunas de `Funcionario` perderia essa variação
por ocorrência e não responde às perguntas do desafio corretamente. Ver a
seção "Achado importante sobre a hierarquia" do spec
(`docs/superpowers/specs/2026-09-10-wellbe-etl-design.md`) para a análise
completa que motivou essa decisão.
