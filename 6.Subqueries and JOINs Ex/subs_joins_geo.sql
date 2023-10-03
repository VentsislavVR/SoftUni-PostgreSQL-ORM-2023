-- 11.
SELECT mc.country_code,
       m.mountain_range,
       p.peak_name,
       p.elevation
FROM mountains AS m
         JOIN mountains_countries AS mc
              ON m.id = mc.mountain_id
         JOIN peaks AS p
              ON m.id = p.mountain_id
WHERE mc.country_code = 'BG'
  AND p.elevation > 2835
ORDER BY p.elevation DESC;

-- 12.
-- SELECT
--         country_code,
--        count(*) as mountain_range_count
-- FROM mountains_countries
-- WHERE country_code IN ('BG', 'RU', 'US')
-- group by country_code
-- ORDER BY mountain_range_count DESC;
-- 12.1
SELECT
        country_code,
       COUNT(*) as mountain_range_count
FROM mountains_countries as mc
JOIN
    mountains as m
ON
    mc.mountain_id = m.id
WHERE
    mc.country_code IN ('BG', 'RU', 'US')
GROUP BY
    mc.country_code
ORDER BY mountain_range_count DESC;


-- 13.
SELECT country_name,
       river_name
FROM countries as c
         LEFT JOIN countries_rivers as cr
                   ON c.country_code = cr.country_code
         LEFT JOIN rivers as r
                   ON cr.river_id = r.id
WHERE c.continent_code = 'AF'
ORDER BY country_name
LIMIT 5;
-- 14.
SELECT
    MIN(avg_area) AS min_average_area
FROM
    (SELECT
         AVG(area_in_sq_km) AS avg_area
      FROM countries
      GROUP BY
          continent_code
      ) AS min_average_are;

-- 15.
SELECT COUNT(*) AS countries_without_mountains
FROM countries AS c
         LEFT JOIN mountains_countries AS mc
                   ON c.country_code = mc.country_code
WHERE mc.country_code IS NULL;

-- 16.
CREATE TABLE monasteries (
	id SERIAL PRIMARY KEY,
	monastery_name VARCHAR(255),
	country_code CHAR(2)
);

INSERT INTO
	monasteries(monastery_name, country_code)
VALUES
	('Rila Monastery "St. Ivan of Rila"', 'BG'),
	('Bachkovo Monastery "Virgin Mary"', 'BG'),
	('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
	('Kopan Monastery', 'NP'),
	('Thrangu Tashi Yangtse Monastery', 'NP'),
	('Shechen Tennyi Dargyeling Monastery', 'NP'),
	('Benchen Monastery', 'NP'),
	('Southern Shaolin Monastery', 'CN'),
	('Dabei Monastery', 'CN'),
	('Wa Sau Toi', 'CN'),
	('Lhunshigyia Monastery', 'CN'),
	('Rakya Monastery', 'CN'),
	('Monasteries of Meteora', 'GR'),
	('The Holy Monastery of Stavronikita', 'GR'),
	('Taung Kalat Monastery', 'MM'),
	('Pa-Auk Forest Monastery', 'MM'),
	('Taktsang Palphug Monastery', 'BT'),
	('Sümela Monastery', 'TR');

ALTER TABLE
	countries
ADD COLUMN
	three_rivers BOOLEAN DEFAULT FALSE;

UPDATE
	countries
SET three_rivers = (
	SELECT
		COUNT(*) >= 3
	FROM
		countries_rivers AS cr
	WHERE
		cr.country_code = countries.country_code
);

SELECT
	m.monastery_name,
	c.country_name
FROM
	monasteries AS m
JOIN
	countries AS c
USING
	(country_code)
WHERE
	NOT three_rivers
ORDER BY
	monastery_name ASC;

-- 17.
-- 18.
SELECT
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename  , indexname ;

-- 19.






-- 19.
-- 20.
-- 21.
-- 22.