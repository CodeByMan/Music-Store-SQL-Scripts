USE MusicStoreSQL;

-- 1. Senior employee by level
SELECT TOP (1) WITH TIES employee_id, first_name, last_name, title, levels
FROM dbo.employee
ORDER BY levels DESC;

-- 2. Invoice counts by billing country
SELECT billing_country, COUNT(*) AS invoice_count
FROM dbo.invoice
GROUP BY billing_country
ORDER BY invoice_count DESC, billing_country;

-- 3. Three largest invoices
SELECT TOP (3) invoice_id, customer_id, invoice_date, total
FROM dbo.invoice
ORDER BY total DESC, invoice_id;

-- 4. Highest revenue city
SELECT TOP (1) WITH TIES billing_country, billing_state, billing_city, SUM(total) AS revenue
FROM dbo.invoice
GROUP BY billing_country, billing_state, billing_city
ORDER BY revenue DESC;

-- 5. Highest spending customer
SELECT TOP (1) WITH TIES c.customer_id, c.first_name, c.last_name,
    SUM(i.total) AS total_spent
FROM dbo.customer AS c
JOIN dbo.invoice AS i ON i.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- 6. Customers who purchased Rock tracks
SELECT DISTINCT c.email, c.first_name, c.last_name, g.name AS genre
FROM dbo.customer AS c
JOIN dbo.invoice AS i ON i.customer_id = c.customer_id
JOIN dbo.invoice_line AS il ON il.invoice_id = i.invoice_id
JOIN dbo.track AS t ON t.track_id = il.track_id
JOIN dbo.genre AS g ON g.genre_id = t.genre_id
WHERE g.name = N'Rock'
ORDER BY c.email;

-- 7. Artists with the most Rock tracks
SELECT TOP (10) a.artist_id, a.name AS artist_name, COUNT(*) AS track_count
FROM dbo.artist AS a
JOIN dbo.album AS al ON al.artist_id = a.artist_id
JOIN dbo.track AS t ON t.album_id = al.album_id
JOIN dbo.genre AS g ON g.genre_id = t.genre_id
WHERE g.name = N'Rock'
GROUP BY a.artist_id, a.name
ORDER BY track_count DESC, a.artist_id;

-- 8. Tracks longer than the average track
SELECT track_id, name, milliseconds
FROM dbo.track
WHERE milliseconds > (SELECT AVG(CAST(milliseconds AS DECIMAL(18, 2))) FROM dbo.track)
ORDER BY milliseconds DESC, track_id;

-- 9. Amount each customer spent on each artist
SELECT c.customer_id, c.first_name, c.last_name, a.artist_id,
    a.name AS artist_name, SUM(il.unit_price * il.quantity) AS total_spent
FROM dbo.customer AS c
JOIN dbo.invoice AS i ON i.customer_id = c.customer_id
JOIN dbo.invoice_line AS il ON il.invoice_id = i.invoice_id
JOIN dbo.track AS t ON t.track_id = il.track_id
JOIN dbo.album AS al ON al.album_id = t.album_id
JOIN dbo.artist AS a ON a.artist_id = al.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.artist_id, a.name
ORDER BY total_spent DESC, c.customer_id, a.artist_id;

-- 10. Most purchased genre in each customer country, including ties
WITH genre_sales AS (
    SELECT c.country, g.genre_id, g.name AS genre_name,
        SUM(il.quantity) AS units_sold
    FROM dbo.customer AS c
    JOIN dbo.invoice AS i ON i.customer_id = c.customer_id
    JOIN dbo.invoice_line AS il ON il.invoice_id = i.invoice_id
    JOIN dbo.track AS t ON t.track_id = il.track_id
    JOIN dbo.genre AS g ON g.genre_id = t.genre_id
    GROUP BY c.country, g.genre_id, g.name
), ranked_genres AS (
    SELECT country, genre_name, units_sold,
        DENSE_RANK() OVER (PARTITION BY country ORDER BY units_sold DESC) AS rank_in_country
    FROM genre_sales
)
SELECT country, genre_name, units_sold
FROM ranked_genres
WHERE rank_in_country = 1
ORDER BY country, genre_name;

-- 11. Highest spending customers by billing country, including ties
WITH customer_spend AS (
    SELECT i.billing_country, c.customer_id, c.first_name, c.last_name,
        SUM(i.total) AS total_spent
    FROM dbo.invoice AS i
    JOIN dbo.customer AS c ON c.customer_id = i.customer_id
    GROUP BY i.billing_country, c.customer_id, c.first_name, c.last_name
), ranked_customers AS (
    SELECT billing_country, customer_id, first_name, last_name, total_spent,
        DENSE_RANK() OVER (PARTITION BY billing_country ORDER BY total_spent DESC) AS rank_in_country
    FROM customer_spend
)
SELECT billing_country, customer_id, first_name, last_name, total_spent
FROM ranked_customers
WHERE rank_in_country = 1
ORDER BY billing_country, customer_id;

-- 12. Artists ranked by units purchased
SELECT a.artist_id, a.name AS artist_name, SUM(il.quantity) AS units_sold
FROM dbo.invoice_line AS il
JOIN dbo.track AS t ON t.track_id = il.track_id
JOIN dbo.album AS al ON al.album_id = t.album_id
JOIN dbo.artist AS a ON a.artist_id = al.artist_id
GROUP BY a.artist_id, a.name
ORDER BY units_sold DESC, a.artist_id;

-- 13. Tracks ranked by units purchased
SELECT t.track_id, t.name AS track_name, SUM(il.quantity) AS units_sold
FROM dbo.invoice_line AS il
JOIN dbo.track AS t ON t.track_id = il.track_id
GROUP BY t.track_id, t.name
ORDER BY units_sold DESC, t.track_id;

-- 14. Average paid price per unit by genre
SELECT g.genre_id, g.name AS genre_name,
    CAST(SUM(il.unit_price * il.quantity) / NULLIF(SUM(il.quantity), 0) AS DECIMAL(10, 2)) AS avg_unit_price
FROM dbo.invoice_line AS il
JOIN dbo.track AS t ON t.track_id = il.track_id
JOIN dbo.genre AS g ON g.genre_id = t.genre_id
GROUP BY g.genre_id, g.name
ORDER BY avg_unit_price DESC, g.genre_id;

-- 15. Countries ranked by purchased units
SELECT c.country, COUNT(DISTINCT i.invoice_id) AS invoice_count,
    SUM(il.quantity) AS units_sold
FROM dbo.customer AS c
JOIN dbo.invoice AS i ON i.customer_id = c.customer_id
JOIN dbo.invoice_line AS il ON il.invoice_id = i.invoice_id
GROUP BY c.country
ORDER BY units_sold DESC, c.country;
