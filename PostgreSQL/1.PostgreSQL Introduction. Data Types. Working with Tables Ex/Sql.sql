
-- 1.
 CREATE TABLE IF NOT EXISTS minions(
	id SERIAL PRIMARY KEY,
	name VARCHAR(30),
	age INTEGER
);

-- 2.
 ALTER TABLE minions
rename to minions_info;

-- 3.
 ALTER TABLE minions_info

ADD COLUMN code CHAR(4),
ADD COLUMN task TEXT,
ADD COLUMN salary NUMERIC(8,3);

-- 4.
 ALTER TABLE minions_info
RENAME COLUMN salary TO banana;

-- 5.
 ALTER TABLE minions_info
ADD COLUMN email VARCHAR(20),
ADD COLUMN equipped BOOLEAN DEFAULT FALSE NOT NULL;

-- 6.
 CREATE TYPE type_mood
AS ENUM(
	'happy',
	'relaxed',
	'stressed',
	'sad'
);
ALTER TABLE minions_info
ADD COLUMN mood type_mood;

-- 7.
ALTER TABLE minions_info

ALTER COLUMN age SET DEFAULT 0,
ALTER COLUMN "name" SET DEFAULT '',
ALTER COLUMN code SET DEFAULT '';

-- 8.
-- #PROPER
ALTER TABLE minions_info

ADD CONSTRAINT UQ_email_and_id
UNIQUE(id,email),

ADD CONSTRAINTS CK_banana_is_positive_number
CHECK(banana >0);
-- 8.1
ALTER TABLE minions_info

ADD CONSTRAINT unique_containt
UNIQUE(id,email),
ADD CONSTRAINTS banana_check
CHECK(banana >0);


-- 9.
ALTER TABLE minions_info
ALTER COLUMN task TYPE VARCHAR(150);

-- 10.
ALTER TABLE minions_info
ALTER COLUMN equipment DROP NOT NULL;
-- 11.
ALTER TABLE minions_info
DROP COLUMN age;
-- 12.
CREATE TABLE minions_birthdays(
	id INTEGER UNIQUE NOT NULL,
	name VARCHAR(50),
	date_of_birth DATE,
	age INTEGER,
	present VARCHAR(100),
	party timestamptz

);

-- 13.
INSERT INTO minions_info
	(name, code, task, banana, email, equipped, mood)
VALUES
	('Mark', 'GKYA', 'Graphing Points', 3265.265, 'mark@minion.com', false, 'happy'),
	('Mel', 'HSK', 'Science Investigation', 54784.996, 'mel@minion.com', true, 'stressed'),
	('Bob', 'HF', 'Painting', 35.652, 'bob@minion.com', true, 'happy'),
	('Darwin', 'EHND', 'Create a Digital Greeting', 321.958, 'darwin@minion.com', false, 'relaxed'),
	('Kevin', 'KMHD', 'Construct with Virtual Blocks', 35214.789, 'kevin@minion.com', false, 'happy'),
	('Norbert', 'FEWB', 'Testing', 3265.500, 'norbert@minion.com', true, 'sad'),
	('Donny', 'L', 'Make a Map', 8.452, 'donny@minion.com', true, 'happy');

-- 14.
ALTER TABLE minions_info
ALTER COLUMN equipment DROP NOT NULL;

-- 15.
TRUNCATE minions_info;

-- 16.
DROP TABLE minions_birthdays;

-- 17.
DROP DATABASE minions_db WITH (FORCE);

-- 18
CREATE TYPE address AS (
	street TEXT,
	city TEXT,
	postalCode CHAR(4)
);

CREATE TABLE customers (
	id SERIAL PRIMARY KEY,
	customer_name TEXT,
	customer_address address
);


INSERT INTO
	customers (customer_name, customer_address)
VALUES ('Diyan', ('some street', 'sofia', '1616'));


