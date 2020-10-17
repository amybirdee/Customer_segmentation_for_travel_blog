-- first reads by country
SELECT country, COUNT(*) AS readers_by_country
FROM first_reads
GROUP BY country
ORDER BY readers_by_country DESC;

-- first reads by source
SELECT source, COUNT(*) AS readers_by_source
FROM first_reads
GROUP BY source
ORDER BY readers_by_source DESC;

-- first_reads by topic
SELECT topic, COUNT(*) AS readers_by_topic
FROM first_reads
GROUP BY topic
ORDER BY readers_by_topic DESC;

-- returning readers by country
SELECT country, COUNT(*) AS returning_by_country
FROM returning_readers
GROUP BY country
ORDER BY returning_by_country DESC;

-- returning readers by topic
SELECT topic, COUNT(*) AS return_readers
FROM returning_readers
GROUP BY topic
ORDER BY return_readers DESC;

-- returning readers by source
SELECT source, COUNT(DISTINCT returning_readers.user_id) AS returning_readers
FROM first_reads
JOIN returning_readers
ON first_reads.user_id = returning_readers.user_id
GROUP BY source
ORDER BY returning_readers DESC;

-- subscribers by country
SELECT first_reads.country, COUNT(subscribers.user_id) AS subscribed_users
FROM first_reads
JOIN subscribers
ON first_reads.user_id = subscribers.user_id
GROUP BY country
ORDER BY subscribed_users DESC;

-- subscribers by source
SELECT first_reads.source, COUNT(subscribers.user_id) AS subscribed_users
FROM first_reads
JOIN subscribers
ON first_reads.user_id = subscribers.user_id
GROUP BY source
ORDER BY subscribed_users DESC;

-- subscribers by topic
SELECT first_reads.topic, COUNT(subscribers.user_id) AS subscribed_users
FROM first_reads
JOIN subscribers
ON first_reads.user_id = subscribers.user_id
GROUP BY topic
ORDER BY subscribed_users DESC;

-- paying users by topic
SELECT first_reads.topic, COUNT(paying_users.user_id) AS paying_users
FROM first_reads
JOIN paying_users
ON first_reads.user_id = paying_users.user_id
GROUP BY topic
ORDER BY paying_users DESC;

-- paying users by country
SELECT first_reads.country, COUNT(*) AS paying_users
FROM first_reads
JOIN paying_users
ON first_reads.user_id = paying_users.user_id
GROUP BY country
ORDER BY paying_users DESC;

-- paying users by country for ebook
SELECT first_reads.country, COUNT(*) AS paying_users
FROM first_reads
JOIN paying_users
ON first_reads.user_id = paying_users.user_id
WHERE price = 8
GROUP BY country
ORDER BY paying_users DESC;

-- paying users by country for video course
SELECT first_reads.country, COUNT(*) AS paying_users
FROM first_reads
JOIN paying_users
ON first_reads.user_id = paying_users.user_id
WHERE price = 80
GROUP BY country
ORDER BY paying_users DESC;

-- paying users by source
SELECT first_reads.source, COUNT(*) AS paying_users
FROM first_reads
JOIN paying_users
ON first_reads.user_id = paying_users.user_id
GROUP BY source
ORDER BY paying_users DESC;

-- paying users by source for ebook
SELECT first_reads.source, COUNT(*) AS paying_users
FROM first_reads
JOIN paying_users
ON first_reads.user_id = paying_users.user_id
WHERE price = 8
GROUP BY source
ORDER BY paying_users DESC;

-- paying users by source for course
SELECT first_reads.source, COUNT(*) AS paying_users
FROM first_reads
JOIN paying_users
ON first_reads.user_id = paying_users.user_id
WHERE price = 80
GROUP BY source
ORDER BY paying_users DESC;

-- total revenue
SELECT SUM(price), COUNT(*) AS count_paid_users
FROM paying_users;

-- total revenue from ebook
SELECT SUM(price), COUNT(*) AS count_ebook
FROM paying_users
WHERE price = 8;

-- total revenue from course
SELECT SUM(price), COUNT(*) AS count_course
FROM paying_users
WHERE price = 80;

-- daily revenue
SELECT event_date, SUM(price) AS revenue
FROM paying_users
GROUP BY event_date
ORDER BY event_date;
