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
)

--select stats to compare defensive player performance
SELECT 	player, squad,
		saves_per100/(SELECT NULLIF(MAX(saves_per100), 0)FROM pl21_22):: float AS saves_per100,
		clean_sheets_per100/(SELECT NULLIF(MAX(clean_sheets_per100), 0)FROM pl21_22):: float AS clean_sheets_per100,
		passes_15yds_completed/(SELECT NULLIF(MAX(passes_15yds_completed), 0)FROM pl21_22 WHERE pos = 'GK'):: float AS passes_15yds_completed,
		passes_40yds_completed/(SELECT NULLIF(MAX(passes_40yds_completed), 0)FROM pl21_22 WHERE pos = 'GK'):: float AS passes_40yds_completed,
		passes_under_pressure/(SELECT NULLIF(MAX(passes_under_pressure), 0)FROM pl21_22 WHERE pos = 'GK'):: float AS passes_under_pressure,
		outside_area_sweep/(SELECT NULLIF(MAX(outside_area_sweep), 0)FROM pl21_22):: float AS outside_area_sweep
FROM	pl21_22
WHERE	minutes >= 1080 
	AND pos = 'GK' 
	AND squad IN
				(
				'Manchester City',
				'Manchester Utd',
				'Liverpool',
				'Arsenal',
				'Tottenham',
				'Chelsea'
				)
;