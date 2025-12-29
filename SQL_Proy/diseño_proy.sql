CREATE TABLE Alumnos(
	id SERIAL PRIMARY KEY,
	nombre_alumno VARCHAR(25),
	apellido VARCHAR(25)
);

CREATE TABLE Cursos(
	id SERIAL PRIMARY KEY,
	nombre_curso VARCHAR(25),
	duracion_semanas INTEGER,
	fecha_inicio DATE
);

CREATE TABLE Inscripciones(
	id SERIAL PRIMARY KEY,
	id_alumno INTEGER REFERENCES Alumnos(id),
	id_curso INTEGER REFERENCES Cursos(id),
	fecha DATE
);

CREATE TABLE Participaciones(
	id SERIAL PRIMARY KEY,
	id_alumno INTEGER REFERENCES Alumnos(id),
	id_curso INTEGER REFERENCES Cursos(id),
	tipo VARCHAR(10) CHECK (tipo IN('Foro','Clase','Tareas')),
	fecha DATE
);

ALTER TABLE Inscripciones
ADD COLUMN fecha DATE;


INSERT INTO Alumnos (id, nombre_alumno, apellido) VALUES
(1,'Juan', 'Pérez'),
(2,'Maria', 'Gonzalez');

INSERT INTO Cursos (id, nombre_curso, duracion_semanas, fecha_inicio) VALUES
(1,'Python', 12, '2023-01-15'),
(2,'SQL', 8, '2023-02-01');

INSERT INTO Inscripciones (id_alumno, id_curso, fecha) VALUES
(1, 1, '2023-01-25'),
(2, 1, '2023-01-22');

INSERT INTO Participaciones (id_alumno, id_curso, tipo, fecha) VALUES
(1, 1,'Foro', '2023-01-25'),
(2, 1,'Clase', '2023-01-22');

SELECT alumnos.nombre_alumno, alumnos.apellido, inscripciones.fecha AS fecha_inicio, participaciones.fecha 
	AS fecha_participacion, participaciones.tipo, cursos.nombre_curso 
FROM alumnos
INNER JOIN inscripciones ON alumnos.id = inscripciones.id_alumno
INNER JOIN participaciones ON alumnos.id = participaciones.id_alumno
INNER JOIN cursos ON cursos.id = participaciones.id_curso
WHERE alumnos.nombre_alumno = 'Juan' AND alumnos.apellido = 'Pérez';

