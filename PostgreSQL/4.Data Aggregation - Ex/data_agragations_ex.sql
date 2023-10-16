-- 1.
SELECT
    COUNT(*)
from wizard_deposits;



-- 2.
SELECT
    SUM(deposit_amount) AS "Total Amount"
from wizard_deposits;

-- 3.
SELECT
    ROUND(AVG(magic_wand_size),3) AS "Average Magic Wand Size"
FROM wizard_deposits;

-- 4.
SELECT
    MIN(deposit_charge) AS "Minimum Deposit Charge"
FROM wizard_deposits;

-- 5.
SELECT
    MAX(age) AS "Maximum Age"
FROM wizard_deposits;

-- 6.
SELECT
    deposit_group,
    SUM(deposit_interest) AS "Deposit Interest"
FROM wizard_deposits
GROUP BY deposit_group
ORDER BY "Deposit Interest" DESC;

-- 7.
SELECT
    magic_wand_creator,
    MIN(magic_wand_size) AS "Minimum Wand Size"
FROM wizard_deposits
GROUP BY magic_wand_creator
ORDER BY "Minimum Wand Size"
LIMIT 5;


-- 8.
SELECT
    deposit_group,
    is_deposit_expired,
    FLOOR(AVG(deposit_interest))
FROM wizard_deposits
WHERE deposit_start_date > '1985-01-01'
GROUP BY deposit_group,is_deposit_expired
ORDER BY deposit_group DESC ,is_deposit_expired;


-- 9.
SELECT
    last_name,
    COUNT(notes) AS "Notes with Dumbledore"
FROM wizard_deposits
WHERE notes LIKE '%Dumbledore%'
GROUP BY last_name;

-- 10.
CREATE VIEW "view_wizard_deposits_with_expiration_date_before_1983_08_17" AS
SELECT
--   first_name || ' ' || last_name AS "Wizard Name"
    CONCAT(first_name,' ',last_name) AS "Wizard Name",
    deposit_start_date AS "Start Date",
    deposit_expiration_date AS "Expiration Date",
    deposit_amount AS "Amount"
FROM wizard_deposits
WHERE deposit_expiration_date <= '1983-08-17'
GROUP BY "Wizard Name","Start Date","Expiration Date","Amount"
ORDER BY "Expiration Date" ;
-- 10.1
-- CREATE VIEW "view_wizard_deposits_with_expiration_date_before_1983_08_17" AS
-- SELECT distinct
-- --   first_name || ' ' || last_name AS "Wizard Name"
--     CONCAT(first_name,' ',last_name) AS "Wizard Name",
--     deposit_start_date AS "Start Date",
--     deposit_expiration_date AS "Expiration Date",
--     deposit_amount AS "Amount"
-- FROM wizard_deposits
-- WHERE deposit_expiration_date <= '1983-08-17'
--
-- ORDER BY "Expiration Date" ;
-- 11.
SELECT
    magic_wand_creator,
    MAX(deposit_amount) as "Maximum Deposit Amount"

FROM wizard_deposits
GROUP BY magic_wand_creator
order by "Maximum Deposit Amount" desc
LIMIT 3;

-- 11.1
SELECT
    magic_wand_creator,
    MAX(deposit_amount) AS "Max Deposit Amount"
FROM
    wizard_deposits
GROUP BY
    magic_wand_creator
HAVING
    MAX(deposit_amount) NOT BETWEEN 20000 AND 40000
ORDER BY
    "Max Deposit Amount" DESC
LIMIT
    3;

-- 12.
SELECT
    CASE
        WHEN age BETWEEN 0 AND 10 THEN '[0-10]'
        WHEN age BETWEEN 11 AND 20 THEN '[11-20]'
        WHEN age BETWEEN 21 AND 30 THEN '[21-30]'
        WHEN age BETWEEN 31 AND 40 THEN '[31-40]'
        WHEN age BETWEEN 41 AND 50 THEN '[41-50]'
        WHEN age BETWEEN 51 AND 60 THEN '[51-60]'
        ELSE '[61+]'
    END AS "Age Group",
    COUNT(*) AS "Number of Wizards"
FROM
    wizard_deposits
GROUP BY
    "Age Group"
ORDER BY
    "Age Group";


