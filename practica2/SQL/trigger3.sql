CREATE OR REPLACE TRIGGER comprobar_pelis_relacionadas
BEFORE INSERT ON pelis_relacionadas
FOR EACH ROW
DECLARE
    estreno_original NUMBER;
    estreno_nueva NUMBER;
BEGIN

    IF :NEW.original = :NEW.nueva THEN
        RAISE_APPLICATION_ERROR(-20006, 'Una pelicula no puede relacionarse consigo misma');
    END IF;

    SELECT estreno INTO estreno_original FROM pelicula WHERE id_pelicula = :NEW.original;
    SELECT estreno INTO estreno_nueva FROM pelicula WHERE id_pelicula = :NEW.nueva;

    IF estreno_original > estreno_nueva THEN
        RAISE_APPLICATION_ERROR(-20007, 'El anyo de estreno de la pelicula nueva debe ser mayor o igual que el de la pelicula original');
    END IF;

END;
/

-----------     EJEMPLO FALLO RELACIONADA CONSIGO MISMA   ------------------------------
-- INSERT INTO pelis_relacionadas (original, nueva, tipo) VALUES (2, 2, 'precuela');
----------------------------------------------------------------------------------------

----------------------      EJEMPLO FALLO FECHAS    ------------------------------------
-- SELECT estreno FROM pelicula WHERE id_pelicula = '69';
-- SELECT estreno FROM pelicula WHERE id_pelicula = '3668';
-- INSERT INTO pelis_relacionadas (original, nueva, tipo) VALUES (3668, 69, 'precuela');
----------------------------------------------------------------------------------------