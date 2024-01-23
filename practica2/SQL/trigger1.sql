CREATE OR REPLACE TRIGGER valido_fechas_serie
BEFORE INSERT OR UPDATE ON serie
FOR EACH ROW
BEGIN
    IF :NEW.estreno <= 1895 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El anyo de estreno debe ser mayor de 1895');
    END IF;

    IF :NEW.estreno > 2023 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El anyo de estreno debe ser menor o igual que 2023');
    END IF;

    IF :NEW.fin > 2023 THEN
        RAISE_APPLICATION_ERROR(-20003, 'El anyo de fin debe ser menor o igual que 2023');
    END IF;

    IF :NEW.estreno > :NEW.fin THEN
        RAISE_APPLICATION_ERROR(-20004, 'El anyo de estreno debe ser menor o igual al anyo de fin');
    END IF;
        
END;
/

-----------------------------  EJEMPLOS DE ERROR ------------------------------------
-- INSERT INTO serie (id_serie, estreno, titulo, fin) VALUES (12345, 1890, 'A', 2023);
-- INSERT INTO serie (id_serie, estreno, titulo) VALUES (22222, 2040, 'B');
-- INSERT INTO serie (id_serie, estreno, titulo, fin) VALUES (54321, 2000, 'C', 2025);
-- INSERT INTO serie (id_serie, estreno, titulo, fin) VALUES (33333, 2012, 'D', 2011);
-------------------------------------------------------------------------------------