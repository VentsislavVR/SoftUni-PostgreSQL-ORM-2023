-- 1.
SELECT
    t.town_id,
    t.name,
    a.address_text
FROM
    towns as t
join addresses as a
on
    t.town_id = a.town_id
WHERE t.name IN ('San Francisco','Sofia','Carnation')
ORDER BY t.town_id,a.address_id;

-- 2.
SELECT
    e.employee_id,
    concat(e.first_name,' ',e.last_name) as full_name,
    d.department_id,
    d.name as department_name
FROM employees as e join
    departments as d
    on e.employee_id = d.manager_id
ORDER BY employee_id
limit 5;

-- 3.
SELECT
    e.employee_id,
    concat(e.first_name,' ',e.last_name) AS full_name,
    p.project_id,
    p.name AS project_name
from employees AS e
    JOIN employees_projects AS ep
--         ON e.employee_id = ep.employee_id
            USING (employee_id)
                JOIN projects AS p
                    USING (project_id)
WHERE project_id = 1;
-- MANY TO MANY JOIN
-- EXAMPLES
--    1....
-- SELECT
-- sum(avarage_salary)
--    FROM (
--        SELECT AVG(salary) AS avarage_salary
--        FROM employees
--        GROUP BY country
--            ) as a
--
-- 2....
-- SELECT
-- first_name,
-- last_name,
--     salary
-- FROM
-- employees
-- WHERE salary > ( SELECT AVG(salary) FROM employees)
-- 3....
-- INSERT INTO person(first_name, last_name, city_id)
-- VALUES ('John',
--         'Doe',
--         (SELECT id FROM cities
--         WHERE name = 'Dobrich')
--         )
-- ;
-- 4............................................................
SELECT
    count(*)
FROM employees
WHERE salary > ( SELECT AVG(salary) FROM employees);

