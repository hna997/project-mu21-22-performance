--merged we undefeated
WITH pl21_22 AS
(
SELECT	*
FROM	"PL21_22".stats
	NATURAL LEFT JOIN "PL21_22".shooting
	NATURAL LEFT JOIN "PL21_22".possession
	NATURAL LEFT JOIN "PL21_22".playingtime
	NATURAL LEFT JOIN "PL21_22".passing_type
	NATURAL LEFT JOIN "PL21_22"."passing"
	NATURAL LEFT JOIN "PL21_22".misc
	NATURAL LEFT JOIN "PL21_22".gca
	NATURAL LEFT JOIN "PL21_22".defense
	NATURAL LEFT JOIN "PL21_22".keepersadv
	NATURAL LEFT JOIN "PL21_22".keepers
),

pl20_21 AS
(
SELECT	*
FROM	"PL20_21".stats
	NATURAL LEFT JOIN "PL20_21".shooting
	NATURAL LEFT JOIN "PL20_21".possession
	NATURAL LEFT JOIN "PL20_21".playingtime
	NATURAL LEFT JOIN "PL20_21".passing_type
	NATURAL LEFT JOIN "PL20_21"."passing"
	NATURAL LEFT JOIN "PL20_21".misc
	NATURAL LEFT JOIN "PL20_21".gca
	NATURAL LEFT JOIN "PL20_21".defense
	NATURAL LEFT JOIN "PL20_21".keepersadv
	NATURAL LEFT JOIN "PL20_21".keepers
),

--united we stand
master AS
(
SELECT	*
FROM	pl21_22
UNION ALL
SELECT	*
FROM	pl20_21
),

--SELECT stats corresponding to gca, display top 4 players only
main_selection AS
(
SELECT 	player,
		season,
		SUM(goals) AS goals, 
		ROW_NUMBER() OVER (PARTITION BY season ORDER BY SUM(goals) DESC) AS rank,
		SUM(shots_on_target) AS shots_on_target,
		SUM(shots) AS shots
FROM	master
WHERE	squad = 'Manchester Utd'
GROUP BY	player,	
			squad, 
			season
)

SELECT	player, 
		season, 
		goals, 
		shots_on_target, 
		shots
FROM	main_selection
WHERE	rank <= 9
UNION ALL
SELECT	'Other',
		AVG(season)::integer, 
		SUM(goals), 
		SUM(shots_on_target), 
		SUM(shots)
FROM	main_selection
WHERE	rank > 9 
	AND season = 2020
UNION ALL
SELECT	'Other',
		AVG(season)::integer,
		SUM(goals),
		SUM(shots_on_target),
		SUM(shots)
FROM	main_selection
WHERE 	rank > 9 
	AND season = 2021
ORDER BY	season,
			goals DESC,
			shots_on_target DESC,
			shots DESC
;
