-- 1º Reto Guiado SQL: Queries Básicas

-- 3.1. Crea el esquema de la BBDD de sakila


-- 3.2. Selecciona todos los nombres de las películas úncos.
SELECT  DISTINCT("title") AS "Título" --Usamos 'DISCTINCT' ya que queremos valores únicos, es decir, que no se repitan.
FROM    "film"

-- 3.3. Crea una columna con el nombre y apellidos de todos los actores y actrices.
SELECT  DISTINCT(CONCAT("first_name", ' ', "last_name"))    AS "Nombre Completo" --Utilizamos el CONCAT para poder concatenar las dos columnas y generar sólo una como resultado.
FROM    "actor"

-- 3.4 Muestra los nombres de todas las películas con una clasificación por edades de "R".
SELECT  "title"     AS "Título", 
        "rating"    AS "Clasificación"
FROM    "film"
WHERE   "rating" = 'R' --Aquí añadimos la condición, que en esre caso es que la clasificación por edades sea igual a 'R'.

-- 3.5. Obtén las películas que tenemos cuyo idioma conicide con el idioma original
SELECT  "title" AS "Título"
FROM    "film"
WHERE   "language_id" = "original_language_id"

-- 3.6. Encuentra el nombre y apellido de los actores que tengan "Allen"" en su apellido.
SELECT  DISTINCT(CONCAT("first_name", ' ', "last_name"))    AS "Nombre Completo"
FROM    "actor"
WHERE   "last_name" = 'ALLEN'

-- 3.7. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
SELECT  "title"     AS "Título", 
        "length"    AS "Duración"
FROM    "film"
WHERE   "length" > 180 --En la cláusula WHERE podemos utilizar operadores de comparación.

-- 3.8. Encuentra los nombres de los actores que tengan un actor_id entre 30 y 40
SELECT  DISTINCT(CONCAT("first_name", ' ', "last_name"))    AS "Nombre Completo", 
        "actor_id"
FROM    "actor"
WHERE   "actor_id"  BETWEEN 30 AND 40 --Usamos BETWEEN para poder obtener los valores que cumplan la condición entre esos dos números.

-- 3.9. Encuentra el título de las películas en la tabla film que no sean ni "NC-17" ni "G" en cuanto a su clasificación
SELECT  "title"     AS "Título", 
        "rating"    AS "Calificación"
FROM    "film"
WHERE   "rating" <> 'NC-17' --El operador '<>' representa valores distintos.
   AND  "rating" <> 'G'   -- Podemos usar 'AND' para poder encadenar condiciones en nuestras queries

-- 3.10. Encuentra el título de todas las películas que son "PG-13" o tienen una duración mayor a 3 horas en la tabla film.
SELECT  "title"     AS "Título", 
        "rating"    AS "Calificación", 
        "length"    AS "Duración"
FROM    "film"
WHERE   "rating" = 'PG-13' 
    OR  "length" > 180  -- Aquí utilizamos 'OR' para generar una elección entre las condiciones. Debe ocurrir una u otra.

-- 3.11. Encuentra la mayor y menor duración de una película de nuestra BBDD
SELECT  MAX("length")   AS "Duración_Máxima", -- Con el 'MAX' obtenemos el valor máximo de la columna que indiquemos.
        MIN("length")   AS "Duración_Mínima"  -- Por el contrario, con el 'MIN' obtenemos el valor mínimo de la columna que indiquemos.
FROM    "film"

-- 3.12. ¿Cuántas películas distintas tenemos?
SELECT  COUNT(DISTINCT "title")     AS "Título" --Utilizamos 'COUNT' para contar valors de la columna que especifiquemos
FROM    "film" 

-- 3.13. ¿Cuánto dinero ha generado en total la empresa?
SELECT  SUM("amount")   AS "Ganancias_Totales" -- Con 'SUM' obtenemos el resultado de la suma de los valores de la columna correspondiente.
FROM "payment" 

-- 3.14. ¿Cuál es la media de duración del alquiler de las películas?
SELECT  ROUND(AVG("rental_duration"),0)     AS "Media_Duración_Alquiler" --Utilizamos 'AVG' para calcular el promedio de valores de la columna específica.
FROM    "film" --Usamos 'ROUND' para redondear el resultado al número de decimales que especifiquemos, en este caso 0 ya que los días son números enteros y no deberían tener decimales

-- 3.15. Encuentra la variabilidad de los que costaría reemplazar las películas
SELECT  ROUND(STDDEV_SAMP("replacement_cost"),2)    AS "Media_Coste_Reemplazo" --Utilizamos STDDEV_SAMP para calcular la desviación de los valores de la columna deseada.
FROM    "film"  
