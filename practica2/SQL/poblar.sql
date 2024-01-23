CREATE SEQUENCE sec START WITH 1 INCREMENT BY 1;
INSERT INTO trabajador(id_trabajador, nombre, sexo)                                   
SELECT sec.NEXTVAL, tabla.name, tabla.gender     
FROM (
    SELECT DISTINCT name, gender
    FROM datosdb.datospeliculas                                                  
    WHERE name IS NOT NULL
) tabla;
DROP SEQUENCE sec;

CREATE SEQUENCE sec START WITH 1 INCREMENT BY 1;                            
INSERT INTO pelicula(id_pelicula, titulo, estreno)
SELECT sec.NEXTVAL, tabla.title, tabla.production_year
FROM (
    SELECT DISTINCT title, production_year
    FROM datosdb.datospeliculas
    WHERE kind = 'movie' AND title IS NOT NULL AND production_year IS NOT NULL
) tabla;
DROP SEQUENCE sec;

INSERT INTO genero_pelicula(id_pelicula, genero)
SELECT DISTINCT pelicula.id_pelicula, keyword
FROM datosdb.datospeliculas d, pelicula
WHERE pelicula.titulo = d.title AND pelicula.estreno = d.production_year 
        AND d.kind = 'movie' AND d.keyword IS NOT NULL;

INSERT INTO actua_pelicula(id_pelicula, id_actor, personaje)
SELECT DISTINCT p.id_pelicula, t.id_trabajador, CASE WHEN d.role_name IS NULL THEN 'UNKNOWN' 
                                                ELSE d.role_name END
FROM pelicula p, trabajador t, datosdb.datospeliculas d
WHERE p.titulo = d.title AND p.estreno = d.production_year AND t.nombre = d.name 
        AND (t.sexo = d.gender OR t.sexo IS NULL) AND d.kind = 'movie' AND 
        (role = 'actor' OR role = 'actress');


INSERT INTO trabaja_pelicula(id_pelicula, id_trabajador, trabajo)
SELECT DISTINCT p.id_pelicula, t.id_trabajador, d.role
FROM pelicula p, trabajador t, datosdb.datospeliculas d
WHERE p.titulo = d.title AND p.estreno = d.production_year AND t.nombre = d.name 
        AND (t.sexo = d.gender OR t.sexo IS NULL) AND d.kind = 'movie' AND role IS NOT NULL 
        AND role <> 'actor' AND role <> 'actress';

INSERT INTO pelis_relacionadas(original, nueva, tipo)
SELECT DISTINCT p2.id_pelicula, p1.id_pelicula, 'remake'
FROM pelicula p1, pelicula p2, datosdb.datospeliculas d
WHERE p1.titulo = d.title AND p1.estreno = d.production_year AND p2.titulo = d.titlelink 
        AND p2.estreno = d.productionyearlink AND (link = 'remake of' OR link = 'version of')
        AND p1.estreno >= p2.estreno;
 
INSERT INTO pelis_relacionadas(original, nueva, tipo)
SELECT DISTINCT p2.id_pelicula, p1.id_pelicula, 'precuela'
FROM pelicula p1, pelicula p2, datosdb.datospeliculas d
WHERE p1.titulo = d.title AND p1.estreno = d.production_year AND p2.titulo = d.titlelink 
        AND p2.estreno = d.productionyearlink AND link = 'followed by' 
        AND p1.estreno > p2.estreno;

INSERT INTO pelis_relacionadas(original, nueva, tipo)
SELECT DISTINCT p2.id_pelicula, p1.id_pelicula, 'secuela'
FROM pelicula p1, pelicula p2, datosdb.datospeliculas d
WHERE p1.titulo = d.title AND p1.estreno = d.production_year AND p2.titulo = d.titlelink 
        AND p2.estreno = d.productionyearlink AND link = 'follows' 
        AND p1.estreno >= p2.estreno;

CREATE SEQUENCE sec START WITH 1 INCREMENT BY 1;                            
INSERT INTO serie(id_serie, titulo, estreno, fin)
SELECT sec.NEXTVAL, tabla.title, tabla.production_year, TO_NUMBER(REGEXP_SUBSTR(tabla.series_years, '\d{4}$'))
FROM (
    SELECT DISTINCT title, production_year, series_years
    FROM datosdb.datospeliculas
    WHERE kind = 'tv series' AND title IS NOT NULL AND production_year IS NOT NULL
) tabla;
DROP SEQUENCE sec;

INSERT INTO genero_serie(id_serie, genero)
SELECT DISTINCT serie.id_serie, keyword
FROM datosdb.datospeliculas d, serie
WHERE serie.titulo = d.title AND serie.estreno = d.production_year 
        AND d.kind = 'tv series' AND d.keyword IS NOT NULL;

INSERT INTO actua_serie(id_serie, id_actor, personaje)
SELECT DISTINCT p.id_serie, t.id_trabajador, CASE WHEN d.role_name IS NULL THEN 'UNKNOWN' 
                                                ELSE d.role_name END
FROM serie p, trabajador t, datosdb.datospeliculas d
WHERE p.titulo = d.title AND p.estreno = d.production_year AND t.nombre = d.name 
        AND (t.sexo = d.gender OR t.sexo IS NULL) AND d.kind = 'movie' AND 
        (role = 'actor' OR role = 'actress');

INSERT INTO trabaja_serie(id_serie, id_trabajador, trabajo)
SELECT DISTINCT s.id_serie, t.id_trabajador, d.role
FROM serie s, trabajador t, datosdb.datospeliculas d
WHERE s.titulo = d.title AND s.estreno = d.production_year AND t.nombre = d.name 
        AND (t.sexo = d.gender OR t.sexo IS NULL) AND d.kind = 'tv series' AND role IS NOT NULL 
        AND role <> 'actor' AND role <> 'actress';

INSERT INTO capitulo(id_serie, titulo, episodio, temporada, estreno)
SELECT DISTINCT serie.id_serie, d.title, d.episode_nr, d.season_nr, d.production_year 
FROM serie, datosdb.datospeliculas d
        WHERE kind = 'episode' AND serie.titulo = d.serie_title 
        AND serie.estreno = d.production_year;