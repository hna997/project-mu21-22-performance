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

--query for overall table contents
overall AS
(
SELECT	m.*,
	--club stats rank OVER league
		DENSE_RANK() OVER (PARTITION BY season ORDER BY goals DESC) AS goals_leaguerank,
		DENSE_RANK() OVER (PARTITION BY season ORDER BY shots_on_target DESC) AS ontarget_leaguerank,
		DENSE_RANK() OVER (PARTITION BY season ORDER BY shots DESC) AS shots_leaguerank,
		DENSE_RANK() OVER (PARTITION BY season ORDER BY goals_allowed ASC) AS goals_allowed_leaguerank,
		DENSE_RANK() OVER (PARTITION BY season ORDER BY shots_on_target_allowed DESC) AS ontarget_allowed_leaguerank,
		DENSE_RANK() OVER (PARTITION BY season ORDER BY saves DESC) AS saves_leaguerank,
		DENSE_RANK() OVER (PARTITION BY season ORDER BY saves_per100 DESC) AS saves_per100_leaguerank,
		DENSE_RANK() OVER (PARTITION BY season ORDER BY touches DESC) AS touches_leaguerank,
		DENSE_RANK() OVER (PARTITION BY season ORDER BY passes_comp DESC) AS passes_comp_leaguerank,
		DENSE_RANK() OVER (PARTITION BY season ORDER BY passes_att DESC) AS passes_att_leaguerank,
		DENSE_RANK() OVER (PARTITION BY season ORDER BY passes_per100 DESC) AS passes_per100_leaguerank,
		DENSE_RANK() OVER (PARTITION BY season ORDER BY tackles DESC) AS tackles_leaguerank,
		DENSE_RANK() OVER (PARTITION BY season ORDER BY shots_on_target DESC) AS clearances_leaguerank
FROM
(
	SELECT	squad,
			season,
	-- convert parameters from aggregate to per game
			sum(goals)/38::float AS goals,
			sum(shots_on_target)/38::float AS shots_on_target,
			sum(shots)/38::float AS shots,
			sum(goals_allowed)/38::float AS goals_allowed,
			sum(shots_on_target_allowed)/38::float AS shots_on_target_allowed,
			sum(saves)/38::float AS saves,
			sum(saves)*100/nullif(sum(shots_on_target_allowed),0)::float AS saves_per100,
			sum(touches)/38::float AS touches,
			sum(passes_completed)/38::float AS passes_comp,
			sum(passes_attempted)/38::float AS passes_att,
			sum(passes_completed)*100/nullif(sum(passes_attempted),0)::float AS passes_per100,
			sum(tackles)/38::float AS tackles,
			sum(clearances)/38::float AS clearances
	FROM	master
	group by	squad,
				season
) AS m
)
	--pivotize the table into a proper structure
SELECT	overall.season,	
		con.param,
		con.value,
		con.rank
FROM	overall
	CROSS JOIN LATERAL	
	(
		VALUES
		('goals', overall.goals, overall.goals_leaguerank),
		('shots_on_target', overall.shots_on_target, overall.ontarget_leaguerank),
		('shots', overall.shots, overall.shots_leaguerank),
		('goals_allowed', overall.goals_allowed, overall.goals_allowed_leaguerank),
		('shots_on_target_allowed', overall.shots_on_target_allowed, overall.ontarget_allowed_leaguerank),
		('saves', overall.saves, overall.saves_leaguerank),
		('saves_per100', overall.saves_per100, overall.saves_per100_leaguerank),
		('touches', overall.touches, overall.touches_leaguerank),
		('passes_comp', overall.passes_comp, overall.passes_comp_leaguerank),
		('passes_att', overall.passes_att, overall.passes_att_leaguerank),
		('passes_per100', overall.passes_per100, overall.passes_per100_leaguerank),
		('tackles', overall.tackles, overall.tackles_leaguerank),
		('clearances', overall.clearances, overall.clearances_leaguerank)
	) AS con
		(
			param, 
			value, 
			rank
		)
WHERE	squad = 'Manchester Utd'
ORDER BY	overall.season
;