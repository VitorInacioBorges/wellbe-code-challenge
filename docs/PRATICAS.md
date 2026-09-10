# Práticas

## Dados suspeitos / outliers

Quando um valor bruto parece ser erro de digitação (ex: custo sem separador
decimal, 100x maior que o normal para aquele registro específico), a prática
deste projeto é: nunca deletar ou "corrigir" o valor silenciosamente. Marcar com
uma coluna booleana (ex: `custo_outlier`), manter o registro na tabela, documentar
a regra de detecção em `docs/DADOS.md`, e excluir o registro apenas das contas
onde o valor suspeito distorceria o resultado — sem esconder o dado nem impedir
correção manual posterior.

Regra estatística *global* (IQR, z-score) só é confiável quando os dados vêm de
uma única distribuição. Dataset pequeno com múltiplos clusters legítimos e bem
separados (ex: custos que variam por tipo de atendimento) precisa de uma regra
*por grupo* (ex: por funcionário, por departamento) pra não confundir "incomum
para o dataset inteiro" com "impossível para esse registro específico".

Atenção: como a carga é idempotente (TRUNCATE + reload a cada execução do
notebook), uma correção manual direto no banco só dura até a próxima
execução — a correção de verdade precisa acontecer na fonte (CSV) ou na
lógica do ETL, e precisa também recalcular/zerar `custo_outlier` pra esse
registro não continuar excluído por engano.
