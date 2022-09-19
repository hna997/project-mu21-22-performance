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

--SELECT stats to compare defensive player performance
SELECT	m.*
FROM
(
	SELECT 	player, 
			squad,
			minutes,
			ntile(3) OVER (PARTITION BY squad ORDER BY passes_key) AS ptile,
--counted stats
			tackles_per100,
			pressures_per100,
			pass_per100,
			passes_under_pressure,
			passes_per100,
			passes_progressive,
--normalized stats
			passes_under_pressure/(SELECT NULLIF(MAX(passes_under_pressure), 0) FROM pl21_22)::float AS passes_under_pressure_norm,
			passes_progressive/(SELECT NULLIF(MAX(passes_progressive), 0) FROM pl21_22)::float AS passes_progressive_norm,
--per90 stats
			passes_under_pressure/(SELECT NULLIF(AVG(played_per90), 0) FROM pl21_22)::float AS passes_under_pressure_per90,
			passes_progressive/(SELECT NULLIF(AVG(played_per90), 0) FROM pl21_22)::float AS passes_progressive_per90
	FROM	pl21_22
	WHERE	minutes >= 1080
		AND pos = 'MF') AS m
WHERE	ptile < 3
	AND pass_per100 >= 85.00
--an explicit command to exclude attacking midfield based on amount of key passes
;