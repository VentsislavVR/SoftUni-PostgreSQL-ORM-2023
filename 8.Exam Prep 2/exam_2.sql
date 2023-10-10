CREATE TABLE addresses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
	id SERIAL PRIMARY KEY,
	name VARCHAR(10) NOT NULL
);

CREATE TABLE clients (
	id SERIAL PRIMARY KEY,
	full_name VARCHAR(50) NOT NULL,
	phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	age INT NOT NULL,
	rating NUMERIC(3, 2) DEFAULT 5.5,

	CONSTRAINT ck_drivers_age
		CHECK (age > 0)
);

CREATE TABLE cars (
	id SERIAL PRIMARY KEY,
	make VARCHAR(20) NOT NULL,
	model VARCHAR(20),
	year INT NOT NULL DEFAULT 0,
	mileage INT DEFAULT 0,
	condition CHAR(1) NOT NULL,
	category_id INT NOT NULL,

	CONSTRAINT ck_cars_year
		CHECK (year > 0),
	CONSTRAINT ck_cars_mileage
		CHECK (mileage > 0),
	CONSTRAINT fk_cars_categories
		FOREIGN KEY (category_id)
		REFERENCES categories(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE courses (
	id SERIAL PRIMARY KEY,
	from_address_id INT NOT NULL,
	start TIMESTAMP NOT NULL,
	bill NUMERIC(10, 2) DEFAULT 10,
	car_id INT NOT NULL,
	client_id INT NOT NULL,

	CONSTRAINT ck_courses_bill
		CHECK (bill > 0),
	CONSTRAINT fk_courses_addresses
		FOREIGN KEY (from_address_id)
		REFERENCES addresses(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT fk_courses_cars
		FOREIGN KEY (car_id)
		REFERENCES cars(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT fk_courses_clients
		FOREIGN KEY (client_id)
		REFERENCES clients(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE cars_drivers (
	car_id INT NOT NULL,
	driver_id INT NOT NULL,

	CONSTRAINT fk_cars_drivers_cars
		FOREIGN KEY (car_id)
		REFERENCES cars(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	CONSTRAINT fk_cars_drivers_drivers
		FOREIGN KEY (driver_id)
		REFERENCES drivers(id)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

-- 2.
INSERT INTO
    clients(full_name,phone_number)
    SELECT first_name || ' ' || last_name,
           '(088) 9999'|| drivers.id * 2

    FROM drivers
    WHERE drivers.id BETWEEN 10 AND 20;

-- 3.

UPDATE cars
SET condition ='C'
WHERE (mileage >= 800000 OR mileage IS NULL)
            AND
    year <= 2010
            AND
    make <> 'Mercedes-Benz';

-- 4.
DELETE FROM
           clients
       WHERE
           LENGTH (full_name) > 3
                AND
            id NOT IN (SELECT client_id FROM courses);
-- 5.

SELECT
    make,
    model,
    condition
FROM cars
ORDER BY id;

-- 6.
SELECT
    d.first_name,
    d.last_name,
    c.make,
    c.model,
    c.mileage
FROM drivers d
JOIN
    cars_drivers cd
    ON cd.driver_id = d.id
JOIN
    cars c
    ON c.id = cd.car_id
WHERE c.mileage IS NOT NULL
ORDER BY mileage DESC,first_name;

-- 7.
SELECT
    c.id as car_id,
    c.make,
    c.mileage,
    count(co.id) AS count_of_courses,
    ROUND(avg(bill),2) AS avrage_bill
FROM cars AS c
    LEFT JOIN
            courses AS co
                ON co.car_id = c.id
GROUP BY c.id
HAVING count(co.id) <> 2
ORDER BY count_of_courses desc , c.id;

-- 8.
SELECT
    full_name,
    COUNT(c.car_id) as count_of_cars,
    SUM(c.bill) AS total_sum

FROM clients

    JOIN courses c
        on clients.id = c.client_id
WHERE SUBSTRING(full_name, 2, 1) = 'a'
-- like '_a%'
GROUP BY full_name
HAVING COUNT(c.car_id) > 1
ORDER BY full_name;

-- 9.
SELECT
    a.name as address,
     CASE
        WHEN EXTRACT(HOUR FROM co.start) BETWEEN 6 AND 20 THEN 'Day'
        ELSE 'Night'
    END AS day_time,
    co.bill,
    c3.full_name,
    c.make,
    c.model,
    c2.name as category_name
FROM
    courses as co
    JOIN addresses a
        ON a.id = co.from_address_id
    JOIN cars c ON
        co.car_id = c.id
    JOIN categories c2
        ON c.category_id = c2.id
        JOIN clients c3 ON co.client_id = c3.id
ORDER BY co.id;

-- 10.

CREATE OR REPLACE FUNCTION fn_courses_by_client(
        phone_num VARCHAR(20)
                ) RETURNS INT AS
$$
    BEGIN
        RETURN ( SELECT
                    count(*) AS count
                FROM clients
                    JOIN courses c
                        ON clients.id = c.client_id
                    WHERE clients.phone_number = phone_num);
    end;
$$
LANGUAGE plpgsql;

SELECT fn_courses_by_client('(803) 6386812');
SELECT fn_courses_by_client('(831) 1391236');
SELECT fn_courses_by_client('(704) 2502909');

-- 10.1 IN OUT

CREATE OR REPLACE FUNCTION fn_courses_by_client(
        IN phone_num VARCHAR(20),
        OUT num_of_courses INT
) RETURNS INT AS
$$
    BEGIN
        num_of_courses := (
                SELECT
                    count(*)
                FROM
                    clients
                JOIN
                    courses c
                ON
                    clients.id = c.client_id
                 WHERE clients.phone_number = phone_num
                 );
    end;
$$
LANGUAGE plpgsql;


CREATE TABLE search_results ( id SERIAL PRIMARY KEY
                            , address_name VARCHAR(50)
                            , full_name VARCHAR(100),
                             level_of_bill VARCHAR(20),
                              make VARCHAR(30),
                              condition CHAR(1),
                              category_name VARCHAR(50) );
CREATE OR REPLACE PROCEDURE sp_courses_by_address(
        IN address_name VARCHAR(100)
) AS
$$
    BEGIN
        TRUNCATE search_results;

        INSERT INTO
            search_results(
                    address_name ,
                    full_name ,
                    level_of_bill ,
                    make ,
                    condition ,
                    category_name
        )
            SELECT
                a.name,
                cl.full_name,
                 CASE
                    WHEN c.bill <= 20 THEN 'Low'
                    WHEN c.bill <= 30 THEN 'Medium'
                    ELSE 'High'
                END AS level_of_bill,
                car.make,
                car.condition,
                c2.name
            FROM
                addresses AS a
            JOIN
                courses c
            ON
                a.id = c.from_address_id
            JOIN
                clients cl
            ON
                c.client_id = cl.id
            JOIN
                cars as car
            ON
                    c.car_id = car.id
            JOIN
                categories c2
            ON
                car.category_id = c2.id
        WHERE a.name = address_name
        ORDER BY CAR.make,cl.full_name;
    end;
$$
language plpgsql;



