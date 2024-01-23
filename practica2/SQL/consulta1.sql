SELECT p.titulo
FROM pelicula p
JOIN genero_pelicula g ON p.id_pelicula = g.id_pelicula
WHERE g.genero = 'family'
    AND p.id_pelicula NOT IN (
        SELECT ap.id_pelicula
        FROM actua_pelicula ap
        JOIN trabajador t ON ap.id_actor = t.id_trabajador
        WHERE t.sexo <> 'f'
    );

/*
--CALCULA EL COSTE DE LA CONSULTA ANTES DE LAS MEJORAS
EXPLAIN PLAN FOR
SELECT p.titulo
FROM pelicula p
JOIN genero_pelicula g ON p.id_pelicula = g.id_pelicula
WHERE g.genero = 'family'
    AND p.id_pelicula NOT IN (
        SELECT ap.id_pelicula
        FROM actua_pelicula ap
        JOIN trabajador t ON ap.id_actor = t.id_trabajador
        WHERE t.sexo <> 'f'
    );
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
*/
