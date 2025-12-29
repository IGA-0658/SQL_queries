-- 4º Reto Guiado SQL: Subqueries.

-- 2.1. Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
SELECT  CONCAT("a"."first_name", ' ', "a"."last_name") AS "Actor"
FROM    "actor" AS "a"
WHERE   "a"."actor_id" NOT IN ( -- Generamos una subconsulta que nos relacione los actores que NO tengan ninguna película asociada
    SELECT  "fa"."actor_id"
	FROM    "film_actor"    AS "fa")

-- 2.2. Qué películas se alquilan por encima del precio medio. (Este ejercicio ya lo resolvimos en el segundo reto guiado de SQL)
SELECT      "title"         AS "Título", 
            "rental_rate"   AS "Precio_Alquiler"
FROM        "film"
WHERE       "rental_rate" >= (
    SELECT  AVG("rental_rate")
	FROM    "film")
ORDER BY    "rental_rate"   DESC

-- 2.3. Encuentra los nombres de las películas que tienen la misma duración que la película con el título "Dancing Fever" Ordena los resultados alfabéticamente por título de película.
SELECT 		"f"."title" AS "Título"
FROM 		"film" AS "f"
WHERE 		"f"."length" = (
	SELECT 	"length" 
	FROM 	"film" 
	WHERE 	"title" = 'DANCING FEVER')
AND 		"f"."title" <> 'DANCING FEVER'
ORDER BY 	"f"."title"

-- 2.4. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
SELECT 		CONCAT("c"."first_name", ' ', "c"."last_name") AS "Cliente"
FROM 		"customer" AS "c"
WHERE 		"c"."customer_id" IN ( -- Creamos una subconsulta que relacione los clientes con los registros de alquiler para que sólo tenga en cuenta las coincidencias.
	SELECT 		"r"."customer_id"
	FROM 		"rental" 	AS "r"
	GROUP BY 	"r"."customer_id" -- Agrupamos por el identificador de cliente para poder hacer la función agregada
	HAVING 		COUNT(DISTINCT "r"."inventory_id") > 7) -- Generamos la condición de que se hayan alquilado 7 películas distintas por cliente.
ORDER BY 	"c"."last_name" -- Ordenamos los resultados por orden alfabético del apellido

-- 2.5. Encuentra el nombre y apellido de los actores que aparecen en la película con título "Egg Igby".
SELECT 	CONCAT("a"."first_name", ' ', "a"."last_name") 	AS "Actor"
FROM 	"actor" 	AS "a"
WHERE 	"a"."actor_id" 	IN ( -- Creamos una subconsulta con los actores que tienen películas asociadas
	SELECT 	"fa"."actor_id"
	FROM 	"film_actor" AS "fa"
	WHERE 	"fa"."film_id" IN ( -- Creamos una segunda subconsulta con las películas que tienen actores asociados
		SELECT 	"f"."film_id"
		FROM 	"film" AS "f"
		WHERE 	"f"."title" ='EGG IGBY')) -- Generamos la condición de que la película debe ser la que tiene el título ''Egg Igby'

-- 2.6. Encuentra el título de todas las películas que son de la misma categoría que "Animation".
SELECT 	"title" AS "Título_Película"
FROM 	"film" AS "f"
WHERE 	"f"."film_id" IN ( -- Creamos una primera subconsulta para seleccionar todas las películas con categoría asociada
	SELECT 	"fc"."film_id"
	FROM "film_category" AS "fc"
	WHERE "fc"."category_id" IN ( -- Ahora creamos otra subconsulta para ver los nombres de las categorías
		SELECT "c"."category_id"
		FROM "category" AS "c"
		WHERE "c"."name" = 'Animation')) -- Finalmente generamos la condición de que todas las películas deben tener la categoría 'Animation'

-- 2.7. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días. 
SELECT 	"title" AS "Título_Película"
FROM 	"film" AS "f"
WHERE 	"f"."film_id" IN ( -- Creamos una subconsulta para obtener las películas que tenemos en el inventario
	SELECT 	"i"."film_id"
	FROM "inventory" AS "i"
	WHERE "i"."inventory_id" IN ( -- Ahora generamos una subconsulta donde relacionemos las películas en el inventario con las que se han alquilado
		SELECT "r"."inventory_id"
		FROM "rental" AS "r"
		WHERE DATE_PART('day',"r"."return_date" - "r"."rental_date") > 8)) /*Usamos DATE_PART para poder realizar operaciones aritméticas en una columna tipo fecha en una unidad de tiempo 
		específica. En es ete caso días*/
		-- Por último, creamos la condición en la que la diferencia entre el día de devolución y el día de alquiler debe ser mayor de 8 días

-- 2.8. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Music".
SELECT 	CONCAT("a"."first_name", ' ', "a"."last_name") AS "Actor"
FROM 	"actor" AS "a"
WHERE 	"a"."actor_id" NOT IN ( -- Creamos una primera subconsulta para obtener los actores que han participado en alguna película de las que tenemos registradas
	SELECT 	"fa"."actor_id"
	FROM 	"film_actor" AS "fa"
	WHERE 	"fa"."film_id" IN ( -- Ahora generamos una segunda subconsulta con las películas las cuales tienen categoría asociada
		SELECT 	"fc"."film_id"
		FROM "film_category" AS "fc"
		WHERE "fc"."category_id" IN ( -- Por último, generamos una subconsulta que nos relacione el índice de la categoría con el nombre de la misma
			SELECT "c"."category_id"
			FROM "category" AS "c"
			WHERE "name" = 'Music'))) -- Para finalizar, creamos la condición de que todas las películas seleccionadas sean de la categoría 'Music'

-- 2.9. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre "Tammy Sanders" y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
SELECT 	"f"."title" AS "Título"
FROM 	"film" AS "f"
WHERE 	"f"."film_id" IN ( -- Creamos una subquery que nos relacione todas las películas que tenemos registradas con las que tenemos en el inventario
	SELECT "i"."film_id"
	FROM "inventory" AS "i"
	WHERE "i"."inventory_id" IN ( -- Creamos una subquery que nos relaciones las películas que tenemos en el inventario con las películas con alquileres registrados.
		SELECT "r"."inventory_id"
		FROM "rental" AS "r"
		WHERE "r"."customer_id" IN ( -- Finalmente, creamos una subquery que nos relacione los clientes con alquileres con la lista de clientes.
			SELECT "c"."customer_id"
			FROM "customer" AS "c"
			WHERE "first_name" = 'TAMMY' AND "last_name" = 'SANDERS')-- Creamos la condición con el nombre y apellido del cliente 'Tammy Sanders
		AND "r"."return_date" IS NULL))-- Por último, elegimos sólo los alquileres que aún no se han devuelto, es decir, que no tienen fecha de devolución.

-- 2.10. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría "Sci-Fi." Ordena los resultados alfabéticamente por apellido.
SELECT 	CONCAT("a"."first_name", ' ', "a"."last_name") AS "Actor"
FROM 	"actor" AS "a"
WHERE 	"a"."actor_id" IN ( -- Creamos la subconsulta que nos relacione todos los actores que coincidan con algun identificador de película
	SELECT 	"fa"."actor_id"
	FROM 	"film_actor" AS "fa"
	WHERE 	"fa"."film_id" IN (-- Ahora generaremos una subconsulta que nos relacione el identificador de película con la categoría
		SELECT 	"fc"."film_id"
		FROM 	"film_category" AS "fc"
		WHERE 	"fc"."category_id" IN (
			SELECT 	"c"."category_id" -- Por último, relacionaremos el identificador de categoría con el nombre de la misma
			FROM 	"category" AS "c"
			WHERE 	"c"."name" = 'Sci-Fi')))-- Ahora creamos la condición por la que todas las películas deben ser de la categoría 'Sci-Fi'
ORDER BY 	"a"."last_name" -- Para terminar, ordenamos los resultados por orden alfabético del apellido.

-- 2.11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
SELECT 		"c"."name" 					AS "Categoría", 
			COUNT("fc"."category_id") 	AS "Recuento" -- Contamos el número de veces que aparece cada categoría.
FROM 		"category" 		AS "c"
INNER JOIN 	"film_category" AS "fc" -- Realizamos una unión dtipo INNER ya que nos interesan sólo las películas con categoría asociada.
ON 			"c"."category_id" = "fc"."category_id"
WHERE 		"fc"."film_id" 	IN ( -- Creamos una subconsulta con las películas que tengamos su categoría y estén en el inventario
	SELECT 		"i"."film_id"
	FROM 		"inventory" AS "i"
	WHERE 		"i"."inventory_id" IN ( -- Creamos otra subconsulta con las películas que tengamos en el inventario y se hayan alquilado.
		SELECT 		"r"."inventory_id"
		FROM 		"rental" AS "r"))
GROUP BY 	"c"."name" --Agrupamos por categorías para poder realizar el recuento.

-- 2.12. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película "Spartacus Cheaper" se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
SELECT 	CONCAT("a"."first_name", ' ', "a"."last_name") AS "Actor"
FROM 	"actor" AS "a"
WHERE 	"a"."actor_id" IN ( -- Primero generamos una subconsulta que nos proporcione los actores que hayan participado en alguna película que tengamos registrada
	SELECT 	"fa"."actor_id"
	FROM 	"film_actor" AS "fa"
	WHERE 	"fa"."film_id" IN (-- Ahora generamos una subconsulta que nos devuelva las películas que tenemos en el inventario
		SELECT 	"i"."film_id"
		FROM 	"inventory" AS "i"
		WHERE 	"i"."inventory_id" IN (-- Después generamos otra subconsulta, en este caso que nos indique las películas que tenemos en el inventario y que se hayan alquilado.
			SELECT 	"r"."inventory_id"
			FROM 	"rental" AS "r"
			WHERE 	"r"."inventory_id" IN (-- Ahora volvemos a hacer las relaciones a la inversa para que el título sea 'Spartacus Cheaper'
				SELECT 	"i"."inventory_id"
				FROM 	"inventory" AS "i"
				WHERE 	"i"."film_id" IN (
					SELECT 	"f"."film_id"
					FROM 	"film" AS "f"
					WHERE 	"title" = 'SPARTACUS CHEAPER'))-- Generamos la condición de que la película a comparar debe ser 'Spartacus Cheaper'
			ORDER BY "rental_date" -- Ordenamos de forma ascendente porque queremos obtener el primer día en el que se alquiló la película
			LIMIT 1))-- Limitamos a 1 la condición ya que es el primer día
ORDER BY "a"."last_name") -- Por último ordenamos los nombres de los actores alfabéticamente por apellido.
