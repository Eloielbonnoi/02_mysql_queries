-- 1 Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els alumnes. 
		--El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
USE universidad;
SELECT apellido1, apellido2, nombre
FROM persona
WHERE tipo = 'alumno'

-- 2 Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT nombre, apellido1, apellido2
FROM persona
WHERE tipo = 'alumno' AND telefono IS NULL
-- 3 Retorna el llistat dels alumnes que van néixer en 1999.
SELECT *
FROM persona
WHERE tipo = 'alumno' AND fecha_nacimiento BETWEEN '1999-01-01' AND '2000-01-01'
-- 4 Retorna el llistat de professors que no han donat d'alta el seu número de telèfon en la base de dades i a més la seva nif acaba en K.
SELECT *
FROM persona
WHERE tipo = 'profesor' AND nif LIKE '%K'
-- 5 Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT *
FROM asignatura
WHERE id_grado= 7 AND curso = 3 AND cuatrimestre = 1
-- 6 Retorna un llistat dels professors juntament amb el nom del departament al qual estan vinculats. 
    --El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. 
    --El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT p.apellido1, p.apellido2, p.nombre, d.nombre
FROM persona p
JOIN profesor pr
ON p.id = pr.id_profesor
JOIN departamento d
ON pr.id_departamento = d.id
-- 7 Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne amb nif 26902806M.
SELECT a.nombre, ce.anyo_inicio, ce.anyo_fin
FROM alumno_se_matricula_asignatura asm
JOIN asignatura a
ON asm.id_asignatura = a.id
AND asm.id_alumno = (SELECT id
					FROM persona 
					WHERE persona.nif = '26902806M')
JOIN curso_escolar ce
ON ce.id = asm.id_curso_escolar

-- 8 Retorna un llistat amb el nom de tots els departaments que tenen professors que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
/*
(SELECT DISTINCT id_profesor FROM asignatura WHERE id_grado =
		( SELECT id FROM grado WHERE nombre = 'Grado en Ingeniería Informática (Plan 2015)' AND nombre IS NOT NULL))
        
 -- Departaments amb professors id 3 i 14

SELECT * FROM profesor JOIN departamento d ON d.id = p.id_departamento AND p.id_profesor IN (3, 14)
              */
-- Tot junt. El problema és que la subquery retorna més d'una fila i això no pot ser

SELECT d.nombre
FROM profesor p
JOIN departamento d
ON d.id = p.id_departamento 
AND p.id_profesor IN 
		(SELECT DISTINCT id_profesor
		FROM asignatura
		WHERE id_grado IN
					(SELECT id
					FROM grado
					WHERE nombre = 'Grado en Ingeniería Informática (Plan 2015)'
					AND nombre IS NOT NULL))

-- 9 Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT p.nombre, p.apellido1, p.apellido2
FROM persona p
WHERE p.id IN (SELECT DISTINCT asm.id_alumno
FROM alumno_se_matricula_asignatura asm
WHERE asm.id_curso_escolar = 
					(SELECT id
					FROM curso_escolar ce
					WHERE ce.anyo_inicio = '2018'))

--Resolgui les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.

-- 1 Retorna un llistat amb els noms de tots els professors i els departaments que tenen vinculats. 
	--El llistat també ha de mostrar aquells professors que no tenen cap departament associat. 
	--El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor. 
	--El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
SELECT de.nombre, pe.apellido1, pe.apellido2, pe.nombre
FROM departamento de
LEFT JOIN profesor pr
ON de.id = pr.id_departamento
RIGHT JOIN persona pe
ON pr.id_profesor = pe.id
ORDER BY de.nombre IS NULL, de.nombre ASC, pe.apellido1, pe.apellido2, pe.nombre

-- 2 Retorna un llistat amb els professors que no estan associats a un departament.
-- 3 Retorna un llistat amb els departaments que no tenen professors associats.
-- 4 Retorna un llistat amb els professors que no imparteixen cap assignatura.
-- 5 Retorna un llistat amb les assignatures que no tenen un professor assignat.
-- 6 Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
-- Consultes resum:

-- 1 Retorna el nombre total d'alumnes que hi ha.
-- 2 Calcula quants alumnes van néixer en 1999.
-- 3 Calcula quants professors hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors associats i haurà d'estar ordenat de major a menor pel nombre de professors.
-- 4 Retorna un llistat amb tots els departaments i el nombre de professors que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors associats. Aquests departaments també han d'aparèixer en el llistat.
-- 5 Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingui en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
-- 6 Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
-- 7 Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
-- 8 Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
-- 9 Retorna un llistat amb el nombre d'assignatures que imparteix cada professor. El llistat ha de tenir en compte aquells professors que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
-- 10 Retorna totes les dades de l'alumne més jove.
-- 11 Retorna un llistat amb els professors que tenen un departament associat i que no imparteixen cap assignatura.