-- 3º Reto Guiado SQL: Relaciones de tablas (JOINS).

-- 2.1. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
SELECT      CONCAT("s"."first_name", ' ', "s"."last_name") AS "Empleado", 
            "st"."store_id"
FROM        "staff" AS "s"
CROSS JOIN  "store" AS "st" -- Realizamos una unión tipo CROSS ya que queremos ver todas las combinaciones posibles que existen entre los trabajadores y las tiendas que tenemos.

-- 2.2. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
SELECT      "c"."customer_id", -- Usamos 'c.' antes de la columna para especificar de qué tabla tomamos esa columna. En este caso, la tabla 'customer'
            CONCAT("c"."first_name", ' ', "c"."last_name")  AS "Cliente", -- Concatenamos para obtener el nombre del cliente en una única columna
            COUNT("r"."inventory_id")                       AS "Películas_Alquiladas"-- Aquí usamos 'r.' porque utilizamos la tabla 'rental'
FROM        "customer"  AS "c" -- Creamos un alias porque cada vez que especifiquemos una columna es necesario indicar a qué tabla pertenece. Con un alias escueto nuestro código es más limpio
LEFT JOIN   "rental"    AS "r" -- Realizamos un LEFT JOIN porque nos interesa tener la información de TODOS los clientes, incluso si no hay alquilado ninguna película.
ON          "r"."customer_id" = "c"."customer_id" -- Indicamos la columna de cada tabla por la que realizamos la unión.
GROUP BY    "c"."customer_id" 

-- 2.3 Obtener todas las películas y, si están disponibles en inventario, mostrar la cantidad disponible.
SELECT      "f"."title"                 AS "Título_Película", 
            COUNT("i"."inventory_id")   AS "Cantidad_Películas"
FROM        "film"          AS "f"
LEFT JOIN   "inventory"     AS "i" --Usamos una unión tipo Left ya que queremos obtener TODAS las películas, estén o no en el inventario.
ON          "f"."film_id" = "i"."film_id"
GROUP BY    "Título_Película"

-- 2.4. Obtener los actores y el número de películas en las que ha actuado
SELECT      CONCAT("a"."first_name",' ',"a"."last_name")    AS "Nombre_Actor", -- Concatenamos para tener una única columna con el nombre de los actores
            COUNT("fa"."film_id")                           AS "Películas_Actuadas"
FROM        "film_actor"    AS "fa"
RIGHT JOIN  "actor"         AS "a" -- Realizamos una unión tipo RIGHT porque nos interesa tener todos los acores de la tabla 'actors' incluso si no han actuado en ninguna película
ON          "fa"."actor_id" = "a"."actor_id"
GROUP BY    "Nombre_Actor"

-- 2.5. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
SELECT      "f"."title"                                     AS "Título_Película", 
            CONCAT("a"."first_name",' ',"a"."last_name")    AS "Nombre_Actor"
FROM        "film"          AS "f"  
LEFT JOIN   "film_actor"    AS "fa" -- Realizamos una unión tipo LEFT ya que nos interesan todas las películas. Tengan o no actores asociados.
ON          "f"."film_id" = "fa"."film_id"  
INNER JOIN  "actor"         AS "a" -- Aquí realizamos un INNER porque nos interesan los títulos de todas los actores que tienen asociados películas 
ON          "fa"."actor_id" = "a"."actor_id"

-- Comprobamos
SELECT      "f"."title"                                     AS "Título_Película", 
            CONCAT("a"."first_name",' ',"a"."last_name")    AS "Nombre_Actor"
FROM        "film"          AS "f"  
LEFT JOIN   "film_actor"    AS "fa"
ON          "f"."film_id" = "fa"."film_id"  -- Realizamos una unión tipo LEFT ya que nos interesan todas las películas. Tengan o no actores asociados.
INNER JOIN  "actor"         AS "a"
ON          "fa"."actor_id" = "a"."actor_id" -- Aquí realizamos un INNER porque nos interesan los títulos de todas los actores que tienen asociados películas 
WHERE CONCAT("a"."first_name",' ',"a"."last_name") IS NULL -- Con esta condición tomaríamos las películas sin ningún actor asignado.

-- 2.6. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
-- Ahora realizamos el ejercicio contrario al anterior
SELECT      CONCAT("a"."first_name",' ',"a"."last_name")    AS "Nombre_Actor",
            "f"."title"                                     AS "Título_Película"
FROM        "film"          AS "f"
INNER JOIN  "film_actor"    AS "fa" -- Realizamos una unión tipo INNER ya que nos interesan sólo las películas que tengan actores asociados. 
ON          "f"."film_id" = "fa"."film_id"
RIGHT JOIN  "actor"         AS "a" -- En cambio ahora hacemos una unión tipo RIGHT ya que nos interesan los todos los actores que tenemos, hayan actuado en alguna película o no.
ON          "fa"."actor_id" = "a"."actor_id"

-- Comprobamos
SELECT      CONCAT("a"."first_name",' ',"a"."last_name")    AS "Nombre_Actor",
            "f"."title"                                     AS "Título_Película"
FROM        "film"          AS "f"
INNER JOIN  "film_actor"    AS "fa" -- Realizamos una unión tipo INNER ya que nos interesan sólo las películas que tengan actores asociados. 
ON          "f"."film_id" = "fa"."film_id"
RIGHT JOIN  "actor"         AS "a" -- En cambio ahora hacemos una unión tipo RIGHT ya que nos interesan los todos los actores que tenemos, hayan actuado en alguna película o no.
ON          "fa"."actor_id" = "a"."actor_id"
WHERE "f"."title"  IS NULL -- Con esta condición tomaríamos los actores sin ninguna película asignada.

-- 2.7. Obtener todas las películas que tenemos y todos los registros de alquiler.
SELECT      "f"."title"         AS "Título", 
            "r"."rental_date"   AS "Fecha_Alquiler"
FROM        "film"          AS "f"
INNER JOIN  "inventory"     AS "i" -- Realizamos una unión tipo INNER ya que nos interesa obtener las películas que tenemos en el inventario
ON          "f"."film_id" = "i"."film_id"
FULL JOIN   "rental"        AS "r" -- Ahora realizamos una unión tipo FULL ya que nos interesan todas las películas y todos los registros de alquiler.
ON          "i"."inventory_id" = "r"."inventory_id"
-- Podemos observar cómo la película 'Academy Dinosaur' no se ha alquilado nunca.

-- 2.8. Encuentra el título de las películas que son de animación y tienen una duración mayor a 120 minutos en la tabla film.
SELECT      "f"."title"     AS "Título", 
            "f"."length"    AS "Duración_Película", 
            "c"."name"      AS "Nombre_Categoría"
FROM        "category"      AS "c"
INNER JOIN  "film_category" AS "fc" --La unión es de tipo INNER porque queremos sólo las películas de una categoría concreta
ON          "c"."category_id" = "fc"."category_id"
INNER JOIN  "film"          AS "f"
ON          "f"."film_id" = "fc"."film_id" -- Similar a la unión anterioir
WHERE       "c"."name"= 'Animation' -- Generamos la condición de que todas las películas sean de la categoría 'Animation'
    AND     "f"."length">120 --Añadimos la condición de que las películas deben durar más de 120 minutos

-- 2.9. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
SELECT      "c"."name"                  AS "Nombre_Categoría", 
            ROUND(AVG("f"."length"),0)  AS "Duración_Media" -- Mostramos la duración media sin decimales
FROM        "category"          AS "c"
INNER JOIN  "film_category"     AS "fc" -- Realizamos una unión tipo 'INNER' porque nos interesan sóloo los valores coincidentes de 'film' y 'film_category'
ON          "c"."category_id" = "fc"."category_id" 
INNER JOIN  "film"              AS "f" -- Igual que el anterior
ON          "f"."film_id" = "fc"."film_id"
GROUP BY    "c"."name" --Agrupamos por el nombre de la categoría
HAVING      ROUND(AVG("f"."length"),0) > 110 --Creamos la condición para que sólo nos muestre las categorías cuya media de duración sea mayor de 110 minutos

-- 2.10. Obtén los 5 clientes españoles que más dinero se hayan gastado con nosotros.
SELECT      CONCAT("c"."first_name", ' ', "c"."last_name")  AS "Cliente", 
            SUM("p"."amount")                               AS "Dinero_Gastado" -- Sumamos la cantidad gastada de todos los pedidos de cada cliente
FROM        "customer"  AS "c"
INNER JOIN  "payment"   AS "p" -- Realizamos una unión tipo INNER ya que nos interesan todos los clientes que hayan tenido pagos con nosotros
ON          "c"."customer_id" = "p"."customer_id"
INNER JOIN  "address"   AS "a" -- Realizamos una unión tipo INNER ya que nos interesan todos los clientes los cuales tengamos su dirección registrada.
ON          "c"."address_id" = "a"."address_id"
INNER JOIN  "city"      AS "ci" -- Realizamos una unión tipo INNER ya que nos interesan todas las direcciones con ciudad asociada.
ON          "ci"."city_id" = "a"."city_id"
INNER JOIN  "country"   AS "co" -- Por último, realizamos una unión tipo INNER ya que nos interesan todos las ciudades con país asociada.
ON          "ci"."country_id" = "co"."country_id"
WHERE       "country" = 'Spain' -- Creamos la condición en la que el país debe ser 'Spain'
GROUP BY    "Cliente" -- Agrupamos por cliente para poder realizar la suma de las cantidades gastadas por cada individuo
ORDER BY    "Dinero_Gastado"    DESC -- Ordenamos de forma descendentr para que primero aparezcan las personas que más dinero han gastado con nosotros.
LIMIT       5 -- Establecemos el límite en 5 para que sólo nos muestre el top 5.