-- 1.
SELECT
    department_id,
    count(department_id)
FROM
   employees
GROUP BY department_id
ORDER BY department_id;

-- 2.
SELECT
    department_id,
    count(salary) AS employee_count
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 3.
SELECT
    department_id,
    sum(salary) AS total_salaries
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 4.
SELECT
    department_id,
    max(salary) AS max_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 5.
SELECT
    department_id,
    min(salary) AS min_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 6.

SELECT
    department_id,
    AVG(salary) AS avrage_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- 7.

SELECT
    department_id,
    sum(salary) AS "Total Salary"
from employees
group by department_id
HAVING sum(salary) < 4200
order by department_id;

-- 8.
-- SELECT
--     id,
--     first_name,
--     last_name,
--     trunc(salary,2),
--     department_id,
--     CASE
--     WHEN department_id = 1 THEN 'Management'
--     WHEN department_id = 2 THEN 'Kitchen Staff'
--     WHEN department_id = 3 THEN 'Service Staff'
--     ELSE 'Other'
--     END AS department_name
-- FROM employees;

SELECT
    id,
    first_name,
    last_name,
    trunc(salary,2),
    department_id,
    CASE department_id
    WHEN 1 THEN 'Management'
    WHEN 2 THEN 'Kitchen Staff'
    WHEN 3 THEN 'Service Staff'
    ELSE 'Other'
    END AS department_name
FROM employees;
