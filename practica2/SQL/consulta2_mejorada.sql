---------------------------------------------------------------------------------------
--                              PRIMERA MEJORA                                       --
---------------------------------------------------------------------------------------
-- La primera mejora consiste en la creación de un índice bitmap para el la columna de 
-- trabajo de la relación trabaja_serie
---------------------------------------------------------------------------------------

CREATE BITMAP INDEX trabajo_serie ON trabaja_serie(trabajo);

SELECT t.nombre
FROM trabajador t
JOIN trabaja_serie ts ON t.id_trabajador = ts.id_trabajador
JOIN serie s ON ts.id_serie = s.id_serie
WHERE  ((s.estreno >= 1990 AND s.estreno < 2000) OR (s.fin >= 1990 AND s.fin < 2000)) 
        AND ts.trabajo = 'director'
GROUP BY t.nombre
HAVING COUNT(DISTINCT s.id_serie) >= 6;

/*
--CALCULA EL COSTE DE LA CONSULTA DESPUES DE LA PRIMERA MEJORA

EXPLAIN PLAN FOR
SELECT t.nombre
FROM trabajador t
JOIN trabaja_serie ts ON t.id_trabajador = ts.id_trabajador
JOIN serie s ON ts.id_serie = s.id_serie
WHERE  ((s.estreno >= 1990 AND s.estreno < 2000) OR (s.fin >= 1990 AND s.fin < 2000)) 
        AND ts.trabajo = 'director'
GROUP BY t.nombre
HAVING COUNT(DISTINCT s.id_serie) >= 6;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
*/
DROP INDEX trabajo_serie;

---------------------------------------------------------------------------------------
--                              SEGUNDA MEJORA                                       --
---------------------------------------------------------------------------------------
-- La segunda mejora consiste en crear una vista materializada en la que se guardan los
-- identificadores de las series, sus directores y los años de estreno y fin de la serie
---------------------------------------------------------------------------------------

CREATE MATERIALIZED VIEW director_serie AS
SELECT s.id_serie, estreno, titulo, fin, t.nombre AS director
FROM serie s 
JOIN trabaja_serie ts ON s.id_serie = ts.id_serie
JOIN trabajador t ON ts.id_trabajador = t.id_trabajador
WHERE trabajo = 'director';

SELECT s.director
FROM director_serie s
WHERE (s.estreno >= 1990 AND s.estreno < 2000) OR (s.fin >= 1990 AND s.fin < 2000)
GROUP BY s.director
HAVING COUNT(DISTINCT s.id_serie) >= 6;

/*
--CALCULA EL COSTE DE LA CONSULTA DESPUES DE LA SEGUNDA MEJORA

EXPLAIN PLAN FOR
SELECT s.director
FROM director_serie s
WHERE (s.estreno >= 1990 AND s.estreno < 2000) OR (s.fin >= 1990 AND s.fin < 2000)
GROUP BY s.director
HAVING COUNT(DISTINCT s.id_serie) >= 6;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
*/

DROP MATERIALIZED VIEW director_serie;
