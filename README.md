# project-mu21-22-performance
***
This repository includes an exploratory data analysis project I did to analyze Manchester United performance in 2021/2022.

Please read the full report [here](https://hnuradhyaksa.github.io/posts/2022-09-21-mufc-last-season/).

## Description

This project starts with extracting data from FBRef. The process will continue with comprehensive data exploration using SQL in the PostgreSQL environment.

Below is a summary of comprehension table containing the actions I took to get this project to completion:

|Comprehension|Technique|Tool|
|:---|:---|:---|
|Data preparation|Create, Clean, Modify, Common Table Expression (CTE)|PostgreSQL|
|Data manipulation & exploration|Normalization, Aggregation, Unit Conversion, Ranking, Pivot Table, Window Function, Statistical Measurement|PostgreSQL|
|Data visualization|- |Tableau, R(fmsb)|
|Reporting|Markdown language|Visual Studio Code|

## Key Insights

 - The club's spending is second in the league, where they only signed three players. Yet, only Ronaldo, the cheapest new signing, managed to deliver.
 - United's both sides (attacking and defending) can be criticized, as they were not functional enough. However, the defensive side is more to blame.
 - United was struggling to control the front area. They had the lowest touches in that area.
 - The primary suspect in their performance downfall was the injury storm. Nevertheless, Manchester United's shallow squad structure did not allow it to overcome the crisis. The quality of the core squad and its backers is lopsided.
 - On an individual basis, United's core Midfielders and Goalkeeper performed poorly during the season.

 # Contents
 ***

 ## Data

Data that has been compiled from the scraping process can be found in the `data/` directory in csv format. 
The following is a description of the files in that folder:

 - `PL20_21` : contains EPL player performance data accross different categories for the 2020/2021 season
 - `PL21_22` : contains EPL player performance data accross different categories for the 2021/2022 season
 - `ENG-Premier-league-transfers.csv` : contains EPL player transfer data
 - `cumulative_tables.csv` : contain MUFC historical performance from 1886 - 2022

 ## Code/Query

 Python:

 - `attacking_stats.sql` : query to extract attacking stats of MUFC player
 - `awb_stats_pl20_21.sql` : query to extract Aaron Wan-Bissaka stats for 2020/2021 season
 - `cdmf_stats.sql` : query to extract MUFC's central and defensive midfielders for 2020/2021 season
 - `gk_stats.sql` : query to extract goalkeeping stats for several players
 - `goal_dist.sql` : query to extract goal distribution accross the big 6 EPL clubs
 - `playing_minutes.sql` : query to extract playing minutes of the squad
 - `spendings_vs_rank.sql` : query to extract club spending and corresponding league rank
 - `united_overall_pl21_22.sql` : query to extract overall stats of MUFC in 2021/2022 season
 - `united_productivity.sql` : query to extract goal productivity for MUFC players
 - `r_plot_gk.R` : R code to plot radar chart to visualize GK stats
 - `r_plot_goaldense.R` : R code to plot goal density of the big 6 team using ridgeline chart

 # Source
 ***

 All the data was scraped from [Class Central](https://www.classcentral.com/providers)