SELECT first_timers.event_date, 
       first_timers.country, 
       first_timers.source, 
       first_timers.topic, 
       first_timers.count_first_reads, 
       returning_users.count_returning_users, 
       subscribed.count_subscribers,
       ebook.count_ebook,
       course.count_course 
FROM
--funnel 1 - first reads
    (SELECT event_date, country, source, topic, COUNT(*) AS count_first_reads
    FROM first_reads
    GROUP BY event_date, country, source, topic
    ORDER BY event_date) AS first_timers
LEFT JOIN
--funnel 2 - returning readers
    (SELECT first_reads.event_date, first_reads.country, first_reads.source, first_reads.topic, COUNT(DISTINCT(returning_readers.user_id)) AS count_returning_users
    FROM returning_readers
    JOIN first_reads
    ON returning_readers.user_id = first_reads.user_id
    GROUP BY first_reads.event_date, first_reads.country, first_reads.source, first_reads.topic
    ORDER BY event_date) AS returning_users
ON first_timers.event_date = returning_users.event_date AND first_timers.country = returning_users.country AND first_timers.source = returning_users.source AND first_timers.topic = returning_users.topic
LEFT JOIN
--funnel 3 - subscribers
    (SELECT first_reads.event_date, first_reads.country, first_reads.source, first_reads.topic, COUNT(DISTINCT(subscribers.user_id)) AS count_subscribers
    FROM subscribers
    JOIN first_reads
    ON subscribers.user_id = first_reads.user_id
    GROUP BY first_reads.event_date, first_reads.country, first_reads.source, first_reads.topic
    ORDER BY event_date) AS subscribed
ON first_timers.event_date = subscribed.event_date AND first_timers.country = subscribed.country AND first_timers.source = subscribed.source AND first_timers.topic = subscribed.topic
LEFT JOIN
--funnel 4 - paid users - ebook
    (SELECT first_reads.event_date, first_reads.country, first_reads.source, first_reads.topic, COUNT(DISTINCT(paying_users.user_id)) AS count_ebook
    FROM paying_users
    JOIN first_reads
    ON paying_users.user_id = first_reads.user_id
    WHERE paying_users.price = 8
    GROUP BY first_reads.event_date, first_reads.country, first_reads.source, first_reads.topic
    ORDER BY event_date) AS ebook
ON first_timers.event_date = ebook.event_date AND first_timers.country = ebook.country AND first_timers.source = ebook.source AND first_timers.topic = ebook.topic
LEFT JOIN
--funnel 5 - paid users - course
    (SELECT first_reads.event_date, first_reads.country, first_reads.source, first_reads.topic, COUNT(DISTINCT(paying_users.user_id)) AS count_course
    FROM paying_users
    JOIN first_reads
    ON paying_users.user_id = first_reads.user_id
    WHERE paying_users.price = 80
    GROUP BY first_reads.event_date, first_reads.country, first_reads.source, first_reads.topic
    ORDER BY event_date) AS course
ON first_timers.event_date = course.event_date AND first_timers.country = course.country AND first_timers.source = course.source AND first_timers.topic = course.topic
ORDER BY first_timers.event_date;
