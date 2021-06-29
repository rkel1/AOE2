-- Meta analysis (e.g. matches analysed, total players)
-- Richard Kelson
-- June 2021


USE AOE2


------------------------------------------------------------------------------------
-- general counts of the entire analysis
DROP VIEW IF EXISTS totalCounts
GO

CREATE VIEW totalCounts AS SELECT 
	(SELECT COUNT(*) FROM matches)  AS matchesAnalysed, -- total matches analysed
	(SELECT COUNT(*) FROM leaderboard) AS playersAnalysed -- total players analysed

GO

------------------------------------------------------------------------------------


-- rating (ELO) distribution of players globally
DROP TABLE IF EXISTS ratingDistribution
GO
SELECT rating, COUNT(*) AS frequency
INTO ratingDistribution
FROM leaderboard
GROUP BY rating
ORDER BY rating ASC


