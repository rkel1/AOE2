-- Clean and transform the leaderboard dataset
-- Richard Kelson
-- June 2021


USE AOE2


DROP TABLE IF EXISTS #leaderboard


-- Unpack the JSON file
Declare @JSON varchar(max)
SELECT @JSON = BulkColumn
FROM OPENROWSET (BULK 'C:\Users\richa\OneDrive\Documents\Career\Portfolio\AOE2\API Data\leaderboard.JSON', SINGLE_CLOB) as j
SELECT * 
INTO #leaderboard
FROM OPENJSON (@JSON) 
WITH(profile_id varchar(128),
	 rank int,
	 rating smallint,
	 steam_id varchar(128),
	 name varchar(256),
	 clan varchar(256),
	 country varchar(128),
	 previous_rating smallint,
	 highest_rating smallint,
	 streak smallint,
	 lowest_streak smallint,
	 highest_streak smallint,
	 games smallint,
	 wins smallint,
	 losses smallint,
	 drops smallint,
	 last_match int,
	 last_match_time int
)

-- where steam IDs are the same, want to concatenate together
-- (some players have multiple accounts - assume one user has 
-- consistent steam_id)
-- update: just remove extras for now
SELECT * INTO leaderboard FROM #leaderboard
WHERE steam_id IN (SELECT DISTINCT steam_id FROM #leaderboard)