CREATE VIEW ganadores(equipo, temporada, puntos) AS
SELECT p1.equipo, j1.temporada, SUM(puntos)
FROM puntos p1 
JOIN jornada j1 ON j1.id_jornada = p1.jornada
WHERE j1.liga='1'
GROUP BY p1.equipo, j1.temporada
HAVING SUM(p1.puntos) = (
        SELECT MAX(SUM(p2.puntos))
        FROM puntos p2 
        JOIN jornada j2 ON j2.id_jornada = p2.jornada
        WHERE j2.liga='1' AND j2.temporada=j1.temporada
        GROUP BY p2.equipo, j2.temporada)
ORDER BY j1.temporada, p1.equipo;

SELECT equipo, COUNT(*)
FROM ganadores
HAVING COUNT(*) = (
        SELECT MAX(COUNT(*))
        FROM ganadores
        GROUP BY equipo)
GROUP BY equipo;

DROP VIEW ganadores;
