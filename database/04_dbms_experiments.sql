USE queuewise;

-- Experiment 1: RDBMS study / inspect database objects
SHOW TABLES;
DESCRIBE queue_tickets;

-- Experiment 2: ER-related relationship inspection using information_schema
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'queuewise' AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;

-- Experiment 3: DDL and DML
INSERT INTO feedback (ticket_id, customer_id, rating, comment)
VALUES (3, 1, 4, 'Demo feedback for a waiting ticket');
UPDATE feedback SET comment = 'Updated demo feedback' WHERE ticket_id = 3;
DELETE FROM feedback WHERE ticket_id = 3;

-- Experiment 4: constraints (safe invalid examples; uncomment individually to observe errors)
-- INSERT INTO users (full_name, email, password_hash) VALUES ('Duplicate', 'aarav@example.com', 'x');
-- INSERT INTO feedback (ticket_id, rating) VALUES (3, 9);
-- INSERT INTO queue_tickets (counter_id, token_date, token_number, token_code)
-- VALUES (99999, CURRENT_DATE, 1, 'BAD-FK');

-- Experiment 5: set, string, and aggregate functions
SELECT UPPER(service_name) AS service_name_upper, LENGTH(service_name) AS name_length
FROM services;
SELECT status, COUNT(*) AS ticket_count
FROM queue_tickets
GROUP BY status;
SELECT COUNT(*) AS total_tickets, MIN(issued_at) AS first_ticket, MAX(issued_at) AS latest_ticket
FROM queue_tickets;

-- Experiment 6: GROUP BY and HAVING; counters whose average actual wait exceeds 5 minutes
SELECT counter_name, service_name, COUNT(*) AS called_tickets,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, issued_at, called_at)), 2) AS avg_wait_minutes
FROM v_ticket_details
WHERE called_at IS NOT NULL
GROUP BY counter_id, counter_name, service_name
HAVING AVG(TIMESTAMPDIFF(MINUTE, issued_at, called_at)) > 5;

-- Experiment 7: correlated subquery; counters slower than overall average actual wait
SELECT counter_id, counter_name, service_name, avg_actual_wait
FROM (
  SELECT sc.counter_id, sc.counter_name, s.service_name,
         AVG(TIMESTAMPDIFF(SECOND, qt.issued_at, qt.called_at)) / 60.0 AS avg_actual_wait
  FROM queue_tickets qt
  JOIN service_counters sc ON sc.counter_id = qt.counter_id
  JOIN services s ON s.service_id = sc.service_id
  WHERE qt.called_at IS NOT NULL
  GROUP BY sc.counter_id, sc.counter_name, s.service_name
) AS counter_stats
WHERE avg_actual_wait > (
  SELECT AVG(TIMESTAMPDIFF(SECOND, issued_at, called_at)) / 60.0
  FROM queue_tickets WHERE called_at IS NOT NULL
);

-- Experiment 8: views
SELECT * FROM v_waiting_queue ORDER BY counter_id, token_number;
SELECT * FROM v_counter_daily_analytics ORDER BY service_day DESC, counter_id;

-- Experiment 9: joins
SELECT qt.token_code, u.full_name, s.service_name, sc.counter_name,
       l.location_name, qt.status, qt.issued_at
FROM queue_tickets qt
LEFT JOIN users u ON u.user_id = qt.customer_id
JOIN service_counters sc ON sc.counter_id = qt.counter_id
JOIN services s ON s.service_id = sc.service_id
JOIN locations l ON l.location_id = sc.location_id
ORDER BY qt.issued_at DESC;

-- Extra: set operations (MySQL supports UNION; UNION DISTINCT is the default)
SELECT email AS contact, 'USER' AS source_type FROM users
UNION
SELECT CONCAT('feedback-ticket-', ticket_id) AS contact, 'FEEDBACK' AS source_type FROM feedback;

-- Extra: peak hour analytics
SELECT HOUR(issued_at) AS hour_of_day, COUNT(*) AS tickets_issued
FROM queue_tickets
GROUP BY HOUR(issued_at)
ORDER BY tickets_issued DESC;

-- Extra: customer satisfaction by service
SELECT s.service_name, COUNT(f.feedback_id) AS responses,
       ROUND(AVG(f.rating), 2) AS average_rating
FROM feedback f
JOIN queue_tickets qt ON qt.ticket_id = f.ticket_id
JOIN service_counters sc ON sc.counter_id = qt.counter_id
JOIN services s ON s.service_id = sc.service_id
GROUP BY s.service_id, s.service_name
HAVING COUNT(f.feedback_id) > 0;
