WITH por_mes AS (
    SELECT
        DATE_FORMAT(data_atestado, '%m/%y') AS mes,
        DATE_FORMAT(data_atestado, '%Y-%m') AS mes_ordenavel,
        COUNT(*) AS total_mes
    FROM Atestado
    GROUP BY mes, mes_ordenavel
)
SELECT
    mes,
    total_mes,
    SUM(total_mes) OVER (ORDER BY mes_ordenavel) AS acumulado
FROM por_mes
ORDER BY mes_ordenavel;
