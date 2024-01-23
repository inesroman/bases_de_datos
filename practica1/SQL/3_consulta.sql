SELECT j.temporada, SUM(goles_favor) AS total_goles
FROM puntos p, jornada j
WHERE j.id_jornada=p.jornada AND p.equipo='Real Zaragoza'
        AND j.temporada IN(
        SELECT j1.temporada
        FROM puntos pu1, partido pa1, jornada j1
        WHERE j1.id_jornada=pa1.jornada AND j1.id_jornada=pu1.jornada AND pu1.equipo = 'Real Zaragoza'
                AND pa1.equipo_local = 'Real Zaragoza' AND pu1.goles_favor > pu1.goles_contra
                AND EXISTS (
                SELECT pa2.equipo_local
                FROM puntos pu2, partido pa2, jornada j2
                WHERE j2.id_jornada=pa2.jornada AND j2.id_jornada=pu2.jornada
                        AND pa2.equipo_local=pa1.equipo_visit AND j2.temporada=j1.temporada 
                        AND pa2.equipo_visit='Real Zaragoza' AND pu2.equipo=pa1.equipo_visit 
                        AND pu2.goles_favor < pu2.goles_contra)
        HAVING COUNT(*) >= 4
        GROUP BY j1.temporada)
GROUP BY j.temporada
ORDER BY j.temporada;

