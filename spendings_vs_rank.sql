WITH master AS
(
SELECT	PL20_21.squad AS Squad_20_21,
		PL21_22.squad AS Squad_21_22,
		CASE 
		WHEN PL20_21.points IS NULL THEN 0
		ELSE PL20_21.points 
		END AS Points_20_21,
		CASE WHEN PL21_22.points IS NULL THEN 0
		ELSE PL21_22.points 
		END AS Points_21_22
FROM	"PL21_22".table AS PL21_22
FULL OUTER JOIN "PL20_21".table AS PL20_21
ON PL21_22.squad = PL20_21.squad
),

comparation AS(
SELECT	master.Squad_20_21 AS Squad_20_21,
		master.Squad_21_22 AS Squad_21_22,
		CASE 
		WHEN master.Points_20_21 = 0 THEN 0
		ELSE ROW_NUMBER() OVER(ORDER BY master.Points_20_21 DESC) 
		END AS Rank_20_21,
		CASE 
		WHEN master.Points_21_22 = 0 THEN 0
		ELSE ROW_NUMBER() OVER(ORDER BY master.Points_21_22 DESC) 
		END AS Rank_21_22
FROM	master
),

transfer_fee AS(
SELECT 	CASE transfer.club_name 
		WHEN 'Manchester United' THEN 'Manchester Utd'
		WHEN 'Liverpool FC' THEN 'Liverpool'
		WHEN 'Chelsea FC' THEN 'Chelsea'
		WHEN 'West Ham United' THEN 'West Ham'
		WHEN 'Tottenham Hotspur' THEN 'Tottenham'
		WHEN 'Arsenal FC' THEN 'Arsenal'
		WHEN 'Everton FC' THEN 'Everton'
		WHEN 'Newcastle United' THEN 'Newcastle Utd'
		WHEN 'Wolverhampton Wanderers' THEN 'Wolves'
		WHEN 'Southampton FC' THEN 'Southampton'
		WHEN 'Brighton & Hove Albion' THEN 'Brighton'
		WHEN 'Burnley FC' THEN 'Burnley'
		WHEN 'Watford FC' THEN 'Watford'
		WHEN 'Brentford FC' THEN 'Brentford'
		ELSE transfer.club_name 
		END AS club_name,
		SUM(transfer.fee_cleaned) AS transfer_fee,
		ROW_NUMBER() OVER (ORDER BY SUM(transfer.fee_cleaned) DESC) AS spending_rank
FROM 	"transfer_database".transfers AS transfer
WHERE	transfer.transfer_movement		= 'in'
	AND transfer.transfer_period	= 'Summer'
	AND transfer.league			= 'Premier League'
	AND transfer.season			= '2021/2022'
GROUP BY	transfer.club_name
)

SELECT	club_name,
		SUM(spending_rank),
		CASE 
		WHEN comparation.Squad_20_21 IS NULL THEN 20 - SUM(comparation.Rank_21_22)
		ELSE SUM(comparation.Rank_20_21) - SUM(comparation.Rank_21_22)
		END AS progression
FROM	comparation
RIGHT JOIN	transfer_fee
ON	comparation.Squad_21_22 = club_name
GROUP BY	comparation.Squad_20_21, club_name