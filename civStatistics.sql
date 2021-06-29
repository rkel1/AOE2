-- Find civ performance using premade tables from 'createTableMatches.sql'
-- Richard Kelson
-- June 2021

USE AOE2

DROP VIEW IF EXISTS dbo.civPerformanceAll
GO

-- for all ELOs
CREATE VIEW civPerformanceAll AS
SELECT c.name, 
	   100*CAST(COUNT(*) AS FLOAT) / (SELECT COUNT(*) FROM matches) AS pickRate, 
	   CAST(SUM(won) AS INT) AS wins, 
	   CAST(SUM(1-won) AS INT) AS losses, 
	   100*SUM(won) / (SUM(won) + SUM(1-won)) AS winPercentage
FROM matches m
	INNER JOIN civs c ON m.civ = c.id
GROUP BY c.name
--ORDER BY winPercentage DESC


-- do pre-filtering of civ choices based on ELO here
--     elo ranges:  0-1000      (low)
--                  1000-1600   (mid)
--                  1600-2000   (high)
--                  2000+       (pro)
--
-- SELECT ...
--
--
--




