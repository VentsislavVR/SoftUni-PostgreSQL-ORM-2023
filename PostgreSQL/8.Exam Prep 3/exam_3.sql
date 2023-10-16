DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- - hold data about the name of each board game category;
DROP TABLE IF EXISTS addresses CASCADE;
CREATE TABLE addresses(
    id SERIAL PRIMARY KEY,
    street_name VARCHAR(100) NOT NULL,
    street_number INT NOT NULL, --CONSTRAINT > 0
    town VARCHAR(30) NOT NULL,
    country VARCHAR(50) NOT NULL,
    zip_code INT NOT NULL,
                CONSTRAINT ck_addresses_street_number
                CHECK (street_number > 0),
                CONSTRAINT ck_addresses_zip_code
                      CHECK (zip_code > 0)

);
-- - store information regarding the locations of board game publishers;
DROP TABLE IF EXISTS publishers CASCADE;
CREATE TABLE publishers(
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    address_id INT NOT NULL, -- CONSTRAINT
    website VARCHAR(40) ,
    phone VARCHAR(20),

    CONSTRAINT fk_publishers_addresses
        FOREIGN KEY (address_id)
            REFERENCES addresses(id)
            ON UPDATE CASCADE
            ON DELETE CASCADE
);

-- - contain information about the publishers of the board games;
DROP TABLE IF EXISTS players_ranges CASCADE;
CREATE TABLE players_ranges(
        id SERIAL PRIMARY KEY,
        min_players INTEGER NOT NULL,
        max_players INTEGER NOT NULL
                    CONSTRAINT ck_players_ranges_min_players
                           CHECK (min_players > 0),
                    CONSTRAINT ck_players_ranges_max_players
                           CHECK (max_players > 0)
);

-- - hold information about the minimum and maximum player counts for each game;
DROP TABLE IF EXISTS creators CASCADE ;
CREATE TABLE creators(
        id SERIAL PRIMARY KEY,
        first_name VARCHAR(30) NOT NULL ,
        last_name VARCHAR(30) NOT NULL ,
        email VARCHAR(30) NOT NULL

);

-- - store data about the creators of the board games;
DROP TABLE IF EXISTS board_games CASCADE;
CREATE TABLE board_games(
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    release_year INT NOT NULL, -- CONSTRAINT >0
    rating NUMERIC(3,2) NOT NULL,
    category_id INT NOT NULL, -- CONSTRAINT
    publisher_id INT NOT NULL, -- CON
    players_range_id INT NOT NULL -- CONSTRAINT
        CONSTRAINT ck_board_games_release_year
                        CHECK ( release_year > 0),
        CONSTRAINT fk_board_games_categories
                FOREIGN KEY (category_id)
                        REFERENCES categories(id)
                        ON UPDATE CASCADE
                        ON DELETE CASCADE,
        CONSTRAINT fk_board_games_publishers
                FOREIGN KEY (publisher_id)
                        REFERENCES publishers(id)
                        ON UPDATE CASCADE
                        ON DELETE CASCADE,
        CONSTRAINT fk_board_games_players_ranges
                FOREIGN KEY (players_range_id)
                        REFERENCES players_ranges(id)
                        ON UPDATE CASCADE
                        ON DELETE CASCADE
);

-- - contain information about each individual board game;

DROP TABLE IF EXISTS creators_board_games CASCADE;
CREATE TABLE creators_board_games(
    creator_id INT NOT NULL,
    board_game_id INT NOT NULL,

    CONSTRAINT fk_creators_board_games_creators
        FOREIGN KEY (creator_id)
            REFERENCES creators(id),
    CONSTRAINT fk_creators_board_games_board_games
            FOREIGN KEY (board_game_id)
                    REFERENCES board_games(id)

);

-- - serves as a mapping table between the creators and board games.

-- 2.
INSERT INTO board_games(name, release_year, rating, category_id, publisher_id, players_range_id)
VALUES  ('Deep Blue',2019,5.67,1,15,7),
        ('Paris',2016,9.78,7,1,5),
        ('Catan: Starfarers',2021,9.87,7,13,6),
        ('Bleeding Kansas',2020,3.25,3	,7,4),
        ('One Small Step',	2019,5.75,5,9,2);
INSERT INTO publishers(name, address_id, website, phone)
VALUES ('Agman Games',5,'www.agmangames.com','+16546135542'),
    ('Amethyst Games',7,'www.amethystgames.com','+15558889992'),
    ('BattleBooks',13,'www.battlebooks.com','+12345678907');
-- 3.
UPDATE players_ranges
SET max_players = max_players +1
WHERE players_ranges.max_players = 2
        and
players_ranges.min_players = 2;
UPDATE  board_games
SET name = name ||' V2'
WHERE release_year >= 2020;

-- 4. damn ....
ALTER TABLE board_games
DROP CONSTRAINT fk_board_games_publishers;

ALTER TABLE board_games
add CONSTRAINT fk_board_games_publishers
                FOREIGN KEY (publisher_id)
                        REFERENCES publishers(id)
                        ON UPDATE CASCADE
                        ON DELETE CASCADE;

DELETE FROM addresses CASCADE
WHERE town LIKE 'L%';
-- where substring(town FROM 1 FOR 1) = 'L'
-- 5.
SELECT
    name,
    rating
FROM board_games
ORDER BY release_year,NAME DESC;

-- 6.
SELECT
    b.id,
    b.name,
    release_year,
    c.name as category_name
FROM board_games as b
join categories c on b.category_id = c.id
where c.name in ('Wargames','Strategy Games')
ORDER BY release_year desc;
-- 7.
SELECT
    c.id,
    CONCAT(c.first_name, ' ', c.last_name) AS creator_name,
    c.email
FROM creators AS c
LEFT JOIN creators_board_games AS cbg
    ON c.id = cbg.creator_id
WHERE cbg.creator_id IS NULL;

-- 8.
SELECT
    bg.name,
    rating,
    c.name
FROM board_games as bg
join players_ranges pr on bg.players_range_id = pr.id
join categories c on bg.category_id = c.id
WHERE (rating > 7.00) and (bg.name LIKE '%a%' or rating > 7.50)
AND pr.min_players = 2 and pr.max_players = 5;


SELECT
    bg.name,
    bg.rating,
    c.name AS category_name
FROM board_games AS bg
JOIN players_ranges AS pr ON bg.players_range_id = pr.id
JOIN categories AS c ON bg.category_id = c.id
WHERE (bg.rating > 7.00)
      AND (lower(bg.name) LIKE '%a%' OR bg.rating > 7.50)
      AND (pr.min_players >= 2 AND pr.max_players <= 5)
ORDER BY
    bg.name ASC,
    bg.rating DESC
LIMIT 5;

-- 9.
SELECT
    concat(c.first_name,' ',c.last_name) AS full_name,
    c.email,
    max(bg.rating)
FROM creators as c
JOIN creators_board_games cbg on c.id = cbg.creator_id
JOIN board_games bg on bg.id = cbg.board_game_id
WHERE email LIKE '%.com'
GROUP BY full_name,c.email, concat_ws(c.first_name,c.last_name)
ORDER BY full_name;

-- 10.
SELECT
    c.last_name,
    ceil(avg(bg.rating)) as avg_rating,
    p.name
FROM creators as c
join creators_board_games cbg on c.id = cbg.creator_id
join board_games bg on bg.id = cbg.board_game_id
join publishers p on p.id = bg.publisher_id
WHERE p.name = 'Stonemaier Games'
group by c.last_name,p.name
ORDER BY avg_rating desc;

-- 11.

CREATE OR REPLACE FUNCTION fn_creator_with_board_games(
            fname VARCHAR(30)
) RETURNS INT AS
$$
    BEGIN
        RETURN ( SELECT
            count(board_game_id)
        FROM creators
        join creators_board_games cbg on creators.id = cbg.creator_id
        where creators.first_name = fname);
    end;
$$
language plpgsql;

-- 12.
CREATE TABLE search_results (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    release_year INT,
    rating FLOAT,
    category_name VARCHAR(50),
    publisher_name VARCHAR(50),
    min_players VARCHAR(50),
    max_players VARCHAR(50)
);

CREATE OR REPLACE PROCEDURE usp_search_by_category(
            category VARCHAR(50)
) as
$$
    BEGIN
        INSERT INTO search_results(
                                   name, release_year,
                                   rating, category_name,
                                   publisher_name, min_players,
                                   max_players

        )
                SELECT
                    distinct(bg.name),
                    bg.release_year,
                    bg.rating,
                    c.name,
                    p.name,
                    pr.min_players || ' people',
                    pr.max_players || ' people'
                FROM board_games as bg
                join categories c on c.id = bg.category_id
                join players_ranges pr on bg.players_range_id = pr.id
                join creators_board_games cbg on bg.id = cbg.board_game_id
                join publishers p on bg.publisher_id = p.id
                where c.name = category
                ORDER BY p.name,release_year;
    end;
$$
language plpgsql;




CALL usp_search_by_category('Wargames');

SELECT * FROM search_results;
