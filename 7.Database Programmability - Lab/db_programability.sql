-- EXAMPLE FUNCTION 1

-- CREATE OR REPLACE FUNCTION fn_full_name(VARCHAR,VARCHAR)
-- RETURNS VARCHAR AS
-- $$
--     DECLARE
--         first_name ALIAS FOR $1;
--         last_name ALIAS FOR $2;
--     BEGIN
--         RETURN concat(first_name,' ',last_name);
--
--     END
-- $$
-- LANGUAGE plpgsql;
--
-- SELECT  fn_full_name('Kumcho', 'Vulcho');
-- #############################


-- EXAMPLE FUNCTION 2


-- CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR,last_name VARCHAR)
-- RETURNS VARCHAR AS
-- $$
--     DECLARE
--         full_name VARCHAR;
--     BEGIN
--         IF first_name IS NULL AND last_name IS NULL THEN
--             full_name := NULL;
--         ELSIF
--             first_name IS NULL THEN
--             full_name := last_name;
--         ELSEIF last_name IS NULL THEN
--             full_name := first_name;
--         ELSE
--             full_name := concat(first_name,' ' ,last_name);
--
--         END IF;
--         RETURN full_name;
--     END
-- $$
-- LANGUAGE plpgsql;

-- SELECT  fn_full_name('hOho', 'NoHo')
-- ################################################################
-- -
-- - EXAMPLE FUNCTION 3 (get city id from dif table)

-- #########
--
-- CREATE OR REPLACE FUNCTION fn_get_city_id(city_name VARCHAR)
-- RETURNS INT AS
-- $$
--     DECLARE
--         city_id INT;
--     BEGIN
--         SELECT id(INTO city_id can be placed here) FROM cities
--         WHERE name = city_name
--         INTO city_id;
--         RETURN city_id;
--
--     END;
--
-- $$
-- LANGUAGE plpgsql;
-- SELECT fn_get_city_id('Varna');
-- INSERT INTO persons(first_name, last_name,city_id)
-- VALUES ('Vencia', 'Rachev', fn_get_city_id('Varna'))
-- SELECT id FROM cities WHERE name = 'Varna' old way


-- ################################

-- EXAMPLE FUNC 4 IN/OUT/STATUS
-- ###########

-- CREATE OR REPLACE FUNCTION fn_get_city_id(
--     IN city_name VARCHAR,
--     OUT city_id INT,
--     OUT status INT
-- ) AS
--
-- $$
--     DECLARE
--         temp_id INT;
--     BEGIN
--        SELECT id FROM cities WHERE name = city_name
--        INTO temp_id;
--        IF temp_id IS NULL THEN
--            SELECT 100 INTO status;
--         ELSE
--             alternative way without SELECT
--                 city_id := temp_id;
--                 status := 0
--            SELECT temp_id,0 INTO city_id,status;
--        END IF;
--
--     END;
--
-- $$
-- LANGUAGE plpgsql;
-- SELECT * FROM fn_get_city_id('Varna');
-- res city_id 3 // status 0
-- SELECT * FROM fn_get_city_id('Varna');
-- res city_id null // status 100

-- 1. first way
CREATE or replace FUNCTION fn_count_employees_by_town(town_name VARCHAR)
RETURNS INT AS
$$
    DECLARE
    town_count INT;
    BEGIN
        SELECT
--             or select count(*) into town_count from etc
            count(*)
        FROM employees as e
        JOIN addresses AS a
            USING (address_id)
                JOIN towns as t
                    USING (town_id)
        WHERE t.name = town_name
        INTO town_count;
        RETURN town_count;
    END
$$
LANGUAGE plpgsql;
SELECT fn_count_employees_by_town('Sofia');

-- 1.1 Second

CREATE or replace FUNCTION fn_count_employees_by_town(town_name VARCHAR)
RETURNS INT AS
$$
    DECLARE
    BEGIN
        RETURN(
            SELECT
                count(*)
            FROM employees as e
            JOIN addresses AS a
                USING (address_id)
                    JOIN towns as t
                        USING (town_id)
            WHERE t.name = town_name
            );
    END
$$
LANGUAGE plpgsql;



-- STORED PROCEDURES EXAMPLES
-- ################################################################

-- CREATE PROCEDURE sp_add_person(first_name VARCHAR, last_name VARCHAR,city_name VARCHAR)
--
-- AS
-- $$
--     BEGIN
--         INSERT INTO persons (first_name, last_name, city_id)
--         VALUES (first_name, last_name, some_func(param));
--
--     END;
-- $$
-- language plpgsql;
-- CALL sp_add_person('Bart','SimPSon', 'city_name param');

-- 2.
CREATE PROCEDURE sp_increase_salaries(department_name VARCHAR)
AS
    $$
        BEGIN
            UPDATE employees
            SET salary = salary + salary * 0.05
            WHERE department_id =
            (
                SELECT
                    d.department_id
                FROM employees AS e
                    JOIN departments AS d
                        USING (department_id)
                WHERE name = department_name
                GROUP BY d.department_id
        );
        end
    $$
LANGUAGE plpgsql;


-- 2.2


CREATE PROCEDURE sp_increase_salaries(department_name VARCHAR)
AS
    $$
        BEGIN
            UPDATE employees as e
            SET salary = salary + salary * 0.05
            WHERE department_id =
            (
                SELECT
                    e.department_id
                from departments
                WHERE name = department_name
        );
        end
    $$
LANGUAGE plpgsql;
call sp_increase_salaries('Marketing')



-- ########################################################################
-- TEST RAISE NOTICE

-- CREATE OR REPLACE FUNCTION fn_test_func(first_name VARCHAR,last_name VARCHAR)
-- RETURNS INT AS
--
-- $$
--     BEGIN
--         RAISE NOTICE 'My name is % % ',first_name,last_name;
--         RETURN NULL;
--     end;
-- $$
-- language plpgsql;
--
-- SELECT fn_test_func('Koko','Boko')

-- 3.
