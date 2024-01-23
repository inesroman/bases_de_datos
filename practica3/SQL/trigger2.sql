CREATE OR REPLACE TRIGGER fechas_vuelo
BEFORE INSERT OR UPDATE ON vuelo
FOR EACH ROW
WHEN (NEW.avion IS NOT NULL)
DECLARE
    anyo_avion NUMBER;
BEGIN
    SELECT anyo
    INTO anyo_avion
    FROM avion
    WHERE matricula = :NEW.avion;

    IF EXTRACT(YEAR FROM :NEW.fecha_salida) < anyo_avion THEN
        RAISE_APPLICATION_ERROR(-20002, 'La fecha de salida del vuelo 
        no puede ser anterior al anyo de fabricacion del avion.');
    END IF;

    IF :NEW.fecha_salida > :NEW.fecha_llegada THEN
        RAISE_APPLICATION_ERROR(-20003, 'La fecha de llegada de un vuelo no puede 
        ser anterior a su fecha de salida.');
    END IF;
END;
/

---------------------- ERROR FECHA ANTERIOR A AVION --------------------------
--INSERT INTO vuelo(id_vuelo, origen, destino, avion, num_vuelo, fecha_salida, 
--       fecha_llegada, cod_compania)
--VALUES (111111, 'SBN', 'TUS', 'N200WN', 123, 
--        TO_DATE('2004-01-01 10:00', 'YYYY-MM-DD HH24:MI'), 
--        TO_DATE('2004-01-01 09:00', 'YYYY-MM-DD HH24:MI'), 'WEQ');
------------------------------------------------------------------------------

---------------------- ERROR FECHAS NO VALIDAS -------------------------------
--INSERT INTO vuelo(id_vuelo, origen, destino, avion, num_vuelo, fecha_salida, 
--       fecha_llegada, cod_compania)
--VALUES (111111, 'SBN', 'TUS', 'N200WN', 123, 
--        TO_DATE('2005-01-01 09:00', 'YYYY-MM-DD HH24:MI'), 
--        TO_DATE('2005-01-01 08:00', 'YYYY-MM-DD HH24:MI'), 'WEQ');
------------------------------------------------------------------------------
