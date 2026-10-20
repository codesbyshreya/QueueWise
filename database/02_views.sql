USE queuewise;

-- Customer/staff-friendly ticket details.
CREATE OR REPLACE VIEW v_ticket_details AS
SELECT
  qt.ticket_id, qt.token_code, qt.token_number, qt.token_date, qt.status,
  qt.issued_at, qt.called_at, qt.service_started_at, qt.completed_at,
  qt.estimated_wait_minutes,
  u.full_name AS customer_name,
  sc.counter_id, sc.counter_name, sc.counter_code,
  s.service_name, l.location_name,
  CASE
    WHEN qt.called_at IS NOT NULL THEN TIMESTAMPDIFF(MINUTE, qt.issued_at, qt.called_at)
    ELSE NULL
  END AS actual_wait_minutes,
  CASE
    WHEN qt.completed_at IS NOT NULL AND qt.service_started_at IS NOT NULL
      THEN TIMESTAMPDIFF(MINUTE, qt.service_started_at, qt.completed_at)
    ELSE NULL
  END AS actual_service_minutes
FROM queue_tickets qt
JOIN service_counters sc ON sc.counter_id = qt.counter_id
JOIN services s ON s.service_id = sc.service_id
JOIN locations l ON l.location_id = sc.location_id
LEFT JOIN users u ON u.user_id = qt.customer_id;

-- Queue positions are calculated from current waiting tickets, not stored redundantly.
CREATE OR REPLACE VIEW v_waiting_queue AS
SELECT
  qt.ticket_id, qt.token_code, qt.token_number, qt.token_date, qt.status,
  qt.issued_at, sc.counter_id, sc.counter_name, s.service_name, l.location_name,
  (
    SELECT COUNT(*)
    FROM queue_tickets earlier
    WHERE earlier.counter_id = qt.counter_id
      AND earlier.token_date = qt.token_date
      AND earlier.status = 'WAITING'
      AND earlier.token_number < qt.token_number
  ) AS people_ahead
FROM queue_tickets qt
JOIN service_counters sc ON sc.counter_id = qt.counter_id
JOIN services s ON s.service_id = sc.service_id
JOIN locations l ON l.location_id = sc.location_id
WHERE qt.status = 'WAITING';

-- Daily analytics. Actual wait is measured from issuance to first call.
CREATE OR REPLACE VIEW v_counter_daily_analytics AS
SELECT
  sc.counter_id, sc.counter_name, s.service_name, l.location_name,
  DATE(qt.issued_at) AS service_day,
  COUNT(*) AS total_tickets,
  SUM(qt.status = 'COMPLETED') AS completed_tickets,
  ROUND(AVG(CASE WHEN qt.called_at IS NOT NULL
    THEN TIMESTAMPDIFF(SECOND, qt.issued_at, qt.called_at) / 60.0 END), 2) AS avg_actual_wait_minutes,
  ROUND(AVG(CASE WHEN qt.completed_at IS NOT NULL AND qt.service_started_at IS NOT NULL
    THEN TIMESTAMPDIFF(SECOND, qt.service_started_at, qt.completed_at) / 60.0 END), 2) AS avg_service_minutes
FROM queue_tickets qt
JOIN service_counters sc ON sc.counter_id = qt.counter_id
JOIN services s ON s.service_id = sc.service_id
JOIN locations l ON l.location_id = sc.location_id
GROUP BY sc.counter_id, sc.counter_name, s.service_name, l.location_name, DATE(qt.issued_at);
