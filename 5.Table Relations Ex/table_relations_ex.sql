-- 1.
CREATE TABLE products (
    product_name VARCHAR(100)
);
INSERT INTO products (product_name)
VALUES ('Broccoli'), ('Shampoo'), ('Toothpaste'), ('Candy');
ALTER TABLE products
ADD COLUMN product_id SERIAL PRIMARY KEY;
--


-- 2.
-- ALTER TABLE products
-- DROP CONSTRAINT products_pkey;
-- SELECT * FROM products;

-- 3.
-- CREATE TABLE passports (
--     passport_id INT GENERATED ALWAYS AS IDENTITY (START WITH 100 INCREMENT BY 1) PRIMARY KEY,
--     nationality VARCHAR(100)
-- );
-- INSERT INTO passports(nationality)
-- VALUES ('N34FG21B'), ('K65LO4R7'), ('ZE657QP2');
--
-- CREATE TABLE people (
--     id SERIAL PRIMARY KEY,
--     first_name VARCHAR(50),
--     salary numeric(10,2),
--     passport_id INT CONSTRAINT fk_people_passports REFERENCES passports(passport_id)
-- );
-- INSERT into people(first_name,salary,passport_id)
-- VALUES ('Roberto', 43300.0000, 101),('Tom', 56100.0000, 102),('Yana', 60200.0000, 100);
-- SELECT * FROM people

-- 4.
--
-- CREATE TABLE manufacturers(
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(50)
-- ) ;
-- CREATE TABLE models(
--     model_name VARCHAR(50),
--     manufacturer_id INT,
--     CONSTRAINT fk_model_manufacturers
--                    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)
--
-- );
-- CREATE TABLE production_years(
--     established_on DATE,
--     manufacturer_id INT,
--         CONSTRAINT fk_production_year_manufacturers
--             FOREIGN KEY (manufacturer_id)
--         REFERENCES  manufacturers(id)
-- );
-- INSERT INTO manufacturers (name) VALUES ('BMW') ,('Tesla'),('Lada');
-- INSERT INTO models (model_name) VALUES ('X11') ,('i6'),('Model S') ,('Model X'),('Model 3'),('Nova');
-- INSERT INTO production_years(established_on) VALUES ('1916-03-01'), ('2003-01-01'), ('1966-05-01');
-- SELECT * FROM manufacturers;


CREATE TABLE manufacturers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE models (
    model_name VARCHAR(50),
    manufacturer_id INT,
    CONSTRAINT fk_model_manufacturers
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)
);

CREATE TABLE production_years (
    established_on DATE,
    manufacturer_id INT,
    CONSTRAINT fk_production_year_manufacturers
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturers(id)
);

INSERT INTO manufacturers (name) VALUES
    ('BMW'),
    ('Tesla'),
    ('Lada');

INSERT INTO models (model_name, manufacturer_id) VALUES
    ('X11', 1),
    ('i6', 1),
    ('Model S', 2),
    ('Model X', 2),
    ('Model 3', 2),
    ('Nova', 3);

INSERT INTO production_years (established_on, manufacturer_id) VALUES
    ('1916-03-01', 1),
    ('2003-01-01', 1),
    ('1966-05-01', 3);

-- 5....

-- 6.
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    date DATE
);

CREATE TABLE photos (
    photo_id SERIAL PRIMARY KEY,
    url VARCHAR(255),
    place VARCHAR(100),
    customer_id INT REFERENCES customers(customer_id)
);
INSERT INTO customers(name,date)
VALUES ('Bella' ,'2022-03-25') ,('Philip',' 2022-07-05');
INSERT INTO photos(url,place,customer_id)
VALUES ('bella_1111.com', 'National Theatre', 1) ,
       ('bella_1112.com', 'Largo',1),
       ('bella_1113.com', 'The View Restaurant',1),
       ('philip_1121.com',' Old Town', 2),
        ('philip_1122.com','Rowing Canal', 2),
        ('philip_1123.com', 'Roman Theater', 2);

SELECT * FROM customers;
SELECT * FROM photos;

-- 7.

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(50)
);
CREATE TABLE exams (
    exam_id INT GENERATED ALWAYS AS IDENTITY (START WITH 101 INCREMENT BY 1) PRIMARY KEY,
    exam_name VARCHAR(50)
);

CREATE TABLE study_halls (
    study_hall_id SERIAL PRIMARY KEY,
    study_hall_name VARCHAR(50),
    exam_id INT REFERENCES exams(exam_id)
);

CREATE TABLE students_exams (
    student_id INT REFERENCES students(student_id),
    exam_id INT REFERENCES exams(exam_id),
    PRIMARY KEY (student_id, exam_id)
);

INSERT INTO students(student_name)
VALUES ('Mila'), ('Toni'), ('Ron');

INSERT INTO exams(exam_name)
    VALUES ('Python Advanced'), ('Python OOP'), ('PostgreSQL');

INSERT INTO study_halls(study_hall_name, exam_id)
VALUES ('Open Source Hall',102),
        ('Inspiration Hall ',101),
    ('Creative Hall',103),
    ('Masterclass Hall',103),
    ('Information Security Hall',103);

SELECT * FROM students











-- 8.

-- 9.

-- 10.

-- 11.

-- 12.

-- 13.


-- 14.

-- 15.

