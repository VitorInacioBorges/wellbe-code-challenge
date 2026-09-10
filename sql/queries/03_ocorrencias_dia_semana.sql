WITH dias_semana AS (
    SELECT 1 AS dia_num, 'Domingo' AS dia_nome
    UNION ALL SELECT 2, 'Segunda'
    UNION ALL SELECT 3, 'Terça'
    UNION ALL SELECT 4, 'Quarta'
    UNION ALL SELECT 5, 'Quinta'
    UNION ALL SELECT 6, 'Sexta'
    UNION ALL SELECT 7, 'Sábado'
)
SELECT
    ds.dia_nome AS dia_da_semana,
    COUNT(a.id) AS total_ocorrencias
FROM dias_semana ds
LEFT JOIN atestado a ON DAYOFWEEK(a.data_atestado) = ds.dia_num
GROUP BY ds.dia_num, ds.dia_nome
ORDER BY ds.dia_num;
