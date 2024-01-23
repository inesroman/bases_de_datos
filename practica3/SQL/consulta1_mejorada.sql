---------------------------------------------------------------------------------------
--                           PRIMERA MEJORA                                          --
---------------------------------------------------------------------------------------
-- La primera mejora consiste en particionar la tabla vuelo que tiene un gran tamaño, 
-- para esta consulta se crea la tabla vuelo2 que guarda unicamente las columnas del 
-- identificador de vuelo y el codigo de la compañia
---------------------------------------------------------------------------------------
CREATE TABLE vuelo2
(
    id_vuelo    NUMBER PRIMARY KEY,
    cod_compania    VARCHAR(7) NOT NULL,
    FOREIGN KEY(cod_compania) REFERENCES compania(cod_compania) ON DELETE CASCADE
);

INSERT INTO vuelo2(id_vuelo, cod_compania)
SELECT id_vuelo, cod_compania
FROM vuelo;

CREATE VIEW porcentajes_retrasos AS
SELECT c.nombre, COUNT(DISTINCT r.id_vuelo) / COUNT(DISTINCT v.id_vuelo) * 100 AS porcentaje
FROM compania c
JOIN vuelo2 v ON c.cod_compania = v.cod_compania
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

---------------------------------------------------------------------------------------
--                           SEGUNDA MEJORA                                          --
---------------------------------------------------------------------------------------
-- La segunda mejora consiste en materializar la vista que se usa para la consulta. 
---------------------------------------------------------------------------------------
CREATE MATERIALIZED VIEW porcentajes_retrasos AS
SELECT c.nombre, COUNT(DISTINCT r.id_vuelo) / COUNT(DISTINCT v.id_vuelo) * 100 AS porcentaje
FROM compania c
JOIN vuelo2 v ON c.cod_compania = v.cod_compania
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

DROP MATERIALIZED VIEW porcentajes_retrasos;
DROP TABLE vuelo2;
