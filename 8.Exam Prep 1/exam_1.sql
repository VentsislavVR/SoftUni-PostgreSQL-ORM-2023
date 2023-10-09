-- 1.
DROP TABLE IF EXISTS owners;
CREATE TABLE owners(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    address VARCHAR(50)
);
--             - stores information about the owners of the animals;

DROP TABLE IF EXISTS animal_types;
CREATE TABLE animal_types(
    id SERIAL PRIMARY KEY,
    animal_type VARCHAR(30) NOT NULL
);
--             - hold data about the different types of animals in the zoo;

DROP TABLE IF EXISTS cages;
CREATE TABLE cages(
    id SERIAL PRIMARY KEY,
    animal_type_id INT NOT NULL

);
--             - stores information about the animal cages;


DROP TABLE IF EXISTS animals;
CREATE TABLE animals(
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    birthdate DATE NOT NULL,
    owner_id INT ,
    animal_type_id INT NOT NULL
);
--             - contain information about the animals;



DROP TABLE IF EXISTS volunteers_departments;
CREATE TABLE volunteers_departments();
--             - hold data about the departments of the volunteers;


DROP TABLE IF EXISTS volunteers;
CREATE TABLE volunteers();
--             - contain information about the volunteers in the zoo;


DROP TABLE IF EXISTS animals_cages;
CREATE TABLE animals_cages();
-- 2.
-- 3.
-- 4.
-- 5.