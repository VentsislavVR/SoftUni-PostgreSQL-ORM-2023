-- 1.
SELECT
    concat(address,' ',address_2) AS appartment_address,
    booked_for AS nights
FROM apartments
JOIN bookings
-- ON apartments.booking_id = bookings.booking_id
USING (booking_id)
ORDER BY apartments.apartment_id;
-- 2.
SELECT
    ap.name,
    ap.country,
--     date(b.booked_at)
    b.booked_at ::date
FROM apartments AS ap
LEFT JOIN bookings AS b
ON ap.booking_id = b.booking_id
LIMIT 10;

-- 3.
SELECT
    b.booking_id,
    DATE(b.starts_at) AS starts_at,
    b.apartment_id,
    CONCAT(c.first_name,' ', c.last_name) AS customer_name

FROM bookings AS b
RIGHT JOIN customers AS c
ON b.customer_id = c.customer_id
ORDER BY customer_name
LIMIT 10;
-- 4.
-- SELECT
--     b.booking_id,
--     a.name AS "apartment_owner",
--     a.apartment_id,
--     CONCAT(c.first_name,' ',c.last_name) AS "customer_name"
--
-- FROM bookings AS b
--     FULL JOIN  apartments AS a ON
--         a.booking_id = b.booking_id
--     FULL JOIN customers AS c
--         ON b.customer_id = c.customer_id
-- ORDER BY b.booking_id,apartment_owner,customer_name;
-- 4.1
SELECT
    b.booking_id,
    a.name AS "apartment_owner",
    a.apartment_id,
    CONCAT(c.first_name,' ',c.last_name) AS "customer_name"

FROM
    apartments as a
FULL JOIN
        bookings as b
USING
    (booking_id)
FULL JOIN
    customers as c
USING
    (customer_id)
ORDER BY
    b.booking_id,apartment_owner,customer_name;

-- 5.
SELECT
    b.booking_id,
    c.first_name
FROM bookings AS b
CROSS JOIN customers AS c
ORDER BY first_name;

-- 6.
SELECT
    b.booking_id,
    b.apartment_id,
    c.companion_full_name
FROM bookings AS b
JOIN customers AS c
USING (customer_id)
where b.apartment_id IS NULL;

-- 7.
SELECT
    b.apartment_id,
    b.booked_for,
    c.first_name,
    c.country
FROM bookings AS b
JOIN customers AS c
ON b.customer_id = c.customer_id
WHERE job_type LIKE 'Lead%';

-- 8.
SELECT
    count(booking_id)
FROM bookings AS b
JOIN customers AS c
    ON
        b.customer_id = c.customer_id
WHERE last_name LIKE 'Hahn%';

-- 9.
SELECT
    a.name,
    sum(b.booked_for)
FROM apartments AS a
JOIN bookings AS b
ON a.apartment_id = b.apartment_id
GROUP BY a.name
ORDER BY name;


-- 10. !!
SELECT
    country,
    count(b.booking_id) AS booking_count
FROM bookings AS b
JOIN apartments as a
    using (apartment_id)
WHERE
    b.booked_at >='2021-05-18 07:52:09.904+03'
    AND
    b.booked_at < '2021-09-17 19:48:02.147+03'

GROUP BY country
ORDER BY booking_count DESC;


