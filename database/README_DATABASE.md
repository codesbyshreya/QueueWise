# QueueWise — Database component

MySQL database for QueueWise, a smart queue-management and waiting-time analytics mini-project.

## Requirements
- MySQL 8.0+
- MySQL Workbench (recommended) or MySQL CLI

## Run scripts in this order
1. `database/01_schema.sql` — creates `queuewise` and all tables, keys, checks, and indexes.
2. `database/03_sample_data.sql` — inserts demo users, locations, services, counters, tickets, events, and feedback.
3. `database/02_views.sql` — creates reporting views.
4. `database/04_dbms_experiments.sql` — runs the nine core DBMS experiment categories plus extra reports.

Open each SQL file in MySQL Workbench and click the lightning-bolt Execute button. The schema script drops and recreates project tables, so do not run it against any database containing data you need to preserve.

## Important security note
The sample `password_hash` values are placeholders, not valid passwords or production hashes. The backend must hash passwords with a password-hashing library (e.g. Argon2id or bcrypt) and must never store plaintext passwords. Never commit real credentials or `.env` files.

## Core design decisions
- `queue_tickets` is the operational source of truth for token status and timestamps.
- `queue_events` is an append-only audit trail of queue actions; the backend should insert an event in the same transaction as each status change.
- `v_waiting_queue` calculates people ahead from current waiting tickets rather than storing a value that can become stale.
- `v_ticket_details` derives actual wait and service duration from timestamps.
- `v_counter_daily_analytics` supports staff analytics without manually entering aggregates.
- `token_sequences` stores the last allocated number for each counter/date; allocate under a transaction with `SELECT ... FOR UPDATE` to prevent concurrent token collisions.
- Unique constraints prevent duplicate token numbers at the same counter on the same date.
- Indexes target queue ordering, status filtering, customer history, and analytics.
- MySQL CHECK constraints require a supported MySQL version (MySQL 8.0.16+ enforces them).

## Suggested verification after setup
```sql
USE queuewise;
SHOW TABLES;
SELECT * FROM v_waiting_queue;
SELECT * FROM v_ticket_details;
SELECT * FROM v_counter_daily_analytics;
SELECT * FROM queue_events ORDER BY event_time;
```

## Backend integration contract
The backend should connect using environment variables (host, port, database, username, password), not credentials committed to GitHub. Suggested read operations:
- Generate token: transactionally allocate the next token number for a counter and date, insert `queue_tickets`, and insert `ISSUED` into `queue_events`.
- Track token: query `v_ticket_details` and `v_waiting_queue`.
- Staff calls/completes/skips: validate the state transition, update the ticket timestamps/status, and insert the corresponding `queue_events` record in one transaction.
- Analytics: query `v_counter_daily_analytics`, plus hourly counts grouped from `queue_tickets.issued_at`.

Do not generate token numbers with `MAX(token_number)+1` alone under concurrent requests; two requests can race. Use `token_sequences` inside a transaction, lock the row with `SELECT ... FOR UPDATE`, increment `last_number`, insert the ticket, and commit. Retain the unique constraint as a final safeguard. For the first token of a counter/date, create the sequence row safely before locking it.
