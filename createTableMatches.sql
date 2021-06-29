-- Create the table of recent matches using the data available through the API,
-- after Python script gets around the 1000 match-request restriction.
-- Richard Kelson
-- June 2021

USE AOE2


DROP TABLE IF EXISTS #matches0, #matches1, #matches2, #matches3, #matches4, #matches5

Declare @JSON0 varchar(max)
SELECT @JSON0 = BulkColumn
FROM OPENROWSET (BULK 'C:\Users\richa\Documents\AOE2 API Storage\matches0.JSON', SINGLE_CLOB) as j
SELECT * 
INTO #matches0
FROM OPENJSON (@JSON0) 
WITH(match_id varchar(256),
	 --lobby_id varchar(256),
	 match_uuid varchar(256),
	 version int,
	 name varchar(128),
	 num_players int '$.num_players',
	 leaderboard_id int,
	 players nvarchar(max) as JSON) as CivPerformance
		CROSS APPLY OPENJSON (players) WITH (
			profile_id int,
			rating float,
			team int,
			civ int,
			won bit)

-- Similarly for other .json files
Declare @JSON1 varchar(max)
SELECT @JSON1 = BulkColumn
FROM OPENROWSET (BULK 'C:\Users\richa\Documents\AOE2 API Storage\matches1.JSON', SINGLE_CLOB) as j
SELECT * 
INTO #matches1
FROM OPENJSON (@JSON1) 
WITH(match_id varchar(256),
	 --lobby_id varchar(256),
	 match_uuid varchar(256),
	 version int,
	 name varchar(128),
	 num_players int '$.num_players',
	 leaderboard_id int,
	 players nvarchar(max) as JSON) as CivPerformance
		CROSS APPLY OPENJSON (players) WITH (
			profile_id int,
			rating float,
			team int,
			civ int,
			won bit)

Declare @JSON2 varchar(max)
SELECT @JSON2 = BulkColumn
FROM OPENROWSET (BULK 'C:\Users\richa\Documents\AOE2 API Storage\matches2.JSON', SINGLE_CLOB) as j
SELECT * 
INTO #matches2
FROM OPENJSON (@JSON2) 
WITH(match_id varchar(256),
	 --lobby_id varchar(256),
	 match_uuid varchar(256),
	 version int,
	 name varchar(128),
	 num_players int '$.num_players',
	 leaderboard_id int,
	 players nvarchar(max) as JSON) as CivPerformance
		CROSS APPLY OPENJSON (players) WITH (
			profile_id int,
			rating float,
			team int,
			civ int,
			won bit)

Declare @JSON3 varchar(max)
SELECT @JSON3 = BulkColumn
FROM OPENROWSET (BULK 'C:\Users\richa\Documents\AOE2 API Storage\matches3.JSON', SINGLE_CLOB) as j
SELECT * 
INTO #matches3
FROM OPENJSON (@JSON3) 
WITH(match_id varchar(256),
	 --lobby_id varchar(256),
	 match_uuid varchar(256),
	 version int,
	 name varchar(128),
	 num_players int '$.num_players',
	 leaderboard_id int,
	 players nvarchar(max) as JSON) as CivPerformance
		CROSS APPLY OPENJSON (players) WITH (
			profile_id int,
			rating float,
			team int,
			civ int,
			won bit)

Declare @JSON4 varchar(max)
SELECT @JSON4 = BulkColumn
FROM OPENROWSET (BULK 'C:\Users\richa\Documents\AOE2 API Storage\matches4.JSON', SINGLE_CLOB) as j
SELECT * 
INTO #matches4
FROM OPENJSON (@JSON4) 
WITH(match_id varchar(256),
	 --lobby_id varchar(256),
	 match_uuid varchar(256),
	 version int,
	 name varchar(128),
	 num_players int '$.num_players',
	 leaderboard_id int,
	 players nvarchar(max) as JSON) as CivPerformance
		CROSS APPLY OPENJSON (players) WITH (
			profile_id int,
			rating float,
			team int,
			civ int,
			won bit)


Declare @JSON5 varchar(max)
SELECT @JSON5 = BulkColumn
FROM OPENROWSET (BULK 'C:\Users\richa\Documents\AOE2 API Storage\matches5.JSON', SINGLE_CLOB) as j
SELECT * 
INTO #matches5
FROM OPENJSON (@JSON5) 
WITH(match_id varchar(256),
	 --lobby_id varchar(256),
	 match_uuid varchar(256),
	 version int,
	 name varchar(128),
	 num_players int '$.num_players',
	 leaderboard_id int,
	 players nvarchar(max) as JSON) as CivPerformance
		CROSS APPLY OPENJSON (players) WITH (
			profile_id int,
			rating float,
			team int,
			civ int,
			won bit)


-- stitch together as union, only keeping the 1v1 Random Map leaderboard
DROP TABLE IF EXISTS matches
SELECT *
INTO matches
FROM (
	 SELECT * FROM #matches0 WHERE leaderboard_id = 3
	 UNION ALL
	 SELECT * FROM #matches1 WHERE leaderboard_id = 3
	 UNION ALL
	 SELECT * FROM #matches2 WHERE leaderboard_id = 3
	 UNION ALL
	 SELECT * FROM #matches3 WHERE leaderboard_id = 3
	 UNION ALL
	 SELECT * FROM #matches4 WHERE leaderboard_id = 3
	 UNION ALL
	 SELECT * FROM #matches5 WHERE leaderboard_id = 3
) AS tmp

ALTER TABLE matches ALTER COLUMN won FLOAT -- convert to integer to enable percentage calculations



---------------------------------------------------------------------------------------------------



-- Create table of civs
DROP TABLE IF EXISTS civs 
CREATE TABLE civs (
	id INT IDENTITY(1,1),
	name varchar(128)
) 

-- Use regex expression to replace from pasted text (from aoe2de program files folder)
	--find: [0-9]{5} "([a-z]*)-utf8.txt"
	--replace: \t('$1'),

	--e.g. to turn 20411 "aztecs-utf8.txt"    --> '(aztecs'),

INSERT INTO civs (name) VALUES ('Aztecs'),
	('Berbers'),
	('British'),
	('Bulgarians'),
	('Burgundians'),
	('Burmese'),
	('Byzantines'),
	('Celts'),
	('Chinese'),
	('Cumans'),
	('Ethiopians'),
	('Franks'),
	('Goths'),
	('Huns'),
	('Incas'),
	('Indians'),
	('Italians'),
	('Japanese'),
	('Khmer'),
	('Koreans'),
	('Lithuanians'),
	('Magyars'),
	('Malay'),
	('Malians'),
	('Mayans'),
	('Mongols'),
	('Persians'),
	('Portuguese'),
	('Saracens'),
	('Sicilians'),
	('Slavs'),
	('Spanish'),
	('Tatars'),
	('Teutons'),
	('Turks'),
	('Vietnamese'),
	('Vikings')

