INSERT INTO aeropuerto(iata, nombre, ciudad, estado)
SELECT DISTINCT originiata, originairport, origincity, originstate
FROM datosdb.datosvuelos
WHERE originiata IS NOT NULL;

INSERT INTO compania(cod_compania, nombre)
SELECT DISTINCT carrierCode, carrierName
FROM datosdb.datosvuelos
WHERE carrierCode IS NOT NULL;

CREATE SEQUENCE sec START WITH 1 INCREMENT BY 1;
INSERT INTO modelo(id_modelo, nombre, tipo_avion, tipo_motor, fabricante)                                
SELECT sec.NEXTVAL, t.planeModel, t.planeAircraft_type ,t.plane_Engine_type, t.planeManufacturer 
FROM (
    SELECT DISTINCT planeModel, planeAircraft_type ,plane_Engine_type, planeManufacturer
    FROM datosdb.datosvuelos
    WHERE planeModel IS NOT NULL
) t;
DROP SEQUENCE sec;

INSERT INTO avion(matricula, anyo, id_modelo)
SELECT DISTINCT tailNum, planeYear, m.id_modelo
FROM datosdb.datosvuelos d, modelo m
WHERE d.planeModel = m.nombre AND d.planeAircraft_type = m.tipo_avion
        AND d.plane_Engine_type = m.tipo_motor AND d.planeManufacturer = m.fabricante
        AND tailNum IS NOT NULL;

INSERT INTO avion(matricula, anyo)
SELECT DISTINCT tailNum, planeYear
FROM datosdb.datosvuelos
WHERE planeModel IS NULL AND tailNum IS NOT NULL;        

CREATE SEQUENCE sec START WITH 1 INCREMENT BY 1;
INSERT INTO vuelo (id_vuelo, origen, destino, avion, num_vuelo, fecha_salida, fecha_llegada, cod_compania)
SELECT sec.NEXTVAL, originiata, destiata, tailNum, flightNum,
    TO_DATE(flightDate || LPAD(crsDepTime, 4, '0'), 'YYYY-MM-DDHH24MI'),
    CASE
        WHEN TO_DATE(flightDate || LPAD(crsArrTime, 4, '0'), 'YYYY-MM-DDHH24MI') < TO_DATE(flightDate || LPAD(crsDepTime, 4, '0'), 'YYYY-MM-DDHH24MI')
        THEN TO_DATE(flightDate || LPAD(crsArrTime, 4, '0'), 'YYYY-MM-DDHH24MI') + INTERVAL '1' DAY
        ELSE TO_DATE(flightDate || LPAD(crsArrTime, 4, '0'), 'YYYY-MM-DDHH24MI')
    END,
    carrierCode
FROM datosdb.datosvuelos
WHERE flightNum IS NOT NULL;
DROP SEQUENCE sec;

INSERT INTO desvio(id_vuelo, num_desvio, aeropuerto)
SELECT DISTINCT id_vuelo, 1, div1airport
FROM datosdb.datosvuelos, vuelo
WHERE originiata = origen AND destiata = destino AND flightNum = num_vuelo 
        AND flightDate = TO_CHAR(fecha_salida, 'YYYY-MM-DD')
        AND carrierCode = cod_compania AND  div1airport IS NOT NULL
UNION
SELECT DISTINCT id_vuelo, 2, div2airport
FROM datosdb.datosvuelos, vuelo
WHERE originiata = origen AND destiata = destino AND flightNum = num_vuelo 
        AND flightDate = TO_CHAR(fecha_salida, 'YYYY-MM-DD')
        AND carrierCode = cod_compania AND  div2airport IS NOT NULL;

INSERT INTO cancelacion(id_vuelo)
SELECT DISTINCT id_vuelo
FROM datosdb.datosvuelos, vuelo
WHERE originiata = origen AND destiata = destino AND flightNum = num_vuelo 
        AND flightDate = TO_CHAR(fecha_salida, 'YYYY-MM-DD')
        AND carrierCode = cod_compania AND cancelled = '1';


INSERT INTO retraso(id_vuelo, motivo, duracion)
    SELECT DISTINCT id_vuelo, 'carrier', SUM(carrierDelay)
    FROM vuelo, datosdb.datosvuelos
    WHERE carrierDelay > 0 AND originiata = origen AND destiata = destino 
        AND flightNum = num_vuelo
        AND flightDate = TO_CHAR(fecha_salida, 'YYYY-MM-DD')
    GROUP BY id_vuelo
    UNION
    SELECT DISTINCT id_vuelo, 'weather', SUM(weatherDelay)
    FROM vuelo, datosdb.datosvuelos
    WHERE weatherDelay > 0 AND originiata = origen AND destiata = destino 
        AND flightNum = num_vuelo
        AND flightDate = TO_CHAR(fecha_salida, 'YYYY-MM-DD')
    GROUP BY id_vuelo
    UNION
    SELECT DISTINCT id_vuelo, 'nas', SUM(nasDelay)
    FROM vuelo, datosdb.datosvuelos
    WHERE nasDelay > 0 AND originiata = origen AND destiata = destino 
        AND flightNum = num_vuelo
        AND flightDate = TO_CHAR(fecha_salida, 'YYYY-MM-DD')
    GROUP BY id_vuelo
    UNION
    SELECT DISTINCT id_vuelo, 'security', SUM(securityDelay)
    FROM vuelo, datosdb.datosvuelos
    WHERE securityDelay > 0 AND originiata = origen AND destiata = destino 
        AND flightNum = num_vuelo
        AND flightDate = TO_CHAR(fecha_salida, 'YYYY-MM-DD')
    GROUP BY id_vuelo
    UNION
    SELECT DISTINCT id_vuelo, 'lateAircraft', SUM(lateAircraftDelay)
    FROM vuelo, datosdb.datosvuelos
    WHERE lateAircraftDelay > 0 AND originiata = origen AND destiata = destino 
        AND flightNum = num_vuelo
        AND flightDate = TO_CHAR(fecha_salida, 'YYYY-MM-DD')
    GROUP BY id_vuelo
    UNION
    SELECT DISTINCT id_vuelo, 'divArr', SUM(divArrDelay)
    FROM vuelo, datosdb.datosvuelos
    WHERE divArrDelay > 0 AND originiata = origen AND destiata = destino 
        AND flightNum = num_vuelo
        AND flightDate = TO_CHAR(fecha_salida, 'YYYY-MM-DD')
    GROUP BY id_vuelo;

