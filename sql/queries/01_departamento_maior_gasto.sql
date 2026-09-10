-- Ranking de gasto por departamento; a primeira linha (maior total_gasto)
-- responde "qual departamento gastou mais em afastamentos". O ranking
-- completo também alimenta o gráfico dessa pergunta.
SELECT
    d.nome AS departamento,
    SUM(a.custo_afastamento) AS total_gasto
FROM Atestado a
JOIN Departamento d ON d.id = a.departamento_id
GROUP BY d.id, d.nome
ORDER BY total_gasto DESC;
