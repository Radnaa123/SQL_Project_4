CREATE TABLE clubs (
    club_id SERIAL PRIMARY KEY,
    club_code VARCHAR(50),
    name VARCHAR(255),
    domestic_competition_id VARCHAR(10),
    total_market_value BIGINT,
    squad_size INT,
    average_age DECIMAL(3,1),
    foreigners_number INT,
    foreigners_percentage DECIMAL(5,2),
    national_team_players INT,
    stadium_name VARCHAR(255),
    stadium_seats INT,
    net_transfer_record VARCHAR(50),
    coach_name VARCHAR(255),
    last_season INT,
    filename TEXT,
    url TEXT
);

CREATE TABLE competitions (
    competition_id VARCHAR(10) PRIMARY KEY,
    competition_code VARCHAR(50),
    name VARCHAR(255),
    sub_type VARCHAR(50),
    type VARCHAR(50),
    country_id INT,
    country_name VARCHAR(100),
    domestic_league_code VARCHAR(10),
    confederation VARCHAR(50),
    url TEXT,
    is_major_national_league BOOLEAN
);

CREATE TABLE games (
    game_id BIGINT PRIMARY KEY,
    competition_id VARCHAR(10) NOT NULL,
    season INT NOT NULL,
    round VARCHAR(100),
    date DATE NOT NULL,
    home_club_id INT NOT NULL,
    away_club_id INT NOT NULL,
    home_club_goals INT DEFAULT 0,
    away_club_goals INT DEFAULT 0,
    home_club_position INT,
    away_club_position INT,
    home_club_manager_name VARCHAR(255),
    away_club_manager_name VARCHAR(255),
    stadium VARCHAR(255),
    attendance INT,
    referee VARCHAR(255),
    url TEXT,
    home_club_formation VARCHAR(50),
    away_club_formation VARCHAR(50),
    home_club_name VARCHAR(255),
    away_club_name VARCHAR(255),
    aggregate VARCHAR(20),
    competition_type VARCHAR(50),
);

ALTER TABLE games
ADD CONSTRAINT fk_competition_id
FOREIGN KEY (competition_id)
REFERENCES competitions(competition_id);

CREATE TABLE players (
    player_id BIGINT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    name VARCHAR(255) NOT NULL,
    last_season INT,
    current_club_id INT,
    player_code VARCHAR(100),
    country_of_birth VARCHAR(100),
    city_of_birth VARCHAR(100),
    country_of_citizenship VARCHAR(100),
    date_of_birth DATE,
    sub_position VARCHAR(100),
    position VARCHAR(100),
    foot VARCHAR(10),
    height_in_cm INT,
    contract_expiration_date DATE,
    agent_name VARCHAR(255),
    image_url TEXT,
    url TEXT,
    current_club_domestic_competition_id VARCHAR(10),
    current_club_name VARCHAR(255),
    market_value_in_eur BIGINT,
    highest_market_value_in_eur BIGINT
);

CREATE TABLE club_games (
    game_id BIGINT,
    club_id INT,
    own_goals INT,
    own_position INT,
    own_manager_name VARCHAR(255),
    opponent_id INT,
    opponent_goals INT,
    opponent_position INT,
    opponent_manager_name VARCHAR(255),
    hosting VARCHAR(10) CHECK (hosting IN ('Home', 'Away')),
    is_win BOOLEAN,
    PRIMARY KEY (game_id, club_id),
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    FOREIGN KEY (club_id) REFERENCES clubs(club_id),
    FOREIGN KEY (opponent_id) REFERENCES clubs(club_id)
);

ALTER TABLE club_games DISABLE TRIGGER ALL;

DELETE FROM club_games
WHERE NOT EXISTS (
    SELECT 1
    FROM clubs
    WHERE clubs.club_id = club_games.club_id
);

ALTER TABLE club_games ENABLE TRIGGER ALL;

CREATE TABLE player_valuations (
    player_id BIGINT NOT NULL,
    date DATE NOT NULL,
    market_value_in_eur BIGINT,
    current_club_id INT NOT NULL,
    player_club_domestic_competition_id VARCHAR(10),
    PRIMARY KEY (player_id, date),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (current_club_id) REFERENCES clubs(club_id)
);

CREATE TABLE game_events (
    game_event_id UUID PRIMARY KEY,
    date DATE NOT NULL,
    game_id BIGINT NOT NULL,
    minute INT,
    type VARCHAR(50),
    club_id INT NOT NULL,
    player_id BIGINT NOT NULL,
    description TEXT,
    player_in_id BIGINT,
    player_assist_id BIGINT,
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    FOREIGN KEY (club_id) REFERENCES clubs(club_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (player_in_id) REFERENCES players(player_id),
    FOREIGN KEY (player_assist_id) REFERENCES players(player_id)
);

ALTER TABLE game_events DISABLE TRIGGER ALL;

DELETE FROM game_events
WHERE NOT EXISTS (
    SELECT 1
    FROM clubs
    WHERE clubs.club_id = game_events.club_id
);

ALTER TABLE game_events ENABLE TRIGGER ALL;

CREATE TABLE appearance (
    game_id BIGINT NOT NULL,
    player_id BIGINT NOT NULL,
    player_club_id INT NOT NULL,
    player_current_club_id INT NOT NULL,
    date DATE NOT NULL,
    player_name VARCHAR(255),
    competition_id VARCHAR(10),
    yellow_cards INT DEFAULT 0,
    red_cards INT DEFAULT 0,
    goals INT DEFAULT 0,
    assists INT DEFAULT 0,
    minutes_played INT,
    PRIMARY KEY (game_id, player_id),
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (player_club_id) REFERENCES clubs(club_id),
    FOREIGN KEY (player_current_club_id) REFERENCES clubs(club_id)
);

ALTER TABLE appearance DISABLE TRIGGER ALL;

DELETE FROM appearance
WHERE NOT EXISTS (
    SELECT 1
    FROM clubs
    WHERE clubs.club_id = appearance.player_club_id
);

DELETE FROM appearance
WHERE NOT EXISTS (
    SELECT 1
    FROM clubs
    WHERE clubs.club_id = appearance.player_current_club_id
);

ALTER TABLE appearance ENABLE TRIGGER ALL;

CREATE TABLE game_lineups (
    game_lineups_id UUID PRIMARY KEY,
    date DATE NOT NULL,
    game_id BIGINT NOT NULL,
    player_id BIGINT NOT NULL,
    club_id INT NOT NULL,
    player_name VARCHAR(255),
    type VARCHAR(50),
    position VARCHAR(50),
    number INT,
    team_captain BOOLEAN,
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (club_id) REFERENCES clubs(club_id)
);

ALTER TABLE game_lineups DISABLE TRIGGER ALL;

DELETE FROM game_lineups
WHERE NOT EXISTS (
    SELECT 1
    FROM players
    WHERE players.player_id = game_lineups.player_id
);

ALTER TABLE game_lineups ENABLE TRIGGER ALL;

CREATE TABLE transfers (
    player_id BIGINT NOT NULL,
    transfer_date DATE NOT NULL,
    transfer_season VARCHAR(10),
    from_club_id INT NOT NULL,
    to_club_id INT NOT NULL,
    from_club_name VARCHAR(255),
    to_club_name VARCHAR(255),
    transfer_fee BIGINT,
    market_value_in_eur BIGINT,
    player_name VARCHAR(255),
    FOREIGN KEY (from_club_id) REFERENCES clubs(club_id),
    FOREIGN KEY (to_club_id) REFERENCES clubs(club_id)
);

ALTER TABLE transfers DISABLE TRIGGER ALL;

DELETE FROM transfers
WHERE NOT EXISTS (
    SELECT 1
    FROM clubs
    WHERE clubs.club_id = transfers.from_club_id
);

DELETE FROM transfers
WHERE NOT EXISTS (
    SELECT 1
    FROM clubs
    WHERE clubs.club_id = transfers.to_club_id
);

ALTER TABLE transfers ENABLE TRIGGER ALL;
