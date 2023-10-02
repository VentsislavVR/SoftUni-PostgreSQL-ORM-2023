-- 11.
SELECT
    mc.country_code,
    m.mountain_range,
    p.peak_name,
    p.elevation
FROM mountains AS m
JOIN mountains_countries AS mc
    ON m.id = mc.mountain_id
JOIN peaks AS p
    ON m.id = p.mountain_id
WHERE mc.country_code = 'BG' AND p.elevation > 2835
ORDER BY p.elevation DESC;

-- 12.
SELECT
    country_code,
    count(*) as mountain_range_count
FROM mountains_countries
WHERE country_code IN ('BG', 'RU', 'US')
group by country_code
ORDER BY mountain_range_count DESC;

-- 13.
SELECT
    country_name,
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
FROM (
    SELECT

        AVG(area_in_sq_km) AS avg_area
    FROM countries
    GROUP BY continent_code
) AS min_average_are;

-- 15.

-- 16.
-- 17.
-- 18.
-- 19.
-- 20.
-- 21.
-- 22.