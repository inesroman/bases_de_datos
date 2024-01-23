CREATE TABLE aeropuerto
(
    iata            VARCHAR(3) PRIMARY KEY,
    nombre          VARCHAR(40) NOT NULL,
    ciudad          VARCHAR(30),
    estado          VARCHAR(2)
);

CREATE TABLE compania
(
    cod_compania    VARCHAR(7) PRIMARY KEY,
    nombre          VARCHAR(100) NOT NULL      
);

CREATE TABLE modelo
(
    id_modelo       NUMBER PRIMARY KEY,
    nombre          VARCHAR(20) NOT NULL,
    tipo_avion      VARCHAR(30) NOT NULL,
    tipo_motor      VARCHAR(20) NOT NULL,
    fabricante      VARCHAR(30) NOT NULL
);

CREATE TABLE avion
(
    matricula       VARCHAR(6) PRIMARY KEY,
    anyo            NUMBER,
    id_modelo       NUMBER,
    FOREIGN KEY(id_modelo) REFERENCES modelo(id_modelo) ON DELETE CASCADE
);

CREATE TABLE vuelo
(
    id_vuelo        NUMBER PRIMARY KEY, 
    origen          VARCHAR(3) NOT NULL,
    destino         VARCHAR(3) NOT NULL,
    avion           VARCHAR(6),
    num_vuelo       NUMBER,
    fecha_salida     DATE NOT NULL,
    fecha_llegada    DATE NOT NULL,
    cod_compania    VARCHAR(7) NOT NULL,
    FOREIGN KEY(origen) REFERENCES aeropuerto(iata) ON DELETE CASCADE,
    FOREIGN KEY(destino) REFERENCES aeropuerto(iata) ON DELETE CASCADE,
    FOREIGN KEY(avion) REFERENCES avion(matricula) ON DELETE CASCADE,
    FOREIGN KEY(cod_compania) REFERENCES compania(cod_compania) ON DELETE CASCADE
);

CREATE TABLE desvio
(
    id_vuelo        NUMBER,
    num_desvio      NUMBER,
    aeropuerto      VARCHAR(3) NOT NULL,
    PRIMARY KEY(id_vuelo, num_desvio),
    FOREIGN KEY(id_vuelo) REFERENCES vuelo(id_vuelo) ON DELETE CASCADE,
    FOREIGN KEY(aeropuerto) REFERENCES aeropuerto(iata) ON DELETE CASCADE
);

CREATE TABLE cancelacion
(
    id_vuelo        NUMBER PRIMARY KEY, 
    FOREIGN KEY(id_vuelo) REFERENCES vuelo(id_vuelo) ON DELETE CASCADE
);

CREATE TABLE retraso
(
    id_vuelo        NUMBER,
    motivo          VARCHAR(20),
    duracion        NUMBER,
    PRIMARY KEY(id_vuelo, motivo),
    FOREIGN KEY(id_vuelo) REFERENCES vuelo(id_vuelo) ON DELETE CASCADE
);
