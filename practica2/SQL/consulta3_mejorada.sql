/*
--CALCULA EL COSTE DE LA CONSULTA ANTES DE LAS MEJORAS
EXPLAIN PLAN FOR
SELECT SUM(COUNT(DISTINCT ap.personaje)) as num_personajes
FROM actua_pelicula ap 
WHERE ap.personaje <> 'UNKNOWN' AND ap.id_pelicula IN (
    SELECT DISTINCT r.original
    FROM pelis_relacionadas r 
    WHERE r.tipo = 'precuela' OR r.tipo = 'secuela'
    UNION
    SELECT DISTINCT r.nueva
    FROM pelis_relacionadas r 
    WHERE r.tipo = 'precuela' OR r.tipo = 'secuela'
)
GROUP BY ap.personaje
HAVING COUNT(DISTINCT ap.id_actor) >= 4;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
*/
---------------------------------------------------------------------------------------
--                                   MEJORA                                          --
--------------------------------------------------------------------------------------- 
-- Se ha creado una vista materializada en la que se guardan el número de actores
-- distintos que han interpretado a un personaje que peretnece a una saga de películas
-- (es precuela o secuela)
---------------------------------------------------------------------------------------

CREATE MATERIALIZED VIEW num_actores_personaje_saga AS
SELECT ap.personaje, COUNT(DISTINCT ap.id_actor) AS num_actores
FROM actua_pelicula ap
WHERE ap.personaje <> 'UNKNOWN' AND ap.id_pelicula IN (
    SELECT DISTINCT r.original
    FROM pelis_relacionadas r 
    WHERE r.tipo = 'precuela' OR r.tipo = 'secuela'
    UNION
    SELECT DISTINCT r.nueva
    FROM pelis_relacionadas r 
    WHERE r.tipo = 'precuela' OR r.tipo = 'secuela'
)
GROUP BY ap.personaje;

SELECT SUM(COUNT(DISTINCT personaje)) as num_personajes
FROM num_actores_personaje_saga
WHERE num_actores >= 4
GROUP BY personaje;

/*
--CALCULA EL COSTE DE LA CONSULTA DESPUES DE LAS MEJORAS
EXPLAIN PLAN FOR
SELECT SUM(COUNT(DISTINCT personaje)) as num_personajes
FROM num_actores_personaje_saga
WHERE num_actores >= 4
GROUP BY personaje;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
*/

DROP MATERIALIZED VIEW num_actores_personaje_saga;