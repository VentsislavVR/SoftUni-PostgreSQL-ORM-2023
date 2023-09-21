-- -- 1.
-- CREATE VIEW
--     view_river_info
--     AS SELECT
--     concat('The river', ' ',
--         river_name, ' ',
--         'flows into the', ' ',
--         outflow, ' ',
--         'and is', ' ', "length",
--         ' ', 'kilometers long.') as "River Information"
-- FROM rivers
-- ORDER BY river_name;
--
--
-- -- 2.
-- CREATE VIEW
--     view_continents_countries_currencies_details
--     AS
-- SELECT
--     TRIM(BOTH ' ' FROM continent_name) || ': ' || TRIM(BOTH ' ' FROM continents.continent_code) AS "Continent Details",
--     CONCAT(country_name,' - ',
--     capital,' - ',
--     area_in_sq_km,' - ','km2') AS "Country Information",
--     concat(description,' (',currencies.currency_code,')') as "Currencies"
--
-- FROM continents,countries,currencies
-- WHERE continents.continent_code = countries.continent_code
-- and currencies.currency_code = countries.currency_code
-- order by "Country Information"  ,"Currencies";
--
-- -- 3.
--
-- ALTER TABLE countries
-- ADD COLUMN capital_code CHAR(2);
--
-- UPDATE countries
-- SET capital_code = SUBSTRING(capital,1,2);
--
-- -- 4.
-- SELECT
--     substring(description,5)
-- FROM currencies;
-- -- 5.
-- SELECT
--     substring("River Information",'[0-9]{1,4}')
-- FROM view_river_info;
-- -- 5.2
-- SELECT
--     (regexp_matches("River Information",'([0-9]{1,4})'))[1]
--         FROM view_river_info;
--
-- -- 6.
-- SELECT
--     replace(mountain_range,'a','@') AS replace_a,
--     replace(mountain_range,'A','$') AS replace_A
-- FROM mountains;
--
-- -- 7.
--
-- SELECT
--     capital,
--     TRANSLATE(capital, 'áãåçéíñóú', 'aaaceinou') AS translated_name
-- FROM countries;
--
--
-- -- 8.
-- SELECT
--     continent_name,
--     trim(BOTH ' ' FROM continent_name) AS "trim"
-- --  trim(LEADING FROM continent_name)
-- -- LTRIM(continent_name)
-- FROM continents;
--
-- -- 9.
--
-- SELECT
--     continent_name,
--     trim(TRAILING ' ' FROM continent_name) AS "trim"
-- --  trim(TRAILING FROM continent_name)
-- -- RTRIM(continent_name)
--
-- FROM continents;
--
-- -- 10.
-- SELECT
-- --     TRIM(ltrim('M') FROM peak_name) as "Left_trim",
-- --     TRIM(rtrim('m') FROM peak_name) as "Right_trim"
--     LTRIM(peak_name,'M') as "Left Trim",
--     RTRIM(peak_name,'m') as "Right Trim"
--
-- FROM peaks;
--
-- -- 11.!!!!!!!!!!!!!!!!!!!!!
-- SELECT
--     CONCAT(mountain_range,' ',peaks.peak_name) as "Mountain Information",
--     length(CONCAT(mountain_range,' ',peaks.peak_name)) as "Characters Lengt",
--     length(CONCAT(mountain_range,' ',peaks.peak_name))  * 8 as "Bits of a String"
-- FROM mountains,peaks
-- where mountains.id = peaks.mountain_id;
-- -- 11.1
-- SELECT
--     CONCAT_WS(' ',m.mountain_range,p.peak_name) as "Mountain Information",
--     CHAR_LENGTH(CONCAT_WS(' ',m.mountain_range,p.peak_name)) as "Character Length",
--     BIT_LENGTH(CONCAT_WS(' ',m.mountain_range,P.peak_name)) as "Bits of a String"
--
--     FROM mountains as m,
--          peaks as p
-- where m.id = p.mountain_id;
-- -- 12.
-- SELECT
--     population,
--     LENGTH(CAST(population AS VARCHAR)) as "lenght"
--
-- FROM countries;
--
--
-- -- 13.
-- SELECT
--     peak_name,
--     LEFT(peak_name, 4) AS "Positive Left",
--     LEFT(peak_name, -4) AS "Negative Left"
-- FROM
--     peaks;
--
-- -- 14.
-- SELECT
--     peak_name,
--     RIGHT(peak_name, 4) AS "Positive Right",
--     RIGHT(peak_name, -4) AS "Negative right"
-- FROM
--     peaks;
--
-- -- 15.
-- UPDATE countries
-- SET
-- --     iso_code = UPPER(SUBSTRING(country_name,1,3))
--     iso_code = UPPER(LEFT(country_name,3))
-- where
--     iso_code is null;
-- SELECT * FROM countries;
--
--
--
-- -- 16. бъгната , тук няма county_code
-- UPDATE countries
--     SET
--     country_code =LOWER(REVERSE(country_code));
-- SELECT
--     id,country_code
-- FROM countries;
--
-- -- 17. WTF
-- SELECT
-- --     CONCAT(elevation, REPEAT(' ', 3), '--->> ', peak_name) AS "Elevation --->> Peak Name"
--         CONCAT_WS(' ',
--             elevation,
--             REPEAT('-', 3) || REPEAT('>',2)
--             ,peak_name
--             ) AS "Elevation --->> Peak Name"
-- FROM
--     peaks
-- WHERE
--     elevation >= 4884;
-- 17.1


-- 18.
CREATE TABLE bookings_calculation
AS
SELECT
    booked_for,
    cast(booked_for * 50 as NUMERIC) as multiplication,
    cast(booked_for % 50 as NUMERIC) as modulo

FROM bookings
WHERE apartment_id = 93;


-- 19.

SELECT
    latitude,
    ROUND(latitude,2) as round,
    TRUNC(latitude,2) as trunc

FROM apartments;

-- 20.

SELECT
    longitude,
    abs(longitude) as abs
from apartments;

-- 21
ALTER TABLE
bookings
ADD COLUMN
billing_day TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;
SELECT
    TO_CHAR(billing_day,'DD "Day" MM "Month" YYYY "Year" HH24:MI:SS') AS "Biling Day"
FROM
    bookings;

-- 22.
SELECT
    EXTRACT(YEAR FROM booked_at ) AS YEAR,
    EXTRACT(MONTH FROM booked_at ) AS MONTH,
    EXTRACT(DAY FROM booked_at ) AS DAY,
    EXTRACT(HOUR FROM booked_at AT TIME ZONE 'UTC') AS HOUR,
    EXTRACT(MINUTE FROM booked_at ) AS MINUTE,
    CEIL(EXTRACT(SECOND FROM booked_at )) AS SECOND
FROM bookings;

-- 23.
SELECT
    user_id,
    AGE(starts_at,booked_at) AS "Early Birds"
FROM bookings
WHERE
    starts_at - booked_at >= '10 Months';

-- 24.

SELECT
    companion_full_name,
    email
FROM users
WHERE
    companion_full_name ILIKE '%aNd%'
  AND
    email NOT LIKE '%@gmail';
-- 25.
SELECT
    LEFT(first_name,2) as initials,
    COUNT('initials') as user_count
FROM users
GROUP BY
    initials
ORDER BY
    user_count DESC,
    initials ASC;

-- 26.
SELECT
    SUM(booked_for) AS total_value
FROM bookings
WHERE apartment_id = 90;
-- 27.
SELECT
    AVG(multiplication) as avrage_value
from bookings_calculation;