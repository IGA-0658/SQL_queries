-- 2º Reto Guiado SQL: Queries Avanzadas.

-- 2.1. Ordena las películas por duración de forma ascendente
SELECT      "title"     AS "Título", 
            "length"    AS "Duración"
FROM        "film"
ORDER BY    "length" --Usamos ORDER BY para ordenar los resultados. Por defecto los ordena de forma ascendente.

-- 2.2. Muestra los 10 clientes con mayor valor de id
SELECT      CONCAT("first_name",' ',"last_name")    AS "Cliente",
            customer_id
FROM        "customer"
ORDER BY    "customer_id"   DESC -- Ordenamos de forma descendiente para tener los valores más altos 
LIMIT       10 -- Usamos LIMIT para limitar el número de valores que queremos que devuelva la consulta, en este caso 10

-- 2.3. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
SELECT      "payment_id",
            "amount"        AS "Cantidad", 
            "payment_date"  AS "Fecha_Alquiler"
FROM        "payment"
ORDER BY    "payment_date" DESC
LIMIT       1 -- Establecemos el LIMIT en 1 para que sólo nos devuelva un valor.
OFFSET      3 -- En este caso, usamos OFFSET para indicar el número de filas que queremos omitir del resultado.

-- 2.4. Qué películas se alquilan por encima del precio medio. Para este ejercicio tendrás que generar dos queries diferentes. Una primera para calcular la media y la segunda para obtener las películas que se alquilan por encima de ese valor.
SELECT  ROUND(AVG("rental_rate"),2)     AS "Precio_Medio" --Redondeamos la media a dos decimales ya que un precio no puede tener más de dos decimales.
FROM    "film";

SELECT      "title"         AS "Título", 
            "rental_rate"   AS "Precio_Alquiler"
FROM        "film"
WHERE       "rental_rate" >= 2.98 -- Aquí añadimos la condición utilizando el valor de la media calculada en la query anterior.
ORDER BY    "rental_rate"   DESC; 

/* Esta es una forma muy poco óptima de realizar este cálculo ya que si, por ejemplo, añadimos nuevas películas a la tabla el valor de la media 
cambiaría. En el reto guiado de subconsultas veremos una forma más óptima de realizar este ejercicio */

-- 2.5. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
SELECT      "rating"            AS "Clasificación", 
            COUNT("film_id")    AS "Num_Películas" --Con 'COUNT' contamos el número de películas 
FROM        "film"
GROUP BY    "Clasificación" -- Aquí estamos agrupando por clasificación para que nos genere el conteo de cada clasificación.

-- 2.6. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
SELECT      "rating"                AS "Clasificación", 
            ROUND(AVG("length"),0)  AS "Duración_Promedio" --Usamos AVG para calcular la media, y ROUND para redondear el resultado. En este caso con 0 decimales
FROM        "film"
GROUP BY    "Clasificación" 

-- 2.7. Números de alquileres por día. Ordenados por cantidad de alquileres de forma descendente.
SELECT      CONCAT(EXTRACT(DAY FROM "payment_date"),'-',EXTRACT(MONTH FROM "payment_date"),'-',EXTRACT(YEAR FROM "payment_date"))         AS "Fecha_Alquiler", 
-- Extraemos el día, año y mes de la columna "payment_date" y lo concatenamos todo para obtenerlos en una única columna
            COUNT("payment_id")                                                                                                           AS "Número_Pedidos"
FROM        "payment"
GROUP BY    "payment_date" -- Agrupamos por la fecha del préstamo para poder contar los préstamos
ORDER BY    "Número_Pedidos"        DESC -- Ordenamos por el número de pedidos de forma descendente

-- 2.8. Averigua el número de alquileres registrados por mes.
SELECT      EXTRACT(MONTH FROM "rental_date")   AS "Mes_Alquiler", -- Extraemos el mes de la columna 'rental_date' para poder calcular los alquileres por mes.
            COUNT("rental_id")                  AS "Alquileres" -- Contamos el identificador de los alquileres
FROM        "rental"
GROUP BY    "Mes_Alquiler" --Agrupamos por el mes
ORDER BY    "Mes_Alquiler" --Ordenamos por meses.

-- 2.9. Número de películas por categoría estrenadas en 2006
SELECT      "rating"            AS "Clasificación", 
            COUNT("film_id")    AS "Películas_Estrenadas"
FROM        "film"
WHERE       "release_year" = 2006 -- Creamos la condición para sólo obtener las películas estrenadas en 2006
GROUP BY    "rating" -- Agrupamos por clasificación por edades

-- 2.10. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT      "actor_id"
FROM        "film_actor"
GROUP BY    "actor_id"  --Empezamos agrupando por el id de cada actor para poder contar las películas en las que ha participado.
HAVING      COUNT(DISTINCT("film_id"))>40 -- Ahora creamos una condición en la que sólo nos devuelva los actores cuyo conteo de películas sea mayor de 40
