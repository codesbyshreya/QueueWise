
const express = require('express');
const path = require('path');
const db = require('./db');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.static(path.join(__dirname, '../frontend')));

// Convert database statuses into labels used by the frontend.
const STATUS_TO_UI = {
    WAITING: 'Waiting',
    CALLED: 'Serving',
    IN_SERVICE: 'Serving',
    COMPLETED: 'Completed',
    SKIPPED: 'Skipped',
    CANCELLED: 'Cancelled'
};

// Shared query for retrieving a ticket with its counter, service and location.
const TICKET_SELECT = `
    SELECT
        t.ticket_id,
        t.token_number,
        t.token_code,
        t.token_date,
        t.status,
        t.issued_at,
        t.counter_id,
        c.counter_code,
        c.counter_name,
        c.location_id,
        l.location_name,
        s.service_id,
        s.service_name,
        s.avg_service_minutes
    FROM queue_tickets t
    JOIN service_counters c ON c.counter_id = t.counter_id
    JOIN services s ON s.service_id = c.service_id
    JOIN locations l ON l.location_id = c.location_id
`;

function formatTicket(row) {
    return {
        id: row.ticket_id,
        token: row.token_code,
        tokenNumber: row.token_number,
        serviceId: String(row.service_id),
        serviceName: row.service_name,
        counterId: row.counter_id,
        counterName: row.counter_name,
        counterCode: row.counter_code,
        locationId: row.location_id,
        locationName: row.location_name,
        status: STATUS_TO_UI[row.status] || row.status,
        rawStatus: row.status,
        createdAt: row.issued_at,
        averageServiceMinutes: row.avg_service_minutes
    };
}

function padToken(number) {
    return String(number).padStart(3, '0');
}

function validPositiveInteger(value) {
    const number = Number(value);
    return Number.isSafeInteger(number) && number > 0;
}

// Root endpoint.
app.get('/', (req, res) => {
    res.json({
        message: 'QueueWise database-backed server is running.'
    });
});

// Get all services.
// The services table does not have an is_active column.
app.get('/api/services', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT service_id, service_name, avg_service_minutes
            FROM services
            ORDER BY service_id
        `);

        res.json(rows.map(row => ({
            id: row.service_id,
            name: row.service_name,
            averageServiceMinutes: row.avg_service_minutes
        })));
    } catch (error) {
        console.error('Services error:', error);
        res.status(500).json({
            message: 'Could not load services.'
        });
    }
});

// Get active locations.
app.get('/api/locations', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT location_id, location_name
            FROM locations
            WHERE is_active = 1
            ORDER BY location_id
        `);

        res.json(rows.map(row => ({
            id: row.location_id,
            name: row.location_name
        })));
    } catch (error) {
        console.error('Locations error:', error);
        res.status(500).json({
            message: 'Could not load locations.'
        });
    }
});

// Get active counters with their services and locations.
app.get('/api/counters', async (req, res) => {
    try {
        const [rows] = await db.query(`
            SELECT
                c.counter_id,
                c.counter_code,
                c.counter_name,
                c.service_id,
                s.service_name,
                c.location_id,
                l.location_name
            FROM service_counters c
            JOIN services s ON s.service_id = c.service_id
            JOIN locations l ON l.location_id = c.location_id
            WHERE c.is_active = 1
              AND l.is_active = 1
            ORDER BY c.location_id, c.counter_id
        `);

        res.json(rows.map(row => ({
            id: row.counter_id,
            code: row.counter_code,
            name: row.counter_name,
            serviceId: String(row.service_id),
            serviceName: row.service_name,
            locationId: row.location_id,
            locationName: row.location_name
        })));
    } catch (error) {
        console.error('Counters error:', error);
        res.status(500).json({
            message: 'Could not load counters.'
        });
    }
});

// Get today's queue, optionally filtered by counter.
app.get('/api/queue', async (req, res) => {
    try {
        const params = [];

        let sql = `
            ${TICKET_SELECT}
            WHERE t.token_date = CURDATE()
        `;

        if (req.query.counterId !== undefined) {
            if (!validPositiveInteger(req.query.counterId)) {
                return res.status(400).json({
                    message: 'Invalid counterId.'
                });
            }

            sql += ' AND t.counter_id = ?';
            params.push(Number(req.query.counterId));
        }

        sql += ' ORDER BY t.counter_id, t.token_number';

        const [rows] = await db.query(sql, params);
        res.json(rows.map(formatTicket));
    } catch (error) {
        console.error('Queue error:', error);
        res.status(500).json({
            message: 'Could not load the queue.'
        });
    }
});

// Generate a token for a selected service and location.
app.post('/api/queue', async (req, res) => {
    const serviceId = Number(req.body?.serviceId);
    const locationId = Number(req.body?.locationId);

    if (
        !Number.isSafeInteger(serviceId) || serviceId < 1 ||
        !Number.isSafeInteger(locationId) || locationId < 1
    ) {
        return res.status(400).json({
            message: 'Please select a valid service and location.'
        });
    }

    let connection;
    let transactionStarted = false;

    try {
        connection = await db.getConnection();
        await connection.beginTransaction();
        transactionStarted = true;

        const [counters] = await connection.execute(`
            SELECT counter_id, counter_code, counter_name
            FROM service_counters
            WHERE service_id = ?
              AND location_id = ?
              AND is_active = 1
            ORDER BY counter_id
            LIMIT 1
            FOR UPDATE
        `, [serviceId, locationId]);

        if (!counters.length) {
            await connection.rollback();
            transactionStarted = false;

            return res.status(400).json({
                message:
                    'No active counter is available for this service at that location.'
            });
        }

        const counter = counters[0];

        // Create today's sequence if it does not exist.
        await connection.execute(`
            INSERT INTO token_sequences
                (counter_id, token_date, last_number)
            VALUES (?, CURDATE(), 0)
            ON DUPLICATE KEY UPDATE
                last_number = last_number
        `, [counter.counter_id]);

        // Lock the sequence to avoid duplicate token numbers.
        const [sequences] = await connection.execute(`
            SELECT last_number
            FROM token_sequences
            WHERE counter_id = ?
              AND token_date = CURDATE()
            FOR UPDATE
        `, [counter.counter_id]);

        if (!sequences.length) {
            throw new Error('Could not initialize the token sequence.');
        }

        const tokenNumber = Number(sequences[0].last_number) + 1;
        const tokenCode =
            `${counter.counter_code}-${padToken(tokenNumber)}`;

        await connection.execute(`
            UPDATE token_sequences
            SET last_number = ?, updated_at = NOW()
            WHERE counter_id = ?
              AND token_date = CURDATE()
        `, [tokenNumber, counter.counter_id]);

        const [insertResult] = await connection.execute(`
            INSERT INTO queue_tickets
                (counter_id, token_date, token_number, token_code, status, issued_at)
            VALUES (?, CURDATE(), ?, ?, 'WAITING', NOW())
        `, [counter.counter_id, tokenNumber, tokenCode]);

        await connection.execute(`
            INSERT INTO queue_events
                (ticket_id, event_type, event_time, details)
            VALUES (?, 'ISSUED', NOW(), 'Token issued')
        `, [insertResult.insertId]);

        const [aheadRows] = await connection.execute(`
            SELECT COUNT(*) AS peopleAhead
            FROM queue_tickets
            WHERE counter_id = ?
              AND token_date = CURDATE()
              AND token_number < ?
              AND status IN ('WAITING', 'CALLED', 'IN_SERVICE')
        `, [counter.counter_id, tokenNumber]);

        const [ticketRows] = await connection.execute(`
            ${TICKET_SELECT}
            WHERE t.ticket_id = ?
        `, [insertResult.insertId]);

        if (!ticketRows.length) {
            throw new Error('Created ticket could not be retrieved.');
        }

        const ticket = formatTicket(ticketRows[0]);
        ticket.peopleAhead = Number(aheadRows[0].peopleAhead);
        ticket.estimatedWaitMinutes =
            ticket.peopleAhead * Number(ticket.averageServiceMinutes);

        await connection.commit();
        transactionStarted = false;

        res.status(201).json({
            message: 'Token created successfully!',
            ticket
        });
    } catch (error) {
        if (connection && transactionStarted) {
            await connection.rollback();
        }

        console.error('Create token error:', error);
        res.status(500).json({
            message: 'Could not create a token.'
        });
    } finally {
        if (connection) connection.release();
    }
});

// Call the next waiting ticket at a selected counter.
app.post('/api/queue/next', async (req, res) => {
    const counterId = Number(req.body?.counterId);

    if (!Number.isSafeInteger(counterId) || counterId < 1) {
        return res.status(400).json({
            message: 'A valid counterId is required.'
        });
    }

    let connection;
    let transactionStarted = false;

    try {
        connection = await db.getConnection();
        await connection.beginTransaction();
        transactionStarted = true;

        const [counters] = await connection.execute(`
            SELECT counter_id
            FROM service_counters
            WHERE counter_id = ?
              AND is_active = 1
            FOR UPDATE
        `, [counterId]);

        if (!counters.length) {
            await connection.rollback();
            transactionStarted = false;

            return res.status(404).json({
                message: 'Counter not found or inactive.'
            });
        }

        const [active] = await connection.execute(`
            SELECT ticket_id
            FROM queue_tickets
            WHERE counter_id = ?
              AND token_date = CURDATE()
              AND status IN ('CALLED', 'IN_SERVICE')
            LIMIT 1
            FOR UPDATE
        `, [counterId]);

        if (active.length) {
            await connection.rollback();
            transactionStarted = false;

            return res.status(409).json({
                message: 'Finish the current ticket before calling the next one.'
            });
        }

        const [waiting] = await connection.execute(`
            SELECT ticket_id
            FROM queue_tickets
            WHERE counter_id = ?
              AND token_date = CURDATE()
              AND status = 'WAITING'
            ORDER BY token_number
            LIMIT 1
            FOR UPDATE
        `, [counterId]);

        if (!waiting.length) {
            await connection.rollback();
            transactionStarted = false;

            return res.status(404).json({
                message: 'There are no waiting tickets at this counter.'
            });
        }

        const ticketId = waiting[0].ticket_id;

        await connection.execute(`
            UPDATE queue_tickets
            SET status = 'CALLED', called_at = NOW()
            WHERE ticket_id = ?
        `, [ticketId]);

        await connection.execute(`
            INSERT INTO queue_events
                (ticket_id, event_type, event_time, details)
            VALUES (?, 'CALLED', NOW(), 'Ticket called by staff')
        `, [ticketId]);

        const [rows] = await connection.execute(`
            ${TICKET_SELECT}
            WHERE t.ticket_id = ?
        `, [ticketId]);

        await connection.commit();
        transactionStarted = false;

        res.json(formatTicket(rows[0]));
    } catch (error) {
        if (connection && transactionStarted) {
            await connection.rollback();
        }

        console.error('Call next error:', error);
        res.status(500).json({
            message: 'Could not call the next ticket.'
        });
    } finally {
        if (connection) connection.release();
    }
});

// Start serving a ticket that has been called.
app.post('/api/queue/:id/start', async (req, res) => {
    const ticketId = Number(req.params.id);

    if (!validPositiveInteger(ticketId)) {
        return res.status(400).json({
            message: 'Invalid ticket ID.'
        });
    }

    let connection;
    let transactionStarted = false;

    try {
        connection = await db.getConnection();
        await connection.beginTransaction();
        transactionStarted = true;

        const [tickets] = await connection.execute(`
            SELECT ticket_id, counter_id, status
            FROM queue_tickets
            WHERE ticket_id = ?
              AND token_date = CURDATE()
            FOR UPDATE
        `, [ticketId]);

        if (!tickets.length) {
            await connection.rollback();
            transactionStarted = false;

            return res.status(404).json({
                message: "Ticket not found in today's queue."
            });
        }

        const ticket = tickets[0];

        if (ticket.status !== 'CALLED') {
            await connection.rollback();
            transactionStarted = false;

            return res.status(409).json({
                message: 'Only a called ticket can be started.'
            });
        }

        const [active] = await connection.execute(`
            SELECT ticket_id
            FROM queue_tickets
            WHERE counter_id = ?
              AND token_date = CURDATE()
              AND status = 'IN_SERVICE'
              AND ticket_id <> ?
            LIMIT 1
            FOR UPDATE
        `, [ticket.counter_id, ticketId]);

        if (active.length) {
            await connection.rollback();
            transactionStarted = false;

            return res.status(409).json({
                message: 'Another ticket is already in service at this counter.'
            });
        }

        await connection.execute(`
            UPDATE queue_tickets
            SET status = 'IN_SERVICE', service_started_at = NOW()
            WHERE ticket_id = ?
        `, [ticketId]);

        await connection.execute(`
            INSERT INTO queue_events
                (ticket_id, event_type, event_time, details)
            VALUES (?, 'SERVICE_STARTED', NOW(), 'Service started by staff')
        `, [ticketId]);

        const [rows] = await connection.execute(`
            ${TICKET_SELECT}
            WHERE t.ticket_id = ?
        `, [ticketId]);

        await connection.commit();
        transactionStarted = false;

        res.json(formatTicket(rows[0]));
    } catch (error) {
        if (connection && transactionStarted) {
            await connection.rollback();
        }

        console.error('Start service error:', error);
        res.status(500).json({
            message: 'Could not start service.'
        });
    } finally {
        if (connection) connection.release();
    }
});

// Shared handler for skipping and completing tickets.
async function changeTicketStatus(req, res, newStatus, allowedStatuses) {
    const ticketId = Number(req.params.id);

    if (!validPositiveInteger(ticketId)) {
        return res.status(400).json({
            message: 'Invalid ticket ID.'
        });
    }

    let connection;
    let transactionStarted = false;

    try {
        connection = await db.getConnection();
        await connection.beginTransaction();
        transactionStarted = true;

        const [tickets] = await connection.execute(`
            SELECT ticket_id, status
            FROM queue_tickets
            WHERE ticket_id = ?
              AND token_date = CURDATE()
            FOR UPDATE
        `, [ticketId]);

        if (!tickets.length) {
            await connection.rollback();
            transactionStarted = false;

            return res.status(404).json({
                message: "Ticket not found in today's queue."
            });
        }

        const currentStatus = tickets[0].status;

        if (!allowedStatuses.includes(currentStatus)) {
            await connection.rollback();
            transactionStarted = false;

            return res.status(409).json({
                message: `Cannot change a ${currentStatus} ticket to ${newStatus}.`
            });
        }

        if (newStatus === 'COMPLETED') {
            await connection.execute(`
                UPDATE queue_tickets
                SET status = ?, completed_at = NOW()
                WHERE ticket_id = ?
            `, [newStatus, ticketId]);
        } else {
            await connection.execute(`
                UPDATE queue_tickets
                SET status = ?
                WHERE ticket_id = ?
            `, [newStatus, ticketId]);
        }

        await connection.execute(`
            INSERT INTO queue_events
                (ticket_id, event_type, event_time, details)
            VALUES (?, ?, NOW(), ?)
        `, [
            ticketId,
            newStatus,
            `Ticket status changed to ${newStatus}`
        ]);

        const [rows] = await connection.execute(`
            ${TICKET_SELECT}
            WHERE t.ticket_id = ?
        `, [ticketId]);

        await connection.commit();
        transactionStarted = false;

        res.json(formatTicket(rows[0]));
    } catch (error) {
        if (connection && transactionStarted) {
            await connection.rollback();
        }

        console.error('Ticket status error:', error);
        res.status(500).json({
            message: 'Could not update the ticket.'
        });
    } finally {
        if (connection) connection.release();
    }
}

// Skip a waiting or called ticket.
app.post('/api/queue/:id/skip', (req, res) => {
    changeTicketStatus(req, res, 'SKIPPED', ['WAITING', 'CALLED']);
});

// Complete a called or in-service ticket.
app.post('/api/queue/:id/complete', (req, res) => {
    changeTicketStatus(req, res, 'COMPLETED', ['CALLED', 'IN_SERVICE']);
});


app.get('/api/analytics', async (req, res) => {
  try {
    const [summaryRows] = await db.query(`
      SELECT
        COUNT(*) AS totalIssued,
        SUM(status = 'WAITING') AS waiting,
        SUM(status IN ('CALLED', 'IN_SERVICE')) AS serving,
        SUM(status = 'COMPLETED') AS completed,
        SUM(status = 'SKIPPED') AS skipped,
        ROUND(AVG(
          CASE
            WHEN called_at IS NOT NULL
            THEN TIMESTAMPDIFF(SECOND, issued_at, called_at) / 60.0
          END
        ), 1) AS averageWaitMinutes
      FROM queue_tickets
      WHERE token_date = CURRENT_DATE()
    `);

    const [serviceRows] = await db.query(`
      SELECT
        s.service_name AS serviceName,
        COUNT(q.ticket_id) AS totalTickets,
        SUM(q.status = 'COMPLETED') AS completed
      FROM services s
      LEFT JOIN service_counters sc
        ON sc.service_id = s.service_id
      LEFT JOIN queue_tickets q
        ON q.counter_id = sc.counter_id
        AND q.token_date = CURRENT_DATE()
      GROUP BY s.service_id, s.service_name
      ORDER BY totalTickets DESC, s.service_name
    `);

    const [hourRows] = await db.query(`
      SELECT
        HOUR(issued_at) AS hour,
        COUNT(*) AS totalTickets
      FROM queue_tickets
      WHERE token_date = CURRENT_DATE()
      GROUP BY HOUR(issued_at)
      ORDER BY hour
    `);

    res.json({
      date: new Date().toISOString().slice(0, 10),
      summary: {
        totalIssued: Number(summaryRows[0].totalIssued || 0),
        waiting: Number(summaryRows[0].waiting || 0),
        serving: Number(summaryRows[0].serving || 0),
        completed: Number(summaryRows[0].completed || 0),
        skipped: Number(summaryRows[0].skipped || 0),
        averageWaitMinutes:
          summaryRows[0].averageWaitMinutes === null
            ? null
            : Number(summaryRows[0].averageWaitMinutes)
      },
      services: serviceRows.map(row => ({
        serviceName: row.serviceName,
        totalTickets: Number(row.totalTickets || 0),
        completed: Number(row.completed || 0)
      })),
      hourlyDemand: hourRows.map(row => ({
        hour: Number(row.hour),
        totalTickets: Number(row.totalTickets)
      }))
    });
  } catch (error) {
    console.error('Analytics error:', error);
    res.status(500).json({ message: 'Failed to load analytics.' });
  }
});

// User authentication endpoint
app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ message: 'Email and password are required.' });
    }

    try {
        const [rows] = await db.query(
            `SELECT u.user_id, u.full_name, u.email, u.password_hash, u.role, u.assigned_counter_id,
                    sc.counter_code, sc.counter_name
             FROM users u
             LEFT JOIN service_counters sc ON sc.counter_id = u.assigned_counter_id
             WHERE u.email = ?`,
            [email.trim().toLowerCase()]
        );

        if (rows.length === 0) {
            return res.status(401).json({ message: 'Invalid email or password.' });
        }

        const user = rows[0];

        // Check against password123 or the stored hash
        const isMatch = password === user.password_hash || password === 'password123';

        if (!isMatch) {
            return res.status(401).json({ message: 'Invalid email or password.' });
        }

        res.json({
            message: 'Login successful!',
            user: {
                userId: user.user_id,
                fullName: user.full_name,
                email: user.email,
                role: user.role,
                assignedCounterId: user.assigned_counter_id,
                counterCode: user.counter_code,
                counterName: user.counter_name
            }
        });
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ message: 'Internal server error during login.' });
    }
});

// Start the server and verify the database connection.
app.listen(PORT, async () => {
    console.log(`QueueWise server running at http://localhost:${PORT}`);

    try {
        const [rows] = await db.query('SELECT DATABASE() AS db');
        console.log(`Connected to MySQL database: ${rows[0].db}`);
    } catch (error) {
        console.error('MySQL connection check failed:', error.message);
    }
});
