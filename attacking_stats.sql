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

pl20_21 AS(
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

stats_pl21_22 AS
(
SELECT	player,
		squad,
		season,
-- counted stats
		goals AS goals,
		assists AS assists,
		gca AS gca,
		sca AS sca,
		passes_other_pen AS passes_other_pen,
		passes_cross_other_pen AS passes_cross_other_pen,
		touches_other_pen AS touches_other_pen,
		carries_other_pen AS carries_other_pen,
-- normalized stats
		goals/(SELECT NULLIF(MAX(goals), 0) FROM pl21_22) :: float AS goals_norm,
		assists/(SELECT NULLIF(MAX(assists), 0) FROM pl21_22) :: float AS assists_norm,
		gca/(SELECT NULLIF(MAX(gca), 0) FROM pl21_22) :: float AS gca_norm,
		sca/(SELECT NULLIF(MAX(sca), 0) FROM pl21_22) :: float AS sca_norm,
		passes_other_pen/(SELECT NULLIF(MAX(passes_other_pen), 0) FROM pl21_22) :: float AS passes_other_pen_norm,
		passes_cross_other_pen/(SELECT NULLIF(MAX(passes_cross_other_pen), 0) FROM pl21_22) :: float AS passes_cross_other_pen_norm,
		touches_other_pen/(SELECT NULLIF(MAX(touches_other_pen), 0) FROM pl21_22) :: float AS touches_other_pen_norm,
		carries_other_pen/(SELECT NULLIF(MAX(carries_other_pen), 0) FROM pl21_22) :: float AS carries_other_pen_norm,
-- per 90 stats
		goals/(SELECT NULLIF(AVG(played_per90), 0) FROM pl21_22) :: float AS goals_per90,
		assists/(SELECT NULLIF(AVG(played_per90), 0) FROM pl21_22) :: float AS assists_per90,
		gca/(SELECT NULLIF(AVG(played_per90), 0) FROM pl21_22) :: float AS gca_per90,
		sca/(SELECT NULLIF(AVG(played_per90), 0) FROM pl21_22) :: float AS sca_per90,
		passes_other_pen/(SELECT NULLIF(AVG(played_per90), 0) FROM pl21_22) :: float AS passes_other_pen_per90,
		passes_cross_other_pen/(SELECT NULLIF(AVG(played_per90), 0) FROM pl21_22) :: float AS passes_cross_other_pen_per90,
		touches_other_pen/(SELECT NULLIF(AVG(played_per90), 0) FROM pl21_22) :: float AS touches_other_pen_per90,
		carries_other_pen/(SELECT NULLIF(AVG(played_per90), 0) FROM pl21_22) :: float AS carries_other_pen_per90
		FROM pl21_22
),

--attacking stats for manchester utd
stats_pl20_21 AS
(
SELECT	player,
		squad,
		season,
-- counted stats
		goals,
		assists,
		gca,
		sca,
		passes_other_pen,
		passes_cross_other_pen,
		touches_other_pen,
		carries_other_pen,
-- normalized stats
		goals/(SELECT NULLIF(MAX(goals), 0) FROM pl20_21) :: float AS goals_norm,
		assists/(SELECT NULLIF(MAX(assists), 0) FROM pl20_21) :: float AS assists_norm,
		gca/(SELECT NULLIF(MAX(gca), 0) FROM pl20_21) :: float AS gca_norm,
		sca/(SELECT NULLIF(MAX(sca), 0) FROM pl20_21) :: float AS sca_norm,
		passes_other_pen/(SELECT NULLIF(MAX(passes_other_pen), 0) FROM pl20_21) :: float AS passes_other_pen_norm,
		passes_cross_other_pen/(SELECT NULLIF(MAX(passes_cross_other_pen), 0) FROM pl20_21) :: float AS passes_cross_other_pen_norm,
		touches_other_pen/(SELECT NULLIF(MAX(touches_other_pen), 0) FROM pl20_21) :: float AS touches_other_pen_norm,
		carries_other_pen/(SELECT NULLIF(MAX(carries_other_pen), 0) FROM pl20_21) :: float AS carries_other_pen_norm,
-- per 90 stats
		goals/(SELECT NULLIF(AVG(played_per90), 0) FROM pl20_21) :: float AS goals_per90,
		assists/(SELECT NULLIF(AVG(played_per90), 0) FROM pl20_21) :: float AS assists_per90,
		gca/(SELECT NULLIF(AVG(played_per90), 0) FROM pl20_21) :: float AS gca_per90,
		sca/(SELECT NULLIF(AVG(played_per90), 0) FROM pl20_21) :: float AS sca_per90,
		passes_other_pen/(SELECT NULLIF(AVG(played_per90), 0) FROM pl20_21) :: float AS passes_other_pen_per90,
		passes_cross_other_pen/(SELECT NULLIF(AVG(played_per90), 0) FROM pl20_21) :: float AS passes_cross_other_pen_per90,
		touches_other_pen/(SELECT NULLIF(AVG(played_per90), 0) FROM pl20_21) :: float AS touches_other_pen_per90,
		carries_other_pen/(SELECT NULLIF(AVG(played_per90), 0) FROM pl20_21) :: float AS carries_other_pen_per90
FROM	pl20_21
)

SELECT	*
FROM	stats_pl21_22
WHERE	squad = 'Manchester Utd'
UNION ALL
SELECT	*
FROM	stats_pl20_21
WHERE	squad = 'Manchester Utd'
;