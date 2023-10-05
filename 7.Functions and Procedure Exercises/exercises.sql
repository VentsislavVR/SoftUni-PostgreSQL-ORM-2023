-- 1.
CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR, last_name VARCHAR)
RETURNS VARCHAR AS
$$
    DECLARE
    full_name VARCHAR;
    BEGIN
        IF first_name IS NULL THEN
            full_name = INITCAP(last_name);
        ELSIF last_name IS NULL THEN
            full_name := INITCAP(first_name);
        ELSIF first_name IS NULL AND last_name IS NULL THEN
            full_name := NULL;
        ELSE
            full_name = concat(initcap(first_name), ' ', initcap(last_name));

        end if;
        RETURN full_name;

    end;
$$

LANGUAGE plpgsql;
SELECT  fn_full_name('bate','venci');

-- 2.
CREATE OR REPLACE FUNCTION fn_calculate_future_value(
    initial_sum NUMERIC,
    yearly_interest_rate NUMERIC,
    number_of_years INT
) RETURNS NUMERIC AS
$$
DECLARE
    future_value NUMERIC;
BEGIN
    future_value := initial_sum * POWER(1 + yearly_interest_rate, number_of_years);
    RETURN trunc(future_value, 4);
END;
$$
LANGUAGE plpgsql;

SELECT fn_calculate_future_value(500, 0.25, 10);

-- 3. not working
-- CREATE OR REPLACE FUNCTION fn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
-- RETURNS BOOLEAN AS
-- $$
-- DECLARE
--     cur_char CHAR;
--     i INT := 1;
-- BEGIN
--     WHILE i <= length(set_of_letters) LOOP
--         cur_char := substring(lower(set_of_letters), i, 1);
--         IF position(lower(cur_char) IN word) = 0 THEN
--             RETURN FALSE;
--         END IF;
--         i := i + 1;
--     END LOOP;
--
--     RETURN TRUE;
-- END;
-- $$
-- LANGUAGE plpgsql;

-- 3.1
CREATE OR REPLACE FUNCTION fn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS BOOLEAN AS
$$
DECLARE
    cur_char CHAR;
    i INT := 1;
    word_composed BOOLEAN;
BEGIN
    set_of_letters := LOWER(set_of_letters);
    word := LOWER(word);
    word_composed := True;
    WHILE i <= length(word) LOOP
        cur_char := substring(word, i, 1);
        IF cur_char ~ '[a-z]' THEN
            IF position(cur_char IN set_of_letters) = 0 THEN
                word_composed := FALSE;
                EXIT;
            END IF;
        END IF;

        i := i + 1;
    END LOOP;

    RETURN word_composed;
END;
$$
LANGUAGE plpgsql;

SELECT fn_is_word_comprised('ois tmiah%f', 'halves');

SELECT fn_is_word_comprised('ois tmiah%f', 'Sofia') ;
SELECT fn_is_word_comprised('bobr', 'Rob') ;

SELECT fn_is_word_comprised('papopep', 'toe') ;

SELECT fn_is_word_comprised('R@o!B$B', 'Bob') ;

-- 4. 100/100 wrong output
CREATE OR REPLACE FUNCTION fn_is_game_over(is_game_over BOOLEAN )
RETURNS TABLE(
    name VARCHAR(50) ,
     game_type_id INT,
    is_finished BOOLEAN
              ) AS
$$
    begin
        RETURN QUERY
        SELECT
        g.name,
        g.game_type_id,
        g.is_finished
            FROM games as g
        WHERE g.is_finished = is_game_over;

    end;

$$
LANGUAGE plpgsql;

SELECT fn_is_game_over(true);

-- 5.
CREATE OR REPLACE FUNCTION fn_difficulty_level(level INT)
RETURNS VARCHAR AS
$$
DECLARE
    difficulty_level VARCHAR;
BEGIN
    IF level <= 40 THEN
        difficulty_level := 'Normal Difficulty';
    ELSIF level BETWEEN 41 AND 60 THEN
        difficulty_level := 'Nightmare Difficulty';
    ELSE
        difficulty_level := 'Hell Difficulty';
    END IF;

    RETURN difficulty_level;
END;
$$
LANGUAGE plpgsql;


SELECT
    ug.user_id,
    ug.level,
    ug.cash,
    fn_difficulty_level(ug.level) as difficulty_level
FROM users_games as ug
order by ug.user_id;


-- 6.
-- 7.

