-- 1.
CREATE OR REPLACE FUNCTION fn_full_name(
        first_name VARCHAR,
        last_name VARCHAR
) RETURNS VARCHAR(101) AS
    $$
    DECLARE full_name VARCHAR(101);
    BEGIN
        full_name := INITCAP(first_name) || ' ' || INITCAP(last_name);
        RETURN full_name;
    end;

    $$
LANGUAGE plpgsql;
SELECT * FROM fn_full_name('BATE','VENCI');

-- 2.
CREATE OR REPLACE FUNCTION fn_calculate_future_value(
    initial_sum DECIMAL,
    yearly_interest_rate DECIMAL,
    number_of_years INT
) RETURNS DECIMAL AS
$$
    BEGIN
        RETURN TRUNC(
            initial_sum * POWER(1+ yearly_interest_rate,number_of_years),4
            );
    end;
$$
LANGUAGE plpgsql;
SELECT fn_calculate_future_value(500, 0.25, 10);

-- 3.
CREATE OR REPLACE FUNCTION fn_is_word_comprised (
        set_of_letters VARCHAR(50),
        word VARCHAR(50)
         ) RETURNS BOOLEAN
AS
$$
    BEGIN
        RETURN TRIM(LOWER(word),LOWER(set_of_letters)) = '';
    end;
$$
    LANGUAGE plpgsql;
SELECT fn_is_word_comprised('ois tmiah%f', 'halves');

SELECT * FROM fn_is_word_comprised('ABC', 'CBA') ;

-- 4.
CREATE OR REPLACE FUNCTION fn_is_game_over(
                is_game_over BOOLEAN
) RETURNS TABLE(
    name VARCHAR(50) ,
    game_type_id INT,
    is_finished BOOLEAN
              ) AS
$$
    BEGIN
        RETURN QUERY
            SELECT
                g.name,
                g.game_type_id,
                g.is_finished
            FROM games AS g
            where g.is_finished = is_game_over;
    end;
$$
    LANGUAGE plpgsql;
SELECT fn_is_game_over(true);

-- 5.
CREATE OR REPLACE FUNCTION fn_difficulty_level(
            level INT
            ) RETURNS VARCHAR(50)
AS
$$
    DECLARE
        difficulty_level VARCHAR(50);
BEGIN
        IF (level <= 40) THEN
            difficulty_level := 'Normal Difficulty';
        ELSIF (level BETWEEN 41 AND 60) THEN
            difficulty_level := 'Nightmare Difficulty';
        ELSE
            difficulty_level := 'Hell Difficulty';
        END IF;

        RETURN difficulty_level;

    END;
$$
LANGUAGE plpgsql;

SELECT
    user_id,
    level,
    cash,
    fn_difficulty_level(level)
from users_games
ORDER BY user_id;

-- 6.

CREATE OR REPLACE FUNCTION fn_cash_in_users_games(
    game_name VARCHAR(50)
) RETURNS TABLE(
    total_cash NUMERIC
)
AS
$$
    BEGIN
        RETURN QUERY
        WITH ranked_games AS (
            SELECT
                cash,
                ROW_NUMBER() OVER (ORDER BY cash DESC) as row_num
            FROM
                users_games AS ug
            JOIN
                games AS g
            ON
                ug.game_id = g.id
            WHERE
                g.name = game_name
            )
        SELECT
            ROUND(SUM(cash),2) AS total_cash
        FROM
            ranked_games
        WHERE row_num % 2 <> 0;
    END;
$$
LANGUAGE plpgsql;
SELECT fn_cash_in_users_games('Love in a mist')
