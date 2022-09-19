SELECT	CASE 
		WHEN pl20_player IS null THEN pl21_player
		WHEN pl21_player IS null THEN pl20_player
		ELSE pl20_player
		END AS player,
		m.pl20_minutes,
		m.pl21_minutes
FROM
(
	SELECT	pl20.player AS pl20_player,
			pl21.player AS pl21_player,
			pl20.minutes AS pl20_minutes,
			pl21.minutes AS pl21_minutes
	FROM	"PL20_21".stats AS pl20
		FULL OUTER JOIN "PL21_22".stats AS pl21
			ON	pl20.player = pl21.player
		WHERE	pl20.squad = 'Manchester Utd'
			OR	pl21.squad = 'Manchester Utd'
	ORDER BY	pl21_minutes DESC
) AS m
WHERE	pl20_minutes >= 500 
	OR 	pl21_minutes >= 500