---------------------------------------------------------------------------------------
--                                   MEJORA                                          --
---------------------------------------------------------------------------------------
-- La mejora consiste en desnormalizar la tabla de intersección de los actores
-- y películas, añadiendo además el sexo del actor. Esta mejora resulta muy útil si 
-- este valor se consulta con frecuencia al buscar los actores de una película
---------------------------------------------------------------------------------------

CREATE TABLE actua_pelicula2 
(
    id_actor        NUMBER,
    id_pelicula     NUMBER,
    personaje       VARCHAR(80),
    sexo            VARCHAR(1),
    PRIMARY KEY(id_actor, id_pelicula, personaje),
    FOREIGN KEY(id_actor) REFERENCES trabajador(id_trabajador) ON DELETE CASCADE,
    FOREIGN KEY(id_pelicula) REFERENCES pelicula(id_pelicula) ON DELETE CASCADE
);

INSERT INTO actua_pelicula2(id_pelicula, id_actor, sexo, personaje)
SELECT DISTINCT p.id_pelicula, t.id_trabajador, d.gender, CASE WHEN d.role_name IS NULL THEN 'UNKNOWN' 
                                                            ELSE d.role_name END
FROM pelicula p, trabajador t, datosdb.datospeliculas d
WHERE p.titulo = d.title AND p.estreno = d.production_year AND t.nombre = d.name 
        AND (t.sexo = d.gender OR t.sexo IS NULL) AND d.kind = 'movie' AND 
        (role = 'actor' OR role = 'actress');

SELECT p.titulo
FROM pelicula p
JOIN genero_pelicula g ON p.id_pelicula = g.id_pelicula
WHERE g.genero = 'family'
    AND p.id_pelicula NOT IN (
        SELECT ap.id_pelicula
        FROM actua_pelicula2 ap
        JOIN trabajador t ON ap.id_actor = t.id_trabajador
        WHERE ap.sexo <> 'f'
    );

/*
--CALCULA EL COSTE DE LA CONSULTA DESPUES DE LA PRIMERA MEJORA
EXPLAIN PLAN FOR
SELECT p.titulo
FROM pelicula p
JOIN genero_pelicula g ON p.id_pelicula = g.id_pelicula
WHERE g.genero = 'family'
    AND p.id_pelicula NOT IN (
        SELECT ap.id_pelicula
        FROM actua_pelicula2 ap
        WHERE ap.sexo <> 'f'
    );

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
*/

DROP TABLE actua_pelicula2;
