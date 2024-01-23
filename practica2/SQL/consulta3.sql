SELECT SUM(COUNT(DISTINCT ap.personaje)) as num_personajes
FROM actua_pelicula ap 
WHERE ap.personaje <> 'UNKNOWN' AND ap.id_pelicula IN (
    SELECT DISTINCT r.original
    FROM pelis_relacionadas r 
    WHERE r.tipo = 'precuela' OR r.tipo = 'secuela'
    UNION
    SELECT DISTINCT r.nueva
    FROM pelis_relacionadas r 
    WHERE r.tipo = 'precuela' OR r.tipo = 'secuela'
)
GROUP BY ap.personaje
HAVING COUNT(DISTINCT ap.id_actor) >= 4;
