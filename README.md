# wellbe-code-challenge

ETL do desafio Wellbe: extrai `data/dados.csv`, trata e carrega em MySQL/MariaDB,
responde 4 perguntas de negócio via SQL e gera os gráficos correspondentes.
Ver `notebooks/etl.ipynb` para o pipeline completo.

## Respostas

1. **Departamento que mais gastou em afastamentos:** `ANALISTA INFORMACOES GERENCIAIS II`,
   R$ 2.603,45 (um atestado com custo suspeito — R$ 9.215,00 em vez de R$ 92,15 —
   foi identificado como outlier e excluído desta conta; ver a nota no notebook
   e em `docs/DADOS.md` para a regra completa e os números antes/depois).
2. **Líder desse departamento:** `Anonimo 108`.
3. **Ocorrências por dia da semana:** não é uma resposta única — ver a
   tabela/gráfico `dia_semana.png` no notebook.
4. **Atestados acumulados por mês:** também uma série, não um valor único —
   ver a tabela/gráfico `acumulado_mensal.png` no notebook.

## Estrutura do repositório

- `notebooks/etl.ipynb` — pipeline completo (extração, tratamento, carga,
  queries, gráficos).
- `sql/schema.sql` — DDL das 3 tabelas (Departamento, Funcionario, Atestado).
- `sql/queries/` — as 4 queries do desafio, isoladas.
- `sql/dump.sql` — dump do banco carregado (entregável).

## Como rodar

Ver `docs/EXECUCAO.md` para o passo a passo completo, do zero.
