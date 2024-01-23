CREATE OR REPLACE TRIGGER actualizar_fin_serie
BEFORE INSERT ON capitulo
FOR EACH ROW
DECLARE
    estreno_serie NUMBER;
BEGIN
    SELECT estreno INTO estreno_serie FROM serie WHERE id_serie = :NEW.id_serie;

    IF :NEW.estreno < estreno_serie THEN
        RAISE_APPLICATION_ERROR(-20005, 'La fecha de estreno del capitulo no puede ser menor que la fecha de estreno de la serie');
    END IF;

    IF :NEW.estreno > estreno_serie THEN
        UPDATE serie SET fin = :NEW.estreno WHERE id_serie = :NEW.id_serie;
    END IF;
END;
/

-------------     EJEMPLO ACTUALIZACIÓN DE FIN          ----------------
-- SELECT fin FROM serie WHERE id_serie = '1590';
-- INSERT INTO capitulo (id_serie, titulo, episodio, temporada, estreno) 
--        VALUES (1590, 'Capítulo X', 1, 1, 2022);
-- SELECT fin FROM serie WHERE id_serie = '1590';
------------------------------------------------------------------------

-------------         EJEMPLO DE ERROR                   ----------------
-- SELECT estreno FROM serie WHERE id_serie = '1590';
-- INSERT INTO capitulo (id_serie, titulo, episodio, temporada, estreno) 
--        VALUES (1590, 'Capítulo X', 1, 1, 1990);
-------------------------------------------------------------------------