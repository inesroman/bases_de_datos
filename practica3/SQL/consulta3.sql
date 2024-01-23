CREATE VIEW instante_vuelos AS
SELECT a1.nombre AS aeropuerto, v1.fecha_salida as fecha, COUNT(*) AS num_vuelos
FROM vuelo v1
JOIN aeropuerto a1 ON v1.origen = a1.iata
JOIN vuelo v2 ON ((v2.origen = a1.iata AND v2.fecha_salida BETWEEN (v1.fecha_salida - INTERVAL '15' MINUTE) AND (v1.fecha_salida + INTERVAL '15' MINUTE))
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
