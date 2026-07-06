--///// CONSULTAS AGREGACION 
-- 1/ Mostrar el ID del álbum, nombre de la canción y precio.
SELECT	"AlbumId" AS "ID_Album",
		"Name" AS "Nombre Cancion",
		"UnitPrice" AS "Precio"		
FROM "Track" AS t; 

-- 2/ Buscar precios MIN y MAX de todas las canciones
SELECT	MIN("UnitPrice") AS "Precio_Min",
		MAX("UnitPrice") AS "Precio_MAX"
FROM "Track" AS t;

--3/ Contar la cantidad de albunes (COUNT) de nuestra BBDD
SELECT COUNT("AlbumId") AS "Num_Albunes" 
FROM "Album" AS a;

--4/ Número total de albunes DISTINTOS de nuestra BBDD, (es de cir sin duplicados)
SELECT COUNT(DISTINCT("AlbumId")) AS "Num_Albunes_DIST" 
FROM "Album" AS a;

--5/ Sumar la duracion total de todas las canciones (SUM)
SELECT SUM("Milliseconds") AS "Duracion" 
FROM "Track" AS t; 

--6/ Calcular precio promedio de las canciones
SELECT ROUND(AVG("UnitPrice"),2) AS "Precio_PROM" 
FROM "Track" AS t; 

--7/ Calcular la desviación estándar y la varianza de los precios de las canciones.
SELECT	ROUND(STDDEV("UnitPrice"),2) AS "Desviacion_STD_Precio",
		ROUND(VARIANCE("UnitPrice"),2) AS "Varianza_Precio"
FROM "Track" AS t; 

--8/ Mostrar nombres clientes en única columna (CONCAT)
SELECT CONCAT("FirstName", ' ', "LastName") AS "Nombre_Completo"
FROM "Customer" AS c; 

--///// CONSULTAS ORDENACION
--9/ Mostrar los títulos de las canciones y su duración ordenadas por duración (de mayor a menor)
/*predet ordena ASC, lo mimso sin ASC -> ORDER BY "Duracion" ASC */
SELECT	"Name" AS "Canción",
		"Milliseconds" AS "Duracion"	
FROM	"Track" AS t 
ORDER BY "Duracion" DESC
--10/ Mostar las anteriores pero limitado a las 10 más largas (LIMT). 
SELECT	"Name" AS "Canción",
		"Milliseconds" AS "Duracion"	
FROM	"Track" AS t 
ORDER BY "Duracion" DESC
LIMIT 10;

--11/ Mostrar la tercera más larga (saltar las 2º primeras => OFFSET)
SELECT	"Name" AS "Canción",
		"Milliseconds" AS "Duracion"	
FROM	"Track" AS t 
ORDER BY "Duracion" DESC
LIMIT 1
OFFSET 2;

--///// CONSULTAS AGRUPACION
--12/ Mostrar cuántos álbumes tiene cada artista y ordenar en forma descendente.
SELECT "ArtistId" AS "Artista_ID",
		COUNT("AlbumId") AS "Num_Albumes"
FROM "Album" AS a
GROUP BY "Artista_ID"
ORDER BY "Num_Albumes" DESC;

--13/ En base a lo anterior mostrar el nombre del artista con más albumes
SELECT "Name" 
FROM "Artist"
WHERE "ArtistId" = 90;

--14/ Muestra cuántos álbumes tienen los artistas con un identificador mayor de 200 (WHERE)
SELECT "ArtistId" AS "Artista_ID",
		COUNT("AlbumId") AS "Num_Albumes"
FROM "Album" AS a
WHERE "ArtistId"  > 200
GROUP BY "Artista_ID";

--15/ Muestra los artistas con más de 5 álbumes (HAVING, teniendo..)
SELECT "ArtistId" AS "Artista_ID",
		COUNT("AlbumId") AS "Num_Albumes"
FROM "Album" AS a
GROUP BY "Artista_ID"
HAVING COUNT("AlbumId") > 5; 


--////// EJERCICIOS EXRA /////
--16/ Obtener precio total y promedio de pistas para cada tipo de medio, considerando slolo aquellas cuyo precio sea mayor o igual a 0.99 
SELECT	"MediaTypeId" ,
		SUM("UnitPrice") AS "Precio_Total",
		AVG("UnitPrice") AS "Precio_Promedio"
FROM "Track" AS t
WHERE "UnitPrice" >= 0.99
GROUP BY "MediaTypeId"; 

--17/ Mostrar el importe total de facturas cuyo total es mayor a $20.
SELECT	"InvoiceId",
		SUM("Total") AS "Total"
FROM "Invoice" AS i
GROUP BY "InvoiceId"
HAVING SUM("Total") >20
ORDER BY "InvoiceId";

--mejorado
SELECT	"InvoiceId",
		"Total"
FROM "Invoice" AS i
WHERE "Total" >20
ORDER BY "InvoiceId";

--18/ Obtener el promedio y la suma de la duración de las pistas (en milisegundos) para cada tipo de medio, pero solo para aquellos donde hay más de 30 pistas.
SELECT	"MediaTypeId",
		ROUND(AVG("Milliseconds"),0) AS "Promedio_duracion",
		SUM("Milliseconds") AS "Total_duracion"
		--COUNT("TrackId") para comprobar
FROM "Track" AS t
GROUP BY "MediaTypeId"
HAVING COUNT("TrackId") > 30;

--////// 3- Relaciones entre tablas //////
--20/ Obtener todos los clientes con facturas asociadas (INNER JOIN)
SELECT CONCAT(c."FirstName", ' ', c."LastName")  
FROM "Customer" AS c --tabla cli
INNER JOIN "Invoice" AS i --tabla fact que coinciden "INNER"
ON c."CustomerId" = i."CustomerId"; --columna de UNION

--pone clie e id para demostrar

SELECT CONCAT(c."FirstName", ' ', c."LastName") AS "Cliente",
	i."InvoiceId" 
FROM "Customer" AS c --tabla cli
INNER JOIN "Invoice" AS i --tabla fact que coinciden "INNER"
ON c."CustomerId" = i."CustomerId" --columna de union
ORDER BY "Cliente"; 

--21/ Extrae todos los álbumes con sus canciones. Incluso aquellos sin canciones asociadas (LEFT JOIN).
SELECT a."Title" AS "Título",
	 t."Name" AS "Canción"
FROM "Album" AS a
LEFT JOIN "Track" AS t 
ON a."AlbumId" = t."AlbumId"; 
-- WHERE t."Name" IS NULL (chequeo si hay algún nulo)

--22/ Encuentra todas las facturas y asócialas a su cliente. Incluye clientes que no tengan facturas asociadas (RIGHT JOIN).
SELECT	i."InvoiceId" AS "Num_Factura",
		CONCAT(c."FirstName", ' ', c."LastName") AS "Cliente"
FROM "Invoice" AS i
RIGHT JOIN "Customer" AS c 
ON i."CustomerId" = c."CustomerId"; 

--23/ Obten todos los álbumes y canciones, esten asociados o no. (FULL JOIN)
SELECT a."Title" AS "Disco",
	 t."Name" AS "Canción"
FROM "Album" AS a
FULL JOIN "Track" AS t 
ON a."AlbumId" = t."AlbumId"; 
--WHERE t."Name" IS NULL

--24/ Obten todas las cambinaciones posibles de clientes y empleados. (CROSS JOIN)
SELECT	CONCAT(c."FirstName", ' ', c."LastName") AS "Cliente",
		CONCAT(e."FirstName", ' ', e."LastName") AS "Empoleado"
FROM "Customer" AS c
CROSS JOIN "Employee" AS e;   

--/////////// Ejercicios EXTRA ///////

--25/
/* Mostrar lista de álbumes y pistas asociadas ordenadas por duración de las pistas, 
 * limitando los resultados a 10 filas y saltando las primeras 5*/
SELECT	a."Title" AS "Disco",
		t."Name" AS "Cancion",
		-- t."Milliseconds" (para comprobar) 
FROM "Album" AS a
INNER JOIN "Track" AS t
ON a."AlbumId" = t."AlbumId" 
ORDER BY t."Milliseconds"
LIMIT 10
OFFSET 5;

--26/
/*Mostrar los títulos de los álbumes y el número de pistas en c/u, incluyendo aquellos
 *  que no tienen pistas */
SELECT	a."Title" AS "Disco",
		COUNT(t."TrackId") AS "Canciones",
FROM "Album" AS a
LEFT JOIN "Track" AS t
ON a."AlbumId" = t."AlbumId"
GROUP BY a."Title"
ORDER BY "Canciones" DESC; 

--27/
/*Mostrar todos los álbumes junto con el precio promedio de las canciones, 
 * (incluyendo las que no tienen coincidencia)*/
SELECT	a."Title" AS "Album",
		COUNT(t."TrackId") AS "Canciones",
		AVG(t."UnitPrice") AS "Precio Prom" 
FROM "Album" AS a
FULL JOIN "Track" AS t
ON a."AlbumId" = t."AlbumId"
GROUP BY a."Title"
ORDER BY "Precio Prom" DESC;

--calcular el valor de cada album

--28/ 
/* Motrar el total de facturas y el monto total por cliente incluyendo aquellos
 *  que no han realizado compras, pero mostrando sólo las facturas mayores a $10*/
SELECT	CONCAT(c."FirstName", ' ', c."LastName") AS "Cliente",
		COUNT(i."InvoiceId") AS "Num_Facturas",
		SUM(i."Total") AS "Monto_Total"
FROM "Invoice" AS i
RIGHT JOIN "Customer" AS c
ON i."CustomerId" = c."CustomerId"
WHERE i."Total" > 10 --Muestro sólo las mayores a $10
GROUP BY "Cliente";
 

--29/
/* Obtener el total de ventas y el número de facturas por cada cliente cuyo total 
 * de ventas supere los $40 */
SELECT	CONCAT(c."FirstName", ' ', c."LastName") AS "Cliente",
		COUNT(i."InvoiceId") AS "Num_Facturas",
		SUM(i."Total") AS "Total Ventas"
FROM "Invoice" AS i
RIGHT JOIN "Customer" AS c
ON i."CustomerId" = c."CustomerId"
GROUP BY "Cliente"
HAVING SUM(i."Total") > 40;

--30/ Mostrar el cliente que más ha gastado y la cantidad de Facturas a su nombre
 
/*SELECT * FROM "Customer" AS c
WHERE c."FirstName" = 'Luis'
*/
/* --da venta total de un cliente
SELECT SUM(i."Total")
FROM "Invoice" AS i 
WHERE i."CustomerId" = 57
46.52 / 7 fact
*/
/*
SELECT	i."CustomerId" AS "Cliente",
		COUNT(i."InvoiceId") AS "Num_Facturas"
FROM "Invoice" AS i 
--WHERE i."CustomerId" = 57
--WHERE i."Total" > 1
GROUP BY i."CustomerId" 
*/

SELECT	CONCAT(c."FirstName", ' ', c."LastName") AS "Cliente",
		SUM(i."Total") AS "Monto_Total",
		COUNT(i."InvoiceId") AS "Num_Facturas"
FROM "Invoice" AS i
RIGHT JOIN "Customer" AS c
ON i."CustomerId" = c."CustomerId"
GROUP BY "Cliente"
ORDER BY "Monto_Total" DESC 
LIMIT 1;


--30/
/*Obtener los clientes y la cantidad de facturas que tienen, incluyendo los clientes
 * que no han realizado ninguna compra, pero mostrando sólo aquellos que tienen 
 * menos de 7 facturas*/

SELECT	CONCAT(c."FirstName", ' ', c."LastName") AS "Cliente",
		COUNT(i."InvoiceId") AS "Num_Facturas"
FROM "Invoice" AS i
FULL JOIN "Customer" AS c
ON i."CustomerId" = c."CustomerId"
GROUP BY "Cliente"
HAVING COUNT(i."InvoiceId") < 7;

--31/
/*Mostrar la suma de las ventas por cada género, pero sólo aquellos géneros 
 * que tienen más de 50 pistas*/
SELECT	g."Name" AS "Genero",
		SUM(il."UnitPrice" * il."Quantity") AS "Ventas_Totales"
FROM "Genre" AS g
INNER JOIN "Track" AS t
ON g."GenreId" = t."GenreId" 
INNER JOIN "InvoiceLine" AS il
ON t."TrackId" = il."TrackId"
GROUP BY "Genero"
HAVING COUNT(il."TrackId") > 50;

--////// 4- Subconsultas //////

--32/
/*Mostrar el nombre de cada canción (track) junto con su precio y el precio
 * promedio de todas las canciones */
SELECT	"Name" AS "Nombre_Cancion",
		"UnitPrice" AS "Precio_Cancion",
		(SELECT	round(avg("UnitPrice"),2) AS "Precio_Prom"
		FROM "Track" AS t) 
FROM "Track" AS t;

--33/
/*Buscar canciones cuyo precio unitario (sea mayor a 1) o superior al precio medio */
SELECT	"Name" AS "Nombre_Canción",
		"UnitPrice" AS "Precio_Cancion",
		/*(SELECT	round(avg("UnitPrice"),2) AS "Precio_Prom"
		FROM "Track" AS t2) --agrego solo para mostrar valor prom. */
FROM "Track" AS t
--WHERE "UnitPrice" > 1
WHERE "UnitPrice" >	(SELECT avg("UnitPrice") 
					 FROM "Track" AS t2 );

--34/
/*Mostrar todos los artistas que tengan algun albun asociados*/
/*no se podría hacer con un INNER pq hay artistas que tienen más de 1 album asociado*/
SELECT "Name" AS "Nombre_Artista"
--SELECT COUNT("ArtistId") AS "Id_artist" --Cant artistas
FROM "Artist" AS a
WHERE EXISTS (
				SELECT 1 --el 1 actua como boleano TRUE o FALSE, si NO se da muestra 1
				FROM "Album" AS a2
				WHERE a."ArtistId" = a2."ArtistId")

--35/
/*Mostrar todos los artistas que NO tengan algun albun asociado*/
SELECT "Name" AS "Nombre_Artista"
--SELECT COUNT("ArtistId") AS "Id_artist" --Cant artistas
FROM "Artist" AS a
WHERE NOT EXISTS (
				SELECT 1
				FROM "Album" AS a2
				WHERE a."ArtistId" = a2."ArtistId")

--36/ Mostrar número de álbumes por cada artista. 
SELECT "cuenta_albumnes", "nombre_artista" --crea tabla temporal y accedo a la consuta
FROM	(SELECT COUNT(al."AlbumId") AS "cuenta_albumnes",
			a."Name" AS "nombre_artista" 
		FROM "Album" AS al
		INNER JOIN "Artist" AS a
		ON al."ArtistId" = a."ArtistId" 
		GROUP BY a."Name") AS "ArtistAlbumCounts" --nombre tabla creada subconsult
		
/*
SELECT COUNT(al."AlbumId"),
		a."Name" 
FROM "Album" AS al
INNER JOIN "Artist" AS a
ON al."ArtistId" = a."ArtistId" 
GROUP BY a."Name"
*/
		
--37/Ver clientes con su gasto total pero que sean superiores al gasto promedio total
SELECT c."FirstName", SUM(i."Total") AS "total_gasto"
FROM "Customer" AS c
INNER JOIN "Invoice" AS i 
ON c."CustomerId" = i."CustomerId" 
GROUP BY c."CustomerId"
HAVING  SUM(i."Total") > (	SELECT	AVG("suma_total_gasto_cliente") AS "media_gasto_total"--calc el AVG 
							FROM (	
							SELECT sum("Total") AS "suma_total_gasto_cliente"
							FROM "Invoice" AS i
							GROUP BY "CustomerId") AS "total_gastado_cliente")

 								
/*
SELECT	"CustomerId", 
		AVG("Total")
FROM "Invoice" AS i
GROUP BY "CustomerId" 
*/

--38/Muestra país de facturación y la media total de facturacion por cliente
SELECT "id_factura",
		"Total",
		(SELECT round(AVG("Total"), 2)
		 FROM "Invoice") AS "media_total",
		 "pais_factura"
FROM (	
		SELECT "BillingCountry" AS "pais_factura",
				"InvoiceId" AS "id_factura", "Total"
		FROM "Invoice" AS i
		WHERE "BillingCountry" ILIKE 'u%') AS iu
WHERE "Total" >
		(SELECT round(AVG("Total"), 2)
		 FROM "Invoice" AS i2)
		
		 
--////// 5- SQL: Vistas, CTEs y Tablas temporales //////
		 
--39/Calcular el total gastado por cliente
		 
SELECT "id_cliente",
       "total_por_cliente"
FROM (
    SELECT "CustomerId" AS "id_cliente",
           sum("Total") AS "total_por_cliente"
    FROM "Invoice" AS i
    GROUP BY "CustomerId"
) AS total_gasto
WHERE "total_por_cliente" > 40
ORDER BY "total_por_cliente" DESC;

-- >>>>>>>>> Lo mismo Utilitando CTEs <<<<<<<

WITH total_gasto AS (
    SELECT "CustomerId" AS "id_cliente",
           sum("Total") AS "total_por_cliente"
    FROM "Invoice" AS i
    GROUP BY "CustomerId"
)
SELECT "id_cliente",
		"total_por_cliente"
FROM total_gasto
WHERE "total_por_cliente" > 40
ORDER BY "total_por_cliente" DESC;
		 
-- >>>>>>>>> VISTAS <<<<<<<

SELECT	"nombre_cliente",
		"total_gastado"
FROM "ventas_por_cliente"
WHERE "total_gastado" < 36

--Borrado vista

DROP VIEW ventas_por_cliente		 
		 
-->>>>>>>>> TABLAS TEMPORALES <<<<<<<

SELECT "CustomerId",
       SUM("Total")
FROM "Invoice" AS i
WHERE i."InvoiceDate" BETWEEN '2013-12-01' AND '2013-12-31'
GROUP BY "CustomerId";

--TABLA TEMPORAL

CREATE TEMP TABLE "ventas_diciembre" AS
SELECT
    "CustomerId",
    "InvoiceDate",
    "Total"
FROM "Invoice" AS i
WHERE i."InvoiceDate" BETWEEN '2013-12-01' AND '2013-12-31';

-- Borro lo de arriba y pruebo

SELECT SUM("Total")
FROM "ventas_diciembre";

--Eliminar tabla temporal

DROP TABLE "ventas_diciembre"


--///////////////CONCLUSION////////////////
--Depende para que necesite, ut una u otra.

-- CTEs (duran sólo una consulta)(mejor para 1 consulta)

WITH nombre_cte AS (query)

-- VISTAS(se usa indefinidamente, pero cada vez que consulte se va a recalcular)(mejor para varias sesiones)

CREATE VIEW nombre_vista AS
SELECT
FROM

-- TABLAS TEMPORALES(duran por la sesión, consume almacenamiento de datos, pero si necesito reutilizar es mejor)(mejor para 1 sesion)

CREATE TEMP TABLE nombre_tabla_temporal AS
SELECT
FROM

----PYTHON
SELECT * FROM "Artist" LIMIT 5


