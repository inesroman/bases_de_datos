SELECT DISTINCT e1.estadio
FROM partido pa1, equipo e1, puntos pu1
WHERE goles_favor >= goles_contra AND pa1.jornada=pu1.jornada
        AND pa1.equipo_local=e1.nombre AND e1.nombre=pu1.equipo   
HAVING COUNT(*) > 0.85* (
        SELECT COUNT(*)
        FROM partido pa2 , equipo e2, puntos pu2    
        WHERE e2.estadio = e1.estadio AND pa2.jornada=pu2.jornada
                AND pa2.equipo_local=e2.nombre AND e2.nombre=pu2.equipo)
GROUP BY e1.estadio
ORDER BY e1.estadio;
