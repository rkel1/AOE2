-- Find statistics on players in the leaderboard
-- Richard Kelson
-- June 2020

USE AOE2

-- create temporary table to find each country's favourite civ
DROP TABLE IF EXISTS #temp
SELECT c.country AS country, 
	   x.name AS civ, 
	   COUNT(*) AS timesPlayed 
INTO #temp
FROM matches m
	INNER JOIN leaderboard l ON l.profile_id = m.profile_id
	INNER JOIN countryCodes c ON l.country = c.Alpha2code
	INNER JOIN civs x ON m.civ = x.id
GROUP BY c.country, x.name
ORDER BY c.country ASC, COUNT(x.name) DESC

DROP TABLE IF EXISTS fave
SELECT country, civ
INTO fave
FROM (
   SELECT *,
          row_number() OVER (PARTITION BY country ORDER BY timesPlayed DESC) AS row_number
   FROM #temp
   ) AS rows
WHERE row_number = 1



------------------------------------------------------------------------------------------

-- create a table of statistics by country
DROP VIEW IF EXISTS playersGlobal
GO
CREATE VIEW playersGlobal
AS SELECT c.country,                 -- country
	   pop.playerPop,                -- players in that country
	   pop.averageELO,               -- average ELO (rating) of country's players
	   pop.winPercentage,            -- average win percentage of country's players
	   x.rank AS highestRankedRank,  -- rank of the highest-ranked player in this country
	   x.name AS highestRankedName,  -- name of the highest-ranked player in this country
	   f.civ AS favouriteCiv         -- country's favourite civ
FROM leaderboard x
	JOIN countryCodes c ON x.country = c.Alpha2code  -- switch from 2-character code to full name

	-- this join is to extract highest player rank and stats
	JOIN (SELECT MIN(rank) AS rank2 FROM leaderboard GROUP BY country) min
		ON x.rank = min.rank2 
	
	-- this join is to get country statistics (player population, average rating, win percentage)
	JOIN (SELECT country, 
					 COUNT(profile_id) AS playerPop, 
					 AVG(rating) AS averageELO,
					 AVG(100* CAST(wins AS FLOAT)/CAST(games AS FLOAT)) AS winPercentage
			FROM leaderboard
			WHERE losses <> 0 AND country IS NOT NULL
			GROUP BY country) pop
			ON x.country = pop.country

	-- this join gets the favourite civ of the country using the temp table of the previous query
	JOIN fave f ON f.country = c.country
