DROP DATABASE IF EXISTS PIDTS03;
CREATE DATABASE IF NOT EXISTS PIDTS03;
USE PIDTS03;
# 1. Año con más carreras -----------------------------------------------------------------
DROP TABLE IF EXISTS `races`;
-- raceId,year,round,circuitId,name,date,time,url
CREATE TABLE IF NOT EXISTS `races` (
  	`raceId` 	INT NOT NULL,
  	`year` 		INT,			
    `round`		INT,
    `circuitId`	INT NOT NULL,
  	`name` 		VARCHAR(50),
    `date`		DATE,
    `time`		VARCHAR(50),
    `url`		VARCHAR(200)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CSVs\\races.csv'
INTO TABLE `races`
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- select `year`, count(`year`) as Numero_carreras
select `year` 
from races
group by `year`
order by count(`year`) desc
limit 1;
#-------------------------------------------------------------------------------------------------

# 2. Piloto con mayor cantidad de primeros puestos -----------------------------------------------------------------
DROP TABLE IF EXISTS `qualifying`;
-- raceId,year,round,circuitId,name,date,time,url
CREATE TABLE IF NOT EXISTS `qualifying` (
  	`qualifyId` 	INT NOT NULL,
  	`raceId` 		INT NOT NULL,			
    `driverId`		INT NOT NULL,
    `constructorId`	INT NOT NULL,
  	`number` 		INT,
    `position`		INT,
    `q1`		VARCHAR(50),
    `q2`		VARCHAR(50),
    `q3`		VARCHAR(50)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CSVs\\Qualifying.csv'
INTO TABLE `qualifying`
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

DROP TABLE IF EXISTS `drivers`;
CREATE TABLE IF NOT EXISTS `drivers`( -- driverId;driverRef;number;code;forename;surname;dob;nationality;url
  	`driverId`		INT NOT NULL,
    `driverRef` 	VARCHAR(70),
  	`number` 		VARCHAR(10),
    `code`			VARCHAR(10),
  	`forename` 		VARCHAR(70),
    `surname`		VARCHAR(70),
    `dob`			DATE,
    `nationality` 	VARCHAR(70),
    `url`			VARCHAR(200)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CSVs\\drivers.csv'
INTO TABLE `drivers`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- SELECT drivers.driverId, count(qualifying.position) as Cantidad_primeros_puestos, drivers.forename as Nombre, drivers.surname as Apellido
SELECT CONCAT(d.forename, ' ',d.surname) as Piloto
FROM qualifying q
	JOIN drivers d ON q.driverId = d.driverId
WHERE q.position = 1
GROUP BY q.driverId
ORDER BY count(q.position) DESC
LIMIT 1;

# 3. Nombre del circuito más corrido -----------------------------------------------------------------
DROP TABLE IF EXISTS `circuits`;
CREATE TABLE IF NOT EXISTS `circuits`( -- circuitId,circuitRef,name,location,country,lat,lng,alt,url
  	`circuitId`	INT NOT NULL,
    `circuitRef`	VARCHAR(70),
  	`name`			VARCHAR(70),
    `location` 	VARCHAR(70),
  	`country`	VARCHAR(70),
    `lat`	VARCHAR(30),
    `lng`	VARCHAR(30),
    `alt`	INT,	
    `url`	VARCHAR(300)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CSVs\\circuits.csv'
INTO TABLE `circuits`
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\n' IGNORE 1 LINES;

-- SELECT count(r.circuitId) as CantidadCarreras, c.name
SELECT c.name as Circuito
FROM races r
	JOIN circuits c ON (r.circuitId = c.circuitId)
GROUP BY r.circuitId
ORDER BY count(r.circuitId) DESC
LIMIT 1;

# 4. Piloto con mayor cantidad de puntos en total, cuyo constructor sea de nacionalidad American o British 
# ----------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS `results`;
CREATE TABLE IF NOT EXISTS `results` (
  	`resultId`	INT NOT NULL,
  	`raceId` 	INT NOT NULL,
  	`driverId` 	INT NOT NULL,
    `constructorId`	INT NOT NULL,
  	`number` 	INT,
    `grid`		INT,
    `position`	INT,
    `positionText`	VARCHAR(20),
    `positionOrder` INT,
    `points`	DECIMAL(10,2),
    `laps`		INT,
    `time`		VARCHAR(40),
    `milliseconds`	INT,
    `fastestLap`	INT,
    `rank`		INT,
    `fastestLapTime`	VARCHAR(70),
    `fastestLapSpeed`	DECIMAL,
    `statusId` INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CSVs\\results.csv'
INTO TABLE `results`
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' IGNORE 1 LINES;

SELECT * FROM results;

DROP TABLE IF EXISTS `constructors`;
CREATE TABLE IF NOT EXISTS `constructors` (
  	`constructorId` 	INT NOT NULL,
  	`constructorRef` 	VARCHAR(50),
  	`name` 				VARCHAR(50),
    `nationality`		VARCHAR(50),
  	`url` 				VARCHAR(200)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CSVs\\constructors.csv'
INTO TABLE `constructors`
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

select * from constructors;

-- SELECT sum(r.points) as Puntaje_total, c.nationality as Nacionalidad_del_constructor, c.name as Nombre, d.forename as Nombre, d.surname as Apellido -- , r.driverId
SELECT CONCAT(d.forename, ' ',d.surname) as Piloto 
FROM results r
	JOIN constructors c ON (r.constructorId = c.constructorId)
    JOIN drivers d ON (r.driverId = d.driverId)
WHERE c.nationality = 'British' OR c.nationality = 'American'
GROUP BY r.driverId
ORDER BY sum(r.points) DESC
LIMIT 1;

-- Plus: crear las relaciones entre las tablas
-- Agregando tablas extra:

DROP TABLE IF EXISTS `pit_stops`;
CREATE TABLE IF NOT EXISTS `pit_stops` (
	`pit_stopId` INT NOT NULL,
  	`raceId` 	INT NOT NULL,
  	`driverId` 	INT NOT NULL,
  	`stop` 		INT,
    `lap`		INT,
  	`time` 		VARCHAR(50),
    `duration`	VARCHAR(50),
    `milliseconds`	INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CSVs\\pit_stops.csv'
INTO TABLE `pit_stops`
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

DROP TABLE IF EXISTS `LapTimes`;
CREATE TABLE IF NOT EXISTS `LapTimes` (
	`lap_timeId` INT NOT NULL,
  	`raceId` 	INT NOT NULL,
  	`driverId` 	INT NOT NULL,
    `lap`		INT,
    `position`	INT,
  	`time` 		VARCHAR(50),
    `milliseconds`	INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\CSVs\\LapTimes.csv'
INTO TABLE `LapTimes`
FIELDS TERMINATED BY ',' ENCLOSED BY '' ESCAPED BY '' 
LINES TERMINATED BY '\n' IGNORE 1 LINES;

select * from laptimes
where lap_timeId = '1';
# https://www.w3schools.com/sql/sql_primarykey.ASP
-- Asignando primary keys
ALTER TABLE `circuits` ADD PRIMARY KEY (`circuitId`);
ALTER TABLE `constructors` ADD PRIMARY KEY (`constructorId`);
ALTER TABLE `drivers` ADD PRIMARY KEY (`driverId`);
ALTER TABLE `laptimes` ADD PRIMARY KEY (`lap_timeId`);
ALTER TABLE `pit_stops` ADD PRIMARY KEY (`pit_stopId`);
ALTER TABLE `qualifying` ADD PRIMARY KEY (`qualifyId`);
ALTER TABLE `races` ADD PRIMARY KEY (`raceId`);
ALTER TABLE `results` ADD PRIMARY KEY (`resultId`);

# https://www.w3schools.com/sql/sql_foreignkey.asp
-- Asignando foreign keys
ALTER TABLE `laptimes`
	ADD FOREIGN KEY (`raceId`) REFERENCES `races`(`raceId`),
	ADD FOREIGN KEY (`driverId`) REFERENCES `drivers`(`driverId`);
ALTER TABLE `pit_stops`
	ADD FOREIGN KEY (`raceId`) REFERENCES `races`(`raceId`),
	ADD FOREIGN KEY (`driverId`) REFERENCES `drivers`(`driverId`);
ALTER TABLE `qualifying`
	ADD FOREIGN KEY (`raceId`) REFERENCES `races`(`raceId`),
	ADD FOREIGN KEY (`driverId`) REFERENCES `drivers`(`driverId`),
    ADD FOREIGN KEY (`constructorId`) REFERENCES `constructors`(`constructorId`);
ALTER TABLE `races`
	ADD FOREIGN KEY (`circuitId`) REFERENCES `circuits`(`circuitId`);
ALTER TABLE `results`
	ADD FOREIGN KEY (`raceId`) REFERENCES `races`(`raceId`),
	ADD FOREIGN KEY (`driverId`) REFERENCES `drivers`(`driverId`),
    ADD FOREIGN KEY (`constructorId`) REFERENCES `constructors`(`constructorId`);