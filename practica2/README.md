# Enunciado Práctica 2 - Base de datos de peliculas

## Parte 1: Creación de una base de datos
- Diseñar una base de datos para una web sobre peliculas y series almacenados en el archivo DatosPeliculas.csv.
- Detalles incluyen título, año de estreno, género/s, actores, directores, personal de realización, etc.
- Considerar películas que son remakes, secuelas o precuelas de otras películas.

### Tareas y Memoria
- Esquema E/R global, restricciones, soluciones alternativas (1 página).
- Esquema relacional, normalización, sentencias SQL de creación de tablas (2 páginas).

## Parte 2: Introducción de datos y ejecución de consultas
- Cargar datos desde un fichero CSV llamado DatosPeliculas.csv.
- Alternativas: Usar tabla Oracle datosdb.datospeliculas o insertar resultados de consultas sobre datosBD.datospeliculas.
- Insertar claves artificiales usando secuencias.

### Tareas y Memoria
- Resumir pasos para poblar BD, destacar problemas y decisiones (1 página).
- Realizar consultas SQL con árboles sintácticos y respuestas obtenidas (1 página por consulta).

## Parte 3: Diseño Físico
- Revisar diseño físico en BD Oracle, optimizar preguntas y crear triggers.
- Utilizar comandos EXPLAIN PLAN FOR y SELECT PLAN_TABLE_OUTPUT para analizar el rendimiento.

### Tareas y Memoria
- Para cada consulta SQL de la Parte 2, enumerar problemas de rendimiento, acciones probadas y mejora de rendimiento (1 página).
- Listar restricciones no verificables con estructura de tablas y restricciones de integridad, elegir tres problemas resolubles con triggers e incluir sentencias SQL (1 página).
