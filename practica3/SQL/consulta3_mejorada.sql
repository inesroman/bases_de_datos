---------------------------------------------------------------------------------------
--                           PRIMERA MEJORA                                          --
---------------------------------------------------------------------------------------
-- La primera mejora consiste en particionar la tabla vuelo que tiene un gran tamaño, 
-- para esta consulta se crea la tabla vuelo4 que guarda unicamente las columnas del
-- identificador de vuelo, los ar¡eropuertos de origen y destino y las fechas de salida
-- y llegada
---------------------------------------------------------------------------------------

CREATE TABLE vuelo4
(
    id_vuelo        NUMBER PRIMARY KEY, 
    origen          VARCHAR(3) NOT NULL,
    destino         VARCHAR(3) NOT NULL,
    fecha_salida     DATE NOT NULL,
    fecha_llegada    DATE NOT NULL,
    FOREIGN KEY(origen) REFERENCES aeropuerto(iata) ON DELETE CASCADE,
    FOREIGN KEY(destino) REFERENCES aeropuerto(iata) ON DELETE CASCADE
);

INSERT INTO vuelo4(id_vuelo, origen, destino, fecha_salida, fecha_llegada)
SELECT id_vuelo, origen, destino, fecha_salida, fecha_llegada
FROM vuelo;

CREATE VIEW instante_vuelos AS
SELECT a1.nombre AS aeropuerto, v1.fecha_salida as fecha, COUNT(*) AS num_vuelos
FROM vuelo4 v1
JOIN aeropuerto a1 ON v1.origen = a1.iata
JOIN vuelo4 v2 ON ((v2.origen = a1.iata AND v2.fecha_salida BETWEEN (v1.fecha_salida - INTERVAL '15' MINUTE) AND (v1.fecha_salida + INTERVAL '15' MINUTE))
                OR (v2.destino = a1.iata AND v2.fecha_llegada BETWEEN (v1.fecha_salida - INTERVAL '15' MINUTE) AND (v1.fecha_salida + INTERVAL '15' MINUTE)))
GROUP BY a1.nombre, v1.fecha_salida;

SELECT aeropuerto, TO_CHAR(fecha, 'YYYY-MM-DD HH24:MI') AS instante
FROM instante_vuelos
WHERE num_vuelos = (
    SELECT MAX(num_vuelos)
    FROM instante_vuelos
);

/*
EXPLAIN PLAN FOR
SELECT aeropuerto, TO_CHAR(fecha, 'YYYY-MM-DD HH24:MI') AS instante
FROM instante_vuelos
WHERE num_vuelos = (
    SELECT MAX(num_vuelos)
    FROM instante_vuelos
);

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
*/

DROP VIEW instante_vuelos;

---------------------------------------------------------------------------------------
--                           SEGUNDA MEJORA                                          --
---------------------------------------------------------------------------------------
-- La segunda mejora consiste en materializar la vista que se usa para la consulta. 
---------------------------------------------------------------------------------------

CREATE MATERIALIZED VIEW instante_vuelos AS
SELECT a1.nombre AS aeropuerto, v1.fecha_salida as fecha, COUNT(*) AS num_vuelos
FROM vuelo4 v1
JOIN aeropuerto a1 ON v1.origen = a1.iata
JOIN vuelo4 v2 ON ((v2.origen = a1.iata AND v2.fecha_salida BETWEEN (v1.fecha_salida - INTERVAL '15' MINUTE) AND (v1.fecha_salida + INTERVAL '15' MINUTE))
                OR (v2.destino = a1.iata AND v2.fecha_llegada BETWEEN (v1.fecha_salida - INTERVAL '15' MINUTE) AND (v1.fecha_salida + INTERVAL '15' MINUTE)))
GROUP BY a1.nombre, v1.fecha_salida;

SELECT aeropuerto, TO_CHAR(fecha, 'YYYY-MM-DD HH24:MI') AS instante
FROM instante_vuelos
WHERE num_vuelos = (
    SELECT MAX(num_vuelos)
    FROM instante_vuelos
);

/*
EXPLAIN PLAN FOR
SELECT aeropuerto, TO_CHAR(fecha, 'YYYY-MM-DD HH24:MI') AS instante
FROM instante_vuelos
WHERE num_vuelos = (
    SELECT MAX(num_vuelos)
    FROM instante_vuelos
);

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
*/

DROP MATERIALIZED VIEW instante_vuelos;
DROP TABLE vuelo4;