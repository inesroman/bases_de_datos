CREATE SEQUENCE sec START WITH 1 INCREMENT BY 1;
INSERT INTO jornada(id_jornada, num_jornada, temporada, liga)
SELECT sec.NEXTVAL, tabla.JORNADA, tabla.INICIO_TEMPORADA, tabla.DIVISION
FROM (
    SELECT DISTINCT JORNADA, INICIO_TEMPORADA, DIVISION
    FROM datosdb.ligahost
) tabla;
DROP SEQUENCE sec;

INSERT INTO estadio(nombre, fecha, capacidad)
SELECT DISTINCT Estadio, Fecha_Inag, Aforo
FROM datosdb.ligahost
WHERE Estadio IS NOT NULL;   

INSERT INTO equipo(nombre, nombre_corto, nombre_hist, fundacion, fundacion_legal, ciudad, estadio)
SELECT DISTINCT Club, EQUIPO_LOCAL, Nombre, Fundacion, Fund_legal, Ciudad, Estadio
FROM datosdb.ligahost
WHERE Club IS NOT NULL;

/*  HAY UN ERROR CON LOS ACENTOS
INSERT INTO equipo(nombre, nombre_corto) VALUES('Ensidesa', 'Ensidesa');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Malaga (C.D.)', 'Malaga (C.D.)');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Palencia', 'Palencia');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Alzira', 'Alzira');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Lorca', 'Lorca');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Zaragoza B', 'Zaragoza B');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Mollerussa', 'Mollerussa');
INSERT INTO equipo(nombre, nombre_corto) VALUES('LLagosterra', 'LLagosterra');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Ejido', 'Ejido');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Ourense', 'Ourense');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Vecindario', 'Vecindario');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Barcelona B', 'Barcelona B');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Almeria (A.D.)', 'Almeria (A.D.)');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Ecija', 'Ecija');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Univ.Las Palma', 'Univ.Las Palma');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Orihuela', 'Orihuela');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Marbella', 'Marbella');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Villarreal B', 'Villarreal B');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Alicante', 'Alicante');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Toledo', 'Toledo');
INSERT INTO equipo(nombre, nombre_corto) VALUES('Malaga B', 'Malaga B');*/

------ MIENTRAS FALLEN LOS ACENTOS ---------------
CREATE TABLE aux (
    EQUIPO_LOCAL    VARCHAR(60)
);
INSERT INTO aux(EQUIPO_LOCAL)
SELECT DISTINCT EQUIPO_LOCAL
FROM datosdb.ligahost
WHERE Club IS NULL AND GOLES_LOCAL IS NOT NULL;

INSERT INTO equipo(Nombre, nombre_corto)
SELECT EQUIPO_LOCAL, EQUIPO_LOCAL
FROM aux;
DROP TABLE aux;
--------------------------------------------------

INSERT INTO otros_nombres(nombre, nombre_oficial)
SELECT DISTINCT Equipo, Club
FROM datosdb.ligahost
WHERE Equipo IS NOT NULL;

INSERT INTO partido(jornada,equipo_local,equipo_visit)
SELECT jornada.id_jornada, l.nombre, v.nombre
FROM jornada,  equipo l, equipo v, datosdb.ligahost
WHERE jornada.num_jornada=JORNADA AND jornada.temporada=INICIO_TEMPORADA
    AND jornada.liga=DIVISION  AND EQUIPO_LOCAL=l.nombre_corto
    AND EQUIPO_VISITANTE=v.nombre_corto;


INSERT INTO puntos(jornada, equipo, puntos, goles_favor, goles_contra)
(SELECT j.id_jornada, e1.nombre,
    (CASE WHEN gh.GOLES_LOCAL > gh.GOLES_VISITANTE THEN 3
        WHEN gh.GOLES_LOCAL = gh.GOLES_VISITANTE THEN 1
    ELSE 0 END) AS puntos, gh.GOLES_LOCAL AS goles_favor, gh.GOLES_VISITANTE AS goles_contra
FROM datosdb.ligahost gh
JOIN equipo e1 ON gh.EQUIPO_LOCAL = e1.nombre_corto
JOIN equipo e2 ON gh.EQUIPO_VISITANTE = e2.nombre_corto
JOIN jornada j ON gh.JORNADA = j.num_jornada AND gh.INICIO_TEMPORADA = j.temporada AND gh.DIVISION = j.liga
WHERE j.num_jornada = JORNADA AND j.temporada = INICIO_TEMPORADA AND j.liga = DIVISION
UNION
SELECT j.id_jornada, e2.nombre,
    (CASE WHEN gh.GOLES_VISITANTE > gh.GOLES_LOCAL THEN 3
    WHEN gh.GOLES_VISITANTE = gh.GOLES_LOCAL THEN 1
    ELSE 0 END) AS puntos, gh.GOLES_VISITANTE AS goles_favor, gh.GOLES_LOCAL AS goles_contra
FROM datosdb.ligahost gh
JOIN equipo e1 ON gh.EQUIPO_LOCAL = e1.nombre_corto
JOIN equipo e2 ON gh.EQUIPO_VISITANTE = e2.nombre_corto
JOIN jornada j ON gh.JORNADA = j.num_jornada AND gh.INICIO_TEMPORADA = j.temporada AND gh.DIVISION = j.liga
WHERE j.num_jornada = JORNADA AND j.temporada = INICIO_TEMPORADA AND j.liga = DIVISION);


