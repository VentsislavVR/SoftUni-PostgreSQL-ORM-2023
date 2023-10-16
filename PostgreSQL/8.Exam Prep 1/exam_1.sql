-- 1.
DROP TABLE IF EXISTS owners CASCADE;
CREATE TABLE owners(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    address VARCHAR(50)
);
--             - stores information about the owners of the animals;

DROP TABLE IF EXISTS animal_types CASCADE ;
CREATE TABLE animal_types(
    id SERIAL PRIMARY KEY,
    animal_type VARCHAR(30) NOT NULL
);
--             - hold data about the different types of animals in the zoo;

DROP TABLE IF EXISTS cages CASCADE ;
CREATE TABLE cages(
    id SERIAL PRIMARY KEY,
    animal_type_id INT NOT NULL

);
--             - stores information about the animal cages;

DROP TABLE IF EXISTS animals CASCADE ;
CREATE TABLE animals(
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    birthdate DATE NOT NULL,
    owner_id INT ,
    animal_type_id INT NOT NULL
);
--             - contain information about the animals;

DROP TABLE IF EXISTS volunteers_departments CASCADE ;
CREATE TABLE volunteers_departments(
    id SERIAL PRIMARY KEY,
    department_name VARCHAR(30) NOT NULL
);
--             - hold data about the departments of the volunteers;

DROP TABLE IF EXISTS volunteers CASCADE ;
CREATE TABLE volunteers(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    address VARCHAR(50),
    animal_id INT,
    department_id INT NOT NULL
);
--             - contain information about the volunteers in the zoo;

DROP TABLE IF EXISTS animals_cages CASCADE;
CREATE TABLE animals_cages(
    cage_id INT NOT NULL,
    animal_id INT NOT NULL
);

ALTER TABLE cages
    ADD CONSTRAINT fk_cages_animal_types
       FOREIGN KEY (animal_type_id)
         REFERENCES animal_types(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
;

ALTER TABLE animals
ADD CONSTRAINT fk_animals_owners
      FOREIGN KEY (owner_id)
        REFERENCES owners(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,


ADD CONSTRAINT fk_animals_animal_types
      FOREIGN KEY (animal_type_id)
        REFERENCES animal_types(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
;

ALTER TABLE volunteers
ADD CONSTRAINT fk_volunteers_animals
    FOREIGN KEY (animal_id)
        REFERENCES animals(id)
            ON DELETE CASCADE
        ON UPDATE CASCADE
    ,
ADD CONSTRAINT fk_volunteers_volunteers_departments
    FOREIGN KEY (department_id)
        REFERENCES volunteers_departments(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
;

ALTER TABLE animals_cages
ADD CONSTRAINT fk_animals_cages_cages
    FOREIGN KEY (cage_id)
        REFERENCES cages(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
ADD CONSTRAINT fk_animals_cages_animals
    FOREIGN KEY (animal_id)
        REFERENCES animals(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
;
-- 2.
INSERT INTO volunteers(name, phone_number, address, animal_id, department_id)
VALUES
    ('Anita Kostova','0896365412','Sofia, 5 Rosa str.' ,15 ,1),
    ('Dimitur Stoev', '0877564223' ,NULL, 42, 4),
    ('Kalina Evtimova','0896321112', 'Silistra, 21 Breza str.' ,9 ,7),
    ('Stoyan Tomov', '0898564100' ,'Montana, 1 Bor str.', 18, 8),
    ('Boryana Mileva', '0888112233', NULL, 31, 5);

INSERT INTO animals(name, birthdate, owner_id, animal_type_id)
VALUES
    ('Giraffe', '2018-09-21', 21, 1),
    ('Harpy Eagle', '2015-04-17', 15, 3),
    ('Hamadryas Baboon', '2017-11-02', NULL ,1),
    ('Tuatara' ,'2021-06-30', 2, 4);
-- 3.

UPDATE animals
SET owner_id = (SELECT ID FROM owners WHERE name = 'Kaloqn Stoqnov')
WHERE owner_id IS NULL;

-- 4.
-- SELECT id FROM volunteers_departments
-- WHERE department_name = 'Education program assistant';
--
-- DELETE FROM volunteers_departments
-- WHERE department_name = 'Education program assistant';

-- 4.4
DELETE FROM volunteers_departments
WHERE id = ( SELECT id FROM
            volunteers_departments
            WHERE department_name = 'Education program assistant');
-- 5.
SELECT
    name,
    phone_number,
    address,
    animal_id,
    department_id
FROM volunteers
ORDER BY name,animal_id DESC,department_id;

-- 6.
SELECT
    a.name,
    at.animal_type,
    to_char(birthdate,'DD.MM.YYYY')
FROM animals a
JOIN animal_types at on a.animal_type_id = at.id
ORDER BY name;

-- 7.
SELECT
    owners.name AS owner ,
    count(*) AS count_of_animals
FROM owners
join animals a ON owners.id = a.owner_id
GROUP BY owner_id,owners.name
ORDER BY count_of_animals DESC,owners.name
LIMIT 5;
-- 7.1
-- SELECT
--     o.name AS owner ,
--     count(owner_id) AS count_of_animals
-- FROM owners as o
-- join animals a ON o.id = a.owner_id
-- GROUP BY o.name
-- ORDER BY count_of_animals DESC,o.name
-- LIMIT 5

-- 8.
SELECT
    concat(o.name, ' - ',a.name) AS "Owners-Animals",
    o.phone_number as "Phone number",
    ac.cage_id as "Cage ID"
FROM owners AS o
JOIN animals AS a
    ON o.id = a.owner_id
       JOIN animals_cages AS ac
        on ac.animal_id = a.id
         JOIN animal_types t on
            a.animal_type_id = t.id
where t.animal_type = 'Mammals'
ORDER BY o.name,a.name DESC;

-- 9.
SELECT
    name as volunteers,
    phone_number,
    substring(trim(replace(address,'Sofia','')),2)
FROM volunteers
JOIN volunteers_departments vd
    on volunteers.department_id = vd.id
WHERE address LIKE '%Sofia%'
AND vd.department_name = 'Education program assistant'
ORDER BY name;

-- 10. works
SELECT
    a.name,
    to_char(a.birthdate,'yyyy') AS birth_year,
    at.animal_type
FROM animals as a
JOIN animal_types at
    on a.animal_type_id = at.id
WHERE owner_id is null
  AND age('2022-01-01'::date, a.birthdate) < interval '5 years'
and at.animal_type <> 'Birds'
ORDER BY a.name;
-- 10.1 also works
SELECT
    a.name,
    extract('year'from a.birthdate),
    t.animal_type
FROM animals a
    left join  owners o
        on a.owner_id = o.id
        join animal_types t
            on a.animal_type_id = t.id
WHERE a.owner_id IS NULL
AND t.animal_type <> 'Birds'
and age('01/01/2022',a.birthdate) < '5 years'
order by a.name;

-- 11.
CREATE OR REPLACE FUNCTION fn_get_volunteers_count_from_department(
        searched_volunteers_department varchar(30)
) returns INT AS
$$
    BEGIN
    RETURN (SELECT
         count(*)
            FROM volunteers_departments
            JOIN volunteers v on
        volunteers_departments.id = v.department_id
            where
            volunteers_departments.department_name = searched_volunteers_department);
    END;
$$
    LANGUAGE plpgsql;


SELECT fn_get_volunteers_count_from_department('Education program assistant');

SELECT fn_get_volunteers_count_from_department('Guest engagement');
SELECT fn_get_volunteers_count_from_department('Zoo events');

-- 12.
CREATE OR REPLACE PROCEDURE sp_animals_with_owners_or_not(
            IN animal_name VARCHAR(30),
            OUT o_name VARCHAR(30))
as
$$
    BEGIN
        SELECT
            o.name
            FROM owners o
                    LEFT JOIN animals a
                    ON a.owner_id = o.id
            WHERE a.name = animal_name
        INTO o_name;
        if o_name IS NULL then
        o_name:= 'For adoption';
        END IF;
        RETURN;
    END;
$$
    LANGUAGE plpgsql;

-- 12.1
CREATE OR REPLACE PROCEDURE sp_animals_with_owners_or_not(
            IN animal_name VARCHAR(30),
            OUT o_name VARCHAR(30))
as
$$
    BEGIN
        SELECT
            coalesce(o.name,'For adoption')
            FROM owners o
                    LEFT JOIN animals a
                    ON a.owner_id = o.id
            WHERE a.name = animal_name
        INTO o_name;
        RETURN;
    END;
$$
    LANGUAGE plpgsql;

CALL sp_animals_with_owners_or_not('Pumpkinseed Sunfish');

CALL sp_animals_with_owners_or_not('Hippo');

CALL sp_animals_with_owners_or_not('Brown bear');