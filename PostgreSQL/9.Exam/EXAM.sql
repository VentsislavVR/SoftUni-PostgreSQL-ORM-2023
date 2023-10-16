CREATE TABLE towns (
        id SERIAL PRIMARY KEY,
        name VARCHAR(45) NOT NULL
);
CREATE TABLE stadiums (
        id SERIAL PRIMARY KEY,
        name VARCHAR(45) NOT NULL,
        capacity INT NOT NULL ,
        town_id INT NOT NULL
        CONSTRAINT ck_stadiums_capacity
            CHECK (capacity > 0),
        CONSTRAINT fk_stadiums_towns
            FOREIGN KEY (town_id)
                REFERENCES towns(id)
                ON DELETE CASCADE
                ON UPDATE CASCADE
);
CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    name VARCHAR(45) NOT NULL,
    established DATE NOT NULL,
    fan_base INT NOT NULL DEFAULT 0, --constraint 0 > default 0
    stadium_id INT NOT NULL -- REFERENCES stadiums(id) cascade
    CONSTRAINT ck_teams_fan_base
        CHECK (fan_base >= 0),
    CONSTRAINT fk_teams_stadiums
        FOREIGN KEY (stadium_id)
            REFERENCES stadiums(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);
CREATE TABLE coaches (
        id SERIAL PRIMARY KEY,
        first_name VARCHAR(10) NOT NULL,
        last_name VARCHAR(20) NOT NULL,
        salary NUMERIC(10,2) NOT NULL DEFAULT 0, --constraint 0 > default 0 MAYBE DECIMAL
        coach_level INT NOT NULL DEFAULT 0--constraint 0 > default 0
        CONSTRAINT ck_coaches_salary
            CHECK (salary >= 0),
        CONSTRAINT ck_coaches_coach_level
            CHECK (coach_level >= 0)
);
CREATE TABLE skills_data (
    id SERIAL PRIMARY KEY,
    dribbling  INT DEFAULT 0 ,-- constraint >0 default 0
    pace INT DEFAULT 0 , -- constraint >0 default 0
    passing INT DEFAULT 0 , -- constraint >0 default 0
    shooting INT DEFAULT 0 , -- constraint >0 default 0
    speed INT DEFAULT 0 , -- constraint >0 default 0
    strength INT DEFAULT 0 -- constraint >0 default 0
    CONSTRAINT ck_skills_data_dribbling
        CHECK (dribbling >= 0),
    CONSTRAINT ck_skills_data_pace
        CHECK (pace >= 0),
    CONSTRAINT ck_skills_data_passing
        CHECK (passing >= 0),
    CONSTRAINT ck_skills_data_shooting
        CHECK (shooting >= 0),
    CONSTRAINT ck_skills_data_speed
        CHECK (speed >= 0),
    CONSTRAINT ck_skills_data_strength
        CHECK (strength >= 0)

);

-- DROP TABLE IF EXISTS players CASCADE;
CREATE TABLE players (
    id INTEGER PRIMARY KEY,
    first_name VARCHAR(10) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    age INTEGER NOT NULL DEFAULT 0 CHECK (age >= 0),
    position CHAR(1) NOT NULL,
    salary NUMERIC(10, 2) NOT NULL DEFAULT 0 CHECK (salary >= 0),
    hire_date TIMESTAMP,
    skills_data_id INTEGER NOT NULL,
    team_id INTEGER,
    FOREIGN KEY (skills_data_id) REFERENCES skills_data(id) on update cascade ON DELETE CASCADE,
    FOREIGN KEY (team_id) REFERENCES teams(id) on update cascade ON DELETE SET NULL
);
CREATE TABLE players_coaches (
    player_id INT , -- REFERENCES players(id) cascade
    coach_id INT,-- REFERENCES coaches(id) cascade
    CONSTRAINT fk_players_coaches_players
        FOREIGN KEY (player_id)
            REFERENCES players(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE,
    CONSTRAINT fk_players_coaches_coaches
        FOREIGN KEY (coach_id)
            REFERENCES coaches(id)
            ON DELETE CASCADE
            ON UPDATE CASCADE
);

-- 2.
INSERT INTO coaches (first_name, last_name, salary, coach_level)
SELECT
    p.first_name,
    p.last_name,
    p.salary * 2,
    LENGTH(p.first_name)
FROM
    players p
WHERE
    p.hire_date < '2013-12-13 07:18:46';

-- 3.
UPDATE coaches
SET salary = salary * coach_level
WHERE first_name LIKE 'C%'
AND id IN (
    SELECT DISTINCT pc.coach_id
    FROM players_coaches pc
);
-- 4.

DELETE FROM players_coaches
WHERE player_id IN (
    SELECT id
    FROM players
    WHERE hire_date < '2013-12-13 07:18:46'
);
DELETE FROM players
WHERE hire_date < '2013-12-13 07:18:46';

-- 5.
SELECT
    concat(first_name, ' ', last_name) AS full_name,
    age,
    hire_date
FROM  players
where first_name like 'M%'
ORDER BY age DESC, full_name ASC;

-- 6.
SELECT
    p.id,
    concat(first_name, ' ', last_name) AS full_name,
    age,
    position,
    salary,
    pace,
    shooting
FROM players as p
JOIN skills_data as s
ON p.skills_data_id = s.id
WHERE position = 'A'
AND pace + shooting > 130
AND p.team_id IS NULL;
-- 7.
SELECT
    t.id as team_id,
    t.name as team_name,
    COUNT(p.id) as player_count,
    t.fan_base
FROM teams as t
LEFT JOIN players p ON t.id = p.team_id
GROUP BY t.id, t.name, t.fan_base
HAVING t.fan_base > 30000
ORDER BY player_count DESC, t.fan_base DESC;

-- 8.
SELECT
    concat(c.first_name, ' ', c.last_name) AS coach_full_name,
    concat(p.first_name, ' ', p.last_name) AS player_full_name,
    t.name AS team_name,
    sd.passing,
    sd.shooting,
    sd.speed

FROM coaches AS c
JOIN players_coaches pc on c.id = pc.coach_id
JOIN players p on pc.player_id = p.id
JOIN teams t on p.team_id = t.id
JOIN skills_data sd on p.skills_data_id = sd.id
order by coach_full_name, player_full_name desc;
-- 9.
CREATE OR REPLACE FUNCTION fn_stadium_team_name(
    stadium_name VARCHAR(30)
) RETURNS TABLE (team_name VARCHAR) AS
$$
BEGIN
    RETURN QUERY (
        SELECT t.name
        FROM stadiums as s
        JOIN teams t on s.id = t.stadium_id
        WHERE s.name LIKE stadium_name
        ORDER BY t.name
    );
END;
$$
LANGUAGE plpgsql;

SELECT fn_stadium_team_name('BlogXS');
SELECT fn_stadium_team_name('Quaxo');


-- 10

CREATE OR REPLACE PROCEDURE sp_players_team_name(
    IN player_name VARCHAR(50),
    OUT team_name VARCHAR(45)
) AS
$$
BEGIN
    SELECT t.name
    INTO team_name
    FROM players p
    LEFT JOIN teams t ON p.team_id = t.id
    WHERE concat(p.first_name, ' ', p.last_name) LIKE player_name;

    IF team_name IS NULL THEN
        team_name = 'The player currently has no team';
    END IF;
END;
$$
LANGUAGE plpgsql;


CALL sp_players_team_name('Thor Serrels', '');
CALL sp_players_team_name('Walther Olenchenko', '');
CALL sp_players_team_name('Isaak Duncombe', '')
-- 11.
-- 12.