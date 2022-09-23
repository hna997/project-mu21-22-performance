SELECT	goals,
		squad
FROM 	"PL21_22".stats
WHERE 	squad IN
			(
				'Manchester Utd',
				'Manchester City',
				'Liverpool',
				'Arsenal',
				'Chelsea',
				'Tottenham'
			)
	AND		minutes > 0
ORDER BY	goals ASC, squad ASC