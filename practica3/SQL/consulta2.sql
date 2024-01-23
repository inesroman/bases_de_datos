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
EXPLAIN PLAN FOR
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