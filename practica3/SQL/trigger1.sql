CREATE OR REPLACE TRIGGER desvios_no_cancelados
BEFORE INSERT ON desvio
FOR EACH ROW 
DECLARE 
    cancelado NUMBER;
BEGIN
    SELECT COUNT(*) INTO cancelado
    FROM cancelacion
    WHERE id_vuelo = :NEW.id_vuelo;

    IF cancelado >= 1 THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Un vuelo que ha sido cancelado no puede ser retrasado');
    END IF;
END;
/

-----------------------------  EJEMPLO DE ERROR ------------------------------
-- INSERT INTO desvio(id_vuelo, num_desvio, aeropuerto) VALUES(303, 1, 'YUM');
------------------------------------------------------------------------------
