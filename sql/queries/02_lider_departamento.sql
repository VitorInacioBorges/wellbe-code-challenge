-- Ranking de gasto por líder DENTRO do departamento que mais gastou (exclui
-- outliers de custo, na CTE e na query externa, pra concordar com a query 1
-- sobre qual departamento venceu); a primeira linha responde "quem é o líder
-- do departamento que mais gastou". O ranking completo alimenta o gráfico.
WITH departamento_maior_gasto AS (
    SELECT a.departamento_id
    FROM atestado a
    WHERE a.departamento_id IS NOT NULL
      AND a.custo_outlier = FALSE
    GROUP BY a.departamento_id
    ORDER BY SUM(a.custo_afastamento) DESC
    LIMIT 1
)
SELECT
    f.nome AS lider,
    SUM(a.custo_afastamento) AS gasto_sob_esse_lider
FROM atestado a
JOIN departamento_maior_gasto dmg ON dmg.departamento_id = a.departamento_id
JOIN funcionario f ON f.id = a.lider_funcionario_id
WHERE a.lider_funcionario_id IS NOT NULL
  AND a.custo_outlier = FALSE
GROUP BY f.id, f.nome
ORDER BY gasto_sob_esse_lider DESC;
