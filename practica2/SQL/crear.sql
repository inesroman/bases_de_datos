CREATE TABLE trabajador 
(
    id_trabajador   NUMBER PRIMARY KEY,
    nombre          VARCHAR(50) NOT NULL,
    sexo            VARCHAR(1)
);

CREATE TABLE pelicula
(
    id_pelicula     NUMBER PRIMARY KEY,
    estreno         NUMBER NOT NULL,
    titulo          VARCHAR(150) NOT NULL
);

CREATE TABLE genero_pelicula
(
    id_pelicula     NUMBER,
    genero          VARCHAR(15),
    PRIMARY KEY(id_pelicula, genero),
    FOREIGN KEY(id_pelicula) REFERENCES pelicula(id_pelicula) ON DELETE CASCADE
);

CREATE TABLE trabaja_pelicula
(
    id_trabajador   NUMBER,
    id_pelicula     NUMBER,
    trabajo         VARCHAR(80),
    PRIMARY KEY(id_trabajador, id_pelicula, trabajo),
    FOREIGN KEY(id_trabajador) REFERENCES trabajador(id_trabajador) ON DELETE CASCADE,
    FOREIGN KEY(id_pelicula) REFERENCES pelicula(id_pelicula) ON DELETE CASCADE
);

CREATE TABLE actua_pelicula
(
    id_actor        NUMBER,
    id_pelicula     NUMBER,
    personaje       VARCHAR(80),
    PRIMARY KEY(id_actor, id_pelicula, personaje),
    FOREIGN KEY(id_actor) REFERENCES trabajador(id_trabajador) ON DELETE CASCADE,
    FOREIGN KEY(id_pelicula) REFERENCES pelicula(id_pelicula) ON DELETE CASCADE
);

CREATE TABLE pelis_relacionadas
(
    original        NUMBER,
    nueva           NUMBER,
    tipo            VARCHAR(15) NOT NULL,
    PRIMARY KEY(original, nueva),
    FOREIGN KEY(original) REFERENCES pelicula(id_pelicula) ON DELETE CASCADE,
    FOREIGN KEY(nueva) REFERENCES pelicula(id_pelicula) ON DELETE CASCADE
);

CREATE TABLE serie
(
    id_serie        NUMBER PRIMARY KEY,
    estreno         NUMBER NOT NULL,
    titulo          VARCHAR(150) NOT NULL, 
    fin             NUMBER
);

CREATE TABLE genero_serie
(
    id_serie        NUMBER,
    genero          VARCHAR(15),
    PRIMARY KEY(id_serie, genero),
    FOREIGN KEY(id_serie) REFERENCES serie(id_serie) ON DELETE CASCADE
);

CREATE TABLE trabaja_serie
(
    id_trabajador   NUMBER,
    id_serie        NUMBER,
    trabajo         VARCHAR(80),
    PRIMARY KEY(id_trabajador, id_serie, trabajo),
    FOREIGN KEY(id_trabajador) REFERENCES trabajador(id_trabajador) ON DELETE CASCADE,
    FOREIGN KEY(id_serie) REFERENCES serie(id_serie) ON DELETE CASCADE
);

CREATE TABLE actua_serie
(
    id_actor        NUMBER,
    id_serie        NUMBER,
    personaje       VARCHAR(80),
    PRIMARY KEY(id_actor, id_serie, personaje),
    FOREIGN KEY(id_actor) REFERENCES trabajador(id_trabajador) ON DELETE CASCADE,
    FOREIGN KEY(id_serie) REFERENCES serie(id_serie) ON DELETE CASCADE
);

CREATE TABLE capitulo 
(
    id_serie        NUMBER,
    titulo          VARCHAR(150),
    episodio        NUMBER,
    temporada       NUMBER,
    estreno         NUMBER,
    PRIMARY KEY(id_serie, titulo),
    FOREIGN KEY(id_serie) REFERENCES serie(id_serie) ON DELETE CASCADE
);