CREATE VIEW porcentajes_retrasos AS
SELECT c.nombre, COUNT(DISTINCT r.id_vuelo) / COUNT(DISTINCT v.id_vuelo) * 100 AS porcentaje
FROM compania c
JOIN vuelo v ON c.cod_compania = v.cod_compania
LEFT JOIN retraso r ON v.id_vuelo = r.id_vuelo
GROUP BY c.nombre;

SELECT nombre
FROM porcentajes_retrasos
WHERE porcentaje >= (
    SELECT MAX(porcentaje)
    FROM porcentajes_retrasos
    WHERE porcentaje < (
        SELECT MAX(porcentaje)
        FROM porcentajes_retrasos
        WHERE porcentaje < (
            SELECT MAX(porcentaje)
            FROM porcentajes_retrasos
        )
    )
)
ORDER BY porcentaje DESC;

/*
EXPLAIN PLAN FOR
SELECT nombre
FROM porcentajes_retrasos
WHERE porcentaje >= (
    SELECT MAX(porcentaje)
    FROM porcentajes_retrasos
    WHERE porcentaje < (
        SELECT MAX(porcentaje)
        FROM porcentajes_retrasos
        WHERE porcentaje < (
            SELECT MAX(porcentaje)
            FROM porcentajes_retrasos
        )
    )
)
ORDER BY porcentaje DESC;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
*/

DROP VIEW porcentajes_retrasos;
