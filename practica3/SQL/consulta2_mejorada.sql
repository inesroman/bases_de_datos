---------------------------------------------------------------------------------------
--                             PRIMERA MEJORA                                        --
---------------------------------------------------------------------------------------
-- La primera mejora consiste en crear indices que el SGDB no crea automaticamente y 
-- que mejoren el rendimiento de la consulta
---------------------------------------------------------------------------------------

CREATE INDEX idx_avion_modelo ON avion(id_modelo);
CREATE INDEX idx_retraso_vuelo  ON retraso(id_vuelo);
CREATE BITMAP INDEX idx_retraso_motivo ON retraso(motivo);

SELECT m1.fabricante, m1.nombre AS modelo, m1.tipo_motor
FROM modelo m1
JOIN avion a1 ON m1.id_modelo = a1.id_modelo
JOIN vuelo v1 ON a1.matricula = v1.avion
JOIN retraso r1 ON v1.id_vuelo = r1.id_vuelo
WHERE r1.motivo = 'security'
GROUP BY m1.fabricante, m1.nombre, m1.tipo_motor, m1.id_modelo
HAVING COUNT(r1.id_vuelo) > 0.01 * (
    SELECT COUNT(*)
    FROM retraso r2
    JOIN vuelo v2 ON v2.id_vuelo = r2.id_vuelo
    JOIN avion a2 ON a2.matricula = v2.avion
    WHERE a2.id_modelo = m1.id_modelo
);

/*
EXPLAIN  PLAN FOR
SELECT m1.fabricante, m1.nombre AS modelo, m1.tipo_motor
FROM modelo m1
JOIN avion a1 ON m1.id_modelo = a1.id_modelo
JOIN vuelo v1 ON a1.matricula = v1.avion
JOIN retraso r1 ON v1.id_vuelo = r1.id_vuelo
WHERE r1.motivo = 'security'
GROUP BY m1.fabricante, m1.nombre, m1.tipo_motor, m1.id_modelo
HAVING COUNT(r1.id_vuelo) > 0.01 * (
    SELECT COUNT(*)
    FROM retraso r2
    JOIN vuelo v2 ON v2.id_vuelo = r2.id_vuelo
    JOIN avion a2 ON a2.matricula = v2.avion
    WHERE a2.id_modelo = m1.id_modelo
);

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
*/

---------------------------------------------------------------------------------------
--                             SEGUNDA MEJORA                                        --
---------------------------------------------------------------------------------------
-- La segunda mejora consiste en particionar la tabla de vuelo, para esta cosnulta solo
-- se necesitan el identificador de vuelo y la matricula del avion que lo realiza
---------------------------------------------------------------------------------------

CREATE TABLE vuelo3
(
    id_vuelo        NUMBER PRIMARY KEY, 
    avion           VARCHAR(6),
    FOREIGN KEY(avion) REFERENCES avion(matricula) ON DELETE CASCADE
);

INSERT INTO vuelo3(id_vuelo, avion)
SELECT id_vuelo, avion
FROM vuelo;

SELECT m1.fabricante, m1.nombre AS modelo, m1.tipo_motor
FROM modelo m1
JOIN avion a1 ON m1.id_modelo = a1.id_modelo
JOIN vuelo3 v1 ON a1.matricula = v1.avion
JOIN retraso r1 ON v1.id_vuelo = r1.id_vuelo
WHERE r1.motivo = 'security'
GROUP BY m1.fabricante, m1.nombre, m1.tipo_motor, m1.id_modelo
HAVING COUNT(r1.id_vuelo) > 0.01 * (
    SELECT COUNT(*)
    FROM retraso r2
    JOIN vuelo3 v2 ON v2.id_vuelo = r2.id_vuelo
    JOIN avion a2 ON a2.matricula = v2.avion
    WHERE a2.id_modelo = m1.id_modelo
);

/*
EXPLAIN  PLAN FOR
SELECT m1.fabricante, m1.nombre AS modelo, m1.tipo_motor
FROM modelo m1
JOIN avion a1 ON m1.id_modelo = a1.id_modelo
JOIN vuelo3 v1 ON a1.matricula = v1.avion
JOIN retraso r1 ON v1.id_vuelo = r1.id_vuelo
WHERE r1.motivo = 'security'
GROUP BY m1.fabricante, m1.nombre, m1.tipo_motor, m1.id_modelo
HAVING COUNT(r1.id_vuelo) > 0.01 * (
    SELECT COUNT(*)
    FROM retraso r2
    JOIN vuelo3 v2 ON v2.id_vuelo = r2.id_vuelo
    JOIN avion a2 ON a2.matricula = v2.avion
    WHERE a2.id_modelo = m1.id_modelo
);

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
*/

DROP INDEX idx_avion_modelo;
DROP INDEX idx_retraso_motivo;
DROP INDEX idx_retraso_vuelo;
DROP TABLE vuelo3;