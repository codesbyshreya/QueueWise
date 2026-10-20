-- QueueWise DBMS Mini Project
-- SQL Experiments and Queries

USE queuewise;

-- 1. Display all queue tickets
SELECT * FROM queue_tickets;

-- 2. Filter waiting tickets
SELECT *
FROM queue_tickets
WHERE status = 'WAITING';

-- 3. Sort tickets by creation time
SELECT *
FROM queue_tickets
ORDER BY created_at DESC;

-- 4. Count tickets by status
SELECT status, COUNT(*) AS total_tickets
FROM queue_tickets
GROUP BY status;

-- 5. Show statuses with more than one ticket
SELECT status, COUNT(*) AS total_tickets
FROM queue_tickets
GROUP BY status
HAVING COUNT(*) > 1;

-- 6. Join tickets with users
SELECT *
FROM queue_tickets qt
INNER JOIN users u ON qt.user_id = u.user_id;

-- 7. Join tickets with services
SELECT qt.ticket_id, qt.token_number, s.service_name, qt.status
FROM queue_tickets qt
INNER JOIN services s ON qt.service_id = s.service_id;

-- 8. Show all users and any associated tickets
SELECT u.user_id, u.name, qt.ticket_id, qt.status
FROM users u
LEFT JOIN queue_tickets qt ON u.user_id = qt.user_id;

-- 9. Find tickets with a status matching the given list
SELECT ticket_id, token_number, status
FROM queue_tickets
WHERE status IN ('WAITING', 'CALLED', 'IN_SERVICE');

-- 10. Use a subquery to find users with more tickets than the average
SELECT u.user_id, u.name, COUNT(qt.ticket_id) AS ticket_count
FROM users u
JOIN queue_tickets qt ON u.user_id = qt.user_id
GROUP BY u.user_id, u.name
HAVING COUNT(qt.ticket_id) >
(
    SELECT AVG(ticket_count)
    FROM (
        SELECT COUNT(*) AS ticket_count
        FROM queue_tickets
        GROUP BY user_id
    ) AS ticket_counts
);

-- 11. Query the queue status summary view
SELECT * FROM v_queue_status_summary;

-- 12. Query the ticket details view
SELECT * FROM v_queue_ticket_details;

-- 13. Calculate average feedback rating
SELECT AVG(rating) AS average_rating
FROM feedback;

-- 14. Categorize tickets using CASE
SELECT ticket_id, token_number, status,
       CASE
           WHEN status = 'WAITING' THEN 'Awaiting Service'
           WHEN status = 'CALLED' THEN 'Called to Counter'
           WHEN status = 'IN_SERVICE' THEN 'Currently Serving'
           WHEN status = 'COMPLETED' THEN 'Service Completed'
           WHEN status = 'CANCELLED' THEN 'Cancelled'
           ELSE 'Other'
       END AS status_description
FROM queue_tickets;
