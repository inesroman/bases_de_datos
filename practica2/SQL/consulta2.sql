SELECT t.nombre
FROM trabajador t
JOIN trabaja_serie ts ON t.id_trabajador = ts.id_trabajador
JOIN serie s ON ts.id_serie = s.id_serie
WHERE  ((s.estreno >= 1990 AND s.estreno < 2000) OR (s.fin >= 1990 AND s.fin < 2000)) 
        AND ts.trabajo = 'director'
GROUP BY t.nombre
HAVING COUNT(DISTINCT s.id_serie) >= 6;

/*
--CALCULA EL COSTE DE LA CONSULTA ANTES DE LAS MEJORAS

EXPLAIN PLAN FOR
SELECT t.nombre
FROM trabajador t
JOIN trabaja_serie ts ON t.id_trabajador = ts.id_trabajador
JOIN serie s ON ts.id_serie = s.id_serie
WHERE  ((s.estreno >= 1990 AND s.estreno < 2000) OR (s.fin >= 1990 AND s.fin < 2000)) 
        AND ts.trabajo = 'director'
GROUP BY t.nombre
HAVING COUNT(DISTINCT s.id_serie) >= 6;

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY());
*/
