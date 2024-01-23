CREATE TABLE jornada
(
    id_jornada      NUMBER PRIMARY KEY,
    num_jornada     NUMBER,
    temporada       NUMBER,
    liga            VARCHAR(10),
    UNIQUE(num_jornada, temporada, liga)
);

CREATE TABLE estadio
(
    nombre          VARCHAR(60) PRIMARY KEY,
    fecha           NUMBER(5), 
    capacidad       NUMBER(5)
);

CREATE TABLE equipo
(
    nombre          VARCHAR(60) PRIMARY KEY,
    nombre_corto    VARCHAR(60),
    nombre_hist     VARCHAR(60), 
    fundacion       NUMBER, 
    fundacion_legal NUMBER, 
    ciudad          VARCHAR(60),
    estadio         VARCHAR(60),
    UNIQUE(nombre_corto),
    FOREIGN KEY(estadio) REFERENCES estadio(nombre) ON DELETE SET NULL
);

CREATE TABLE otros_nombres
(
    nombre          VARCHAR(60) PRIMARY KEY,
    nombre_oficial  VARCHAR(60),
    FOREIGN KEY(nombre_oficial) REFERENCES equipo ON DELETE CASCADE
);

CREATE TABLE partido
(
    jornada         NUMBER,
    equipo_local    VARCHAR(60) NOT NULL,
    equipo_visit    VARCHAR(60) NOT NULL,
    PRIMARY KEY(jornada, equipo_local),
    UNIQUE(jornada, equipo_visit),
    FOREIGN KEY(jornada) REFERENCES jornada(id_jornada) ON DELETE CASCADE,
    FOREIGN KEY(equipo_local) REFERENCES equipo ON DELETE CASCADE,
    FOREIGN KEY(equipo_visit) REFERENCES equipo ON DELETE CASCADE
);

CREATE TABLE puntos(
    jornada         NUMBER, 
    equipo          VARCHAR(60), 
    puntos          NUMBER NOT NULL,
    goles_favor    NUMBER,
    goles_contra    NUMBER,
    PRIMARY KEY(jornada, equipo),
    FOREIGN KEY(jornada) REFERENCES jornada(id_jornada) ON DELETE CASCADE,
    FOREIGN KEY(equipo) REFERENCES equipo ON DELETE CASCADE
);
        
/* Permisos a usuarios */

--GRANT SELECT, INSERT ON jornada TO PUBLIC;
--GRANT SELECT, INSERT, UPDATE, DELETE ON estadio TO PUBLIC;
--GRANT SELECT, INSERT, UPDATE, DELETE ON equipo TO PUBLIC;
--GRANT SELECT, INSERT, UPDATE, DELETE ON otros_nombres TO PUBLIC;
--GRANT SELECT, INSERT, UPDATE, DELETE ON partido TO PUBLIC;