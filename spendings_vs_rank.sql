WITH standings AS
(
SELECT	year,
		rank,
		pts
FROM	standings.standings
WHERE	year >= 1992
),

expenditure AS
(
SELECT	m.year,	m.rank
FROM
(
	SELECT	club_name,
			year,
			DENSE_RANK() OVER (PARTITION BY year ORDER BY SUM(fee_cleaned) DESC) AS rank
	FROM	transfer_database.transfers 
	WHERE	transfer_movement = 'in'
	GROUP BY	year,
				club_name
) AS m
WHERE	club_name = 'Manchester United'
)

SELECT	standings.year,
		standings.rank AS league_rank,
		standings.pts,
		expenditure.rank AS spending_rank
FROM	standings
LEFT JOIN	expenditure
	ON	standings.year = expenditure.year