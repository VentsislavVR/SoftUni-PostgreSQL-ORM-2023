-- 1.

CREATE TABLE mountains(
    id serial PRIMARY KEY,
    name VARCHAR(50)

);
CREATE TABLE peaks(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    mountain_id INT,
    CONSTRAINT fk_peaks_mountains
            FOREIGN KEY (mountain_id)
                  REFERENCES mountains(id)
);



-- 2.
SELECT
    v.driver_id,
    v.vehicle_type,
    concat(c.first_name,' ',c.last_name)

FROM vehicles AS v  JOIN
     campers AS c ON v.driver_id = c.id;
-- 3.
SELECT
    r.start_point,
    r.end_point,
    r.leader_id,
    concat(c.first_name,' ',c.last_name) as leader_name

FROM
    routes  as r  Join
    campers as c
        ON r.leader_id = c.id;

-- 4.
CREATE TABLE  mountains(
    id serial PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE  peaks(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    mountain_id INT,
    CONSTRAINT fk_mountain_id
            FOREIGN KEY (mountain_id)
                   REFERENCES mountains(id)
                   ON DELETE CASCADE);
