CREATE OR REPLACE TRIGGER aeropuertos_diferentes
BEFORE INSERT OR UPDATE OF origen, destino ON vuelo 
FOR EACH ROW
DECLARE
    ciudad_origen VARCHAR(30);
    ciudad_destino VARCHAR(30);
BEGIN
    IF :NEW.origen = :NEW.destino THEN
        RAISE_APPLICATION_ERROR(-20004, 'Los aeropuertos de origen y destino no pueden ser iguales');
    END IF;

    SELECT ciudad INTO ciudad_origen
    FROM aeropuerto
    WHERE iata = :NEW.origen;

    SELECT ciudad INTO ciudad_destino
    FROM aeropuerto
    WHERE iata = :NEW.destino;

    IF ciudad_destino = ciudad_origen THEN
        RAISE_APPLICATION_ERROR(-20005, 'Un avion no puede viajar de un aeropuerto
         a otro en la misma ciudad');
    END IF;
END;
/

---------------------  ERROR AEROPUERTOS IGUALES ----------------------------
--INSERT INTO vuelo(id_vuelo, origen, destino, avion, num_vuelo, fecha_salida, 
--       fecha_llegada, cod_compania)
--VALUES (111111, 'SBN', 'SBN', 'N200WN', 123, 
--        TO_DATE('2004-01-01 10:00', 'YYYY-MM-DD HH24:MI'), 
--        TO_DATE('2004-01-01 09:00', 'YYYY-MM-DD HH24:MI'), 'WEQ');
------------------------------------------------------------------------------

--------------------------  ERROR MISMA CIUDAD -------------------------------
--INSERT INTO vuelo(id_vuelo, origen, destino, avion, num_vuelo, fecha_salida, 
--       fecha_llegada, cod_compania)
--VALUES (111111, 'LGA', 'JFK', 'N200WN', 123, 
--       TO_DATE('2008-01-01 01:00', 'YYYY-MM-DD HH24:MI'), 
--        TO_DATE('2008-01-01 09:00', 'YYYY-MM-DD HH24:MI'), 'WEQ');
------------------------------------------------------------------------------