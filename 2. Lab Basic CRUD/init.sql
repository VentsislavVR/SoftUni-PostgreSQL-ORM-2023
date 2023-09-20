-- 1.
SELECT  * FROM cities
ORDER BY ID;

-- 2.
SELECT
    CONCAT(name,' ', state) AS "Cities Information",
          area as "Area (km2)"
FROM cities
ORDER BY ID;

-- 3.
SELECT
    DISTINCT name,
          area as "Area (km2)"
FROM cities
ORDER BY name DESC;

-- 4.
SELECT
    id AS "ID",
    concat(first_name,' ',last_name) AS "Full Name",
        job_title AS "Job Title"
FROM employees
ORDER BY first_name
LIMIT 50;

-- 5.
SELECT
    id ,
    concat(first_name,' ', middle_name,' ' ,last_name) AS "Full Name",
        hire_date AS "Hire Date"
FROM employees
ORDER BY hire_date
OFFSET 9;

-- 6.
SELECT
    id ,
    concat(number,' ',street) AS "Address",
        city_id
FROM addresses
WHERE id >= 20;

-- 7.
SELECT
    concat(number,' ',street) AS "Address",
    city_id

FROM addresses
WHERE city_id %2 = 0
ORDER BY city_id;

-- 8.
SELECT
    name,start_date,end_date
FROM projects
WHERE
    start_date >= '2016-06-01 07:00:00'
AND
    end_date < '2023-06-04 00:00:00'
ORDER BY  start_date;

-- 9.
SELECT
    number,
    street
FROM
    addresses
WHERE
    (id BETWEEN 50 AND 100) OR (number < 1000);

-- 10.
SELECT
    employee_id,
    project_id
FROM
    employees_projects
WHERE
    employee_id IN (200,250)
AND
    project_id NOT IN (50,100);

-- 11.
SELECT
    name,
    start_date
FROM
    projects
WHERE
    name in ('Mountain', 'Road','Touring')
LIMIT 20;

-- 12.
SELECT
    concat(first_name,' ',last_name) as "Full Name",
    job_title,
    salary
FROM
    employees
WHERE salary IN (12500, 14000, 23600,25000)
ORDER BY salary DESC;

-- 13.
SELECT
    id,
    first_name,
    last_name

FROM
    employees
WHERE middle_name is null
limit 3;

-- 14.
INSERT into
        departments (department, manager_id)
VALUES
        ('Finance', 3),
        ('Information Services', 42),
        ('Document Control', 90),
        ('Quality Assurance', 274),
        ('Facilities and Maintenance', 218),
        ('Shipping and Receiving', 85),
        ('Executive', 109)
RETURNING *;

-- 15.
CREATE TABLE company_chart
AS
SELECT
    concat(first_name,' ',last_name) as "Full Name",
    job_title as "Job Title",
    department_id as "Department ID",
    manager_id as "Manager ID"
FROM employees;
-- 16...

UPDATE projects
SET
    end_date = start_date + INTERVAL '5 months'
WHERE end_date IS NULL;
-- 16.
UPDATE employees
SET salary = salary + 1500,
    job_title = CONCAT('Senior ', job_title)
WHERE hire_date >= 'January 1, 1998' AND hire_date <= 'January 5, 2000';
select first_name,job_title,salary
from employees;

-- 17.
UPDATE employees
SET salary = salary + 1500,
    job_title = CONCAT('Senior ', job_title)
WHERE hire_date >= '1998-01-01' AND hire_date <= '2000-01-05';

SELECT *
FROM employees
WHERE hire_date >= '1998-01-01' AND hire_date <= '2000-01-05';

-- 18.
DELETE FROM
    addresses
WHERE
    city_id IN (5, 17, 20, 30);

-- 19.
CREATE VIEW
    view_company_chart
AS
SELECT
	"Full Name",
	 "Job Title"
FROM
	company_chart
WHERE
    "Manager ID"=184;
SELECT * FROM view_company_chart;


-- 20. not correct
CREATE VIEW view_addresses
AS
SELECT
	concat(first_name,' ',last_name) AS "Full Name",
	department_id,
    concat(number,' ',street) as "Address"
FROM
	employees,addresses
WHERE employees.address_id = addresses.id
ORDER BY "Address";
SELECT * FROM view_addresses;

-- 20 !!! proper way
CREATE VIEW
    view_addresses
as

SELECT
    e.first_name || ' ' || e.last_name AS "Full Name",
    e.department_id,
    a.number||' '||a.street AS "Adress"

FROM
    employees AS e
JOIN addresses AS a
        ON
    e.address_id = a.id
    ORDER BY
        "Adress";

-- 21.
ALTER VIEW
    view_addresses
RENAME TO
    view_employee_addresses_info;

-- 22.
DROP VIEW view_company_chart;

-- 23.*
UPDATE
    projects
SET
    name = UPPER(name);

-- 24.*
CREATE VIEW
    view_initials
AS
SELECT
    "left"(first_name,2) AS "initial",
     last_name

FROM employees
ORDER BY last_name;

-- 24***
CREATE VIEW
    view_initials
AS
SELECT
    SUBSTRING(first_name,1,2) as initial,
     last_name
FROM
 employees
ORDER BY
 last_name;

-- 25.*
SELECT
    name,
    start_date
FROM projects
WHERE name LIKE 'MOUNT%'
ORDER BY id;



