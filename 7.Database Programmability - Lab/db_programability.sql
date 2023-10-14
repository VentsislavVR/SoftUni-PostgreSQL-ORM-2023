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
--         SELECT id(INTO city_id //<-can be placed here//) FROM cities
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
call sp_increase_salaries('Marketing');



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

-- ################################################################
-- TRANSACTIONS EXAMPLE bank table

CREATE OR REPLACE PROCEDURE p_transfer_money(
        IN sender_id INT,
        IN receiver_id INT,
        IN transfer_amount FLOAT,
        OUT status VARCHAR
)
    AS
    $$
    DECLARE
        sender_amount FLOAT;
        receiver_amount FLOAT;
        temp_val FLOAT;
    BEGIN
    SELECT b.amount FROM bank as b WHERE id = sender_id INTO sender_amount;
    IF sender_amount < transfer_amount THEN
        status := 'Not enough money';
        RETURN ;
    end if;
    SELECT b.amount FROM bank as b WHERE id =  receiver_id INTO receiver_amount;
    UPDATE bank SET amount = amount -transfer_amount WHERE id = sender_id;
    UPDATE bank SET amount = amount + transfer_amount WHERE id = receiver_id;
    SELECT b.amount FROM bank as b WHERE id = sender_id INTO temp_val;
    IF sender_amount - transfer_amount <> temp_val THEN
        status = 'Error in sender';
        ROLLBACK;
        RETURN;
    END IF;
    SELECT b.amount FROM bank as b WHERE id = receiver_id INTO temp_val;
    IF receiver_amount + transfer_amount <> temp_val THEN
        status = 'Error in receiver';
        ROLLBACK;
        RETURN;

    end if;
    status = 'Success'
    commit;
    return;
    end;
    $$
LANGUAGE plpgsql;

SELECT * FROM bank;

call p_transfer_money(1,2,300,null);

-- 3.
CREATE PROCEDURE sp_increase_salary_by_id(id INT)
AS
$$
    BEGIN
        IF (SELECT salary FROM employees WHERE employee_id = id) IS NULL THEN
            RETURN;
        ELSE
            UPDATE employees SET salary = salary +salary * 0.05 WHERE employee_id = id;
        END IF;
        COMMIT;

    END
$$
LANGUAGE plpgsql;


-- ####

-- TRIGGERS EXAMPLE items/items_log tables

CREATE OR REPLACE FUNCTION log_items()
RETURNS TRIGGER AS
$$
    BEGIN
        INSERT INTO items_log(status,create_date)
        VALUES(NEW.status,NEW.create_date);
        RETURN NEW;
    END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER log_items_trigger
AFTER INSERT ON items
FOR EACH ROW
EXECUTE PROCEDURE log_items();

INSERT INTO items(status, create_date)
VALUES(1,NOW()),
      (2,NOW()),
      (3,NOW()),
      (3,NOW())
;
SELECT * FROM items;

-- ################################################################
CREATE OR REPLACE FUNCTION delete_last_item_log()
RETURNS TRIGGER AS
$$
    BEGIN
        WHILE (SELECT count(*) FROM items_log) > 10 LOOP
            delete from items_log WHERE id=(SELECT MIN(id) FROM items_log);
        END LOOP;
        return new;
    end;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER clear_item_log
AFTER INSERT ON items_log
FOR EACH STATEMENT
EXECUTE PROCEDURE delete_last_item_log();


SELECT * FROM items_log;

-- 4.
CREATE TABLE deleted_employees(
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    middle_name VARCHAR(20),
    job_title VARCHAR(50),
    department_id INT,
    salary numeric(19,4)

);
CREATE OR REPLACE FUNCTION backup_fired_employees()
RETURNS TRIGGER AS
    $$
        BEGIN
            INSERT INTO deleted_employees(
                first_name,
                last_name,
                middle_name,
                job_title,
                department_id,
                salary

            )
            VALUES (
                    old.first_name,
                    old.last_name,
                    old.middle_name,
                    old.job_title,
                    old.department_id,
                    old.salary
                   );
            RETURN new;
        end;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER backup_employees
AFTER DELETE ON employees
FOR EACH ROW
EXECUTE PROCEDURE backup_fired_employees();