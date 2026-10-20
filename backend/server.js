
const express = require('express');

const app = express();
const PORT = 3000;

app.use(express.json());
const path = require('path');

app.use(express.static(path.join(__dirname, '../frontend')));
// Sample queue data
let queue = [
    {
        id: 1,
        token: "Q001",
        serviceId: "1",
        status: "Serving",
        createdAt: Date.now() - 15000
    },
    {
        id: 2,
        token: "Q002",
        serviceId: "2",
        status: "Waiting",
        createdAt: Date.now() - 10000
    },
    {
        id: 3,
        token: "Q003",
        serviceId: "3",
        status: "Waiting",
        createdAt: Date.now() - 5000
    }
];

const serviceTimes = {
    "1": 10,  // Document Verification — 10 minutes
    "2": 3,   // Fee Payment — 3 minutes
    "3": 5    // Student Enquiry — 5 minutes
};

// Home route
app.get('/', (req, res) => {
    res.json({
        message: 'QueueWise backend is running!'
    });
});

// Get all queue tickets
app.get('/api/queue', (req, res) => {
    res.json(queue);
});


app.post('/api/queue', (req, res) => {
    const serviceId = req.body?.serviceId;

    // Check whether the selected service is valid
    if (!serviceId || !serviceTimes[serviceId]) {
        return res.status(400).json({
            message: 'Please select a valid service.'
        });
    }

    const newId = queue.length > 0
        ? Math.max(...queue.map(ticket => ticket.id)) + 1
        : 1;

    const newTicket = {
        id: newId,
        token: `Q${String(newId).padStart(3, '0')}`,
        serviceId: serviceId,
        status: 'Waiting',
        createdAt: Date.now()
    };

    queue.push(newTicket);

    // Count earlier tickets that are waiting or being served
    const ticketsAhead = queue.filter(ticket =>
        ticket.id < newTicket.id &&
        (ticket.status === 'Waiting' ||
         ticket.status === 'Serving')
    );

    const peopleAhead = ticketsAhead.length;

    // Estimate wait using the service time of each earlier ticket
    const estimatedWaitMinutes = ticketsAhead.reduce(
        (total, ticket) =>
            total + serviceTimes[ticket.serviceId],
        0
    );

    res.status(201).json({
        message: 'Token created successfully!',
        ticket: {
            ...newTicket,
            peopleAhead,
            estimatedWaitMinutes
        }
    });
});



app.post('/api/queue/next', (req, res) => {
    // Only allow one ticket to be serving at a time
    const current = queue.find(ticket => ticket.status === 'Serving');

    if (current) {
        return res.status(409).json({
            message: `${current.token} is still being served. Complete it first.`
        });
    }

    const nextTicket = queue
        .filter(ticket => ticket.status === 'Waiting')
        .sort((a, b) => a.id - b.id)[0];

    if (!nextTicket) {
        return res.status(404).json({
            message: 'No waiting tickets in the queue.'
        });
    }

    nextTicket.status = 'Serving';

    res.json({
        message: `${nextTicket.token} is now being served.`,
        ticket: nextTicket
    });
});


app.post('/api/queue/:id/skip', (req, res) => {
    const ticket = queue.find(
        item => item.id === Number(req.params.id)
    );

    if (!ticket) {
        return res.status(404).json({ message: 'Ticket not found.' });
    }

    if (ticket.status !== 'Waiting') {
        return res.status(400).json({
            message: 'Only waiting tickets can be skipped.'
        });
    }

    ticket.status = 'Skipped';

    res.json({ message: `${ticket.token} was skipped.`, ticket });
});


app.post('/api/queue/:id/complete', (req, res) => {
    const ticket = queue.find(
        item => item.id === Number(req.params.id)
    );

    if (!ticket) {
        return res.status(404).json({ message: 'Ticket not found.' });
    }

    if (ticket.status !== 'Serving') {
        return res.status(400).json({
            message: 'Only the serving ticket can be completed.'
        });
    }

    ticket.status = 'Completed';

    res.json({ message: `${ticket.token} was completed.`, ticket });
});


// Start server
app.listen(PORT, () => {
    console.log(`QueueWise server running at http://localhost:${PORT}`);
});
