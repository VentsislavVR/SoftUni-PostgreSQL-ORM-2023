-- 1.
CREATE VIEW
    view_river_info
    AS SELECT
    concat('The river', ' ',
        river_name, ' ',
        'flows into the', ' ',
        outflow, ' ',
        'and is', ' ', "length",
        ' ', 'kilometers long.') as "River Information"
FROM rivers
ORDER BY river_name;


-- 2.
CREATE VIEW
    view_continents_countries_currencies_details
    AS
SELECT
    TRIM(BOTH ' ' FROM continent_name) || ': ' || TRIM(BOTH ' ' FROM continents.continent_code) AS "Continent Details",
    CONCAT(country_name,' - ',
    capital,' - ',
    area_in_sq_km,' - ','km2') AS "Country Information",
    concat(description,' (',currencies.currency_code,')') as "Currencies"

FROM continents,countries,currencies
WHERE continents.continent_code = countries.continent_code
and currencies.currency_code = countries.currency_code
order by "Country Information"  ,"Currencies";

-- 3.

ALTER TABLE countries
ADD COLUMN capital_code VARCHAR(2);

UPDATE countries
SET capital_code = SUBSTRING(capital,1,2);

-- 4.

SELECT
    substring("River Information",'[0-9]{1,4}')
FROM view_river_info;

-- 5.

SELECT
    replace(mountain_range,'a','@') AS replace_a,
    replace(mountain_range,'A','$') AS replace_A
FROM mountains;

-- 6.
SELECT
    replace(mountain_range,'a','@') AS replace_a,
    replace(mountain_range,'A','$') AS replace_A
FROM mountains;

-- 7.

SELECT
    capital,
    TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') AS translated_name
FROM countries;


-- 8.
SELECT
    continent_name,
    trim(BOTH ' ' FROM continent_name) AS "trim"
FROM continents;

-- 9.

SELECT
    continent_name,
    trim(TRAILING ' ' FROM continent_name) AS "trim"
FROM continents;

-- 10.
SELECT
    TRIM(ltrim('M') FROM peak_name) as "left_trim",
    TRIM(rtrim('m') FROM peak_name) as "left_trim"

FROM peaks;

-- 11.!!!!!!!!!!!!!!!!!!!!!
SELECT
    CONCAT(mountain_range,' ',peaks.peak_name) as "Mountain Information",
    length(CONCAT(mountain_range,' ',peaks.peak_name)) as "Characters Lengt",
    length(CONCAT(mountain_range,' ',peaks.peak_name))  * 8 as "Bits of a String"
FROM mountains,peaks
where mountains.id = peaks.mountain_id;



-- 12.
SELECT
    population,
    length(CAST(population as text)) as "lenght"

FROM countries;


-- 13.
SELECT
    peak_name,
    LEFT(peak_name, 4) AS "Positive Left",
    LEFT(peak_name, -4) AS "Negative Left"
FROM
    peaks;

-- 14.
SELECT
    peak_name,
    right(peak_name, 4) AS "Positive Right",
    right(peak_name, -4) AS "Negative right"
FROM
    peaks;

-- 15.
UPDATE countries
SET
    iso_code = upper(substring(country_name,1,3))
where iso_code is null;
SELECT * FROM countries;



-- 16. бъгната , тук няма county_code
UPDATE countries
    SET
    country_code =lower(reverse(country_code));
SELECT
    id,country_code
FROM countries;

-- 17. WTF
SELECT
    CONCAT(elevation, REPEAT(' ', 3), '--->> ', peak_name) AS "Elevation --->> Peak Name"
FROM
    peaks
WHERE
    elevation >= 4884;
-- 18.
-- CREATE TABLE bookings_calculation
-- AS
-- SELECT
--     booked_for
-- FROM bookings
-- WHERE apartment_id = 93;
-- ALTER TABLE bookings_calculation
-- ADD COLUMN multiplication NUMERIC,
-- ADD COLUMN modulo NUMERIC;
--
-- 19.


