-- Prepare matches data for Python ML, by defining elo difference, civ match_up and player_match_up
-- Richard Kelson
-- June 2021

DROP TABLE IF EXISTS matchPredictions
GO


-- civ and profile matchup
SELECT a.rating-b.rating AS ratingDifference,
	   CONCAT(CAST(a.profile_id AS VARCHAR),':',CAST(b.profile_id AS VARCHAR)) AS playerMatchup,
	   CONCAT(CAST(a.civ AS VARCHAR),':',CAST(b.civ AS VARCHAR)) AS civMatchup,
	   (CASE WHEN a.won=1 THEN 1 WHEN b.won=1 THEN -1 END) AS winner
INTO matchPredictions
FROM
   ( SELECT * FROM matches ) a
   INNER JOIN
   ( SELECT * FROM matches ) b
   ON a.match_id = b.match_id
WHERE a.profile_id < b.profile_id 
	AND a.rating IS NOT NULL
	AND b.rating IS NOT NULL
	AND a.civ IS NOT NULL
	AND b.civ IS NOT NULL
	AND a.won IS NOT NULL
	AND b.won IS NOT NULL
ORDER BY a.match_id


--SELECT
--    1.00*(ratingDifference-MinRatingDifference)/ratingDifferenceRange
--FROM
--    (
--    SELECT
--       ratingDifference,
--       MIN(ratingDifference) OVER () AS MinRatingDifference,
--       MAX(ratingDifference) OVER () - MIN(ratingDifference) OVER () AS ratingDifferenceRange
--    FROM matchPredictions
--    ) X