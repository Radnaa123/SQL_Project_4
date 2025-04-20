--Question1. Which player has scored the most goals in a 2019?
SELECT 
    a.player_id,
    p.name AS player_name,
    a.competition_id,
    SUM(a.goals) AS total_goals,
    a.date
FROM appearance a
JOIN players p ON a.player_id = p.player_id
WHERE EXTRACT(YEAR FROM a.date) = 2019
GROUP BY a.player_id, p.name, a.competition_id, a.date
ORDER BY total_goals DESC
LIMIT 1;

--Question2. Which club has the highest win percentage in 2019?
WITH club_win_stats AS (
    SELECT 
        cg.club_id,
        c.name AS club_name,
        COUNT(*) AS total_games,
        SUM(CASE WHEN cg.is_win = TRUE THEN 1 ELSE 0 END) AS total_wins,
        ROUND(100.0 * SUM(CASE WHEN cg.is_win = TRUE THEN 1 ELSE 0 END) / COUNT(*), 2) AS win_percentage
    FROM club_games cg
    JOIN clubs c ON cg.club_id = c.club_id
    JOIN games g ON cg.game_id = g.game_id
    WHERE g.season = 2019
    GROUP BY cg.club_id, c.name
)
SELECT club_id, club_name, total_games, total_wins, win_percentage
FROM club_win_stats
ORDER BY win_percentage DESC
LIMIT 1;

--Question3. What is the average attendance in the home stadium for each club?
SELECT 
    g.home_club_id,
    c.name AS club_name,
    AVG(g.attendance) AS avg_attendance
FROM games g
JOIN clubs c ON g.home_club_id = c.club_id
WHERE g.attendance IS NOT NULL
GROUP BY g.home_club_id, c.name
ORDER BY avg_attendance DESC;

--Question4. Which competition had the most goals scored in a 2019?
SELECT 
    g.competition_id,
    c.name AS competition_name,
    SUM(g.home_club_goals + g.away_club_goals) AS total_goals
FROM games g
JOIN competitions c ON g.competition_id = c.competition_id
WHERE g.season = 2019
GROUP BY g.competition_id, c.name
ORDER BY total_goals DESC
LIMIT 1;

--Question5. How many yellow and red cards did each player receive in 2019?

SELECT 
    player_id,
    player_name,
    SUM(yellow_cards) AS total_yellow_cards,
    SUM(red_cards) AS total_red_cards
FROM appearance
WHERE EXTRACT(YEAR FROM date) = 2019
GROUP BY player_id, player_name
ORDER BY total_red_cards DESC, total_yellow_cards DESC;

--Question6. Which manager had the highest win rate in 2019?
WITH manager_wins AS (
    SELECT 
        cg.own_manager_name AS manager_name,
        COUNT(*) AS total_games,
        SUM(CASE WHEN cg.is_win THEN 1 ELSE 0 END) AS wins,
        ROUND(100.0 * SUM(CASE WHEN cg.is_win THEN 1 ELSE 0 END) / COUNT(*), 2) AS win_rate
    FROM club_games cg
    JOIN games g ON cg.game_id = g.game_id
    WHERE g.season = 2019
    AND cg.own_manager_name IS NOT NULL
    GROUP BY cg.own_manager_name
)
SELECT 
    manager_name,
    total_games,
    wins,
    win_rate
FROM manager_wins
ORDER BY win_rate DESC
LIMIT 1;

--Question7. Which club has the most goals scored at home?
SELECT 
    cg.club_id,
    c.name AS club_name,
    SUM(cg.own_goals) AS total_goals_scored_at_home
FROM club_games cg
JOIN clubs c ON cg.club_id = c.club_id
WHERE cg.hosting = 'Home'
GROUP BY cg.club_id, c.name
ORDER BY total_goals_scored_at_home DESC
LIMIT 1;

--Question8. What is the average number of goals per game in each competition?
SELECT 
    g.competition_id,
    c.name AS competition_name,
    COUNT(g.game_id) AS total_games,
    SUM(g.home_club_goals + g.away_club_goals) AS total_goals,
    ROUND(SUM(g.home_club_goals + g.away_club_goals) / COUNT(g.game_id), 2) AS avg_goals_per_game
FROM games g
JOIN competitions c ON g.competition_id = c.competition_id
GROUP BY g.competition_id, c.name
ORDER BY avg_goals_per_game DESC;

--Question9. Which stadium has hosted the most matches in 2019?
SELECT 
    g.stadium,
    COUNT(g.game_id) AS total_matches_hosted
FROM games g
WHERE g.season = 2019
GROUP BY g.stadium
ORDER BY total_matches_hosted DESC
LIMIT 1;

--Question10. What is the average player age for each club's squad?
SELECT 
    c.club_id,
    c.name AS club_name,
    AVG(EXTRACT(YEAR FROM AGE(p.date_of_birth))) AS avg_player_age
FROM players p
JOIN clubs c ON p.current_club_id = c.club_id
GROUP BY c.club_id, c.name
ORDER BY avg_player_age DESC;

--Question11. Which player has been transferred the most number of times?
SELECT 
    t.player_id,
    p.name AS player_name,
    COUNT(t.transfer_date) AS total_transfers
FROM transfers t
JOIN players p ON t.player_id = p.player_id
GROUP BY t.player_id, p.name
ORDER BY total_transfers DESC
LIMIT 1;

--Question12. What is the average transfer fee paid by clubs for players in a 2019?
SELECT 
    AVG(t.transfer_fee) AS avg_transfer_fee
FROM transfers t
WHERE t.transfer_date BETWEEN '2019-01-01' AND '2019-12-31';

--Question13. Which team has the best home performance in terms of goals scored and wins?
SELECT 
    g.home_club_id,
    c.name AS club_name,
    COUNT(CASE WHEN g.home_club_goals > g.away_club_goals THEN 1 END) AS home_wins,
    SUM(g.home_club_goals) AS total_home_goals
FROM games g
JOIN clubs c ON g.home_club_id = c.club_id
WHERE g.season = 2019
GROUP BY g.home_club_id, c.name
ORDER BY home_wins DESC, total_home_goals DESC
LIMIT 1;

--Question14. Which club has spent the most money on player transfers in 2019?

SELECT 
    c.name AS club_name,
    SUM(t.transfer_fee) AS total_spent
FROM transfers t
JOIN clubs c ON t.to_club_id = c.club_id
WHERE EXTRACT(YEAR FROM t.transfer_date) = 2019
  AND t.transfer_fee IS NOT NULL
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;

--Question15. Which player has the most assists in 2019?
SELECT 
    a.player_id,
    a.player_name,
    SUM(a.assists) AS total_assists
FROM appearance a
WHERE EXTRACT(YEAR FROM a.date) = 2019
GROUP BY a.player_id, a.player_name
ORDER BY total_assists DESC
LIMIT 1;