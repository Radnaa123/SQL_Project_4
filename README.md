# SQL_Project_4

### Data source: https://www.kaggle.com/datasets/davidcariboo/player-scores

Энэхүү төсөл нь Transfermarkt гэх сайтын датан дээр суурилж хийгдсэн ба нийт 15 асуултанд SQL хэл ашиглан хариулсан.

### Асуултууд:

- Which player has scored the most goals in 2019?
- Which club has the highest win percentage in 2019?
- What is the average attendance in the home stadium for each club?
- Which competition had the most goals scored in a 2019?
- How many yellow and red cards did each player receive in 2019?
- Which manager had the highest win rate in 2019?
- Which club has the most goals scored at home?
- What is the average number of goals per game in each competition?
- Which stadium has hosted the most matches in 2019?
- What is the average player age for each club's squad?
- Which player has been transferred the most number of times?
- What is the average transfer fee paid by clubs for players in a 2019?
- Which team has the best home performance in terms of goals scored and wins?
- Which club has spent the most money on player transfers in 2019?
- Which player has the most assists in 2019?

Эдгээр асуултуудыг ChatGPT-с авч гүйцэтгэсэн ба зарим асуултуудын хариуг энд орууллаа.

### Question1: Which player has scored the most goals in a 2019?

| player_name	| total_goals | date |
----------------|-------------|-----------
| Kasper Kusk	|      5	  | 9/25/2019 |

### Question2. Which club has the highest win percentage in 2019?

club_id	| club_name	| total_games	| total_wins	| win_percentage
--------|-----------|---------------|---------------|----------------
3719	| FK Khimki	| 6	| 5	| 83.33

### Question4. Which competition had the most goals scored in a 2019?

competition_id	| competition_name	| total_goals
----------------|-------------------|---------------
IT1	| serie-a	| 1154

### Question7. Which club has the most goals scored at home?

club_id	| club_name	| total_goals_scored_at_home
--------|-----------|---------------------------
131	| Futbol Club Barcelona	| 992

### Question9. Which stadium has hosted the most matches in 2019?

stadium	| total_matches_hosted
--------|---------------------
Giuseppe | Meazza	52

### Question11. Which player has been transferred the most number of times?

player_id	| player_name	| total_transfers
--------|-------------|-------
124560	| Samuele Longo	| 21

### Question13. Which team has the best home performance in terms of goals scored and wins?

home_club_id	| club_name	| home_wins	| total_home_goals
----------------|-----------|-----------|-----------------
31	| Liverpool Football Club	| 24	| 76
