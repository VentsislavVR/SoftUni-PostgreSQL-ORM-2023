-- 1.
CREATE TABLE products
(
    product_name VARCHAR(100)
);
INSERT INTO products (product_name)
VALUES ('Broccoli'),
       ('Shampoo'),
       ('Toothpaste'),
       ('Candy');
ALTER TABLE products
    ADD COLUMN id SERIAL PRIMARY KEY;
--


-- 2.
-- ALTER TABLE products
-- DROP CONSTRAINT products_pkey;
-- SELECT * FROM products;

-- 3.
CREATE TABLE passports
(
    id INT GENERATED BY DEFAULT AS IDENTITY (START WITH 100 INCREMENT BY 1) PRIMARY KEY,
    nationality VARCHAR(50)
);
INSERT INTO passports(nationality)
VALUES ('N34FG21B'),
       ('K65LO4R7'),
       ('ZE657QP2');


CREATE TABLE people
(
    id          SERIAL PRIMARY KEY,
    first_name  VARCHAR(50),
    salary      numeric(10, 2),
    passport_id INT,
    CONSTRAINT fk_people_passports
        FOREIGN KEY (passport_id)
            REFERENCES passports (id)
);
INSERT into people(first_name, salary, passport_id)
VALUES ('Roberto', 43300.0000, 101),
       ('Tom', 56100.0000, 102),
       ('Yana', 60200.0000, 100);
SELECT *
FROM people;

-- 4.

CREATE TABLE manufacturers
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE models
(
    id INT GENERATED ALWAYS AS IDENTITY (START WITH 1000 INCREMENT BY 1) PRIMARY KEY,
    name            VARCHAR(50),
    manufacturer_id INT,
    CONSTRAINT fk_model_manufacturers
        FOREIGN KEY (manufacturer_id)
            REFERENCES manufacturers(id)

);
CREATE TABLE production_years
(
    established_on  DATE,
    manufacturer_id INT,
    CONSTRAINT fk_production_year_manufacturers
        FOREIGN KEY (manufacturer_id)
            REFERENCES manufacturers(id)
);
INSERT INTO manufacturers (name)
VALUES ('BMW'),
       ('Tesla'),
       ('Lada');

INSERT INTO models (model_name, manufacturer_id)
VALUES ('X11', 1),
       ('i6', 1),
       ('Model S', 2),
       ('Model X', 2),
       ('Model 3', 2),
       ('Nova', 3);

INSERT INTO production_years (established_on, manufacturer_id)
VALUES ('1916-03-01', 1),
       ('2003-01-01', 1),
       ('1966-05-01', 3);


-- 5....

-- 6.
CREATE TABLE customers
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50),
    date DATE
);

CREATE TABLE photos
(
    id    SERIAL PRIMARY KEY,
    url         VARCHAR(255),
    place       VARCHAR(100),
    customer_id INT,
    constraint fk_photos_customers
        foreign key (customer_id)
            REFERENCES customers (id) ON DELETE CASCADE
);
INSERT INTO customers(name, date)
VALUES ('Bella', '2022-03-25'),
       ('Philip', ' 2022-07-05');
INSERT INTO photos(url, place)
VALUES ('bella_1111.com', 'National Theatre'),
       ('bella_1112.com', 'Largo'),
       ('bella_1113.com', 'The View Restaurant'),
       ('philip_1121.com', ' Old Town'),
       ('philip_1122.com', 'Rowing Canal'),
       ('philip_1123.com', 'Roman Theater');

SELECT *
FROM customers;
SELECT *
FROM photos;

-- 7.

CREATE TABLE students
(
    id   SERIAL PRIMARY KEY,
    student_name VARCHAR(50)
);
CREATE TABLE exams
(
    id   INT GENERATED ALWAYS AS IDENTITY (START WITH 101 INCREMENT BY 1) PRIMARY KEY,
    exam_name VARCHAR(50)
);

CREATE TABLE study_halls
(
    id   SERIAL PRIMARY KEY,
    study_hall_name VARCHAR(50),
    exam_id INT,
     CONSTRAINT fk_students_halls_exams
        FOREIGN KEY (exam_id)
            REFERENCES exams (id) ON DELETE CASCADE
);

CREATE TABLE students_exams (
    student_id INT ,
    exam_id INT ,
    CONSTRAINT fk_students_exams_students
        FOREIGN KEY (student_id)
            REFERENCES students (id) ON DELETE CASCADE,
    CONSTRAINT fk_students_exams_exams
        FOREIGN KEY (exam_id)
             REFERENCES exams (id) ON DELETE CASCADE
);

INSERT INTO students(student_name)
VALUES ('Mila'),
       ('Toni'),
       ('Ron');

INSERT INTO exams(exam_name)
VALUES ('Python Advanced'),
       ('Python OOP'),
       ('PostgreSQL');

INSERT INTO study_halls(study_hall_name, exam_id)
VALUES ('Open Source Hall', 102),
       ('Inspiration Hall ', 101),
       ('Creative Hall', 103),
       ('Masterclass Hall', 103),
       ('Information Security Hall', 103);
insert into students_exams(student_id,exam_id)
VALUES (1 ,101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);

SELECT *
FROM students_exams



-- 8.

-- 9.

-- 10.

-- 11.

-- 12.

-- 13.


-- 14.

-- 15.

