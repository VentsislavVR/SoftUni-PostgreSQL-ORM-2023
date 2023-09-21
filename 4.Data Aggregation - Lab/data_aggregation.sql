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
    AVG(salary) AS avrage_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;
-- 6.


-- 7.

-- 8.