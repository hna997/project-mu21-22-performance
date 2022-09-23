WITH pl20_21 AS 
(
SELECT	player,
		minutes
FROM	"PL20_21".stats
WHERE	squad = 'Manchester Utd'
	AND	minutes >= 500
),

pl21_22 AS
(
SELECT	player,
		minutes
FROM	"PL21_22".stats
WHERE	squad = 'Manchester Utd'
	AND	minutes >= 500
),

main_selection AS
(
SELECT	pl20_21.player AS pl20_player,
		pl21_22.player AS pl21_player,
		pl20_21.minutes AS pl20_minutes,
		pl21_22.minutes AS pl21_minutes
	FROM	pl20_21
		FULL OUTER JOIN pl21_22
			ON	pl20_21.player = pl21_22.player
	ORDER BY	pl21_minutes DESC
)

SELECT	CASE 
		WHEN pl20_player IS null THEN pl21_player
		WHEN pl21_player IS null THEN pl20_player
		ELSE pl20_player
		END AS player,
		pl20_minutes,
		pl21_minutes
FROM	main_selection
;