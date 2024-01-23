# Enunciado Práctica 3 - Base de datos de vuelos

## Parte 1: Creación de una base de datos
- Diseñar una base de datos para gestionar información de vuelos comerciales en aeropuertos de EEUU almacenada en el archivo DatosVuelos.csv.
- Detalles incluyen número de vuelo, origen, destino, fechas y horarios, incidencias, causas de retraso, aeropuertos alternativos, información de aeropuertos, compañías aéreas y aviones.

### Tareas y Memoria
- Esquema E/R global, restricciones, soluciones alternativas (1 página).
- Esquema relacional, normalización, sentencias SQL de creación de tablas (2 páginas).

## Parte 2: Introducción de datos y ejecución de consultas
- Cargar datos desde un fichero CSV llamado DatosVuelo.csv.
- Alternativas: Usar tabla Oracle datosdb.datosvuelos o insertar resultados de consultas sobre datosBD.datosvuelos.
- Insertar claves artificiales usando secuencias.

### Tareas y Memoria
- Resumir pasos seguidos para poblar BD, destacar problemas y decisiones (1 página).
- Realizar consultas SQL con árboles sintácticos y respuestas obtenidas (1 página por consulta).

## Parte 3: Diseño Físico
- Revisar diseño físico en BD Oracle, optimizar preguntas y crear triggers.
- Utilizar comandos EXPLAIN PLAN FOR y SELECT PLAN_TABLE_OUTPUT para analizar el rendimiento.

### Tareas y Memoria
- Para cada consulta SQL de la Parte 2, enumerar problemas de rendimiento, acciones probadas y mejora de rendimiento (1 página).
- Listar restricciones no verificables con estructura de tablas y restricciones de integridad, elegir tres problemas resolubles con triggers e incluir sentencias SQL (1 página).
