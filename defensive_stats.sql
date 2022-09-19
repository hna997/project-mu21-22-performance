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

--SELECT stats to compare defensive player performance
SELECT n.*
FROM
(
	SELECT	m.*,
			ntile(10) OVER (ORDER BY crosses_per90) AS ptile
	FROM
	(
		SELECT	player, 
				squad,
				minutes,
				blocks+tackles_won+intercepts AS def_action,
				(blocks+tackles_won+intercepts)/(SELECT NULLIF(AVG(played_per90), 0) FROM pl20_21) AS def_action_per90,
				crosses AS crosses,
				crosses/(SELECT NULLIF(AVG(played_per90), 0) FROM pl20_21) AS crosses_per90
		FROM 	pl20_21
		WHERE 	minutes >= 1080 
			AND	pos	LIKE 'DF'
		ORDER BY	def_action_per90 DESC
	) AS m
) AS n
WHERE	ptile > 6
ORDER BY	squad ASC,
			ptile DESC
-- to explicitly filter cb from the list
;