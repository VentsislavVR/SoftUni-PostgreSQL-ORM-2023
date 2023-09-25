-- 13.
SELECT
    SUM(CASE WHEN department_id = 1 THEN 1 ELSE 0 END) AS "Engineering",
    SUM(CASE WHEN department_id = 2 THEN 1 ELSE 0 END) AS "Tool Design",
    SUM(CASE WHEN department_id = 3 THEN 1 ELSE 0 END) AS "Sales",
    SUM(CASE WHEN department_id = 4 THEN 1 ELSE 0 END) AS "Marketing",
    SUM(CASE WHEN department_id = 5 THEN 1 ELSE 0 END) AS "Purchasing",
    SUM(CASE WHEN department_id = 6 THEN 1 ELSE 0 END) AS "Research and Development",
    SUM(CASE WHEN department_id = 7 THEN 1 ELSE 0 END) AS "Production"
FROM employees;

-- 14.
UPDATE employees
SET
    job_title = CASE
        WHEN hire_date < '2015-01-16' THEN 'Senior ' || job_title
        WHEN hire_date < '2020-03-04' THEN 'Mid-' || job_title
        ELSE job_title
    END,
    salary = CASE
        WHEN hire_date < '2015-01-16' THEN salary + 2500
        WHEN hire_date < '2020-03-04' THEN salary + 1500
        ELSE salary
    END;

-- 15
SELECT
    job_title,
    CASE
        WHEN AVG(salary) > 45800 THEN 'Good'
        WHEN AVG(salary) BETWEEN 27500 AND 45800 THEN 'Medium'
        WHEN AVG(salary) < 27500 THEN 'Need Improvement'
    END AS "Category"
FROM employees
GROUP BY job_title
ORDER BY "Category",job_title;


-- 16.

SELECT
    project_name,
    CASE
        WHEN start_date IS NULL AND end_date IS NULL THEN 'Ready for development'
        WHEN start_date IS NOT NULL AND end_date IS NULL THEN 'In Progress'
        ELSE 'Done'
    END AS project_status
FROM
    projects
WHERE
    project_name LIKE '%Mountain%';

-- 17.
SELECT
    department_id,
    count(first_name) as num_employees,
    case
    when avg(salary) > 50000 THEN 'Above average'
    when avg(salary) <= 50000 THEN 'Below average'
    end as salary_level
from employees
GROUP BY department_id
HAVING  avg(salary) > 30000
order by department_id;


-- 18.
CREATE VIEW "view_performance_rating"
AS
SELECT
    first_name,
    last_name,
    job_title,
    salary,
    department_id,
    CASE
    WHEN salary > 25000 and job_title like 'Senior%' THEN 'High-performing Senior'
    WHEN salary >= 25000 and job_title NOT like 'Senior' THEN 'High-performing Employee'
    else 'Average-performing'
    END AS performance_rating
FROM
    employees;

-- 19.
CREATE TABLE employees_projects (
    id serial PRIMARY KEY,
    employee_id INT,
    project_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(id),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);
-- 19.1
-- CREATE TABLE employees_projects (
--     id serial PRIMARY KEY,
--     employee_id INT REFERENCES employees,
--     project_id INT REFERENCES projects
-- );

-- 20.
SELECT *
FROM departments
JOIN employees ON departments.id = employees.department_id;

